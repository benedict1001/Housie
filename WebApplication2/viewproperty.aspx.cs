using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class viewproperty : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                BindDropdowns();
                FilterProperties();
            }
        }

        private void BindDropdowns()
        {
            
            DataTable dtLoc = m1.select("SELECT dname FROM district1");
         

            ddlLocation.DataSource = dtLoc;
            ddlLocation.DataTextField = "dname";
            ddlLocation.DataValueField = "dname";
            ddlLocation.DataBind();
            ddlLocation.Items.Insert(0, new ListItem("All Locations", "0"));

            
            DataTable dtType = m1.select("SELECT * FROM propertytype1");
      

            ddlType.DataSource = dtType;
            ddlType.DataTextField = "type";
            ddlType.DataValueField = "type";
            ddlType.DataBind();
            ddlType.Items.Insert(0, new ListItem("All Types", "0"));
        }

        private void FilterProperties()
        {
            try
            {
            
                string qry = "SELECT * FROM property WHERE 1=1 ";

                
                if (ddlLocation.SelectedValue != "0" && ddlLocation.SelectedValue != "")
                {
                    qry += " AND address = '" + ddlLocation.SelectedValue + "'";
                }

               
                if (ddlType.SelectedValue != "0" && ddlType.SelectedValue != "")
                {
                    qry += " AND typeid = '" + ddlType.SelectedValue + "'";
                }

                qry += " ORDER BY pid DESC";

                DataTable dt = m1.select(qry);

                if (dt != null && dt.Rows.Count > 0)
                {
                    gvProperties.DataSource = dt;
                    gvProperties.DataBind();
                    lblTotalCount.Text = dt.Rows.Count.ToString();
                }
                else
                {
                    gvProperties.DataSource = null;
                    gvProperties.DataBind();
                    lblTotalCount.Text = "0";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Filter Error: " + ex.Message);
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            FilterProperties();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlLocation.SelectedIndex = 0;
            ddlType.SelectedIndex = 0;
            FilterProperties();
        }
    }
}