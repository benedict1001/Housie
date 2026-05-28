using System;
using System.Data;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hostbooking : System.Web.UI.Page
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
                    BindProperties();
                }
            }
        }

        private void BindProperties()
        {
            try
            {
                string hostId = Session["host_id"].ToString();

              
                string query = string.Format(@"
                    SELECT p.pid, p.title, p.district, p.pimage, 
                           (SELECT COUNT(*) FROM booking b WHERE b.pid = p.pid) AS totalbookings 
                    FROM property p 
                    WHERE p.hid = {0} AND p.status = 2", hostId);

                DataTable dtProps = m1.select(query);

                if (dtProps != null && dtProps.Rows.Count > 0)
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
                Repeater rptBookings = (Repeater)e.Item.FindControl("rptBookings");
                Label lblNoBookings = (Label)e.Item.FindControl("lblNoBookings");

                DataRowView row = (DataRowView)e.Item.DataItem;
                string currentPid = row["pid"].ToString();

            
                string bookingQuery = string.Format(@"
                    SELECT bid, cid, checkindate, checkoutdate, totalamount,
                           CASE WHEN checkoutdate < CONVERT(date, GETDATE()) THEN 'Completed'
                                WHEN checkindate <= CONVERT(date, GETDATE()) AND checkoutdate >= CONVERT(date, GETDATE()) THEN 'Ongoing'
                                ELSE 'Upcoming' END AS StatusText,
                           CASE WHEN checkoutdate < CONVERT(date, GETDATE()) THEN 'past-booking'
                                ELSE 'future-booking' END AS TimeClass
                    FROM booking 
                    WHERE pid = {0} 
                    ORDER BY checkindate ASC", currentPid); 

                DataTable dtBookings = m1.select(bookingQuery);

                if (dtBookings != null && dtBookings.Rows.Count > 0)
                {
                    rptBookings.DataSource = dtBookings;
                    rptBookings.DataBind();
                    rptBookings.Visible = true;
                    lblNoBookings.Visible = false;
                }
                else
                {
                    rptBookings.Visible = false;
                    lblNoBookings.Visible = true;
                }
            }
        }
    }
}