using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class district : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRepeater();
            }
        }

        private void BindRepeater()
        {
            Class1 cls = new Class1();
            Repeater1.DataSource = cls.getdistrict();
            Repeater1.DataBind();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Class1 m1 = new Class1();
            if (Button1.Text == "Insert")
            {
                m1.inserdistrict(TextBox1.Text);
            }
            else
            {
                m1.updatedistrict(hfDistrictId.Value, TextBox1.Text);
                Button1.Text = "Insert";
            }
            TextBox1.Text = "";
            hfDistrictId.Value = "";
            BindRepeater();
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Class1 cls = new Class1();
            string did = e.CommandArgument.ToString();

            if (e.CommandName == "edit")
            {
                DataTable dt = cls.getdistrictbyid(did);
                if (dt.Rows.Count > 0)
                {
                    TextBox1.Text = dt.Rows[0]["dname"].ToString();
                    hfDistrictId.Value = did;
                    Button1.Text = "Update";
                }
            }
            else if (e.CommandName == "delete")
            {
                cls.deletedistrict(did);
                BindRepeater();
            }
        }
    }
}