using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class activehost : System.Web.UI.Page
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
           
            DataTable dt = cls.select("SELECT * FROM hostdetails WHERE status = 2 ORDER BY hid DESC");
            Repeater1.DataSource = dt;
            Repeater1.DataBind();
        }

        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
           
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