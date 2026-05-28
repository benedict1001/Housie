using System;
using System.Data;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class hostapprovel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindPendingHosts();
            }
        }

        private void BindPendingHosts()
        {
            Class1 cls = new Class1();
            // Fetch hosts where status = 1 (Pending)
            DataTable dt = cls.select("SELECT * FROM hostdetails WHERE status = 1 ORDER BY hid DESC");
            Repeater1.DataSource = dt;
            Repeater1.DataBind();
        }

        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Show "No Data" message if the list is empty
            if (e.Item.ItemType == ListItemType.Footer)
            {
                Repeater rpt = (Repeater)sender;
                if (rpt.Items.Count == 0)
                {
                    Label lbl = (Label)e.Item.FindControl("lblNoData");
                    lbl.Visible = true;
                }
            }
        }
    }
}