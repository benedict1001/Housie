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
    public partial class flagproperty : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["host_id"] == null)
            {
                Response.Redirect("hostloginform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["pid"] != null)
                {
                    string pid = Request.QueryString["pid"].ToString();
                    LoadPropertyDetails(pid);
                    LoadMessages(pid);
                }
                else
                {
                    Response.Redirect("hosthome.aspx");
                }
            }
        }

        private void LoadPropertyDetails(string pid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT title, pimage, rejectreason FROM property WHERE pid = @pid AND hid = @hid";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        cmd.Parameters.AddWithValue("@hid", Session["host_id"].ToString());

                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                litPropTitle.Text = reader["title"].ToString();

                                string imgPath = reader["pimage"].ToString();
                                imgProperty.ImageUrl = !string.IsNullOrEmpty(imgPath) ? ResolveUrl("~/" + imgPath) : "https://via.placeholder.com/150";

                                string reason = reader["rejectreason"].ToString();
                                if (!string.IsNullOrEmpty(reason))
                                {
                                    litRejectReason.Text = reason;
                                }
                            }
                            else
                            {
                                // Security check: If property doesn't belong to this host, kick them out
                                Response.Redirect("hosthome.aspx");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading flag details: " + ex.Message);
            }
        }

        private void LoadMessages(string pid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT sender_type, message, created_at FROM property_appeals WHERE pid = @pid ORDER BY created_at ASC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@pid", pid);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptChat.DataSource = dt;
                                rptChat.DataBind();
                                rptChat.Visible = true;
                                lblNoMessages.Visible = false;
                            }
                            else
                            {
                                rptChat.Visible = false;
                                lblNoMessages.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading messages: " + ex.Message);
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string pid = Request.QueryString["pid"];
            string message = txtMessage.Text.Trim();

            if (!string.IsNullOrEmpty(pid) && !string.IsNullOrEmpty(message))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        string query = "INSERT INTO property_appeals (pid, sender_type, message, created_at) VALUES (@pid, 'Host', @message, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@pid", pid);
                            cmd.Parameters.AddWithValue("@message", message);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    txtMessage.Text = ""; // Clear input
                    LoadMessages(pid); // Refresh chat
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error sending message: " + ex.Message);
                }
            }
        }
    }
}