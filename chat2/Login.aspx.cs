using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace chat2
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if already logged in
                if (Session["UserId"] != null)
                {
                    string userRole = Session["UserRole"].ToString();
                    if (userRole == "Admin")
                        Response.Redirect("AdminDashboard.aspx");
                    else
                        Response.Redirect("UserDashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            //try
            //{
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                DataTable dt = UserDAL.ValidateUser(username, password);

                if (dt.Rows.Count > 0)
                {
                    // User found - Create session
                    DataRow row = dt.Rows[0];
                    int userId = Convert.ToInt32(row["UserId"]);
                    string userRole = row["UserRole"].ToString();
                    string fullName = row["FullName"].ToString();

                    Session["UserId"] = userId;
                    Session["Username"] = username;
                    Session["FullName"] = fullName;
                    Session["UserRole"] = userRole;

                    // Update last login
                    UserDAL.UpdateLastLogin(userId);

                    // Redirect based on role
                    if (userRole == "Admin")
                        Response.Redirect("AdminDashboard.aspx");
                    else
                        Response.Redirect("UserDashboard.aspx");
                }
                else
                {
                    lblError.Text = "Invalid username or password";
                    lblError.Visible = true;
                }
            //}
            //catch (Exception ex)
            //{
            //    lblError.Text = "An error occurred: " + ex.Message;
            //    lblError.Visible = true;
            //}
        }
    }
}