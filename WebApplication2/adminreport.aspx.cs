using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class adminreport : System.Web.UI.Page
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
                
                txtStartDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

               
                BindHosts();
            }
        }

        private void BindHosts()
        {
            try
            {
                // Fetch all approved hosts (status = 2)
                string qry = "SELECT hid, fname + ' ' + lname AS HostName FROM hostdetails WHERE status = 2";
                DataTable dt = m1.select(qry);
                ddlHost.DataSource = dt;
                ddlHost.DataTextField = "HostName";
                ddlHost.DataValueField = "hid";
                ddlHost.DataBind();

                // Add default option
                ddlHost.Items.Insert(0, new ListItem("All Hosts", "0"));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error binding hosts: " + ex.Message);
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            summarySection.Visible = false;

            if (string.IsNullOrEmpty(txtStartDate.Text) || string.IsNullOrEmpty(txtEndDate.Text))
            {
                lblError.Text = "Please select both a Start Date and an End Date.";
                return;
            }

            try
            {
                string reportType = ddlReportType.SelectedValue;
                string startDate = txtStartDate.Text;
                string endDate = txtEndDate.Text + " 23:59:59";
                string query = "";

                // NEW: Dynamic Host Filter Logic
                string hostFilter = "";
                if (ddlHost.SelectedValue != "0")
                {
                    // p.hid filters by the specific host who owns the property
                    hostFilter = $" AND p.hid = {ddlHost.SelectedValue} ";
                }

                // 1. BOOKINGS & REVENUE REPORT
                if (reportType == "Bookings")
                {
                    // Note: Included INNER JOIN to hostdetails so we can filter by it
                    query = $@"
                        SELECT 
                            b.bid AS [Booking ID],
                            c.fname + ' ' + c.lname AS [Customer Name],
                            p.title AS [Property],
                            h.fname + ' ' + h.lname AS [Host Name],
                            b.checkindate AS [Check-In],
                            b.checkoutdate AS [Check-Out],
                            b.totalamount AS [Total Amount (₹)],
                            b.bookingdate AS [Date Booked]
                        FROM booking b
                        INNER JOIN customer c ON b.cid = c.cid
                        INNER JOIN property p ON b.pid = p.pid
                        INNER JOIN hostdetails h ON p.hid = h.hid
                        WHERE b.bookingdate >= '{startDate}' AND b.bookingdate <= '{endDate}' AND b.status = 1 {hostFilter}
                        ORDER BY b.bookingdate DESC";
                }
                // 2. NEW PROPERTIES REPORT
                else if (reportType == "Properties")
                {
                    query = $@"
                        SELECT 
                            p.pid AS [Property ID],
                            p.title AS [Property Title],
                            h.fname + ' ' + h.lname AS [Host Name],
                            p.district AS [District],
                            p.price AS [Nightly Price (₹)],
                            CASE WHEN p.status = 1 THEN 'Pending' WHEN p.status = 2 THEN 'Approved' ELSE 'Rejected' END AS [Status]
                        FROM property p
                        INNER JOIN hostdetails h ON p.hid = h.hid
                        WHERE 1=1 {hostFilter}
                        ORDER BY p.pid DESC";
                }
                // 3. CUSTOMERS REPORT
                else if (reportType == "Customers")
                {
                    query = $@"
                        SELECT 
                            cid AS [Customer ID], 
                            fname + ' ' + lname AS [Name], 
                            email AS [Email Address], 
                            phoneno AS [Phone Number] 
                        FROM customer 
                        ORDER BY cid DESC";
                }
                // 4. CANCELLATIONS REPORT
                else if (reportType == "Cancellations")
                {
                    query = $@"
                        SELECT 
                            b.bid AS [Booking ID],
                            c.fname + ' ' + c.lname AS [Customer Name],
                            p.title AS [Property],
                            h.fname + ' ' + h.lname AS [Host Name],
                            b.checkindate AS [Check-In],
                            b.checkoutdate AS [Check-Out],
                            b.totalamount AS [Total Amount (₹)],
                            b.bookingdate AS [Date Booked]
                        FROM booking b
                        INNER JOIN customer c ON b.cid = c.cid
                        INNER JOIN property p ON b.pid = p.pid
                        INNER JOIN hostdetails h ON p.hid = h.hid
                        WHERE b.bookingdate >= '{startDate}' AND b.bookingdate <= '{endDate}' AND b.status = 2 {hostFilter}
                        ORDER BY b.bookingdate DESC";
                }

                DataTable dt = m1.select(query);
                gvReport.DataSource = dt;
                gvReport.DataBind();

                // Calculate Totals for the Summary Card
                if (dt.Rows.Count > 0)
                {
                    summarySection.Visible = true;
                    lblTotalCount.Text = dt.Rows.Count.ToString();

                    if (reportType == "Bookings")
                    {
                        revenueBlock.Visible = true;
                        decimal totalRev = 0;
                        foreach (DataRow row in dt.Rows)
                        {
                            if (row["Total Amount (₹)"] != DBNull.Value)
                            {
                                totalRev += Convert.ToDecimal(row["Total Amount (₹)"]);
                            }
                        }

                        // Split calculations (10% Admin, 90% Host)
                        decimal adminEarnings = totalRev * 0.0909090909m;
                        decimal hostEarnings = totalRev * 0.909090909m;

                        // Format with commas
                        lblTotalRevenue.Text = totalRev.ToString("N0");
                        lblAdminRevenue.Text = adminEarnings.ToString("N0");
                        lblHostRevenue.Text = hostEarnings.ToString("N0");
                    }
                    else
                    {
                        revenueBlock.Visible = false;
                    }
                }
                else
                {
                    summarySection.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred while generating the report. Details: " + ex.Message;
            }
        }
    }
}