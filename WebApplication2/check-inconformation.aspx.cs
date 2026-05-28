using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class check_inconformation : System.Web.UI.Page
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
                LoadPendingCheckins();
            }
        }

        private void LoadPendingCheckins()
        {
            try
            {
                string hid = Session["host_id"].ToString();

                // SQL Logic:
                // 1. Match the logged-in host (p.hid)
                // 2. Status = 1 (Booking is confirmed but not checked in)
                // 3. checkindate = GETDATE() (The check-in date is EXACTLY today)
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
                      AND b.status = 1 
                      AND CAST(b.checkindate AS DATE) = CAST(GETDATE() AS DATE)
                    ORDER BY b.checkindate ASC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCheckins.DataSource = dt;
                    rptCheckins.DataBind();

                    rptCheckins.Visible = true;
                    pnlNoCheckins.Visible = false;
                }
                else
                {
                    rptCheckins.Visible = false;
                    pnlNoCheckins.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading check-ins: " + ex.Message);
            }
        }

        protected void rptCheckins_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmCheckIn")
            {
                try
                {
                    // Grab the booking ID (bid) from the button's CommandArgument
                    string bid = e.CommandArgument.ToString();

                    // Update the status to 3 (Checked-In)
                    string qryUpdate = $"UPDATE booking SET status = 3 WHERE bid = '{bid}'";
                    m1.execute(qryUpdate);

                    // Show success alert using JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Guest successfully checked in!');", true);

                    // Refresh the list so the checked-in guest disappears from this screen
                    LoadPendingCheckins();
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