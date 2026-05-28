using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hosthome : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["host_id"] == null)
                {
                    Response.Redirect("hostloginform.aspx");
                }
                else
                {
                    LoadMyProperties();
                    LoadSidebarUnreadCount();
                }
            }
        }

        private void LoadMyProperties()
        {
            try
            {
                string hostId = Session["host_id"].ToString();

                DataTable dt = m1.get_host_properties(hostId);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptProperties.DataSource = dt;
                    rptProperties.DataBind();
                    rptProperties.Visible = true;
                    pnlNoProperties.Visible = false;
                }
                else
                {
                    rptProperties.Visible = false;
                    pnlNoProperties.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Populates the sidebar unread message badge for the host dashboard.
        /// </summary>
        private void LoadSidebarUnreadCount()
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
                        lblSidebarUnreadBadge.Text = count > 99 ? "99+" : count.ToString();
                        lblSidebarUnreadBadge.Visible = true;
                    }
                    else
                    {
                        lblSidebarUnreadBadge.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadSidebarUnreadCount error: " + ex.Message);
            }
        }

        protected void rptProperties_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                try
                {
                    string pid = e.CommandArgument.ToString();


                    string getStatusQry = "SELECT status FROM property WHERE pid = '" + pid + "'";
                    DataTable dt = m1.select(getStatusQry);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        string currentStatus = dt.Rows[0]["status"].ToString();


                        if (currentStatus == "2" || currentStatus == "6")
                        {

                            string newStatus = (currentStatus == "2") ? "6" : "2";


                            string updateQry = "UPDATE property SET status = " + newStatus + " WHERE pid = '" + pid + "'";
                            m1.execute(updateQry);


                            LoadMyProperties();
                        }
                        else
                        {

                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Only approved properties can be listed or unlisted.');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error toggling status: " + ex.Message);
                }
            }
        }
    }
}