using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class adminpropertydetails : System.Web.UI.Page
    {

        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx");
                return;
            }
            if (!IsPostBack)
            {
                if (Session["pid"] != null)
                {
                    string pid = Session["pid"].ToString();

                    LoadPropertyDetails(pid);
                    LoadPropertyImages(pid);
                    LoadReviews(pid);
                }
                else
                {
                    Response.Redirect("adminhomepage.aspx");
                }
            }
        }

        private void LoadPropertyDetails(string pid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = @"
                        SELECT p.*, 
                               (h.fname + ' ' + h.lname) AS host_name, 
                               h.email AS host_email, 
                               h.phno AS host_phone 
                        FROM property p 
                        LEFT JOIN hostdetails h ON p.hid = h.hid 
                        WHERE p.pid = @pid";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                DataRow row = dt.Rows[0];

                                litTitle.Text = row["title"].ToString();
                                litAddress.Text = row["address"].ToString();
                                litDistrict.Text = row["district"].ToString();
                                litPrice.Text = row["price"].ToString();
                                litGuests.Text = row["guestno"].ToString();
                                litBedrooms.Text = row["bedroomno"].ToString();
                                litBeds.Text = row["bedno"].ToString();
                                litBaths.Text = row["bathroomno"].ToString();
                                litDescription.Text = row["description"].ToString();

                                litHostName.Text = row["host_name"] != DBNull.Value ? row["host_name"].ToString() : "N/A";
                                litHostEmail.Text = row["host_email"] != DBNull.Value ? row["host_email"].ToString() : "N/A";
                                litHostPhone.Text = row["host_phone"] != DBNull.Value ? row["host_phone"].ToString() : "N/A";


                                if (row["pimage"] != DBNull.Value && !string.IsNullOrEmpty(row["pimage"].ToString()))
                                {
                                    imgProperty.ImageUrl = ResolveUrl("~/" + row["pimage"].ToString());
                                }
                                else
                                {
                                    imgProperty.ImageUrl = "https://via.placeholder.com/1200x500?text=No+Image";
                                }

                                txtAdminMessage.Text = row["rejectreason"].ToString();
                                string status = row["status"].ToString();
                                hfCurrentStatus.Value = status;
                                UpdateUIBasedOnStatus(status);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Property Details Error: " + ex.Message);
            }
        }


        private void LoadPropertyImages(string pid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT * FROM propertyimage WHERE pid = @pid";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                DataRow row = dt.Rows[0];

                                // FIXED: Using ResolveUrl for string paths instead of byte[] Base64 conversion
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
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error Loading Gallery: " + ex.Message);
            }
        }


        private void LoadReviews(string pid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT rating, reviewtext, reviewdate FROM review WHERE pid = @pid ORDER BY reviewdate DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptReviews.DataSource = dt;
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
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Review Load Error: " + ex.Message);
            }
        }

        private void UpdateUIBasedOnStatus(string status)
        {
            if (status == "4")
            {
                lblStatusBadge.Text = "Currently Flagged";
                lblStatusBadge.CssClass = "status-badge badge-flagged";

                btnToggleFlag.Text = "Unflag Property";
                btnToggleFlag.CssClass = "btn btn-unflag";
            }
            else
            {
                lblStatusBadge.Text = "Active / Unflagged";
                lblStatusBadge.CssClass = "status-badge badge-active";

                btnToggleFlag.Text = "Flag Property";
                btnToggleFlag.CssClass = "btn btn-flag";
            }
        }

        protected void btnToggleFlag_Click(object sender, EventArgs e)
        {
            if (Session["pid"] == null) return;
            string pid = Session["pid"].ToString();

            string adminMessage = txtAdminMessage.Text.Trim();
            string currentStatus = hfCurrentStatus.Value;
            string newStatus = (currentStatus == "4") ? "2" : "4";

            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "UPDATE property SET status = @status, rejectreason = @reason WHERE pid = @pid";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@status", newStatus);
                        cmd.Parameters.AddWithValue("@reason", adminMessage);
                        cmd.Parameters.AddWithValue("@pid", pid);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                LoadPropertyDetails(pid);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Flag Update Error: " + ex.Message);
            }
        }
    }
}