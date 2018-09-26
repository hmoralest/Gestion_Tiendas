using System;
using System.Collections.Generic;
//using Npgsql; //Npgsql .NET Data Provider for PostgreSQL
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Gestion_Tiendas.Funciones
{
    class Usuarios
    {
        #region [atributos]
        public string usu_id { set; get; }
        public string usu_nombres { set; get; }
        public string usu_apellidos { set; get; }
        public string usu_login { set; get; }
        public string usu_password  { set; get; }
        public string usu_usumod { set; get; }
        #endregion

        #region [metodos]
        public static DataTable Obtener_Usuario(string usu, string pwd)
        {
            DataTable result = new DataTable();
            
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Obtener_Usuario";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@login", SqlDbType.VarChar).Value = usu;
                    cmd.Parameters.Add("@contra", SqlDbType.VarChar).Value = pwd;
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

        public static bool Valida_Login(string login)
        {
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Valida_Login";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@login", SqlDbType.VarChar).Value = login;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
            if(result.Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public static void USP_GTDA_Grabar_Modificar_Usuario(string id, string nombres, string apellidos, 
                                                             string login, string pwd, string usu_cre)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Grabar_Modificar_Seguros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@Id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@nombres", SqlDbType.VarChar).Value = nombres;
                    cmd.Parameters.Add("@apellid", SqlDbType.VarChar).Value = apellidos;

                    cmd.Parameters.Add("@login", SqlDbType.VarChar).Value = login;
                    cmd.Parameters.Add("@contra", SqlDbType.VarChar).Value = pwd;

                    cmd.Parameters.Add("@usu_act", SqlDbType.VarChar).Value = usu_cre;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
        }
        #endregion

    }
}
