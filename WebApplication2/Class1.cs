using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public class Class1 : connection
    {
        public DataTable select(string qry)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlDataAdapter adpt = new SqlDataAdapter(qry, sqlcon);
            DataTable dt = new DataTable();
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public int get_count(string qry)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand(qry, sqlcon);
            object result = cmd.ExecuteScalar();
            int i = (result != null) ? Convert.ToInt32(result) : 0;
            sqlcon.Close();
            return i;
        }

        public int exenonquery(string qry)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand(qry, sqlcon);
            int i = cmd.ExecuteNonQuery();
            sqlcon.Close();
            return i;
        }

        public void execute(string query)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public void inserdistrict(string name)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO district1 (dname,status)VALUES(@dname,1)", sqlcon);
            cmd.Parameters.AddWithValue("@dname", name);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public DataTable getdistrictbyid(string did)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "SELECT * FROM district1 WHERE did = @did";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@did", did);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public void updatedistrict(string did, string dname)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "UPDATE district1 SET dname = @dname WHERE did = @did";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@dname", dname);
            cmd.Parameters.AddWithValue("@did", did);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public void deletedistrict(string did)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "DELETE FROM district1 WHERE did = @did";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@did", did);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public void insertpropertytype(string type1)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO propertytype1 (type,status)VALUES(@type,1)", sqlcon);
            cmd.Parameters.AddWithValue("@type", type1);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public DataTable gettypebyid(string tid)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "SELECT * FROM propertytype1 WHERE typeid = @tid";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@tid", tid);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public void updatepropertytype(string tid, string type)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "UPDATE propertytype1 SET type = @type WHERE typeid = @tid";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@type", type);
            cmd.Parameters.AddWithValue("@tid", tid);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public void deletepropertytype(string tid)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "DELETE FROM propertytype1 WHERE typeid = @tid";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@tid", tid);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        internal DataTable gettype()
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            DataTable dt = new DataTable();
            SqlDataAdapter adpt = new SqlDataAdapter("select * from propertytype1", sqlcon);
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        internal DataTable getdistrict()
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            DataTable dt = new DataTable();
            SqlDataAdapter adpt = new SqlDataAdapter("select * from district1", sqlcon);
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        internal DataTable getno()
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            DataTable dt = new DataTable();
            SqlDataAdapter cou = new SqlDataAdapter("select count(*) from propertytype1", sqlcon);
            cou.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        internal DataTable getproperty(string status)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            DataTable dt = new DataTable();
            SqlDataAdapter adpt = new SqlDataAdapter("select * from districtproperty where status=@status", sqlcon);
            adpt.SelectCommand.Parameters.AddWithValue("@status", status);
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public void inserthostregistration(string fname, string lname, string email, string phno, string password, byte[] himage, byte[] hidimage)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO hostdetails (fname,lname,email,phno,password,himage,hidimage,status)VALUES(@fname,@lname,@email,@phno,@password,@himage,@hidimage,1)", sqlcon);
            cmd.Parameters.AddWithValue("@fname", fname);
            cmd.Parameters.AddWithValue("@lname", lname);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@phno", phno);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@himage", himage);
            cmd.Parameters.AddWithValue("@hidimage", hidimage);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public DataTable getdatapropertytype()
        {
            try
            {
                if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
                SqlDataAdapter adpt = new SqlDataAdapter("select * from propertytype1", sqlcon);
                DataTable dt = new DataTable();
                adpt.Fill(dt);
                sqlcon.Close();
                return dt;
            }
            catch (Exception) { return new DataTable(); }
        }

        public DataTable getdatadistrict()
        {
            try
            {
                if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
                SqlDataAdapter adpt = new SqlDataAdapter("select * from district1", sqlcon);
                DataTable dt = new DataTable();
                adpt.Fill(dt);
                sqlcon.Close();
                return dt;
            }
            catch (Exception) { return new DataTable(); }
        }

        // UPDATED METHOD: Changed 'byte[] img' to 'string img' to match the database string path logic
        public void inserthostproperty(string title, string typeid, string hid, string price, string desc, string bedrm, string bathrm, string bedno, string guestno, string dist, string addr, string img, string pool, string location_type)
        {
            string qry = "INSERT INTO property (title, typeid, hid, price, description, bedroomno, bathroomno, bedno, guestno, district, address, pimage, status, pool, location_type) " +
                         "VALUES (@title, @typeid, @hid, @price, @desc, @bedrm, @bathrm, @bedno, @guestno, @dist, @addr, @img, 1, @pool, @location_type)";

            SqlCommand cmd = new SqlCommand(qry, sqlcon);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@typeid", typeid);
            cmd.Parameters.AddWithValue("@hid", hid);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@bedrm", bedrm);
            cmd.Parameters.AddWithValue("@bathrm", bathrm);
            cmd.Parameters.AddWithValue("@bedno", bedno);
            cmd.Parameters.AddWithValue("@guestno", guestno);
            cmd.Parameters.AddWithValue("@dist", dist);
            cmd.Parameters.AddWithValue("@addr", addr);
            cmd.Parameters.AddWithValue("@img", img);
            cmd.Parameters.AddWithValue("@pool", pool);
            cmd.Parameters.AddWithValue("@location_type", location_type);

            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public DataTable get_host_properties(string host_id)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string qry = "SELECT * FROM property WHERE hid = '" + host_id + "' ORDER BY pid DESC";
            SqlDataAdapter adpt = new SqlDataAdapter(qry, sqlcon);
            DataTable dt = new DataTable();
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public void update_property_with_image(string pid, string title, string address, string price, byte[] imgData)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string query = "UPDATE property SET title=@title, address=@address, price=@price, pimage=@img WHERE pid=@pid";
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@title", title);
            cmd.Parameters.AddWithValue("@address", address);
            cmd.Parameters.AddWithValue("@price", price);
            cmd.Parameters.AddWithValue("@img", imgData);
            cmd.Parameters.AddWithValue("@pid", pid);
            cmd.ExecuteNonQuery();
            sqlcon.Close();
        }

        public void update_property_full(string pid, string title, string typeid, string price, string description, string bedroomno, string bathroomno, string bedno, string guestno, string district, string address, byte[] pimage, string pool)
        {
            try
            {
                if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();

                string q = @"UPDATE property SET 
                        title=@title, 
                        typeid=@typeid, 
                        price=@price, 
                        description=@description, 
                        bedroomno=@bedroomno, 
                        bathroomno=@bathroomno, 
                        bedno=@bedno, 
                        guestno=@guestno, 
                        district=@district, 
                        address=@address, 
                        pool=@pool";

                if (pimage != null)
                {
                    q += ", pimage=@pimage";
                }

                q += " WHERE pid=@pid";

                SqlCommand cmd = new SqlCommand(q, sqlcon);

                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@typeid", typeid);
                cmd.Parameters.AddWithValue("@price", Convert.ToDecimal(price));
                cmd.Parameters.AddWithValue("@bedroomno", Convert.ToInt32(bedroomno));
                cmd.Parameters.AddWithValue("@bathroomno", Convert.ToInt32(bathroomno));
                cmd.Parameters.AddWithValue("@bedno", Convert.ToInt32(bedno));
                cmd.Parameters.AddWithValue("@guestno", Convert.ToInt32(guestno));
                cmd.Parameters.AddWithValue("@description", description);
                cmd.Parameters.AddWithValue("@district", district);
                cmd.Parameters.AddWithValue("@address", address);

                cmd.Parameters.AddWithValue("@pool", pool);

                cmd.Parameters.AddWithValue("@pid", pid);

                if (pimage != null)
                {
                    cmd.Parameters.AddWithValue("@pimage", pimage);
                }

                cmd.ExecuteNonQuery();
                sqlcon.Close();
            }
            catch (Exception ex)
            {
                Debug.WriteLine("SQL Update Error: " + ex.Message);
                if (sqlcon.State == ConnectionState.Open) sqlcon.Close();

                throw ex;
            }
        }

        public DataTable all_admin_properties()
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string qry = "SELECT * FROM property ORDER BY pid DESC";
            SqlDataAdapter adpt = new SqlDataAdapter(qry, sqlcon);
            DataTable dt = new DataTable();
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public DataTable get_all_properties(string host_id)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            string qry = "SELECT * FROM property WHERE status = '1' ORDER BY pid DESC";
            SqlDataAdapter adpt = new SqlDataAdapter(qry, sqlcon);
            DataTable dt = new DataTable();
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public DataTable select_with_parameter(string query, string email, string pass)
        {
            if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
            SqlCommand cmd = new SqlCommand(query, sqlcon);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@pass", pass);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adpt.Fill(dt);
            sqlcon.Close();
            return dt;
        }

        public void insert_extra_images(string pid, byte[] img1, byte[] img2, byte[] img3, byte[] img4, byte[] img5)
        {
            try
            {
                if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
                string qry = "INSERT INTO propertyimage (pid, image1, image2, image3, image4, image5, status) VALUES (@pid, @img1, @img2, @img3, @img4, @img5, 1)";
                SqlCommand cmd = new SqlCommand(qry, sqlcon);

                cmd.Parameters.Add("@pid", SqlDbType.Int).Value = pid;
                cmd.Parameters.Add("@img1", SqlDbType.VarBinary).Value = (object)img1 ?? DBNull.Value;
                cmd.Parameters.Add("@img2", SqlDbType.VarBinary).Value = (object)img2 ?? DBNull.Value;
                cmd.Parameters.Add("@img3", SqlDbType.VarBinary).Value = (object)img3 ?? DBNull.Value;
                cmd.Parameters.Add("@img4", SqlDbType.VarBinary).Value = (object)img4 ?? DBNull.Value;
                cmd.Parameters.Add("@img5", SqlDbType.VarBinary).Value = (object)img5 ?? DBNull.Value;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Insert Image Error: " + ex.Message);
            }
            finally
            {
                if (sqlcon.State == ConnectionState.Open) sqlcon.Close();
            }
        }

        public void update_single_extra_image(string pid, string column, byte[] data)
        {
            try
            {
                if (sqlcon.State == ConnectionState.Closed) sqlcon.Open();
                string qry = "UPDATE propertyimage SET " + column + " = @image WHERE pid = @pid";
                SqlCommand cmd = new SqlCommand(qry, sqlcon);

                cmd.Parameters.Add("@image", SqlDbType.VarBinary).Value = data;
                cmd.Parameters.Add("@pid", SqlDbType.Int).Value = pid;

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Update Image Error: " + ex.Message);
            }
            finally
            {
                if (sqlcon.State == ConnectionState.Open) sqlcon.Close();
            }
        }
    }
}