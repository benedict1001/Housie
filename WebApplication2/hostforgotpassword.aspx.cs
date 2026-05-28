using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace WebApplication2
{
    public partial class hostforgotpassword : System.Web.UI.Page
    {
        
        string connString = @"Data Source=localhost;Initial Catalog=projectdb;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMsg.Text = "";
            }
        }

        private void SendOTPViaEmail(string targetEmail, string otpCode)
        {
            try
            {
                MailMessage mm = new MailMessage("housie.propertyrental@gmail.com", targetEmail);
                mm.Subject = "HousieHost - Password Reset OTP";
                mm.Body = string.Format("Your verification code is: <b>{0}</b><br/><br/>Do not share this with anyone.", otpCode);
                mm.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                NetworkCredential nc = new NetworkCredential("housie.propertyrental@gmail.com", "eydoqcdkmxvjqwnb");
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = nc;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Email Error: " + ex.Message;
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnCheckEmail_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                lblMsg.Text = "Please enter your email.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connString))
            {
                
                string query = "SELECT COUNT(*) FROM hostdetails WHERE email = @email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@email", email);

                con.Open();
                int count = (int)cmd.ExecuteScalar();
                con.Close();

                if (count > 0)
                {
                    Random ran = new Random();
                    string otp = ran.Next(100000, 999999).ToString();

                    Session["reset_otp"] = otp;
                    Session["reset_email"] = email;

                    SendOTPViaEmail(email, otp);

                    pnlEmail.Visible = false;
                    pnlOTP.Visible = true;
                    lblMsg.Text = "OTP has been sent to your registered email.";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblMsg.Text = "This email is not registered.";
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (Session["reset_otp"] != null && txtEnteredOTP.Text == Session["reset_otp"].ToString())
            {
                pnlOTP.Visible = false;
                pnlReset.Visible = true;
                lblMsg.Text = "Identity verified.";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblMsg.Text = "Invalid OTP. Please check again.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (txtNewPass.Text != txtConfirmPass.Text || string.IsNullOrEmpty(txtNewPass.Text))
            {
                lblMsg.Text = "Passwords do not match!";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (Session["reset_email"] != null)
            {
                string targetEmail = Session["reset_email"].ToString();

                using (SqlConnection con = new SqlConnection(connString))
                {
                    
                    string query = "UPDATE hostdetails SET password = @pass WHERE email = @email";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@pass", txtNewPass.Text);
                    cmd.Parameters.AddWithValue("@email", targetEmail);

                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    con.Close();

                    if (result > 0)
                    {
                        Session.RemoveAll();
                        string script = "alert('Password updated successfully!'); window.location='hostloginform.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "Success", script, true);
                    }
                }
            }
            else
            {
                lblMsg.Text = "Session expired. Please start again.";
            }
        }
    }
}