using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hostpayments : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["host_id"] == null)
                {
                    Response.Redirect("hostloginform.aspx");
                }
                else
                {
                    BindGrandTotal();
                    BindProperties();
                }
            }
        }

        private void BindGrandTotal()
        {
            try
            {
                string hostId = Session["host_id"].ToString();

                // Calculates 90% of the booking amount. 
                // Only includes Confirmed (1), Checked In (3), and Completed (4). Ignores Canceled (2).
                string totalQuery = string.Format(@"
                    SELECT COALESCE(SUM(CAST(totalamount AS DECIMAL(18,2)) * 0.9090909), 0) AS GrandTotal 
                    FROM booking 
                    WHERE pid IN (SELECT pid FROM property WHERE hid = {0})
                    AND status IN (1, 3, 4)", hostId);

                DataTable dtTotal = m1.select(totalQuery);

                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    lblGrandTotal.Text = Convert.ToDouble(dtTotal.Rows[0]["GrandTotal"]).ToString("N2");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error binding grand total: " + ex.Message);
            }
        }

        private void BindProperties()
        {
            try
            {
                string hostId = Session["host_id"].ToString();

                // Calculates 90% for the property badge. Ignores Canceled bookings in the sum.
                string query = string.Format(@"
                    SELECT pr.pid, pr.title, pr.district, pr.pimage, 
                           (SELECT COUNT(*) FROM booking b WHERE b.pid = pr.pid) AS totalbookings,
                           COALESCE((SELECT SUM(CAST(b.totalamount AS DECIMAL(18,2)) * 0.9090909) 
                                     FROM booking b 
                                     WHERE b.pid = pr.pid AND b.status IN (1, 3, 4)), 0) AS totalearned
                    FROM property pr 
                    WHERE pr.hid = {0} AND pr.status = 2", hostId);

                DataTable dtProps = m1.select(query);

                if (dtProps != null)
                {
                    rptProperties.DataSource = dtProps;
                    rptProperties.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error binding properties: " + ex.Message);
            }
        }

        protected void rptProperties_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptPayments = (Repeater)e.Item.FindControl("rptPayments");
                Label lblNoPayments = (Label)e.Item.FindControl("lblNoPayments");

                DataRowView row = (DataRowView)e.Item.DataItem;
                string currentPid = row["pid"].ToString();

                // Pulls straight from the booking table (b.totalamount) and takes 90%.
                string paymentQuery = string.Format(@"
                    SELECT 
                        b.bid, 
                        b.cid, 
                        b.bookingdate, 
                        (CAST(b.totalamount AS DECIMAL(18,2)) * 0.9090909) AS totalamount, 
                        b.status,
                        CASE 
                            WHEN b.status = 1 THEN 'Confirmed'
                            WHEN b.status = 2 THEN 'Canceled'
                            WHEN b.status = 3 THEN 'Checked In'
                            WHEN b.status = 4 THEN 'Completed'
                            ELSE 'Unknown'
                        END AS StatusText
                    FROM booking b
                    WHERE b.pid = {0}
                    ORDER BY b.bookingdate DESC", currentPid);

                DataTable dtPayments = m1.select(paymentQuery);

                if (dtPayments != null && dtPayments.Rows.Count > 0)
                {
                    rptPayments.DataSource = dtPayments;
                    rptPayments.DataBind();
                    rptPayments.Visible = true;
                    lblNoPayments.Visible = false;
                }
                else
                {
                    rptPayments.Visible = false;
                    lblNoPayments.Visible = true;
                }
            }
        }
    }
}