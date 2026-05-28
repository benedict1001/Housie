using System;
using System.Data;

namespace WebApplication2
{
    public partial class hostloginform : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Class1 m1 = new Class1();
       
            string query = "SELECT * FROM hostdetails WHERE email=@email AND password=@pass AND status=2";

     
            DataTable dt = m1.select_with_parameter(query, txtLoginEmail.Text, txtLoginPassword.Text);

            if (dt.Rows.Count > 0)
            {
                Session["host_id"] = dt.Rows[0]["hid"].ToString();
                Response.Redirect("hosthome.aspx");
            }
            else
            {
                lblError.Text = "Invalid email/password or account pending approval.";
            }
        }
    }
}