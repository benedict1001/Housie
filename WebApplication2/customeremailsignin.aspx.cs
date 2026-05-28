using System;
using System.Net;
using System.Net.Mail;
using System.Data;

namespace WebApplication2
{
    public partial class customeremailsignin : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            try
            {
            
                string checkQry = $"SELECT * FROM customer WHERE email = '{txtEmail.Text.Trim()}'";
                DataTable dt = m1.select(checkQry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    Response.Write("<script>alert('Email already exists. Please log in.');</script>");
                    return;
                }

            
                string otp = new Random().Next(100000, 999999).ToString();
                Session["RegOTP"] = otp;
                lblTargetEmail.Text = txtEmail.Text;

            
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("housie.propertyrental@gmail.com", "Housie Support");
                mail.To.Add(txtEmail.Text.Trim());
                mail.Subject = "Housie Verification Code";
                mail.Body = "Your OTP is: " + otp;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential("housie.propertyrental@gmail.com", "eydoqcdkmxvjqwnb");

                smtp.Send(mail);
                mvSignup.ActiveViewIndex = 1;
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (txtOTP.Text == Session["RegOTP"]?.ToString())
            {
                
                string qry = $"INSERT INTO customer (fname, lname, email, phoneno, password, status) VALUES ('{txtFname.Text}', '{txtLname.Text}', '{txtEmail.Text}', '{txtPhone.Text}', '{txtPass.Text}', 1)";
                m1.execute(qry);

          
                Session["cemail"] = txtEmail.Text;

             
                string source = Request.QueryString["source"];

                if (source == "booking")
                {
                  
                    Response.Redirect("customerbookproperty.aspx");
                }
                else
                {
                    Response.Redirect("customerhomepage.aspx");
                }
            }
            else
            {
                Response.Write("<script>alert('Invalid OTP.');</script>");
            }
        }
    }
}