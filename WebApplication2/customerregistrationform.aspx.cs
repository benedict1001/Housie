using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Google.Apis.Auth;
using System.Threading.Tasks;

namespace WebApplication2
{
    public partial class customerregistrationform : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnGoToEmailLogin_Click(object sender, EventArgs e)
        {
            // Pass the baton: If they came from booking, send those details to the login page
            if (Request.QueryString["source"] != null && Request.QueryString["source"].ToString() == "booking")
            {
                string pid = Request.QueryString["pid"];
                string checkin = Request.QueryString["in"];
                string checkout = Request.QueryString["out"];
                string guests = Request.QueryString["g"];

                Response.Redirect($"customeremailsignin.aspx?source=booking&pid={pid}&in={checkin}&out={checkout}&g={guests}");
            }
            else if (Request.QueryString["pid"] != null)
            {
                Response.Redirect("customeremailsignin.aspx?pid=" + Request.QueryString["pid"].ToString());
            }
            else
            {
                Response.Redirect("customeremailsignin.aspx");
            }
        }

        protected async void btnGoogleHidden_Click(object sender, EventArgs e)
        {
            try
            {
                string idToken = hfGoogleToken.Value;
                var payload = await GoogleJsonWebSignature.ValidateAsync(idToken, new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = new[] { "216506236992-kos43rmpf4np6k2ckifiq4rkderdrfin.apps.googleusercontent.com" }
                });

                DataTable dt = m1.select($"SELECT cid FROM customer WHERE email = '{payload.Email}'");

                if (dt != null && dt.Rows.Count > 0)
                {
                    // Existing Google User Logging In
                    Session["cid"] = dt.Rows[0]["cid"].ToString();
                    Session["cemail"] = payload.Email; // Added so the Booking page knows they are logged in

                    // Redirect back to booking if applicable
                    if (Request.QueryString["source"] != null && Request.QueryString["source"].ToString() == "booking")
                    {
                        string pid = Request.QueryString["pid"];
                        string checkin = Request.QueryString["in"];
                        string checkout = Request.QueryString["out"];
                        string guests = Request.QueryString["g"];
                        Response.Redirect($"customerbookproperty.aspx?pid={pid}&in={checkin}&out={checkout}&g={guests}", false);
                    }
                    else
                    {
                        Response.Redirect("customerhomepage.aspx", false);
                    }
                }
                else
                {
                    // New Google User - Go to finish step
                    Session["G_Email"] = payload.Email;
                    Session["G_Fname"] = payload.GivenName;
                    Session["G_Lname"] = payload.FamilyName;

                    lblGoogleName.Text = payload.GivenName;
                    mvRegister.ActiveViewIndex = 1;
                }
            }
            catch (Exception)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Google Authentication failed.');", true);
            }
        }

        protected void btnFinishGoogle_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtGooglePhone.Text) || string.IsNullOrEmpty(txtGooglePass.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Phone and Password are required.');", true);
                return;
            }

            string email = Session["G_Email"].ToString();
            string fname = Session["G_Fname"].ToString();
            string lname = Session["G_Lname"].ToString();

            string qry = $"INSERT INTO customer (fname, lname, email, phoneno, password, status) VALUES ('{fname}', '{lname}', '{email}', '{txtGooglePhone.Text}', '{txtGooglePass.Text}', 1)";
            m1.execute(qry);

            DataTable dt = m1.select($"SELECT cid FROM customer WHERE email = '{email}'");
            Session["cid"] = dt.Rows[0]["cid"].ToString();
            Session["cemail"] = email; // Added so the Booking page knows they are logged in

            // Redirect back to booking if applicable
            if (Request.QueryString["source"] != null && Request.QueryString["source"].ToString() == "booking")
            {
                string pid = Request.QueryString["pid"];
                string checkin = Request.QueryString["in"];
                string checkout = Request.QueryString["out"];
                string guests = Request.QueryString["g"];
                Response.Redirect($"customerbookproperty.aspx?pid={pid}&in={checkin}&out={checkout}&g={guests}", false);
            }
            else
            {
                Response.Redirect("customerhomepage.aspx", false);
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string qry = $"INSERT INTO customer (fname, lname, email, phoneno, password, status) VALUES ('{txtFirstName.Text}', '{txtLastName.Text}', '{txtEmail.Text}', '{txtPhone.Text}', '{txtPassword.Text}', 1)";
            m1.execute(qry);

            // Standard Registration doesn't log them in yet, so send them to the login page.
            // Pass the baton so the login page knows to send them to booking after!
            if (Request.QueryString["source"] != null && Request.QueryString["source"].ToString() == "booking")
            {
                string pid = Request.QueryString["pid"];
                string checkin = Request.QueryString["in"];
                string checkout = Request.QueryString["out"];
                string guests = Request.QueryString["g"];
                Response.Redirect($"customerloginform.aspx?source=booking&pid={pid}&in={checkin}&out={checkout}&g={guests}");
            }
            else
            {
                Response.Redirect("customerloginform.aspx");
            }
        }
    }
}