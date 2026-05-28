using System;
using System.Data;
using System.Web.UI;

namespace WebApplication2
{
    public partial class payment : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cid"] == null)
            {
                Response.Redirect("customerregistrationform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null && Request.QueryString["in"] != null && Request.QueryString["out"] != null)
                {
                    LoadCheckoutDetails();
                }
                else
                {
                    Response.Redirect("customerhomepage.aspx");
                }
            }
        }

        private void LoadCheckoutDetails()
        {
            try
            {
                string pid = Request.QueryString["pid"].ToString();
                DateTime checkIn = Convert.ToDateTime(Request.QueryString["in"]);
                DateTime checkOut = Convert.ToDateTime(Request.QueryString["out"]);
                string guests = Request.QueryString["g"].ToString();

                TimeSpan diff = checkOut - checkIn;
                int nights = diff.Days;

                lblDates.Text = checkIn.ToString("MMM dd") + " - " + checkOut.ToString("MMM dd, yyyy");
                lblGuestCount.Text = guests + (guests == "1" ? " guest" : " guests");
                lblNights.Text = nights.ToString();

                string qry = "SELECT title, price, pimage FROM property WHERE pid = '" + pid + "'";
                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    lblPropTitle.Text = row["title"].ToString();

                    // FIXED: Load image as string path
                    if (row["pimage"] != DBNull.Value && !string.IsNullOrEmpty(row["pimage"].ToString()))
                    {
                        imgPropThumb.ImageUrl = ResolveUrl("~/" + row["pimage"].ToString());
                    }
                    else
                    {
                        imgPropThumb.ImageUrl = "https://via.placeholder.com/150?text=No+Image";
                    }

                    decimal basePrice = Convert.ToDecimal(row["price"]);
                    decimal baseTotal = basePrice * nights;
                    decimal serviceFee = baseTotal * 0.10m;
                    decimal grandTotal = baseTotal + serviceFee;

                    lblBasePrice.Text = string.Format("{0:N0}", basePrice);
                    lblBaseTotal.Text = string.Format("{0:N0}", baseTotal);
                    lblServiceFee.Text = string.Format("{0:N0}", serviceFee);
                    lblGrandTotal.Text = string.Format("{0:N0}", grandTotal);

                    ViewState["FinalAmount"] = grandTotal;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Checkout Error: " + ex.Message);
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            try
            {
                string paymentMethod = ddlPaymentMethod.SelectedValue;
                string pid = Request.QueryString["pid"].ToString();

                DateTime dtIn = Convert.ToDateTime(Request.QueryString["in"]);
                DateTime dtOut = Convert.ToDateTime(Request.QueryString["out"]);
                string checkIn = dtIn.ToString("yyyy-MM-dd");
                string checkOut = dtOut.ToString("yyyy-MM-dd");

                string guests = Request.QueryString["g"].ToString();

                // Get final amount from ViewState
                decimal rawAmount = Convert.ToDecimal(ViewState["FinalAmount"]);
                string totalAmount = rawAmount.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture);

                string todayDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                string cid = Session["cid"].ToString();

                string qryBooking = "INSERT INTO booking (pid, cid, checkindate, checkoutdate, guestcount, totalamount, bookingdate, status) " +
                                    "VALUES ('" + pid + "', '" + cid + "', '" + checkIn + "', '" + checkOut + "', '" + guests + "', '" + totalAmount + "', '" + todayDate + "', 1)";

                m1.execute(qryBooking);

                string qryGetBid = "SELECT TOP 1 bid FROM booking WHERE cid = '" + cid + "' ORDER BY bid DESC";
                DataTable dtBid = m1.select(qryGetBid);

                if (dtBid != null && dtBid.Rows.Count > 0)
                {
                    string bid = dtBid.Rows[0]["bid"].ToString();

                    string qryPayment = "INSERT INTO payment (bid, amount, paymentmethod, transactiondate, status) " +
                                        "VALUES ('" + bid + "', '" + totalAmount + "', '" + paymentMethod + "', '" + todayDate + "', 1)";

                    m1.execute(qryPayment);
                }

                ClientScript.RegisterStartupScript(this.GetType(), "ShowPopup", "showSuccessPopup();", true);
            }
            catch (Exception ex)
            {
                string cleanError = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", " ");
                System.Diagnostics.Debug.WriteLine("Database Insertion Error: " + cleanError);
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Database Error: " + cleanError + "');", true);
            }
        }
    }
}