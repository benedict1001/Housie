using System;
using System.Data;
using System.Web.UI;

namespace WebApplication2
{
    public partial class customerreview : System.Web.UI.Page
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
              
                if (Request.QueryString["pid"] != null && Request.QueryString["bid"] != null)
                {
                    LoadPropertyDetails();
                    CheckIfAlreadyReviewed();
                }
                else
                {
                    Response.Redirect("customertrips.aspx");
                }
            }
        }

        private void LoadPropertyDetails()
        {
            try
            {
                string pid = Request.QueryString["pid"].ToString();
                string bid = Request.QueryString["bid"].ToString();
                string cid = Session["cid"].ToString();

                
                string qry = "SELECT p.title, p.pimage, b.checkindate, b.checkoutdate " +
                             "FROM property p INNER JOIN booking b ON p.pid = b.pid " +
                             "WHERE p.pid = '" + pid + "' AND b.bid = '" + bid + "' AND b.cid = '" + cid + "'";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    lblPropTitle.Text = row["title"].ToString();

                    DateTime checkin = Convert.ToDateTime(row["checkindate"]);
                    DateTime checkout = Convert.ToDateTime(row["checkoutdate"]);
                    lblDates.Text = checkin.ToString("MMM dd") + " - " + checkout.ToString("MMM dd, yyyy");

                    if (row["pimage"] != DBNull.Value)
                    {
                        byte[] imgBytes = (byte[])row["pimage"];
                        imgProperty.ImageUrl = "data:image/jpg;base64," + Convert.ToBase64String(imgBytes);
                    }
                }
                else
                {
                 
                    Response.Redirect("customertrips.aspx");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Review Load Error: " + ex.Message);
            }
        }

        private void CheckIfAlreadyReviewed()
        {
            try
            {
                string bid = Request.QueryString["bid"].ToString();

             
                string qry = "SELECT review_id FROM review WHERE bid = '" + bid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('You have already reviewed this trip!'); window.location='customertrips.aspx';", true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Review Check Error: " + ex.Message);
            }
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    string pid = Request.QueryString["pid"].ToString();
                    string bid = Request.QueryString["bid"].ToString();
                    string cid = Session["cid"].ToString();

                   
                    string rating = hfRatingScore.Value;
                    string reviewText = txtReview.Text.Replace("'", "''"); 
                    string todayDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            
                    if (rating == "0" || string.IsNullOrEmpty(rating))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a star rating.');", true);
                        return;
                    }

                
                    string qryInsert = "INSERT INTO review (pid, cid, bid, rating, reviewtext, reviewdate) " +
                                       "VALUES ('" + pid + "', '" + cid + "', '" + bid + "', '" + rating + "', N'" + reviewText + "', '" + todayDate + "')";

                    m1.execute(qryInsert);

                   
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Thank you! Your review has been submitted.'); window.location='customertrips.aspx';", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Review Submit Error: " + ex.Message);
                    string cleanError = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Database Error: " + cleanError + "');", true);
                }
            }
        }
    }
}