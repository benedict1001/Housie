using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class checkout_conformation : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security: Ensure the host is logged in
            if (Session["host_id"] == null)
            {
                Response.Redirect("hostloginform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadPendingCheckouts();
            }
        }

        private void LoadPendingCheckouts()
        {
            try
            {
                string hid = Session["host_id"].ToString();

                // SQL Logic:
                // 1. Match the logged-in host (p.hid)
                // 2. Status = 3 (Booking is currently checked in)
                // 3. checkoutdate <= GETDATE() (The check-out date is today, or they are overdue)
                string qry = $@"
                    SELECT 
                        b.bid, 
                        c.fname + ' ' + c.lname AS CustomerName, 
                        c.phoneno, 
                        p.title, 
                        b.checkindate, 
                        b.checkoutdate, 
                        b.guestcount 
                    FROM booking b
                    INNER JOIN property p ON b.pid = p.pid
                    INNER JOIN customer c ON b.cid = c.cid
                    WHERE p.hid = '{hid}' 
                      AND b.status = 3 
                      AND CAST(b.checkoutdate AS DATE) <= CAST(GETDATE() AS DATE)
                    ORDER BY b.checkoutdate ASC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCheckouts.DataSource = dt;
                    rptCheckouts.DataBind();

                    rptCheckouts.Visible = true;
                    pnlNoCheckouts.Visible = false;
                }
                else
                {
                    rptCheckouts.Visible = false;
                    pnlNoCheckouts.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading check-outs: " + ex.Message);
            }
        }

        protected void rptCheckouts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmCheckOut")
            {
                try
                {
                    // Grab the booking ID (bid) from the button's CommandArgument
                    string bid = e.CommandArgument.ToString();

                    // Update the status to 4 (Completed/Checked-Out)
                    string qryUpdate = $"UPDATE booking SET status = 4 WHERE bid = '{bid}'";
                    m1.execute(qryUpdate);

                    // Show success alert using JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Guest successfully checked out. Trip completed!');", true);

                    // Refresh the list so the checked-out guest disappears from this screen
                    LoadPendingCheckouts();
                }
                catch (Exception ex)
                {
                    // Clean the error string so it doesn't break the JavaScript alert
                    string cleanError = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error: {cleanError}');", true);
                }
            }
        }
    }
}