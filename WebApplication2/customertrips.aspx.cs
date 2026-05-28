using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace WebApplication2
{
    public partial class customertrips : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("customerloginform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUpcomingTrips();
                LoadCurrentTrips();
                LoadPastTrips();
            }
        }

        private void LoadUpcomingTrips()
        {
            try
            {
                string cid = Session["cid"].ToString();

                string qry = "SELECT b.bid, b.pid, p.title, p.pimage, p.hid, b.checkindate, b.checkoutdate, b.totalamount " +
                             "FROM booking b INNER JOIN property p ON b.pid = p.pid " +
                             "WHERE b.cid = '" + cid + "' AND b.status = 1 " +
                             "ORDER BY b.checkindate ASC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptUpcoming.DataSource = dt;
                    rptUpcoming.DataBind();
                    lblNoUpcoming.Visible = false;
                }
                else
                {
                    rptUpcoming.DataSource = null;
                    rptUpcoming.DataBind();
                    lblNoUpcoming.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading upcoming trips: " + ex.Message);
            }
        }

        private void LoadCurrentTrips()
        {
            try
            {
                string cid = Session["cid"].ToString();

                string qry = "SELECT b.bid, b.pid, p.title, p.pimage, p.hid, b.checkindate, b.checkoutdate, b.totalamount " +
                             "FROM booking b INNER JOIN property p ON b.pid = p.pid " +
                             "WHERE b.cid = '" + cid + "' AND b.status = 3 " +
                             "ORDER BY b.checkoutdate ASC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptCurrent.DataSource = dt;
                    rptCurrent.DataBind();
                    lblNoCurrent.Visible = false;
                }
                else
                {
                    rptCurrent.DataSource = null;
                    rptCurrent.DataBind();
                    lblNoCurrent.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading current trips: " + ex.Message);
            }
        }

        private void LoadPastTrips()
        {
            try
            {
                string cid = Session["cid"].ToString();

                // ADDED: Subquery to check the 'review' table for an existing rating linked to this 'bid'
                string qry = "SELECT b.bid, b.pid, p.title, p.pimage, b.checkindate, b.checkoutdate, b.totalamount, " +
                             "(SELECT COUNT(*) FROM review WHERE bid = b.bid) AS HasReviewed " +
                             "FROM booking b INNER JOIN property p ON b.pid = p.pid " +
                             "WHERE b.cid = '" + cid + "' AND b.status = 4 " +
                             "ORDER BY b.checkoutdate DESC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptPast.DataSource = dt;
                    rptPast.DataBind();
                    lblNoPast.Visible = false;
                }
                else
                {
                    rptPast.DataSource = null;
                    rptPast.DataBind();
                    lblNoPast.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading past trips: " + ex.Message);
            }
        }

        protected void btnConfirmCancel_Click(object sender, EventArgs e)
        {
            // ... (existing cancel logic unchanged)
            try
            {
                string bid = hfCancelBid.Value;

                if (!string.IsNullOrEmpty(bid))
                {
                    string qryCheck = "SELECT checkindate FROM booking WHERE bid = '" + bid + "'";
                    DataTable dt = m1.select(qryCheck);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        DateTime checkin = Convert.ToDateTime(dt.Rows[0]["checkindate"]);

                        if ((checkin - DateTime.Now).TotalDays >= 2)
                        {
                            string qryUpdateBooking = "UPDATE booking SET status = 2 WHERE bid = '" + bid + "'";
                            m1.execute(qryUpdateBooking);

                            string qryUpdatePayment = "UPDATE payment SET status = 2 WHERE bid = '" + bid + "'";
                            m1.execute(qryUpdatePayment);

                            ClientScript.RegisterStartupScript(this.GetType(), "ShowSuccess", "showCancelSuccess();", true);
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Cancellations must be made at least 48 hours prior to check-in.');", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string cleanError = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error: " + cleanError + "');", true);
            }
        }

        /// <summary>
        /// Handles the "Message Host" LinkButton click from both the Upcoming and Current trip repeaters.
        /// The CommandArgument is encoded as "hostId|propertyId".
        /// </summary>
        protected void lnkMessageHost_Command(object sender, CommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "MessageHost")
                {
                    string[] parts = e.CommandArgument.ToString().Split('|');
                    if (parts.Length == 2)
                    {
                        string hostId = parts[0].Trim();
                        string propId = parts[1].Trim();

                        if (!string.IsNullOrEmpty(hostId) && !string.IsNullOrEmpty(propId))
                        {
                            Response.Redirect($"chat.aspx?hostId={hostId}&propId={propId}");
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alertMsg",
                                "alert('Could not open chat: host or property information is missing.');", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("lnkMessageHost_Command error: " + ex.Message);
            }
        }

        protected string GetImage(object imgData)
        {
            if (imgData != DBNull.Value && !string.IsNullOrEmpty(imgData.ToString()))
            {
                return ResolveUrl("~/" + imgData.ToString());
            }
            return "https://via.placeholder.com/400x200?text=No+Image";
        }
    }
}