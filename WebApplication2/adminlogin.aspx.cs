using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication2
{
    public partial class adminlogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear session if the admin lands on the login page
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblError.Text = "Please enter both email and password.";
                return;
            }

            try
            {
                string strcon = ConfigurationManager.AppSettings["con"];
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    // Parameterized query to prevent SQL injection
                    string query = "SELECT id, name FROM admin WHERE email = @email AND password = @password";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@email", email);
                        cmd.Parameters.AddWithValue("@password", password);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                // Login successful, set session variables
                                Session["admin_id"] = dt.Rows[0]["id"].ToString();
                                Session["admin_name"] = dt.Rows[0]["name"].ToString();

                                // Redirect to the admin dashboard (ensure this file exists!)
                                Response.Redirect("adminhomepage.aspx", false);
                            }
                            else
                            {
                                lblError.Text = "Invalid email or password.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Admin Login Error: " + ex.Message);
                lblError.Text = "An error occurred during login. Please try again.";
            }
        }
    }
}