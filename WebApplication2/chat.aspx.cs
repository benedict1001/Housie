using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class chat : System.Web.UI.Page
    {
        // Connection string pulled from Web.config appSettings key "con"
        private string _connStr = ConfigurationManager.AppSettings["con"].ToString();

        // These are set once and reused across helper methods
        private string _customerId;
        private string _hostId;
        private string _propId;

        // Tracks whether the current viewer is a host (true) or customer (false)
        private bool _isHost = false;

        // =====================================================================
        // PAGE LOAD
        // =====================================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            // --- Dual-role auth guard ---
            // Hosts arrive via: chat.aspx?hostId=X&custId=Y&propId=Z
            // Customers arrive via: chat.aspx?hostId=X&propId=Z
            if (Session["host_id"] != null && Request.QueryString["custId"] != null)
            {
                // ---- HOST VIEW ----
                _isHost     = true;
                _hostId     = Session["host_id"].ToString();
                _customerId = Request.QueryString["custId"];
                _propId     = Request.QueryString["propId"];
            }
            else if (Session["cid"] != null)
            {
                // ---- CUSTOMER VIEW ----
                _isHost     = false;
                _customerId = Session["cid"].ToString();
                _hostId     = Request.QueryString["hostId"];
                _propId     = Request.QueryString["propId"];
            }
            else
            {
                // Not logged in as either — redirect to customer login
                Response.Redirect("customerloginform.aspx");
                return;
            }

            // Validate required query string values
            if (string.IsNullOrWhiteSpace(_hostId) || string.IsNullOrWhiteSpace(_propId)
                    || string.IsNullOrWhiteSpace(_customerId))
            {
                Response.Redirect(_isHost ? "hostmessages.aspx" : "customerhomepage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Store in hidden fields so PostBack handlers can reuse them without QS
                hfHostId.Value  = _hostId;
                hfPropId.Value  = _propId;
                hfCustId.Value  = _customerId;

                LoadHostInfo();
                LoadPropertyName();
                LoadChatHistory();
            }
            else
            {
                // On PostBack, restore from hidden fields
                _hostId     = hfHostId.Value;
                _propId     = hfPropId.Value;
                _customerId = hfCustId.Value;
                // Re-detect who is viewing on postback
                _isHost = (Session["host_id"] != null && Session["host_id"].ToString() == _hostId);
            }
        }


        // =====================================================================
        // LOAD HOST INFO (name + initial avatar letter)
        // =====================================================================
        private void LoadHostInfo()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT fname, lname FROM hostdetails WHERE hid = @hid", con))
                {
                    cmd.Parameters.Add("@hid", SqlDbType.VarChar, 50).Value = _hostId;
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string fname = dr["fname"] != DBNull.Value ? dr["fname"].ToString() : "";
                            string lname = dr["lname"] != DBNull.Value ? dr["lname"].ToString() : "";
                            string fullName = (fname + " " + lname).Trim();

                            lblHostName.Text = Server.HtmlEncode(fullName);

                            // Set avatar initial
                            if (!string.IsNullOrEmpty(fname))
                                hostInitialDiv.InnerText = fname.Substring(0, 1).ToUpper();
                        }
                        else
                        {
                            lblHostName.Text = "Your Host";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadHostInfo error: " + ex.Message);
                lblHostName.Text = "Your Host";
            }
        }

        // =====================================================================
        // LOAD PROPERTY NAME
        // =====================================================================
        private void LoadPropertyName()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT title FROM property WHERE pid = @pid", con))
                {
                    cmd.Parameters.Add("@pid", SqlDbType.Int).Value = int.Parse(_propId);
                    con.Open();

                    object result = cmd.ExecuteScalar();
                    lblPropertyName.Text = result != null
                        ? Server.HtmlEncode(result.ToString())
                        : "Property";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadPropertyName error: " + ex.Message);
                lblPropertyName.Text = "Property";
            }
        }

        // =====================================================================
        // LOAD CHAT HISTORY
        // =====================================================================
        private void LoadChatHistory()
        {
            try
            {
                const string sql = @"
                    SELECT message_id, sender_id, receiver_id, message_text, sent_date
                    FROM   chat_messages
                    WHERE  property_id = @propId
                      AND  (
                              (sender_id = @custId AND receiver_id = @hostId)
                           OR (sender_id = @hostId AND receiver_id = @custId)
                           )
                    ORDER BY sent_date ASC";

                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@propId",  SqlDbType.Int).Value         = int.Parse(_propId);
                    cmd.Parameters.Add("@custId",  SqlDbType.VarChar, 50).Value = _customerId;
                    cmd.Parameters.Add("@hostId",  SqlDbType.VarChar, 50).Value = _hostId;

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    bool hasMessages = dt.Rows.Count > 0;
                    pnlEmptyChat.Visible  = !hasMessages;
                    rptMessages.DataSource = dt;
                    rptMessages.DataBind();

                    // Mark incoming messages as read
                    if (hasMessages) MarkMessagesAsRead();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadChatHistory error: " + ex.Message);
                ShowError("Could not load message history. Please try refreshing.");
            }
        }

        // =====================================================================
        // TASK C — MARK MESSAGES AS READ
        // Marks all unread messages sent to the current viewer as read.
        // When a customer opens the chat → marks host→customer messages as read.
        // When a host opens the chat    → marks customer→host messages as read.
        // =====================================================================
        private void MarkMessagesAsRead()
        {
            try
            {
                // The "sender" whose messages we mark as read is whoever sent TO the current viewer.
                string currentViewerId = _isHost ? _hostId     : _customerId;
                string otherPersonId   = _isHost ? _customerId : _hostId;

                const string sql = @"
                    UPDATE chat_messages
                    SET    is_read = 1
                    WHERE  property_id  = @propId
                      AND  sender_id    = @senderId
                      AND  receiver_id  = @viewerId
                      AND  is_read      = 0";

                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@propId",   SqlDbType.Int).Value         = int.Parse(_propId);
                    cmd.Parameters.Add("@senderId", SqlDbType.VarChar, 50).Value = otherPersonId;
                    cmd.Parameters.Add("@viewerId", SqlDbType.VarChar, 50).Value = currentViewerId;
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("MarkMessagesAsRead error: " + ex.Message);
            }
        }

        // =====================================================================
        // SEND BUTTON CLICK
        // =====================================================================
        protected void btnSend_Click(object sender, EventArgs e)
        {
            string messageText = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(messageText))
            {
                // Nothing to send — silently ignore
                LoadChatHistory();
                return;
            }

            try
            {
                const string sql = @"
                    INSERT INTO chat_messages
                        (sender_id, receiver_id, property_id, message_text, sent_date, is_read)
                    VALUES
                        (@senderId, @receiverId, @propId, @msgText, GETDATE(), 0)";

                using (SqlConnection con = new SqlConnection(_connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    // Sender/receiver depend on who is currently viewing the chat
                    string senderId   = _isHost ? _hostId     : _customerId;
                    string receiverId = _isHost ? _customerId : _hostId;

                    cmd.Parameters.Add("@senderId",   SqlDbType.VarChar,   50).Value = senderId;
                    cmd.Parameters.Add("@receiverId", SqlDbType.VarChar,   50).Value = receiverId;
                    cmd.Parameters.Add("@propId",     SqlDbType.Int           ).Value = int.Parse(_propId);
                    cmd.Parameters.Add("@msgText",    SqlDbType.NVarChar, -1 ).Value = messageText;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Clear the input and refresh history
                txtMessage.Text = string.Empty;
                LoadChatHistory();

                // Scroll to bottom after send
                ClientScript.RegisterStartupScript(GetType(),
                    "scrollDown", "scrollToBottom();", true);
            }
            catch (FormatException)
            {
                ShowError("Invalid property ID. Please go back and try again.");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("btnSend_Click error: " + ex.Message);
                ShowError("Failed to send message. Please try again.");
            }
        }

        // =====================================================================
        // REPEATER ITEM DATA BOUND (not strictly needed, placeholder kept)
        // =====================================================================
        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Reserved for future per-item logic (e.g. read-receipt icons)
        }

        // =====================================================================
        // HELPERS — called from ASPX data-binding expressions
        // =====================================================================

        /// <summary>
        /// Returns the CSS class for the message row based on whether the
        /// message was sent by the user currently viewing the chat.
        /// Works for both the host view and the customer view.
        /// </summary>
        protected string GetBubbleRowClass(string senderId)
        {
            // "sent" = the current viewer sent this; "recv" = the other person sent it
            string viewerId = _isHost ? _hostId : _customerId;
            return (senderId == viewerId) ? "msg-row sent" : "msg-row recv";
        }

        /// <summary>
        /// Returns the avatar initial letter.
        /// Current viewer's messages get their own initial; opposite side gets the other's.
        /// </summary>
        protected string GetInitial(string senderId)
        {
            string viewerId = _isHost ? _hostId : _customerId;
            if (senderId == viewerId)
                return _isHost ? "H" : "C";
            return _isHost ? "C" : "H";
        }

        // =====================================================================
        // PRIVATE UTILITY
        // =====================================================================
        private void ShowError(string message)
        {
            lblError.Text    = "<i class='fas fa-exclamation-circle'></i>&nbsp;" + message;
            lblError.Visible = true;
        }
    }
}
