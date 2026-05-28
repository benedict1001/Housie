using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class adminviewallproperty : System.Web.UI.Page
    {
        Class1 m1 = new Class1();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("adminlogin.aspx");
                return;
            }
            if (!IsPostBack)
            {
                BindLocations();
                BindProperties();
                BindFlaggedProperties();
            }
        }

        private void BindLocations()
        {
            try
            {
                string query = "SELECT DISTINCT district FROM property WHERE status IN (2, 4)";
                DataTable dt = m1.select(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    ddlLocation.DataSource = dt;
                    ddlLocation.DataTextField = "district";
                    ddlLocation.DataValueField = "district";
                    ddlLocation.DataBind();
                }

                ddlLocation.Items.Insert(0, new ListItem("Search destinations", "0"));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading locations: " + ex.Message);
            }
        }

        // Binds the active properties (status 2)
        private void BindProperties(string query = "SELECT pid, hid, address, title, guestno, price, pimage FROM property WHERE status = 2")
        {
            try
            {
                DataTable dt = m1.select(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptProperties.DataSource = dt;
                    rptProperties.DataBind();
                    rptProperties.Visible = true;
                    lblNoResults.Visible = false;
                    hdgActiveProperties.Visible = true;
                }
                else
                {
                    rptProperties.Visible = false;
                    lblNoResults.Visible = true;
                    hdgActiveProperties.Visible = false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading active properties: " + ex.Message);
            }
        }

        // NEW: Binds the flagged properties (status 4)
        private void BindFlaggedProperties(string query = "SELECT pid, hid, address, title, guestno, price, pimage FROM property WHERE status = 4")
        {
            try
            {
                DataTable dt = m1.select(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptFlaggedProperties.DataSource = dt;
                    rptFlaggedProperties.DataBind();
                    pnlFlaggedSection.Visible = true;
                }
                else
                {
                    pnlFlaggedSection.Visible = false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading flagged properties: " + ex.Message);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string location = ddlLocation.SelectedValue;
            string guests = txtGuestNo.Text.Trim();

            // Setup base queries for both sections
            string queryActive = "SELECT pid, hid, address, title, guestno, price, pimage FROM property WHERE status = 2";
            string queryFlagged = "SELECT pid, hid, address, title, guestno, price, pimage FROM property WHERE status = 4";

            if (location != "0")
            {
                string locationFilter = string.Format(" AND district = '{0}'", location.Replace("'", "''"));
                queryActive += locationFilter;
                queryFlagged += locationFilter;
            }

            if (!string.IsNullOrEmpty(guests))
            {
                string guestFilter = string.Format(" AND guestno >= {0}", guests);
                queryActive += guestFilter;
                queryFlagged += guestFilter;
            }

            // Apply search filters to both grids simultaneously 
            BindProperties(queryActive);
            BindFlaggedProperties(queryFlagged);
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            ddlLocation.SelectedIndex = 0;
            txtGuestNo.Text = "";
            BindProperties();
            BindFlaggedProperties();
        }

        protected void btnDetails_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            // Split the CommandArgument to get both IDs
            string[] arguments = btn.CommandArgument.ToString().Split('|');

            if (arguments.Length == 2)
            {
                string propertyId = arguments[0];
                string hostId = arguments[1];

                // STORE IN SESSION INSTEAD OF URL
                Session["pid"] = propertyId;
                Session["hid"] = hostId;
            }
            else
            {
                // Fallback just in case it only receives the pid
                Session["pid"] = btn.CommandArgument;
            }

            // Redirect cleanly without any messy query strings
            Response.Redirect("adminpropertydetails.aspx");
        }
    }
}