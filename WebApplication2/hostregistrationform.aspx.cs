using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

// <-- NEW: Added for Database and Email functionality
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;

namespace WebApplication2
{
    public partial class hostregistrationform : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // <-- NEW: Method to fetch admin email and send the notification
        private void SendAdminEmail(string firstName, string lastName, string email, string phone)
        {
            try
            {
                string adminEmail = "";
                string strcon = ConfigurationManager.AppSettings["con"];

                // 1. Fetch the admin email from the database
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT TOP 1 email FROM admin"; // Grabs the first admin email
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            adminEmail = result.ToString();
                        }
                    }
                }

                // 2. If an email was found, send the notification
                if (!string.IsNullOrEmpty(adminEmail))
                {
                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("housie.propertyrental@gmail.com", "Housie System");
                    mail.To.Add(adminEmail);
                    mail.Subject = "New Host Registration - Pending Approval";

                    // Customized body for a new host
                    mail.Body = $"Hello Admin,\n\nA new host has registered on Housie and is waiting for your approval.\n\nHost Details:\nName: {firstName} {lastName}\nEmail: {email}\nPhone: {phone}\n\nPlease log in to the admin dashboard to review their details and ID proof.\n\nBest Regards,\nThe Housie Team";
                    mail.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new System.Net.NetworkCredential("housie.propertyrental@gmail.com", "eydoqcdkmxvjqwnb");

                    smtp.Send(mail);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error sending admin email: " + ex.Message);
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (fuHostPhoto.HasFile && fuIdProof.HasFile)
            {
                try
                {
                    byte[] hostPhoto = fuHostPhoto.FileBytes;
                    byte[] idProof = fuIdProof.FileBytes;

                    Class1 m1 = new Class1();

                    m1.inserthostregistration(
                        txtFirstName.Text,
                        txtLastName.Text,
                        txtEmail.Text,
                        txtPhone.Text,
                        txtPassword.Text,
                        hostPhoto,
                        idProof
                    );

                    // <-- NEW: Call the email method right after successful database insert
                    SendAdminEmail(txtFirstName.Text, txtLastName.Text, txtEmail.Text, txtPhone.Text);

                    Response.Write("<script>alert('Registration successful! Your account is pending approval.'); window.location='hostloginform.aspx';</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
            else
            {
                Response.Write("<script>alert('Please upload both your profile photo and ID proof.');</script>");
            }
        }
    }
}