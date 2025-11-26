using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace chat2
{
    public partial class ChatRoom : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Get chat room ID from query string
                if (Request.QueryString["id"] != null)
                {
                    int chatRoomId = Convert.ToInt32(Request.QueryString["id"]);
                    hfChatRoomId.Value = chatRoomId.ToString();

                    LoadChatRoomDetails(chatRoomId);
                    LoadMessages(chatRoomId);
                    LoadDocuments(chatRoomId);

                    // Set back button link
                    string userRole = Session["UserRole"].ToString();
                    if (userRole == "Admin")
                        lnkBack.NavigateUrl = "AdminDashboard.aspx";
                    else
                        lnkBack.NavigateUrl = "UserDashboard.aspx";
                }
                else
                {
                    Response.Redirect("UserDashboard.aspx");
                }
            }
        }

        private void LoadChatRoomDetails(int chatRoomId)
        {
            DataTable dt = ChatRoomDAL.GetChatRoomDetails(chatRoomId);
            if (dt.Rows.Count > 0)
            {
                lblRoomName.Text = dt.Rows[0]["RoomName"].ToString();
            }
        }

        private void LoadMessages(int chatRoomId)
        {
            DataTable dt = MessageDAL.GetMessages(chatRoomId);

            // Decode HTML-encoded MessageText (if DB contains encoded anchors)
            foreach (DataRow row in dt.Rows)
            {
                if (row["MessageText"] != DBNull.Value)
                {
                    row["MessageText"] = HttpUtility.HtmlDecode(row["MessageText"].ToString());
                }
            }

            rptMessages.DataSource = dt;
            rptMessages.DataBind();

            // Mark messages as read
            int userId = Convert.ToInt32(Session["UserId"]);
            MessageDAL.MarkMessagesAsRead(chatRoomId, userId);
        }

        private void LoadDocuments(int chatRoomId)
        {
            DataTable dt = DocumentDAL.GetDocuments(chatRoomId);
            rptDocuments.DataSource = dt;
            rptDocuments.DataBind();
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrWhiteSpace(txtMessage.Text))
                {
                    int chatRoomId = Convert.ToInt32(hfChatRoomId.Value);
                    int userId = Convert.ToInt32(Session["UserId"]);
                    string messageText = txtMessage.Text.Trim();

                    MessageDAL.SendMessage(chatRoomId, userId, messageText);

                    txtMessage.Text = string.Empty;
                    LoadMessages(chatRoomId);
                }
            }
            catch (Exception ex)
            {
                // Handle error
                Response.Write("<script>alert('Error sending message: " + ex.Message + "');</script>");
            }
        }

        protected void btnUploadServer_Click(object sender, EventArgs e)
        {
            try
            {
                // This handler supports "attach + send" behaviour:
                // - save file to ~/Uploads/
                // - create a document record via DocumentDAL.UploadDocument(...)
                // - send a chat message where MessageText contains an anchor to the uploaded file
                if (fileUpload.HasFile)
                {
                    int chatRoomId = Convert.ToInt32(hfChatRoomId.Value);
                    int userId = Convert.ToInt32(Session["UserId"]);

                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string fileExtension = Path.GetExtension(fileName);
                    long fileSize = fileUpload.PostedFile.ContentLength;

                    // Create uploads directory if it doesn't exist
                    string uploadFolder = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    // Generate unique file name to avoid collisions
                    string uniqueFileName = Guid.NewGuid().ToString("N") + "_" + fileName;
                    string filePath = Path.Combine(uploadFolder, uniqueFileName);

                    // Save file to disk
                    fileUpload.SaveAs(filePath);

                    // Save document record in database (existing method)
                    DocumentDAL.UploadDocument(chatRoomId, userId, fileName, filePath, fileSize, fileExtension);

                    // Build a public URL for the uploaded file. Ensure your Uploads folder is accessible.
                    // If you prefer to use DownloadDocument.aspx?id=..., adapt DocumentDAL.UploadDocument to return the inserted ID.
                    string fileUrl = ResolveUrl("~/Uploads/" + uniqueFileName);

                    // Send a chat message containing a link to the file. MessageText is stored as HTML and rendered in the repeater.
                    string messageLink = $"<a href='{fileUrl}' target='_blank'>{HttpUtility.HtmlEncode(fileName)}</a>";
                    MessageDAL.SendMessage(chatRoomId, userId, messageLink);

                    // Reload UI
                    LoadDocuments(chatRoomId);
                    LoadMessages(chatRoomId);

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Document uploaded and sent successfully!');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error uploading document: " + ex.Message + "');", true);
            }
        }

        // Return inline SVG markup for common file types
        private string GetIconSvg(string ext)
        {
            ext = (ext ?? "").ToLowerInvariant();
            switch (ext)
            {
                case ".pdf":
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMidYMid meet'><rect width='48' height='32' rx='4' fill='#e83e34'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>PDF</text></svg>";
                case ".doc":
                case ".docx":
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg'><rect width='48' height='32' rx='4' fill='#2a69a6'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>DOC</text></svg>";
                case ".xls":
                case ".xlsx":
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg'><rect width='48' height='32' rx='4' fill='#207245'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>XLS</text></svg>";
                case ".ppt":
                case ".pptx":
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg'><rect width='48' height='32' rx='4' fill='#d1631a'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>PPT</text></svg>";
                case ".zip":
                case ".rar":
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg'><rect width='48' height='32' rx='4' fill='#6c757d'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>ZIP</text></svg>";
                case ".png":
                case ".jpg":
                case ".jpeg":
                case ".gif":
                case ".bmp":
                case ".webp":
                    // for images we use thumbnail img instead of icon - return empty
                    return "";
                default:
                    return "<svg width='48' height='32' viewBox='004832' xmlns='http://www.w3.org/2000/svg'><rect width='48' height='32' rx='4' fill='#495057'/><text x='50%' y='60%' font-family='Arial' font-size='10' fill='white' text-anchor='middle' font-weight='700'>FILE</text></svg>";
            }
        }

        // Helper to format bytes to human readable
        private string FormatBytes(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            double kb = bytes / 1024.0;
            if (kb < 1024) return $"{kb:0.##} KB";
            double mb = kb / 1024.0;
            if (mb < 1024) return $"{mb:0.##} MB";
            return $"{mb / 1024.0:0.##} GB";
        }

        // Repeater item data bound - render preview for file links (images, pdfs) inline
        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var drv = e.Item.DataItem as DataRowView;
            if (drv == null)
                return;

            // Decode in case DB stored encoded HTML
            string rawMessage = drv["MessageText"]?.ToString() ?? string.Empty;
            string messageText = HttpUtility.HtmlDecode(rawMessage);

            var lit = e.Item.FindControl("litMessage") as Literal;
            if (lit == null)
                return;

            lit.Mode = LiteralMode.PassThrough;

            // Attempt to find anchor href or plain http(s) URL
            var match = Regex.Match(messageText, @"<a\s+[^>]*href\s*=\s*['""](?<url>[^'""]+)['""][^>]*>(?<text>.*?)<\/a>", RegexOptions.IgnoreCase);
            string resolvedUrl = null;
            string filename = null;

            if (match.Success)
            {
                resolvedUrl = match.Groups["url"].Value;
                filename = HttpUtility.HtmlDecode(match.Groups["text"].Value);
            }
            else
            {
                var urlMatch = Regex.Match(messageText, @"(?<url>https?:\/\/[^\s<]+)", RegexOptions.IgnoreCase);
                if (urlMatch.Success)
                {
                    resolvedUrl = urlMatch.Groups["url"].Value;
                    try { filename = Path.GetFileName(new Uri(resolvedUrl).AbsolutePath); } catch { filename = resolvedUrl; }
                }
            }

            if (string.IsNullOrEmpty(resolvedUrl))
            {
                // plain text message - render safely
                lit.Text = HttpUtility.HtmlEncode(messageText).Replace("\n", "<br/>");
                return;
            }

            // Normalize application-relative urls
            if (resolvedUrl.StartsWith("~/") || resolvedUrl.StartsWith("/"))
                resolvedUrl = ResolveUrl(resolvedUrl);

            string ext = Path.GetExtension(resolvedUrl).ToLowerInvariant();
            long fileSize = -1;

            // Try to get server file size when the URL maps to our Uploads folder
            try
            {
                string serverPath = null;
                if (resolvedUrl.StartsWith("/"))
                {
                    // absolute path on same host
                    serverPath = Server.MapPath("~" + resolvedUrl);
                }
                else if (resolvedUrl.StartsWith("~/"))
                {
                    serverPath = Server.MapPath(resolvedUrl);
                }
                else
                {
                    // Absolute URL: if host matches request host, map its path
                    Uri uri;
                    if (Uri.TryCreate(resolvedUrl, UriKind.Absolute, out uri) && uri.Host == Request.Url.Host)
                    {
                        serverPath = Server.MapPath(uri.AbsolutePath);
                    }
                }

                if (!string.IsNullOrEmpty(serverPath) && File.Exists(serverPath))
                {
                    var fi = new FileInfo(serverPath);
                    fileSize = fi.Length;
                }
            }
            catch
            {
                // ignore file probing failures
                fileSize = -1;
            }

            string sizeText = fileSize >= 0 ? FormatBytes(fileSize) : "";

            // Build WhatsApp-like card with iconSvg or thumbnail
            string iconSvg = GetIconSvg(ext);
            string cardHtml;
            if (ext == ".png" || ext == ".jpg" || ext == ".jpeg" || ext == ".gif" || ext == ".bmp" || ext == ".webp")
            {
                cardHtml = $@"
<div class='attachment-card'>
  <a class='attachment-link' href='{resolvedUrl}' target='_blank'>
    <img class='attachment-thumb' src='{resolvedUrl}' alt='{HttpUtility.HtmlAttributeEncode(filename)}' />
    <div class='attachment-meta'>
      <div class='attachment-name'>{HttpUtility.HtmlEncode(filename)}</div>
      <div class='attachment-info'>{sizeText} • Image</div>
    </div>
  </a>
</div>";
            }
            else
            {
                // use inline SVG icon
                cardHtml = $@"
<div class='attachment-card'>
  <a class='attachment-link' href='{resolvedUrl}' target='_blank'>
    <div class='attachment-icon'>{iconSvg}</div>
    <div class='attachment-meta'>
      <div class='attachment-name'>{HttpUtility.HtmlEncode(filename)}</div>
      <div class='attachment-info'>{sizeText} • {HttpUtility.HtmlEncode(ext.TrimStart('.').ToUpperInvariant())}</div>
    </div>
  </a>
</div>";
            }

            // Render original message link + card (original anchor will still be clickable if present)
            lit.Text = $"<div>{messageText}</div>{cardHtml}";
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            // Refresh messages periodically, but only if user is at bottom of chat
            // This prevents auto-scroll interruptions when user is viewing history
            bool isScrollAtBottom = true;

            // Check if hidden field exists and read scroll state
            if (hfIsScrollAtBottom != null && !string.IsNullOrEmpty(hfIsScrollAtBottom.Value))
            {
                isScrollAtBottom = hfIsScrollAtBottom.Value == "true";
            }

            // Only refresh messages if user is at bottom
            if (isScrollAtBottom)
            {
                int chatRoomId = Convert.ToInt32(hfChatRoomId.Value);
                LoadMessages(chatRoomId);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
        protected void btnClear_Click(object sender, EventArgs e)
        {
            // If your intention is simply “do nothing / avoid error”, leave this empty
        }

        protected void btnClearHistory_Click(object sender, EventArgs e)
        {

        }

        protected void btnExport_Click(object sender, EventArgs e)
        {

        }
    }
}