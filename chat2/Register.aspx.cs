using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace chat2
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();
                string fullName = txtFullName.Text.Trim();

                // Check if username already exists
                if (UserDAL.CheckUsernameExists(username))
                {
                    lblMessage.Text = "Username already exists. Please choose a different username.";
                    lblMessage.CssClass = "error-box";
                    lblMessage.Visible = true;
                    return;
                }

                // Register user
                int result = UserDAL.RegisterUser(username, email, password, fullName);

                if (result > 0)
                {
                    lblMessage.Text = "Registration successful! Redirecting to login...";
                    lblMessage.CssClass = "success-message";
                    lblMessage.Visible = true;

                    // Redirect to login page after 2 seconds
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
                else
                {
                    lblMessage.Text = "Registration failed. Please try again.";
                    lblMessage.CssClass = "error-box";
                    lblMessage.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
                lblMessage.CssClass = "error-box";
                lblMessage.Visible = true;
            }
        }
    }
}