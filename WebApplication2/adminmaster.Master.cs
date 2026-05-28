using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Prevent the browser from caching the page (Fixes the Back Button exploit)
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();

            // 2. Security Check: Ensure the admin is actually logged in
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        // The secure logout event
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Clear all session variables
                Session.Clear();

                // 2. Destroy the session completely from the server
                Session.Abandon();

                // 3. Clear the authentication cookie (safeguard)
                if (Request.Cookies["ASP.NET_SessionId"] != null)
                {
                    Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                    Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
                }

                // 4. Redirect them to the admin login page
                Response.Redirect("adminlogin.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Admin Logout Error: " + ex.Message);
            }
        }
    }
}