using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class customerloginform : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string email = txtLoginEmail.Text.Trim();
                    string password = txtLoginPassword.Text.Trim();

                    string qry = "SELECT cid, email FROM customer WHERE email = '" + email + "' AND password = '" + password + "' AND status = 1";
                    DataTable dt = m1.select(qry);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        // 1. Establish the session
                        Session["cid"] = dt.Rows[0]["cid"].ToString();
                        Session["cemail"] = dt.Rows[0]["email"].ToString();

                        // 2. Check if they came from the booking page
                        string source = Request.QueryString["source"];

                        if (source == "booking" && Request.QueryString["pid"] != null)
                        {
                            // Grab the booking details and send them back to pay
                            string pid = Request.QueryString["pid"].ToString();
                            string checkin = Request.QueryString["in"] != null ? Request.QueryString["in"].ToString() : "";
                            string checkout = Request.QueryString["out"] != null ? Request.QueryString["out"].ToString() : "";
                            string guests = Request.QueryString["g"] != null ? Request.QueryString["g"].ToString() : "1";

                            Response.Redirect($"customerbookproperty.aspx?pid={pid}&in={checkin}&out={checkout}&g={guests}", false);
                        }
                        else if (Request.QueryString["pid"] != null)
                        {
                            // Alternative flow: Came from viewing a property detail page
                            Response.Redirect("customerpropertydetail.aspx?pid=" + Request.QueryString["pid"].ToString(), false);
                        }
                        else
                        {
                            // Standard flow: Send to homepage
                            Response.Redirect("customerhomepage.aspx", false);
                        }

                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Invalid Email or Password.');", true);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Login Error: " + ex.Message);
                    string cleanError = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error: " + cleanError + "');", true);
                }
            }
        }

        // BONUS: Use this if you have a "Create an Account / Sign Up" button on your login page!
        protected void btnGoToRegister_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["source"] != null && Request.QueryString["source"].ToString() == "booking")
            {
                // Pass the booking baton back to the registration page
                string pid = Request.QueryString["pid"];
                string checkin = Request.QueryString["in"];
                string checkout = Request.QueryString["out"];
                string guests = Request.QueryString["g"];

                Response.Redirect($"customerregistrationform.aspx?source=booking&pid={pid}&in={checkin}&out={checkout}&g={guests}");
            }
            else
            {
                // Standard redirect
                Response.Redirect("customerregistrationform.aspx");
            }
        }
    }
}