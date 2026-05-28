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
    public partial class propertyapproveldetails : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null)
                {
                    fetchPropertyDetails();
                }
                else
                {
                    Response.Redirect("verifyproperties.aspx");
                }
            }
        }

        private void fetchPropertyDetails()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = @"SELECT p.*, h.hid, h.phno, h.email, (h.fname + ' ' + h.lname) AS full_name 
                                 FROM property p 
                                 INNER JOIN hostdetails h ON p.hid = h.hid 
                                 WHERE p.pid = @pid";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@pid", Request.QueryString["pid"]);

                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        lblTitle.Text = dr["title"].ToString();
                        lblPrice.Text = dr["price"].ToString();
                        lblDesc.Text = dr["description"].ToString();
                        lblRooms.Text = dr["bedroomno"].ToString();
                        lblGuests.Text = dr["guestno"].ToString();
                        lblbathroom.Text = dr["bathroomno"].ToString();
                        lblbed.Text = dr["bedno"].ToString();

                        lblHostID.Text = dr["hid"].ToString();
                        lblHostName.Text = dr["full_name"].ToString();
                        lblHostPhone.Text = dr["phno"].ToString();
                        lblHostEmail.Text = dr["email"].ToString();

                        // THE FIX: Check for the new image_path column (string) instead of converting bytes
                        if (dr.GetSchemaTable().Select("ColumnName = 'image_path'").Length > 0 && dr["image_path"] != DBNull.Value)
                        {
                            imgMain.ImageUrl = ResolveUrl("~/" + dr["image_path"].ToString());
                        }
                        // Fallback just in case you kept the name 'pimage' for the string column
                        else if (dr.GetSchemaTable().Select("ColumnName = 'pimage'").Length > 0 && dr["pimage"] != DBNull.Value)
                        {
                            imgMain.ImageUrl = ResolveUrl("~/" + dr["pimage"].ToString());
                        }
                        else
                        {
                            // Display a placeholder if no image path is found
                            imgMain.ImageUrl = "https://via.placeholder.com/600x400?text=No+Image+Available";
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('No data found for this ID');</script>");
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error fetching details: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            UpdateStatus(2, "");
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtReason.Text))
            {
                Response.Write("<script>alert('Please provide a reason for rejection.');</script>");
            }
            else
            {
                UpdateStatus(3, txtReason.Text);
            }
        }

        private void UpdateStatus(int status, string reason)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                string query = "UPDATE property SET status = @status, rejectreason = @reason WHERE pid = @pid";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@status", status);
                cmd.Parameters.AddWithValue("@reason", reason);
                cmd.Parameters.AddWithValue("@pid", Request.QueryString["pid"]);

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    string message = (status == 2) ? "Property Approved Successfully!" : "Property Rejected.";
                    Response.Write("<script>alert('" + message + "'); window.location='verifyproperties.aspx';</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Update failed: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }
    }
}