using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class location_type : System.Web.UI.Page
    {
    
        string strcon = ConfigurationManager.AppSettings["con"];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLocationTypes();
            }
        }

       
        private void LoadLocationTypes()
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
               
                string query = "SELECT loctyp_id AS loc_id, location_type AS loc_name, status FROM location_types";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        Repeater1.DataSource = dt;
                        Repeater1.DataBind();
                    }
                }
            }
        }

     
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string locTypeName = txtLocationType.Text.Trim();

            if (string.IsNullOrEmpty(locTypeName))
            {
           
                return;
            }

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();

                if (string.IsNullOrEmpty(hfLocationId.Value))
                {
            
                    string query = "INSERT INTO location_types (location_type, status) VALUES (@LocationType, 1)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@LocationType", locTypeName);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
              
                    string query = "UPDATE location_types SET location_type = @LocationType WHERE loctyp_id = @Id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@LocationType", locTypeName);
                        cmd.Parameters.AddWithValue("@Id", hfLocationId.Value);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

          
            txtLocationType.Text = "";
            hfLocationId.Value = "";
            btnSave.Text = "Insert";

          
            LoadLocationTypes();
        }


        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string id = e.CommandArgument.ToString();

            if (e.CommandName == "edit")
            {
                
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "SELECT * FROM location_types WHERE loctyp_id = @Id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            txtLocationType.Text = dr["location_type"].ToString();
                            hfLocationId.Value = id; 
                            btnSave.Text = "Update"; 
                        }
                    }
                }
            }
            else if (e.CommandName == "delete")
            {
                
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    string query = "DELETE FROM location_types WHERE loctyp_id = @Id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

             
                LoadLocationTypes();
            }
        }
    }
}