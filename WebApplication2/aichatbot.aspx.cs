using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
namespace WebApplication2
{
    public partial class aichatbot : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        // ── Page lifecycle ────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string pids = Request.QueryString["pids"];
                string district = Request.QueryString["district"];
                string price = Request.QueryString["price"];

                if (!string.IsNullOrEmpty(pids) || !string.IsNullOrEmpty(district) || !string.IsNullOrEmpty(price))
                    LoadProperties();
            }
        }

        private void LoadProperties()
        {
            string pids = Request.QueryString["pids"];
            string district = Request.QueryString["district"];
            string price = Request.QueryString["price"];

            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    string query = "SELECT * FROM property WHERE 1=1";

                    if (!string.IsNullOrEmpty(pids))
                    {
                        string cleanPids = Regex.Replace(pids, @"[^0-9,]", "");
                        query += " AND pid IN (" + cleanPids + ")";
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(district)) query += " AND district LIKE @dist";
                        if (!string.IsNullOrEmpty(price)) query += " AND price <= @price";
                    }

                    query += " AND status = 2";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (string.IsNullOrEmpty(pids))
                        {
                            if (!string.IsNullOrEmpty(district)) cmd.Parameters.AddWithValue("@dist", "%" + district + "%");
                            if (!string.IsNullOrEmpty(price)) cmd.Parameters.AddWithValue("@price", price);
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            PropertyRepeater.DataSource = dt;
                            PropertyRepeater.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadProperties error: " + ex.Message);
            }
        }

        // ── n8n Webhook WebMethod ─────────────────────────────────────────────────
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SendChatMessage(string userMessage)
        {
            if (string.IsNullOrWhiteSpace(userMessage))
                return "Please type a message first.";

            // 1. Production URL (no '-test') so it works 24/7
            const string N8N_WEBHOOK_URL = "http://localhost:5678/webhook/31587710-f77c-4e44-b095-fdaef3d031c6";

            try
            {
                using (HttpClient http = new HttpClient())
                {
                    http.Timeout = TimeSpan.FromSeconds(60);

                    // 2. Added sessionId so the 'Simple Memory' node in n8n doesn't crash
                    var payload = new
                    {
                        message = userMessage,
                        sessionId = "housie-default-session"
                    };

                    string jsonBody = JsonConvert.SerializeObject(payload);
                    var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

                    HttpResponseMessage response = http.PostAsync(N8N_WEBHOOK_URL, content).GetAwaiter().GetResult();
                    response.EnsureSuccessStatusCode();

                    string rawResponse = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                    if (!string.IsNullOrWhiteSpace(rawResponse))
                    {
                        if (rawResponse.TrimStart().StartsWith("{"))
                        {
                            try
                            {
                                JObject json = JObject.Parse(rawResponse);
                                string extracted = json["output"]?.ToString()
                                               ?? json["message"]?.ToString()
                                               ?? json["text"]?.ToString();
                                if (!string.IsNullOrEmpty(extracted))
                                    return extracted.Trim();
                            }
                            catch { /* return raw if parsing fails */ }
                        }
                        return rawResponse.Trim();
                    }

                    return "The assistant did not return a response.";
                }
            }
            catch (TaskCanceledException)
            {
                return "⚠️ The request timed out. Please check your n8n workflow is active.";
            }
            catch (HttpRequestException ex)
            {
                return "⚠️ Could not reach n8n: " + ex.Message;
            }
            catch (Exception ex)
            {
                return "⚠️ An unexpected error occurred: " + ex.Message;
            }
        }
    }
}