using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class activehostdetails : System.Web.UI.Page
    {
       
             protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                string hid = Request.QueryString["hid"];

                if (!string.IsNullOrEmpty(hid))
                {
                    FetchHostProfile(hid);
                }
                else
                {

                    Response.Redirect("hostapprovel.aspx");
                }
            }
        }

        private void FetchHostProfile(string hid)
        {
            Class1 cls = new Class1();

            DataTable dt = cls.select("SELECT * FROM hostdetails WHERE hid = " + hid);

            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];


                lblFname.Text = dr["fname"].ToString();
                lblLname.Text = dr["lname"].ToString();
                lblEmail.Text = dr["email"].ToString();
                lblPhone.Text = dr["phno"].ToString();


                if (dr["himage"] != DBNull.Value)
                {
                    byte[] himageData = (byte[])dr["himage"];
                    imgProfile.ImageUrl = "data:image/jpg;base64," + Convert.ToBase64String(himageData);
                }


                if (dr["hidimage"] != DBNull.Value)
                {
                    byte[] hidimageData = (byte[])dr["hidimage"];
                    imgID.ImageUrl = "data:image/jpg;base64," + Convert.ToBase64String(hidimageData);
                }
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            string hid = Request.QueryString["hid"];
            Class1 cls = new Class1();


            int result = cls.exenonquery("UPDATE hostdetails SET status = 2 WHERE hid = " + hid);

            if (result == 2)
            {

                Response.Write("<script>alert('Host Approved Successfully');window.location='hostapprovel.aspx';</script>");
            }
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            string hid = Request.QueryString["hid"];
            Class1 cls = new Class1();


            int result = cls.exenonquery("UPDATE hostdetails SET status = 3 WHERE hid = " + hid);

            if (result == 3)
            {
                Response.Write("<script>alert('Host Rejected');window.location='hostapprovel.aspx';</script>");
            }
        }
    }
    }
