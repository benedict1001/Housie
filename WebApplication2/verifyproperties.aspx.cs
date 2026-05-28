using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class verifyproperties : System.Web.UI.Page
    {
      
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pendingpropertyapprovel();
            }
        }

        private void pendingpropertyapprovel()
        {
       
            using (SqlConnection con = new SqlConnection(strcon))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM property WHERE status = 1", con);
                DataTable dt = new DataTable();

                try
                {
                    da.Fill(dt);
                    dlPendingProperties.DataSource = dt;
                    dlPendingProperties.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                }
            }
        }

        protected void lnkViewDetails_Click(object sender, EventArgs e)
        {
            string pid = ((LinkButton)sender).CommandArgument;
            Response.Redirect("propertyapproveldetails.aspx?pid=" + pid);
        }

        protected void dlPendingProperties_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}