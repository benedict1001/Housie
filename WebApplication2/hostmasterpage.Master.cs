using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hostmasterpage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["host_id"] != null)
            {
                LoadUnreadMessageCount();
            }
        }

        /// <summary>
        /// Queries the count of unread messages where the host is the receiver.
        /// Shows/hides the navbar badge accordingly.
        /// </summary>
        private void LoadUnreadMessageCount()
        {
            try
            {
                string hostId = Session["host_id"].ToString();
                string connStr = ConfigurationManager.AppSettings["con"].ToString();

                const string sql = @"
                    SELECT COUNT(*)
                    FROM   chat_messages
                    WHERE  receiver_id = @hostId
                      AND  is_read    = 0";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@hostId", hostId);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        lblNavUnreadBadge.Text    = count > 99 ? "99+" : count.ToString();
                        lblNavUnreadBadge.Visible = true;
                    }
                    else
                    {
                        lblNavUnreadBadge.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUnreadMessageCount error: " + ex.Message);
                lblNavUnreadBadge.Visible = false;
            }
        }
        protected void LinkButtonLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("hostloginform.aspx"); 
        }
    }
}