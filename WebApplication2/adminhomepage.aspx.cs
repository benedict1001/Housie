using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.EnterpriseServices;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class adminhomepage : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["admin_id"] == null) { Response.Redirect("adminlogin.aspx"); return; }

                realtimecount();
            }
        }

        private void realtimecount()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    litPaymentCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM payment WHERE status = 1");
                    litHostCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM hostdetails WHERE status=1");
                    litCategoryCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM propertytype1 WHERE status=1");
                    litLocationCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM district1 WHERE status=1");
                    litPendingPropertyCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM property WHERE status=1");
                    litPropertyCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM property WHERE status=2");
                    litActiveHostCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM hostdetails WHERE status=2");
                    litTotalReviewCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM review");
                    litFeedbackCount.Text = ExecuteCount(con, "SELECT COUNT(*) FROM feedback");

                    string lowReviewQuery = "SELECT COUNT(*) FROM (SELECT pid FROM review GROUP BY pid HAVING AVG(CAST(rating AS FLOAT)) <= 2) AS lowrated";
                    litLowReviewCount.Text = ExecuteCount(con, lowReviewQuery);

                    // MODIFIED: Counts only properties where the MOST RECENT message was sent by the 'Host'.
                    // This accurately reflects "New" or "Unreplied" messages awaiting the Admin.
                    string newAppealsQuery = @"
                        SELECT COUNT(*) 
                        FROM (
                            SELECT pid, sender_type,
                                   ROW_NUMBER() OVER(PARTITION BY pid ORDER BY created_at DESC) as rn
                            FROM property_appeals
                        ) as latest_msgs
                        WHERE rn = 1 AND sender_type = 'Host'";

                    litAppealsCount.Text = ExecuteCount(con, newAppealsQuery);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Payment Count Error: " + ex.Message);
            }
        }

        private string ExecuteCount(SqlConnection con, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "0";
            }
        }
    }
}