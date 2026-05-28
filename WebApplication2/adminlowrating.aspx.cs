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
    public partial class adminlowrating : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security: Ensure the admin is logged in
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindLowRatedProperties();
            }
        }

        private void BindLowRatedProperties()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    // Confirmed: Using exact column names from 'property' and 'review' tables
                    string query = @"
                        SELECT 
                            p.pid, 
                            p.title, 
                            p.address, 
                            p.price, 
                            p.pimage, 
                            r_stats.avg_rating 
                        FROM property p
                        INNER JOIN (
                            SELECT pid, AVG(CAST(rating AS DECIMAL(10,2))) as avg_rating
                            FROM review
                            GROUP BY pid
                            HAVING AVG(CAST(rating AS DECIMAL(10,2))) > 0 
                               AND AVG(CAST(rating AS DECIMAL(10,2))) <= 2
                        ) AS r_stats ON p.pid = r_stats.pid
                        ORDER BY r_stats.avg_rating ASC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter adp = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adp.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptLowRatedProperties.DataSource = dt;
                                rptLowRatedProperties.DataBind();
                                pnlNoResults.Visible = false;
                                rptLowRatedProperties.Visible = true;
                            }
                            else
                            {
                                rptLowRatedProperties.Visible = false;
                                pnlNoResults.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("QC Page Error: " + ex.Message);
            }
        }

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string propertyID = btn.CommandArgument;
            Response.Redirect("adminpropertydetails.aspx?pid=" + propertyID);
        }
    }
}