using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication2
{
    public partial class hostmessages : System.Web.UI.Page
    {
        private string _connStr = ConfigurationManager.AppSettings["con"].ToString();
        private string _hostId;

        // =====================================================================
        // PAGE LOAD
        // =====================================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            // Auth guard — host must be logged in
            if (Session["host_id"] == null)
            {
                Response.Redirect("hostloginform.aspx");
                return;
            }

            _hostId = Session["host_id"].ToString();

            if (!IsPostBack)
            {
                LoadConversations();
            }
        }

        // =====================================================================
        // TASK B — LOAD CONVERSATIONS
        // Groups chat_messages by (sender/customer + property), returns the
        // latest message text, date, and unread count for each thread.
        // =====================================================================
        private void LoadConversations()
        {
            try
            {
                // This query returns one row per unique (customer, property) thread.
                // It fetches the latest message snippet and the per-thread unread count.
                const string sql = @"
                    SELECT
                        cm.sender_id,
                        cm.property_id,
                        p.hid          AS host_id,
                        p.title        AS property_title,
                        ISNULL(c.fname + ' ' + c.lname, cm.sender_id)
                                       AS customer_name,
                        MAX(cm.sent_date)
                                       AS latest_date,
                        -- Latest message text via a correlated sub-select
                        (
                            SELECT TOP 1 message_text
                            FROM   chat_messages cm2
                            WHERE  cm2.property_id = cm.property_id
                              AND  (  (cm2.sender_id   = cm.sender_id AND cm2.receiver_id = @hostId)
                                   OR (cm2.receiver_id = cm.sender_id AND cm2.sender_id   = @hostId)
                                   )
                            ORDER BY cm2.sent_date DESC
                        )              AS latest_message,
                        -- Unread count: only messages from the customer that the host hasn't read
                        SUM(CASE WHEN cm.is_read = 0 AND cm.receiver_id = @hostId THEN 1 ELSE 0 END)
                                       AS unread_count
                    FROM   chat_messages cm
                    INNER JOIN property  p ON cm.property_id = p.pid
                    LEFT  JOIN customer  c ON cm.sender_id   = c.cid
                    WHERE  (cm.sender_id = @hostId OR cm.receiver_id = @hostId)
                      AND  cm.sender_id <> @hostId   -- group by guest, not host's own messages
                    GROUP BY cm.sender_id, cm.property_id, p.hid, p.title,
                             c.fname, c.lname
                    ORDER BY latest_date DESC";

                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@hostId", _hostId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    bool hasConvs = dt.Rows.Count > 0;
                    pnlEmpty.Visible              = !hasConvs;
                    rptConversations.DataSource   = dt;
                    rptConversations.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadConversations error: " + ex.Message);
                ShowError("Could not load conversations. Please try refreshing.");
            }
        }

        // =====================================================================
        // HELPERS — called from ASPX data-binding expressions
        // =====================================================================

        /// <summary>Returns the first capital letter of a name for the avatar circle.</summary>
        protected string GetInitial(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "?";
            return name.Trim().Substring(0, 1).ToUpper();
        }

        /// <summary>
        /// Formats the latest message timestamp:
        ///  - Today  → "2:45 PM"
        ///  - This week → "Mon"
        ///  - Older  → "Apr 14"
        /// </summary>
        protected string FormatTime(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "";
            DateTime dt = Convert.ToDateTime(dateObj);
            DateTime now = DateTime.Now;

            if (dt.Date == now.Date)
                return dt.ToString("h:mm tt");

            if ((now - dt).TotalDays < 7)
                return dt.ToString("ddd");

            return dt.ToString("MMM d");
        }

        // =====================================================================
        // PRIVATE UTILITY
        // =====================================================================
        private void ShowError(string message)
        {
            lblError.Text    = "<i class='fas fa-exclamation-circle me-1'></i>" + message;
            lblError.Visible = true;
        }
    }
}
