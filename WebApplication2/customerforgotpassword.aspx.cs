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
    public partial class customerforgotpassword : System.Web.UI.Page
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
                mm.Subject = "Customer Support - Password Reset OTP";
                mm.Body = string.Format("Hello Customer,<br/><br/>Your verification code is: <b>{0}</b><br/><br/>Please enter this code on the website to reset your password.", otpCode);
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
                lblMsg.Text = "Please enter your email address.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connString))
            {
               
                string query = "SELECT COUNT(*) FROM customer WHERE email = @email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@email", email);

                con.Open();
                int count = (int)cmd.ExecuteScalar();
                con.Close();

                if (count > 0)
                {
                   
                    Random ran = new Random();
                    string otp = ran.Next(100000, 999999).ToString();

                 
                    Session["cust_otp"] = otp;
                    Session["cust_email"] = email;

                    
                    SendOTPViaEmail(email, otp);

                    
                    pnlEmail.Visible = false;
                    pnlOTP.Visible = true;
                    lblMsg.Text = "A verification code has been sent to your email.";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblMsg.Text = "We couldn't find an account with that email.";
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

       
        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (Session["cust_otp"] != null && txtEnteredOTP.Text == Session["cust_otp"].ToString())
            {
                pnlOTP.Visible = false;
                pnlReset.Visible = true;
                lblMsg.Text = "Code verified successfully.";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblMsg.Text = "Invalid verification code. Please try again.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

      
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtNewPass.Text) || txtNewPass.Text != txtConfirmPass.Text)
            {
                lblMsg.Text = "Passwords do not match!";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (Session["cust_email"] != null)
            {
                string targetEmail = Session["cust_email"].ToString();

                using (SqlConnection con = new SqlConnection(connString))
                {
                   
                    string query = "UPDATE customer SET password = @pass WHERE email = @email";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@pass", txtNewPass.Text);
                    cmd.Parameters.AddWithValue("@email", targetEmail);

                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    con.Close();

                    if (result > 0)
                    {
                        
                        Session.Remove("cust_otp");
                        Session.Remove("cust_email");

                        string script = "alert('Password Reset Successful! You can now login.'); window.location='customerloginform.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "CustSuccess", script, true);
                    }
                }
            }
            else
            {
                lblMsg.Text = "Session timeout. Please start over.";
                pnlReset.Visible = false;
                pnlEmail.Visible = true;
            }
        }
    }
}