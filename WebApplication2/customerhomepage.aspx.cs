using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace WebApplication2
{
    public partial class customerhomepage : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bindlocation();
                loadproperty();
            }
        }

        private void bindlocation()
        {
            try
            {
                DataTable dt = m1.select("SELECT DISTINCT district FROM property WHERE status = 2");
                ddlLocation.DataSource = dt;
                ddlLocation.DataTextField = "district";
                ddlLocation.DataValueField = "district";
                ddlLocation.DataBind();
                ddlLocation.Items.Insert(0, new ListItem("Anywhere", "0"));
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Bind Error: " + ex.Message); }
        }

        private void loadproperty()
        {
            try
            {
                string loc = ddlLocation.SelectedValue != "0" ? ddlLocation.SelectedValue : "";
                string locFilter = !string.IsNullOrEmpty(loc) ? $" AND p.district = '{loc}'" : "";
                string guestFilter = !string.IsNullOrEmpty(txtGuestNo.Text) ? $" AND p.guestno >= {txtGuestNo.Text}" : "";

                
                string dateFilter = "";
                if (!string.IsNullOrEmpty(txtWhen.Text))
                {
                    DateTime parsedDate;
                  
                    if (DateTime.TryParse(txtWhen.Text, out parsedDate))
                    {
                       
                        if (txtWhen.Text.Contains(" "))
                        {
                           
                            DateTime startOfMonth = new DateTime(parsedDate.Year, parsedDate.Month, 1);
                            DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

                            string startStr = startOfMonth.ToString("yyyy-MM-dd");
                            string endStr = endOfMonth.ToString("yyyy-MM-dd");

                            
                            dateFilter = $" AND p.pid NOT IN (SELECT pid FROM booking WHERE status IN (1, 3) AND checkindate <= '{startStr}' AND checkoutdate >= '{endStr}')";
                        }
                        else
                        {
                            
                            string exactDate = parsedDate.ToString("yyyy-MM-dd");

                          
                            dateFilter = $" AND p.pid NOT IN (SELECT pid FROM booking WHERE status IN (1, 3) AND '{exactDate}' >= checkindate AND '{exactDate}' < checkoutdate)";
                        }
                    }
                }

                // Query 1: Guest Favorites (Rating >= 4.5)
                BindCategory($@"SELECT p.* FROM property p WHERE p.status = 2 {locFilter} {guestFilter} {dateFilter}
                    AND (SELECT AVG(CAST(rating AS FLOAT)) FROM review r WHERE r.pid = p.pid) >= 4.5", rptGuestFavorites, rowGuestFavorites);

                // Query 2: Poolside Escapes
                BindCategory($"SELECT p.* FROM property p WHERE p.status = 2 AND p.pool = 'Yes' {locFilter} {guestFilter} {dateFilter}", rptPool, rowPool);

                // Query 3: Mid-Range (3000 to 5000)
                BindCategory($"SELECT p.* FROM property p WHERE p.status = 2 AND p.price >= 3000 AND p.price <= 5000 {locFilter} {guestFilter} {dateFilter}", rptMidRange, rowMidRange);

                // Query 4: Budget (< 3000)
                BindCategory($"SELECT p.* FROM property p WHERE p.status = 2 AND p.price < 3000 {locFilter} {guestFilter} {dateFilter}", rptBudget, rowBudget);

                // Query 5: Luxury (> 5000)
                BindCategory($"SELECT p.* FROM property p WHERE p.status = 2 AND p.price > 5000 {locFilter} {guestFilter} {dateFilter}", rptLuxury, rowLuxury);

                // Hide sections if no results
                lblNoResults.Visible = !rowGuestFavorites.Visible && !rowPool.Visible && !rowMidRange.Visible && !rowBudget.Visible && !rowLuxury.Visible;
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Load Error: " + ex.Message); }
        }

        private void BindCategory(string qry, Repeater rpt, HtmlGenericControl row)
        {
            DataTable dt = m1.select(qry);
            if (dt != null && dt.Rows.Count > 0)
            {
                rpt.DataSource = dt;
                rpt.DataBind();
                row.Visible = true;
            }
            else { row.Visible = false; }
        }

        protected void btnSearch_Click(object sender, EventArgs e) => loadproperty();

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            Response.Redirect("customerpropertydetail.aspx?pid=" + btn.CommandArgument);
        }
    }
}