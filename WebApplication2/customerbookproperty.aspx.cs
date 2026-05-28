using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;

namespace WebApplication2
{
    public partial class customerbookproperty : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null && Request.QueryString["in"] != null && Request.QueryString["out"] != null)
                {
                    LoadBookingSummary();

                    if (Session["cemail"] != null)
                    {
                        pnlGuestView.Visible = false;
                        pnlAuthView.Visible = true;
                    }
                    else
                    {
                        pnlGuestView.Visible = true;
                        pnlAuthView.Visible = false;
                    }
                }
                else
                {
                    Response.Redirect("customerhomepage.aspx");
                }
            }
        }

        private void LoadBookingSummary()
        {
            try
            {
                string pid = Request.QueryString["pid"].ToString();
                DateTime checkin = Convert.ToDateTime(Request.QueryString["in"]);
                DateTime checkout = Convert.ToDateTime(Request.QueryString["out"]);
                string guests = Request.QueryString["g"] != null ? Request.QueryString["g"].ToString() : "1";

                int totalDays = (checkout - checkin).Days;
                if (totalDays <= 0) totalDays = 1;

                string qry = "SELECT title, price, pimage FROM property WHERE pid = '" + pid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    lblPropName.Text = row["title"].ToString();

                    // FIXED: Read image as string path instead of byte array
                    if (row["pimage"] != DBNull.Value && !string.IsNullOrEmpty(row["pimage"].ToString()))
                    {
                        imgProperty.ImageUrl = ResolveUrl("~/" + row["pimage"].ToString());
                    }
                    else
                    {
                        imgProperty.ImageUrl = "https://via.placeholder.com/600x400?text=No+Image";
                    }

                    decimal nightlyPrice = Convert.ToDecimal(row["price"]);
                    decimal baseTotal = nightlyPrice * totalDays;

                    decimal serviceFee = baseTotal * 0.10m;
                    decimal grandTotal = baseTotal + serviceFee;

                    lblDates.Text = checkin.ToString("MMM dd") + " – " + checkout.ToString("MMM dd, yyyy");
                    lblGuestCount.Text = guests + (guests == "1" ? " guest" : " guests");
                    lblCalculation.Text = "₹" + nightlyPrice.ToString("N0") + " x " + totalDays + " nights";
                    lblBaseTotal.Text = baseTotal.ToString("N0");
                    lblServiceFee.Text = serviceFee.ToString("N0");
                    lblGrandTotal.Text = grandTotal.ToString("N0");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Summary Error: " + ex.Message);
            }
        }

        // Host Notification Email Method
        private void SendHostEmail(string pid, string checkin, string checkout)
        {
            try
            {
                string hostEmail = "";
                string propName = "";
                string strcon = ConfigurationManager.AppSettings["con"];

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = @"
                        SELECT h.email, p.title 
                        FROM property p 
                        INNER JOIN hostdetails h ON p.hid = h.hid 
                        WHERE p.pid = @pid";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hostEmail = reader["email"].ToString();
                                propName = reader["title"].ToString();
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(hostEmail))
                {
                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("housie.propertyrental@gmail.com", "Housie System");
                    mail.To.Add(hostEmail);
                    mail.Subject = "New Booking Confirmed! - " + propName;

                    string bookedDate = DateTime.Now.ToString("MMM dd, yyyy");
                    DateTime dtCheckin = Convert.ToDateTime(checkin);
                    DateTime dtCheckout = Convert.ToDateTime(checkout);

                    mail.Body = $"Hello Host,\n\nGreat news! Your property has just been booked.\n\nBooking Details:\nProperty: {propName}\nCheck-in: {dtCheckin.ToString("MMM dd, yyyy")}\nCheck-out: {dtCheckout.ToString("MMM dd, yyyy")}\nBooked On: {bookedDate}\n\nPlease log in to your host dashboard to view more details and prepare for your guest.\n\nBest Regards,\nThe Housie Team";
                    mail.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;

                    // Credentials applied here
                    smtp.Credentials = new System.Net.NetworkCredential("housie.propertyrental@gmail.com", "eydoqcdkmxvjqwnb");

                    smtp.Send(mail);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error sending host email: " + ex.Message);
            }
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            string pid = Request.QueryString["pid"].ToString();
            string checkin = Request.QueryString["in"].ToString();
            string checkout = Request.QueryString["out"].ToString();
            string guests = Request.QueryString["g"] != null ? Request.QueryString["g"].ToString() : "1";

            string redirectUrl = $"customerloginform.aspx?source=booking&pid={pid}&in={checkin}&out={checkout}&g={guests}";

            Response.Redirect(redirectUrl, false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnProceedToPay_Click(object sender, EventArgs e)
        {
            string pid = Request.QueryString["pid"].ToString();
            string checkin = Request.QueryString["in"].ToString();
            string checkout = Request.QueryString["out"].ToString();
            string guests = Request.QueryString["g"] != null ? Request.QueryString["g"].ToString() : "1";

            // Triggering the email
            SendHostEmail(pid, checkin, checkout);

            Response.Redirect("payment.aspx?pid=" + pid + "&in=" + checkin + "&out=" + checkout + "&g=" + guests, false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}