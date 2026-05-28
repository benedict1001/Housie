using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;
using System.IO;

namespace WebApplication2
{
    public partial class add_property : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Form != null)
            {
                this.Form.Enctype = "multipart/form-data";
            }

            if (!IsPostBack)
            {
                if (Session["host_id"] == null)
                {
                    Response.Redirect("hostloginform.aspx");
                    return;
                }
                LoadPropertyTypes();
                dis();
                LoadLocationTypes();
            }
        }

        public async Task CallN8NWebhook(string actionType, string propTitle, string dist, string price)
        {
            using (HttpClient client = new HttpClient())
            {
                string url = "http://localhost:5678/webhook/housie-alerts";
                var postData = new
                {
                    type = actionType,
                    title = propTitle,
                    district = dist,
                    price = price,
                    host = Session["host_name"]?.ToString() ?? "Host ID: " + Session["host_id"]?.ToString()
                };

                string json = JsonConvert.SerializeObject(postData);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                try
                {
                    await client.PostAsync(url, content);
                }
                catch (Exception) { /* Fail silently */ }
            }
        }

        private void LoadPropertyTypes()
        {
            try
            {
                Class1 m1 = new Class1();
                DataTable dt = m1.getdatapropertytype();
                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlPropertyType.DataSource = dt;
                    ddlPropertyType.DataTextField = "type";
                    ddlPropertyType.DataValueField = "typeid";
                    ddlPropertyType.DataBind();
                }
                ddlPropertyType.Items.Insert(0, new ListItem("-- Select Type --", "0"));
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error: " + ex.Message); }
        }

        private void dis()
        {
            try
            {
                Class1 m1 = new Class1();
                DataTable dt = m1.getdatadistrict();
                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlDistrict.DataSource = dt;
                    ddlDistrict.DataTextField = "dname";
                    ddlDistrict.DataValueField = "dname";
                    ddlDistrict.DataBind();
                }
                ddlDistrict.Items.Insert(0, new ListItem("-- Select District --", "0"));
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error: " + ex.Message); }
        }

        private void LoadLocationTypes()
        {
            try
            {
                string strcon = ConfigurationManager.AppSettings["con"];
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT loctyp_id, location_type FROM location_types WHERE status = 1";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                ddlLocationType.DataSource = dt;
                                ddlLocationType.DataTextField = "location_type";
                                ddlLocationType.DataValueField = "location_type";
                                ddlLocationType.DataBind();
                            }
                        }
                    }
                }
                ddlLocationType.Items.Insert(0, new ListItem("-- Select Location Type --", "0"));
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error loading locations: " + ex.Message); }
        }

        private void SendAdminEmail(string propTitle, string dist, string price)
        {
            try
            {
                string adminEmail = "";
                string strcon = ConfigurationManager.AppSettings["con"];

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT TOP 1 email FROM admin";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null) adminEmail = result.ToString();
                    }
                }

                if (!string.IsNullOrEmpty(adminEmail))
                {
                    MailMessage mail = new MailMessage();
                    mail.From = new MailAddress("housie.propertyrental@gmail.com", "Housie System");
                    mail.To.Add(adminEmail);
                    mail.Subject = "New Property Added - Pending Approval";
                    mail.Body = $"Hello Admin,\n\nA new property has been submitted on Housie and is waiting for your approval.\n\nProperty Details:\nTitle: {propTitle}\nLocation: {dist}\nPrice: ₹{price}\n\nPlease log in to the admin dashboard to review it.";
                    mail.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new System.Net.NetworkCredential("housie.propertyrental@gmail.com", "eydoqcdkmxvjqwnb");
                    smtp.Send(mail);
                }
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error sending admin email: " + ex.Message); }
        }

        protected void btnSaveProperty_Click(object sender, EventArgs e)
        {
            lblDebug.Text = "";
            lblDebug.ForeColor = System.Drawing.Color.Red;

            try
            {
                if (ddlPropertyType.SelectedValue == "0") { lblDebug.Text = "Please select a Type."; return; }
                if (ddlDistrict.SelectedValue == "0") { lblDebug.Text = "Please select a District."; return; }
                if (ddlLocationType.SelectedValue == "0") { lblDebug.Text = "Please select a Location Type."; return; }
                if (string.IsNullOrWhiteSpace(txtPrice.Text)) { lblDebug.Text = "Enter a Price."; return; }

                // Save image to folder and get path
                string imagePath = "";
                if (fileMainImage.HasFile)
                {
                    string folderPath = Server.MapPath("~/PropertyImages/");
                    if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fileMainImage.FileName);
                    fileMainImage.SaveAs(Path.Combine(folderPath, fileName));
                    imagePath = "PropertyImages/" + fileName;
                }
                else
                {
                    lblDebug.Text = "Please upload a Cover Photo.";
                    return;
                }

                Class1 m1 = new Class1();

                m1.inserthostproperty(
                    txtTitle.Text,
                    ddlPropertyType.SelectedValue,
                    Session["host_id"].ToString(),
                    txtPrice.Text,
                    txtDescription.Text,
                    txtBedrooms.Text,
                    txtBathrooms.Text,
                    txtBeds.Text,
                    txtGuests.Text,
                    ddlDistrict.SelectedValue,
                    txtAddress.Text,
                    imagePath,
                    ddlPool.SelectedValue,
                    ddlLocationType.SelectedValue
                );

                _ = CallN8NWebhook("New Property Added", txtTitle.Text, ddlDistrict.SelectedValue, txtPrice.Text);
                SendAdminEmail(txtTitle.Text, ddlDistrict.SelectedValue, txtPrice.Text);

                // Trigger the popup in the .aspx file
                ClientScript.RegisterStartupScript(this.GetType(), "PopupScript", "showSuccessPopup();", true);
            }
            catch (Exception ex)
            {
                lblDebug.Text = "Error: " + ex.Message;
            }
        }
    }
}