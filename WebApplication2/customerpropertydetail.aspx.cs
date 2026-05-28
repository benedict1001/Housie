using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class customerpropertydetail : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null)
                {
                    string pid = Request.QueryString["pid"].ToString();
                    LoadPropertyDetails(pid);
                    LoadPropertyImages(pid);
                    LoadBookedDates(pid);
                    LoadReviews(pid);
                }
                else
                {
                    Response.Redirect("customerhomepage.aspx");
                }
            }
        }

        private void LoadPropertyDetails(string pid)
        {
            try
            {
                string qry = "SELECT * FROM property WHERE pid = '" + pid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                    lblTitle.Text = row["title"].ToString();
                    lblLocation.Text = row["address"].ToString();

                    if (dt.Columns.Contains("location_type") && row["location_type"] != DBNull.Value)
                    {
                        lblLocationType.Text = row["location_type"].ToString();
                    }
                    else if (dt.Columns.Contains("locationtype") && row["locationtype"] != DBNull.Value)
                    {
                        lblLocationType.Text = row["locationtype"].ToString();
                    }

                    lblDescription.Text = row["description"].ToString();

                    lblGuests.Text = row["guestno"].ToString();
                    lblBedrooms.Text = row["bedroomno"].ToString();
                    lblBaths.Text = row["bathroomno"].ToString();
                    lblBeds.Text = row["bedno"].ToString();

                    int maxGuests = 0;
                    if (int.TryParse(row["guestno"].ToString(), out maxGuests))
                    {
                        ddlGuests.Items.Clear();
                        for (int i = 1; i <= maxGuests; i++)
                        {
                            string itemText = (i == 1) ? "1 guest" : i.ToString() + " guests";
                            ddlGuests.Items.Add(new ListItem(itemText, i.ToString()));
                        }
                    }

                    string priceString = row["price"].ToString();
                    decimal price = 0;
                    if (decimal.TryParse(priceString, out price))
                    {
                        lblPrice.Text = string.Format("{0:N0}", price);
                        hfBasePrice.Value = price.ToString();
                    }

                    // FIXED: Load main image from string path
                    if (row["pimage"] != DBNull.Value && !string.IsNullOrEmpty(row["pimage"].ToString()))
                    {
                        imgMain.ImageUrl = ResolveUrl("~/" + row["pimage"].ToString());
                    }

                    if (row["hid"] != null)
                    {
                        string hid = row["hid"].ToString();
                        hfHostId.Value = hid;
                        hostimage(hid);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Details: " + ex.Message);
            }
        }

        private void hostimage(string hid)
        {
            try
            {
                string qry = "SELECT * FROM hostdetails WHERE hid= '" + hid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string firstName = row["fname"] != DBNull.Value ? row["fname"].ToString() : "";
                    string lastName = row["lname"] != DBNull.Value ? row["lname"].ToString() : "";

                    lblHostName.Text = (firstName + " " + lastName).Trim();

                    // Host image remains as byte[] (if that is your design), only properties were moved to string path
                    if (row["himage"] != DBNull.Value)
                    {
                        byte[] hostImgBytes = (byte[])row["himage"];
                        imgHostAvatar.ImageUrl = "data:image/jpg;base64," + Convert.ToBase64String(hostImgBytes);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Host Details: " + ex.Message);
            }
        }

        private void LoadPropertyImages(string pid)
        {
            try
            {
                string qry = "SELECT * FROM propertyimage WHERE pid = '" + pid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];

                    // FIXED: Load gallery images from string paths
                    if (row["image1"] != DBNull.Value && !string.IsNullOrEmpty(row["image1"].ToString()))
                        img2.ImageUrl = ResolveUrl("~/" + row["image1"].ToString());
                    if (row["image2"] != DBNull.Value && !string.IsNullOrEmpty(row["image2"].ToString()))
                        img3.ImageUrl = ResolveUrl("~/" + row["image2"].ToString());
                    if (row["image3"] != DBNull.Value && !string.IsNullOrEmpty(row["image3"].ToString()))
                        img4.ImageUrl = ResolveUrl("~/" + row["image3"].ToString());
                    if (row["image4"] != DBNull.Value && !string.IsNullOrEmpty(row["image4"].ToString()))
                        img5.ImageUrl = ResolveUrl("~/" + row["image4"].ToString());
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Gallery: " + ex.Message);
            }
        }

        private void LoadBookedDates(string pid)
        {
            try
            {
                string qry = "SELECT checkindate, checkoutdate FROM booking WHERE pid = '" + pid + "' AND status = 1";
                DataTable dt = m1.select(qry);

                List<string> bookedDatesList = new List<string>();

                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        DateTime checkIn = Convert.ToDateTime(row["checkindate"]);
                        DateTime checkOut = Convert.ToDateTime(row["checkoutdate"]);

                        for (DateTime date = checkIn; date < checkOut; date = date.AddDays(1))
                        {
                            bookedDatesList.Add(date.ToString("yyyy-MM-dd"));
                        }
                    }
                }
                hfBookedDates.Value = string.Join(",", bookedDatesList);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Booked Dates: " + ex.Message);
            }
        }

        private void LoadReviews(string pid)
        {
            try
            {
                string qry = "SELECT r.rating, r.reviewtext, r.reviewdate, c.fname " +
                             "FROM review r INNER JOIN customer c ON r.cid = c.cid " +
                             "WHERE r.pid = '" + pid + "' " +
                             "ORDER BY r.reviewdate DESC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptReviews.DataSource = dt;
                    rptReviews.DataBind();

                    int totalReviews = dt.Rows.Count;
                    double sumRatings = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        sumRatings += Convert.ToDouble(row["rating"]);
                    }

                    double avgRating = sumRatings / totalReviews;
                    string formattedAvg = avgRating.ToString("0.00");
                    string reviewText = totalReviews == 1 ? "1 review" : totalReviews + " reviews";

                    lblTopRating.Text = formattedAvg;
                    lblTopReviewCount.Text = reviewText;

                    lblBottomRating.Text = formattedAvg;
                    lblBottomReviewCount.Text = reviewText;

                    lblNoReviews.Visible = false;
                }
                else
                {
                    rptReviews.DataSource = null;
                    rptReviews.DataBind();

                    lblTopRating.Text = "New";
                    lblTopReviewCount.Text = "0 reviews";

                    lblBottomRating.Text = "New";
                    lblBottomReviewCount.Text = "0 reviews";

                    lblNoReviews.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Reviews: " + ex.Message);
            }
        }

        protected string GetStars(int rating)
        {
            string starsHtml = "";
            for (int i = 0; i < rating; i++)
            {
                starsHtml += "<i class='fas fa-star'></i>";
            }
            return starsHtml;
        }

        protected void btnReserve_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCheckIn.Text) || string.IsNullOrEmpty(txtCheckOut.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select check-in and check-out dates.');", true);
                return;
            }

            string pid = Request.QueryString["pid"].ToString();
            DateTime checkInDate = Convert.ToDateTime(txtCheckIn.Text);
            DateTime checkOutDate = Convert.ToDateTime(txtCheckOut.Text);

            string overlapQuery = string.Format(@"
                SELECT * FROM booking 
                WHERE pid = '{0}' AND status = 1 
                AND checkindate < '{1}' 
                AND checkoutdate > '{2}'",
                pid, checkOutDate.ToString("yyyy-MM-dd"), checkInDate.ToString("yyyy-MM-dd"));

            DataTable dtOverlap = m1.select(overlapQuery);

            if (dtOverlap != null && dtOverlap.Rows.Count > 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Sorry, those dates are already booked. Please select available dates on the calendar.');", true);
                return;
            }

            string checkin = txtCheckIn.Text;
            string checkout = txtCheckOut.Text;
            string guests = ddlGuests.SelectedValue;

            Response.Redirect("customerbookproperty.aspx?pid=" + pid + "&in=" + checkin + "&out=" + checkout + "&g=" + guests, false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnMessageHost_Click(object sender, EventArgs e)
        {
            try
            {
                string pid = Request.QueryString["pid"];
                string hostId = hfHostId.Value;

                if (string.IsNullOrEmpty(hostId) || string.IsNullOrEmpty(pid))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertMsg",
                        "alert('Unable to start chat. Property information is missing.');", true);
                    return;
                }

                if (Session["cid"] == null)
                {
                    Response.Redirect("customerloginform.aspx");
                    return;
                }

                Response.Redirect($"chat.aspx?hostId={hostId}&propId={pid}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in Message Host: " + ex.Message);
            }
        }
    }
}