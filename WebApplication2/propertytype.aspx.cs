using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class propertytype : System.Web.UI.Page
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
            Repeater1.DataSource = cls.gettype();
            Repeater1.DataBind();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Class1 cls = new Class1();
            if (Button1.Text == "Insert")
            {
                cls.insertpropertytype(TextBox1.Text);
            }
            else
            {
                cls.updatepropertytype(hfTypeId.Value, TextBox1.Text);
                Button1.Text = "Insert";
            }
            TextBox1.Text = "";
            hfTypeId.Value = "";
            BindRepeater();
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Class1 cls = new Class1();
            string tid = e.CommandArgument.ToString();

            if (e.CommandName == "edit")
            {
                DataTable dt = cls.gettypebyid(tid);
                if (dt.Rows.Count > 0)
                {
                    TextBox1.Text = dt.Rows[0]["type"].ToString();
                    hfTypeId.Value = tid;
                    Button1.Text = "Update";
                }
            }
            else if (e.CommandName == "delete")
            {
                cls.deletepropertytype(tid);
                BindRepeater();
            }
        }
    }
}