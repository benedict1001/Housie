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
    public partial class adminpayment : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx");
                return;
            }
            if (!IsPostBack)
            {
                BindAdminRevenue();
            }
        }

        private void BindAdminRevenue()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // FIXED: Pulls from 'booking' table instead of 'payment' to catch all bookings
                    string totalQuery = "SELECT COALESCE(SUM(CAST(totalamount AS DECIMAL(18,2)) * 0.0909090909), 0) FROM booking WHERE status IN (1, 3, 4)";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                    {
                        lblAdminTotal.Text = Convert.ToDouble(cmd.ExecuteScalar()).ToString("N2");
                    }

                    // FIXED: Pulls totalamount from 'booking' (b). 
                    // ALSO FIXED: Swapped the 0.90 and 0.09 multipliers so Host gets 90% and Admin gets 10%.
                    string listQuery = @"
                        SELECT 
                            h.hid, 
                            (h.fname + ' ' + h.lname) as hostfullname, 
                            COUNT(DISTINCT pr.pid) as property_count,
                            COALESCE(SUM(CAST(b.totalamount AS DECIMAL(18,2)) * 0.909090909), 0) as host_total_earnings,
                            COALESCE(SUM(CAST(b.totalamount AS DECIMAL(18,2)) * 0.0909090909), 0) as admin_total_commission
                        FROM hostdetails h
                        LEFT JOIN property pr ON h.hid = pr.hid
                        LEFT JOIN booking b ON pr.pid = b.pid AND b.status IN (1, 3, 4)
                        GROUP BY h.hid, h.fname, h.lname
                        ORDER BY host_total_earnings DESC";

                    SqlDataAdapter adpt = new SqlDataAdapter(listQuery, con);
                    DataTable dt = new DataTable();
                    adpt.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptPayments.DataSource = dt;
                        rptPayments.DataBind();
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        pnlNoData.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Revenue List Error: " + ex.Message);
            }
        }
    }
}