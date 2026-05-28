using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace WebApplication2
{
    public partial class edithostproperty : System.Web.UI.Page
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
                else if (Request.QueryString["pid"] != null)
                {
                    string pid = Request.QueryString["pid"].ToString();
                    LoadDropdowns();
                    LoadPropertyData(pid);
                }
            }
        }

        private void LoadDropdowns()
        {
            ddlPropertyType.DataSource = m1.getdatapropertytype();
            ddlPropertyType.DataTextField = "type";
            ddlPropertyType.DataValueField = "typeid";
            ddlPropertyType.DataBind();

            ddlDistrict.DataSource = m1.getdatadistrict();
            ddlDistrict.DataTextField = "dname";
            ddlDistrict.DataValueField = "dname";
            ddlDistrict.DataBind();
        }

        private void LoadPropertyData(string pid)
        {
            try
            {
                DataTable dt = m1.select("SELECT * FROM property WHERE pid = '" + pid + "'");
                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    txtTitle.Text = dr["title"].ToString();
                    txtPrice.Text = dr["price"].ToString();
                    ddlPropertyType.SelectedValue = dr["typeid"].ToString();
                    if (dr["pool"] != DBNull.Value) ddlPool.SelectedValue = dr["pool"].ToString();
                    txtBedrooms.Text = dr["bedroomno"].ToString();
                    txtBathrooms.Text = dr["bathroomno"].ToString();
                    txtBeds.Text = dr["bedno"].ToString();
                    txtGuests.Text = dr["guestno"].ToString();
                    ddlDistrict.SelectedValue = dr["district"].ToString();
                    txtAddress.Text = dr["address"].ToString();
                    txtDescription.Text = dr["description"].ToString();

                    if (dr["pimage"] != DBNull.Value && !string.IsNullOrEmpty(dr["pimage"].ToString()))
                    {
                        imgPrev.ImageUrl = ResolveUrl("~/" + dr["pimage"].ToString());
                    }
                }

                DataTable dtGallery = m1.select("SELECT * FROM propertyimage WHERE pid = '" + pid + "'");
                if (dtGallery != null && dtGallery.Rows.Count > 0)
                {
                    DataRow gdr = dtGallery.Rows[0];
                    SetPreview(gdr["image1"], imgGallery1);
                    SetPreview(gdr["image2"], imgGallery2);
                    SetPreview(gdr["image3"], imgGallery3);
                    SetPreview(gdr["image4"], imgGallery4);
                    SetPreview(gdr["image5"], imgGallery5);
                }
            }
            catch (Exception ex) { ShowAlert("Load Error: " + ex.Message); }
        }

        private void SetPreview(object dbVal, System.Web.UI.WebControls.Image img)
        {
            if (dbVal != DBNull.Value && !string.IsNullOrEmpty(dbVal.ToString()))
            {
                img.ImageUrl = ResolveUrl("~/" + dbVal.ToString());
            }
            else { img.ImageUrl = "https://via.placeholder.com/150?text=Empty+Slot"; }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["pid"] != null)
                {
                    string pid = Request.QueryString["pid"].ToString();
                    string mainImagePath = null;

                    if (fuImage.HasFile)
                    {
                        string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuImage.FileName);
                        string savePath = Server.MapPath("~/PropertyImages/") + fileName;
                        fuImage.SaveAs(savePath);
                        mainImagePath = "PropertyImages/" + fileName;
                    }

                    // Update main property details. Note: You may need to adjust your update_property_full 
                    // in Class1 to handle the string path for pimage instead of byte[]
                    m1.update_property_full(pid, txtTitle.Text, ddlPropertyType.SelectedValue, txtPrice.Text, txtDescription.Text,
                        txtBedrooms.Text, txtBathrooms.Text, txtBeds.Text, txtGuests.Text, ddlDistrict.SelectedValue,
                        txtAddress.Text, mainImagePath != null ? System.Text.Encoding.UTF8.GetBytes(mainImagePath) : null, ddlPool.SelectedValue);

                    UpdateGallery(pid);
                    Response.Redirect("hosthome.aspx", false);
                }
            }
            catch (Exception ex) { ShowAlert("Update Error: " + ex.Message); }
        }

        private void UpdateGallery(string pid)
        {
            DataTable dt = m1.select("SELECT pid FROM propertyimage WHERE pid = '" + pid + "'");
            if (dt.Rows.Count == 0)
            {
                m1.exenonquery("INSERT INTO propertyimage (pid, status) VALUES ('" + pid + "', 1)");
            }

            if (fuGallery1.HasFile) SaveImgPath(pid, "image1", fuGallery1);
            if (fuGallery2.HasFile) SaveImgPath(pid, "image2", fuGallery2);
            if (fuGallery3.HasFile) SaveImgPath(pid, "image3", fuGallery3);
            if (fuGallery4.HasFile) SaveImgPath(pid, "image4", fuGallery4);
            if (fuGallery5.HasFile) SaveImgPath(pid, "image5", fuGallery5);
        }

        private void SaveImgPath(string pid, string col, FileUpload fu)
        {
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fu.FileName);
            string savePath = Server.MapPath("~/PropertyImages/") + fileName;
            fu.SaveAs(savePath);
            string dbPath = "PropertyImages/" + fileName;
            m1.exenonquery($"UPDATE propertyimage SET {col} = '{dbPath}' WHERE pid = '{pid}'");
        }

        private void ShowAlert(string m) { ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{m}');", true); }
    }
}