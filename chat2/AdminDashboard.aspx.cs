using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace chat2
{
    public partial class AdminDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Check if user has admin role
            string userRole = Session["UserRole"].ToString();
            if (userRole != "Admin")
            {
                Response.Redirect("UserDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblAdminName.Text = Session["FullName"].ToString();
                LoadStatistics();
                LoadChatRooms();
            }
        }

        private void LoadStatistics()
        {
            // Total Active Chats
            string queryChats = "SELECT COUNT(*) FROM ChatRooms WHERE IsActive = 1";
            lblTotalChats.Text = DBHelper.ExecuteScalar(queryChats).ToString();

            // Total Users
            string queryUsers = "SELECT COUNT(*) FROM Users WHERE UserRole = 'User'";
            lblTotalUsers.Text = DBHelper.ExecuteScalar(queryUsers).ToString();

            // Total Messages
            string queryMessages = "SELECT COUNT(*) FROM Messages";
            lblTotalMessages.Text = DBHelper.ExecuteScalar(queryMessages).ToString();
        }

        private void LoadChatRooms()
        {
            DataTable dt = ChatRoomDAL.GetAdminChatRooms();

            if (dt.Rows.Count > 0)
            {
                rptChatRooms.DataSource = dt;
                rptChatRooms.DataBind();
                pnlNoChats.Visible = false;
            }
            else
            {
                pnlNoChats.Visible = true;
            }
        }

        private void LoadUsers()
        {
            DataTable dt = UserDAL.GetAllUsers();

            if (dt.Rows.Count > 0)
            {
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
                pnlNoUsers.Visible = false;
            }
            else
            {
                pnlNoUsers.Visible = true;
            }
        }

        protected void btnTabChats_Click(object sender, EventArgs e)
        {
            btnTabChats.CssClass = "tab-button active";
            btnTabUsers.CssClass = "tab-button";
            pnlChats.Visible = true;
            pnlUsers.Visible = false;
            LoadChatRooms();
        }

        protected void btnTabUsers_Click(object sender, EventArgs e)
        {
            btnTabChats.CssClass = "tab-button";
            btnTabUsers.CssClass = "tab-button active";
            pnlChats.Visible = false;
            pnlUsers.Visible = true;
            LoadUsers();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}