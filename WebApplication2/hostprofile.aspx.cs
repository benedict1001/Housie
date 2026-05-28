using System;
using System.Data;
using System.Web.UI;

namespace WebApplication2
{
    public partial class hostprofile : System.Web.UI.Page
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
                    LoadHostProfile();
                }
            }
        }

        private void LoadHostProfile()
        {
            try
            {
                string hostId = Session["host_id"].ToString();

           
                string hostQuery = string.Format("SELECT fname, lname, email, phno, status, himage, hidimage FROM hostdetails WHERE hid = {0}", hostId);
                DataTable dtHost = m1.select(hostQuery);

                if (dtHost != null && dtHost.Rows.Count > 0)
                {
                    DataRow row = dtHost.Rows[0];

               
                    string firstName = row["fname"] != DBNull.Value ? row["fname"].ToString() : "Unknown";
                    string lastName = row["lname"] != DBNull.Value ? row["lname"].ToString() : "";

                    lblFullName.Text = firstName + " " + lastName;
                    lblFname.Text = firstName;
                    lblLname.Text = lastName;
                    lblTopEmail.Text = row["email"] != DBNull.Value ? row["email"].ToString() : "No Email";
                    lblPhone.Text = row["phno"] != DBNull.Value ? row["phno"].ToString() : "No Phone";

                
                    if (row["status"] != DBNull.Value)
                    {
                        int status = Convert.ToInt32(row["status"]);
                        if (status == 2)
                        {
                            lblStatus.Text = "Approved";
                            lblStatus.CssClass = "status-badge status-active";
                        }
                        else
                        {
                            lblStatus.Text = "Pending Review";
                            lblStatus.CssClass = "status-badge status-pending";
                        }
                    }
                    else
                    {
                        lblStatus.Text = "No Status";
                        lblStatus.CssClass = "status-badge status-pending";
                    }

               
                    try
                    {
                        if (row["himage"] != DBNull.Value)
                        {
                            byte[] avatarBytes = (byte[])row["himage"];
                            if (avatarBytes.Length > 0)
                            {
                                imgAvatar.Src = "data:image/jpg;base64," + Convert.ToBase64String(avatarBytes);
                            }
                            else
                            {
                                imgAvatar.Src = "https://via.placeholder.com/150?text=Avatar";
                            }
                        }
                    }
                    catch { imgAvatar.Src = "https://via.placeholder.com/150?text=Error"; }

               
                    try
                    {
                        if (row["hidimage"] != DBNull.Value)
                        {
                            byte[] idBytes = (byte[])row["hidimage"];
                            if (idBytes.Length > 0)
                            {
                                imgHostId.Src = "data:image/jpg;base64," + Convert.ToBase64String(idBytes);
                            }
                            else
                            {
                                imgHostId.Src = "https://via.placeholder.com/400x250?text=No+ID+Uploaded";
                            }
                        }
                        else
                        {
                            imgHostId.Src = "https://via.placeholder.com/400x250?text=No+ID+Uploaded";
                        }
                    }
                    catch { imgHostId.Src = "https://via.placeholder.com/400x250?text=Error"; }
                }

                
                try
                {
                    string countQuery = string.Format("SELECT COUNT(*) AS total FROM property WHERE hid = {0}", hostId);
                    DataTable dtCount = m1.select(countQuery);
                    if (dtCount != null && dtCount.Rows.Count > 0)
                    {
                        lblTotalProperties.Text = dtCount.Rows[0]["total"].ToString();
                    }
                }
                catch
                {
                    lblTotalProperties.Text = "0"; 
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Major Error loading profile: " + ex.Message);
            }
        }
    }
}