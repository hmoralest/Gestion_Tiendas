using System;
using System.Collections.Generic;
using Npgsql; //Npgsql .NET Data Provider for PostgreSQL
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Gestion_Tiendas.Funciones
{
    class Locales
    {
        #region [atributos]
        public string loc_codigo { set; get; }
        public string loc_descripcion { set; get; }
        public string loc_tipo { set; get; }
        public string loc_estado_actual { set; get; }
        public string loc_supervisor { set; get; }
        public string loc_propietario { set; get; }
        public string loc_direccion { set; get; }
        public string loc_plano_actual { set; get; }
        public string loc_area { set; get; }
        #endregion

        #region [metodos]
        /*public static DataTable Listar_LocalesPSG()
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();

            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            string query = "";
            query += "Select ";
            query += "  ent.cod_entid As codigo, ";
            query += "  ent.des_entid As Nombre, ";
            query += "  CASE WHEN alm.cod_entid is not null THEN 'ALM' ";
            query += "      WHEN alm.cod_entid is not null THEN 'TDA' ";
            query += "  ELSE '' ";
            query += "  END As Tipo, ";
            query += "  ''  As Supervisor, ";
            query += "  ''  As Propietario, ";
            query += "  ent.cod_ubige1 As distrito, ";
            query += "  '' As direccion, ";
            query += "  ''              As Estado ";
            query += "From public.tentidad ent ";
            query += "  Left Join public.tentidad_almacen alm ";
            query += "      On (ent.cod_entid = alm.cod_entid) ";
            query += "  Left Join public.tentidad_tienda tda ";
            query += "      On (ent.cod_entid = tda.cod_entid) ";
            query += "Where ent.tip_estad = 'A' ";
            query += "  And (alm.cod_entid is not null or tda.cod_entid is not null) ";

            //query = "Select * from public.tentidad";

            using (NpgsqlConnection con = Conexion.getConexionPGS())
            {
                try
                {
                    con.Open();
                    NpgsqlCommand cmd = new NpgsqlCommand(query, con);
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            //return listado;
            return result;
        }*/

        public static DataTable Listar_Locales()
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();

            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();
                        
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Locales";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@des", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@super", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@arren", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@ubic", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@direc", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@estado", SqlDbType.VarChar).Value = "";
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            //return listado;
            return result;
        }

        public static DataTable Buscar_Locales(string id, string des, string tipo, string super, string arren, string ubic, string direc, string estado)
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();

            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Locales";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@des", SqlDbType.VarChar).Value = des;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    cmd.Parameters.Add("@super", SqlDbType.VarChar).Value = super;
                    cmd.Parameters.Add("@arren", SqlDbType.VarChar).Value = arren;
                    cmd.Parameters.Add("@ubic", SqlDbType.VarChar).Value = ubic;
                    cmd.Parameters.Add("@direc", SqlDbType.VarChar).Value = direc;
                    cmd.Parameters.Add("@estado", SqlDbType.VarChar).Value = estado;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            //return listado;
            return result;
        }

        public static DataTable Consulta_Datos_Locales(string id_local, string tipo)
        {
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Obten_Datos_Locales";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            return result;
        }

        public static DataTable Consulta_Relacion_Locales(string id_local, string tipo)
        {
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Obten_Relacion_Locales";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            return result;
        }
        #endregion

    }
}
