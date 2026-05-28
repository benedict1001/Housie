using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class adminreview : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx");
                return;
            }
            if (!IsPostBack)
            {
             
                BindDashboardStats();
                BindProperties();
            }
        }

       
        private void BindDashboardStats()
        {
            try
            {
               
                DataTable dtTotal = m1.select("SELECT COUNT(*) FROM review");
                litTotalReviews.Text = dtTotal.Rows[0][0].ToString();

            
                DataTable dtAvg = m1.select("SELECT AVG(CAST(rating AS DECIMAL(10,2))) FROM review");
             
                if (dtAvg.Rows[0][0] != DBNull.Value)
                {
                   
                    litAvgRating.Text = Convert.ToDouble(dtAvg.Rows[0][0]).ToString("N1");
                }
                else
                {
                    litAvgRating.Text = "0.0";
                }

            
                DataTable dtCritical = m1.select("SELECT COUNT(*) FROM review WHERE rating <= 2");
                litCriticalCount.Text = dtCritical.Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Stats Error: " + ex.Message);
            }
        }

        private void BindProperties()
        {
            try
            {
            
                string qry = @"SELECT p.pid, p.title, p.address, p.pimage, 
                              (SELECT COUNT(*) FROM review r WHERE r.pid = p.pid) as review_count
                              FROM property p WHERE p.status = 2";

                DataTable dt = m1.select(qry);
                rptProperties.DataSource = dt;
                rptProperties.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Binding Properties: " + ex.Message);
            }
        }

        protected void rptProperties_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptNestedReviews = (Repeater)e.Item.FindControl("rptNestedReviews");
                Label lblNoReviews = (Label)e.Item.FindControl("lblNoReviews");

                DataRowView row = (DataRowView)e.Item.DataItem;
                string pid = row["pid"].ToString();

             
                string reviewQry = string.Format(@"
                    SELECT r.review_id, r.rating, r.reviewtext, r.reviewdate, c.fname 
                    FROM review r 
                    INNER JOIN customer c ON r.cid = c.cid 
                    WHERE r.pid = {0} ORDER BY r.reviewdate DESC", pid);

                DataTable dtReviews = m1.select(reviewQry);

                if (dtReviews != null && dtReviews.Rows.Count > 0)
                {
                    rptNestedReviews.DataSource = dtReviews;
                    rptNestedReviews.DataBind();
                }
                else
                {
                    lblNoReviews.Visible = true;
                }
            }
        }

        protected string GetStars(int rating)
        {
            string stars = "";
            for (int i = 1; i <= 5; i++)
            {
                stars += (i <= rating) ? "<i class='fas fa-star star-active'></i>" : "<i class='fas fa-star star-inactive'></i>";
            }
            return stars;
        }

        protected void rptNestedReviews_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteReview")
            {
                try
                {
                    string reviewId = e.CommandArgument.ToString();

                    
                    string delQry = "DELETE FROM review WHERE review_id = " + reviewId;
                    m1.execute(delQry);

               
                    BindDashboardStats();
                    BindProperties();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Delete Error: " + ex.Message);
                }
            }
        }
    }
}