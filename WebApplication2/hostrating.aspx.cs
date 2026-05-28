using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hostrating : System.Web.UI.Page
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
                           COALESCE((SELECT AVG(CAST(rating AS FLOAT)) FROM review r WHERE r.pid = p.pid), 0) AS avgrating,
                           (SELECT COUNT(*) FROM review r WHERE r.pid = p.pid) AS totalreviews
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
                Repeater rptReviews = (Repeater)e.Item.FindControl("rptReviews");
                Label lblNoReviews = (Label)e.Item.FindControl("lblNoReviews");

                DataRowView row = (DataRowView)e.Item.DataItem;
                string currentPid = row["pid"].ToString();

              
                string reviewQuery = string.Format(@"
                    SELECT r.rating, r.reviewtext, r.reviewdate, c.fname 
                    FROM review r
                    INNER JOIN customer c ON r.cid = c.cid
                    WHERE r.pid = {0} 
                    ORDER BY r.reviewdate DESC", currentPid);

                DataTable dtReviews = m1.select(reviewQuery);

                if (dtReviews != null && dtReviews.Rows.Count > 0)
                {
                    rptReviews.DataSource = dtReviews;
                    rptReviews.DataBind();
                    rptReviews.Visible = true;
                    lblNoReviews.Visible = false;
                }
                else
                {
                    rptReviews.Visible = false;
                    lblNoReviews.Visible = true;
                }
            }
        }
    }
}