using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace chat2
{
    public partial class UserDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Check if user has correct role
            string userRole = Session["UserRole"].ToString();
            if (userRole != "User")
            {
                Response.Redirect("AdminDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblUserName.Text = Session["FullName"].ToString();
                LoadChatRooms();
                LoadAdmins();
            }
        }

        private void LoadChatRooms()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            DataTable dt = ChatRoomDAL.GetUserChatRooms(userId);

            if (dt.Rows.Count > 0)
            {
                rptChatRooms.DataSource = dt;
                rptChatRooms.DataBind();
                pnlChatRooms.Visible = true;
                pnlNoChats.Visible = false;
            }
            else
            {
                pnlChatRooms.Visible = false;
                pnlNoChats.Visible = true;
            }
        }

        private void LoadAdmins()
        {
            string query = "SELECT UserId, FullName FROM Users WHERE UserRole = 'Admin' AND IsActive = 1";
            DataTable dt = DBHelper.ExecuteDataTable(query);

            ddlAdmin.DataSource = dt;
            ddlAdmin.DataTextField = "FullName";
            ddlAdmin.DataValueField = "UserId";
            ddlAdmin.DataBind();
        }

        protected void btnNewChat_Click(object sender, EventArgs e)
        {
            ViewState["ShowModal"] = true;
        }

        protected void btnCreateChat_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrWhiteSpace(txtChatTopic.Text))
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    int adminId = Convert.ToInt32(ddlAdmin.SelectedValue);
                    string roomName = txtChatTopic.Text.Trim() + " - " + Session["FullName"].ToString();

                    int chatRoomId = ChatRoomDAL.CreateChatRoom(roomName, userId, adminId);

                    if (chatRoomId > 0)
                    {
                        ViewState["ShowModal"] = false;
                        Response.Redirect("ChatRoom.aspx?id=" + chatRoomId);
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error creating chat: " + ex.Message + "');</script>");
            }
        }

        protected void btnCancelModal_Click(object sender, EventArgs e)
        {
            ViewState["ShowModal"] = false;
            txtChatTopic.Text = string.Empty;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}