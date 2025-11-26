using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.WebRequestMethods;
using System.IO; // Add this using directive at the top

namespace chat2
{
    public partial class DownloadDocument : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (Request.QueryString["id"] != null)
            {
                int documentId = Convert.ToInt32(Request.QueryString["id"]);
                DownloadFile(documentId);
            }
            else
            {
                Response.Write("Invalid document ID");
            }
        }

        private void DownloadFile(int documentId)
        {
            try
            {
                DataTable dt = DocumentDAL.GetDocumentById(documentId);

                if (dt.Rows.Count > 0)
                {
                    string fileName = dt.Rows[0]["FileName"].ToString();
                    string filePath = dt.Rows[0]["FilePath"].ToString();

                    // Fix: Use System.IO.File.Exists instead of File.Exists from WebRequestMethods
                    if (System.IO.File.Exists(filePath))
                    {
                        Response.Clear();
                        Response.ContentType = "application/octet-stream";
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
                        Response.TransmitFile(filePath);
                        Response.End();
                    }
                    else
                    {
                        Response.Write("File not found on server");
                    }
                }
                else
                {
                    Response.Write("Document not found in database");
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error downloading file: " + ex.Message);
            }
        }
    }
}