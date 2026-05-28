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
    public partial class adminappeals : System.Web.UI.Page
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
                BindAppealsList();
            }
        }

        private void BindAppealsList()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    // This query gets unique properties that have an appeal, along with some summary stats
                    string query = @"
                        SELECT 
                            pa.pid, 
                            MAX(pr.title) as title, 
                            MAX(h.fname + ' ' + h.lname) as hostfullname,
                            COUNT(pa.appeal_id) as MessageCount,
                            MAX(pa.created_at) as LatestMessage,
                            MAX(pr.status) as status
                        FROM property_appeals pa
                        INNER JOIN property pr ON pa.pid = pr.pid
                        INNER JOIN hostdetails h ON pr.hid = h.hid
                        GROUP BY pa.pid
                        ORDER BY LatestMessage DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptAppealsList.DataSource = dt;
                                rptAppealsList.DataBind();
                                rptAppealsList.Visible = true;
                                pnlNoAppeals.Visible = false;
                            }
                            else
                            {
                                rptAppealsList.Visible = false;
                                pnlNoAppeals.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error binding appeals list: " + ex.Message);
            }
        }

        protected void rptAppealsList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewChat")
            {
                string pid = e.CommandArgument.ToString();
                hfActivePid.Value = pid;
                litActivePid.Text = pid;

                LoadChatHistory(pid);

                pnlChatInterface.Visible = true;
            }
        }

        private void LoadChatHistory(string pid)
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

                            rptChatMessages.DataSource = dt;
                            rptChatMessages.DataBind();
                        }
                    }

                    // Check if the property is currently flagged to toggle the Unflag button
                    string statusQuery = "SELECT status FROM property WHERE pid = @pid";
                    using (SqlCommand cmdStatus = new SqlCommand(statusQuery, con))
                    {
                        cmdStatus.Parameters.AddWithValue("@pid", pid);
                        con.Open();
                        object result = cmdStatus.ExecuteScalar();
                        con.Close();

                        if (result != null && result.ToString() == "4")
                        {
                            btnUnflag.Visible = true;
                        }
                        else
                        {
                            btnUnflag.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading chat: " + ex.Message);
            }
        }

        protected void btnSendReply_Click(object sender, EventArgs e)
        {
            string pid = hfActivePid.Value;
            string message = txtAdminReply.Text.Trim();

            if (!string.IsNullOrEmpty(pid) && !string.IsNullOrEmpty(message))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        string query = "INSERT INTO property_appeals (pid, sender_type, message, created_at) VALUES (@pid, 'Admin', @message, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@pid", pid);
                            cmd.Parameters.AddWithValue("@message", message);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    txtAdminReply.Text = ""; // Clear input
                    LoadChatHistory(pid); // Refresh chat
                    BindAppealsList(); // Refresh the main table to update the "Latest Activity" column
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error sending admin reply: " + ex.Message);
                }
            }
        }

        protected void btnCloseChat_Click(object sender, EventArgs e)
        {
            pnlChatInterface.Visible = false;
            hfActivePid.Value = "";
        }

        protected void btnUnflag_Click(object sender, EventArgs e)
        {
            string pid = hfActivePid.Value;

            if (!string.IsNullOrEmpty(pid))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        // Change status back to 2 (Active/Approved)
                        string query = "UPDATE property SET status = 2, rejectreason = 'Resolved via Appeal' WHERE pid = @pid";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@pid", pid);
                            con.Open();
                            cmd.ExecuteNonQuery();
                            con.Close();
                        }

                        // Add an automated system message to the chat
                        string msgQuery = "INSERT INTO property_appeals (pid, sender_type, message, created_at) VALUES (@pid, 'Admin', 'System: Property has been unflagged and is now visible to customers.', GETDATE())";
                        using (SqlCommand cmdMsg = new SqlCommand(msgQuery, con))
                        {
                            cmdMsg.Parameters.AddWithValue("@pid", pid);
                            con.Open();
                            cmdMsg.ExecuteNonQuery();
                        }
                    }

                    LoadChatHistory(pid);
                    BindAppealsList();

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Property successfully unflagged.');", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error unflagging property: " + ex.Message);
                }
            }
        }
    }
}