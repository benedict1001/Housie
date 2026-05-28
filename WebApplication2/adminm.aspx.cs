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
    public partial class adminm : System.Web.UI.Page
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
                BindHosts();
            }
        }

        private void BindHosts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    // Pulls all hosts, newest first
                    string query = "SELECT hid, fname, lname, email, phno, status, himage FROM hostdetails ORDER BY hid DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptHosts.DataSource = dt;
                                rptHosts.DataBind();
                                rptHosts.Visible = true;
                                pnlNoHosts.Visible = false;
                            }
                            else
                            {
                                rptHosts.Visible = false;
                                pnlNoHosts.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading hosts: " + ex.Message);
            }
        }

        protected void rptHosts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string hostId = e.CommandArgument.ToString();
            int newStatus = 0;

            if (e.CommandName == "Activate")
            {
                newStatus = 2; // 2 = Active
            }
            else if (e.CommandName == "Suspend")
            {
                newStatus = 3; // 3 = Suspended/Blocked
            }

            if (newStatus != 0)
            {
                UpdateHostStatus(hostId, newStatus);
            }
        }

        private void UpdateHostStatus(string hostId, int status)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "UPDATE hostdetails SET status = @status WHERE hid = @hid";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@status", status);
                        cmd.Parameters.AddWithValue("@hid", hostId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Refresh the table to show the new status
                BindHosts();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating host status: " + ex.Message);
            }
        }

        // --- HELPER METHODS FOR THE FRONTEND ---

        protected string GetImageSource(object imageData, string fname, string lname)
        {
            // If the host uploaded an image, convert the byte array to Base64
            if (imageData != null && imageData != DBNull.Value)
            {
                byte[] bytes = (byte[])imageData;
                if (bytes.Length > 0)
                {
                    string base64String = Convert.ToBase64String(bytes);
                    return "data:image/jpeg;base64," + base64String;
                }
            }

            // If no image exists, generate a professional avatar using their initials
            string fullName = (fname + " " + lname).Trim();
            if (string.IsNullOrEmpty(fullName)) fullName = "Host";

            return "https://ui-avatars.com/api/?name=" + Uri.EscapeDataString(fullName) + "&background=f1f5f9&color=64748b&bold=true";
        }

        protected string GetStatusText(object statusObj)
        {
            if (statusObj == null || statusObj == DBNull.Value) return "Unknown";

            string status = statusObj.ToString();
            switch (status)
            {
                case "1": return "Pending";
                case "2": return "Active";
                case "3": return "Suspended";
                default: return "Unknown";
            }
        }

        protected string GetStatusCssClass(object statusObj)
        {
            if (statusObj == null || statusObj == DBNull.Value) return "";

            string status = statusObj.ToString();
            switch (status)
            {
                case "1": return "badge-pending";
                case "2": return "badge-active";
                case "3": return "badge-suspended";
                default: return "";
            }
        }
    }
}
