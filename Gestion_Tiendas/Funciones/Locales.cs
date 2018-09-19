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
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = "";
                    cmd.Parameters.Add("@cod_int", SqlDbType.VarChar).Value = "";
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

        public static DataTable Buscar_Locales(string id, string cod_int, string des, string tipo, string super, string arren, string ubic, string direc, string estado)
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
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@cod_int", SqlDbType.VarChar).Value = cod_int;
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
                    cmd.CommandTimeout = 60;

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
                    cmd.CommandTimeout = 60;

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

        public static DataTable Lista_TipoSeguros()
        {
            DataTable result = new DataTable();
            
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_TipoSeguros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandTimeout = 60;
                    
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

        public static DataTable Lista_Seguros(string cod_local, string tip_local, string tip_seg)
        {
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Seguros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_local;
                    cmd.Parameters.Add("@tip_ent", SqlDbType.VarChar).Value = tip_local;
                    cmd.Parameters.Add("@tip_seg", SqlDbType.VarChar).Value = tip_seg;
                    cmd.Parameters.Add("@cod_seg", SqlDbType.VarChar).Value = "";

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

        public static DataTable Obten_Seguro(string cod_local, string tip_local, string tip_seg, string cod_seg)
        {
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Seguros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandTimeout = 60;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_local;
                    cmd.Parameters.Add("@tip_ent", SqlDbType.VarChar).Value = tip_local;
                    cmd.Parameters.Add("@tip_seg", SqlDbType.VarChar).Value = tip_seg;
                    cmd.Parameters.Add("@cod_seg", SqlDbType.VarChar).Value = cod_seg;

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

        public static void Grabar_Modificar_Seguros(    string cod_ent, string tip_ent,
                                                        string tipo, string codigo, DateTime fec_ini, DateTime fec_fin,
                                                        string aseg_ruc, string aseg_raz, string nro_doc, string benef_ruc, string benef_raz,
                                                        decimal cant, string unid, decimal valor,
                                                        string ruta)
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

                    cmd.Parameters.Add("@ent_cod", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@ent_tip", SqlDbType.VarChar).Value = tip_ent;

                    cmd.Parameters.Add("@seg_cod", SqlDbType.VarChar).Value = codigo;
                    cmd.Parameters.Add("@seg_tip", SqlDbType.VarChar).Value = tipo;
                    cmd.Parameters.Add("@fec_ini", SqlDbType.VarChar).Value = fec_ini.ToShortDateString();
                    cmd.Parameters.Add("@fec_fin", SqlDbType.VarChar).Value = fec_fin.ToShortDateString();

                    cmd.Parameters.Add("@asg_ruc", SqlDbType.VarChar).Value = aseg_ruc;
                    cmd.Parameters.Add("@asg_raz", SqlDbType.VarChar).Value = aseg_raz;
                    cmd.Parameters.Add("@nro_doc", SqlDbType.VarChar).Value = nro_doc;
                    cmd.Parameters.Add("@ben_ruc", SqlDbType.VarChar).Value = benef_ruc;
                    cmd.Parameters.Add("@ben_raz", SqlDbType.VarChar).Value = benef_raz;

                    cmd.Parameters.Add("@cantid", SqlDbType.VarChar).Value = cant;
                    cmd.Parameters.Add("@unidad", SqlDbType.VarChar).Value = unid;
                    cmd.Parameters.Add("@valor", SqlDbType.VarChar).Value = valor;

                    cmd.Parameters.Add("@ruta", SqlDbType.VarChar).Value = ruta;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
        }

        public static DataTable Lista_PagoTerceros(string cod_ent, string tip_ent)
        {
            DataTable lista = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_PagoTerceros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    
                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tip_ent", SqlDbType.VarChar).Value = tip_ent;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(lista);

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
            return lista;
        }

        public static void Graba_PagosTerceros(string cod_ent, string tip_ent,
                                                 string id, string ruc, string raz_soc,
                                                 decimal porc,
                                                 string banc_id, string banc_des, string banc_cta)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Inserta_Linea_PagoTerceros";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_loc", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tip_loc", SqlDbType.VarChar).Value = tip_ent;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@ruc", SqlDbType.VarChar).Value = ruc;
                    cmd.Parameters.Add("@raz_soc", SqlDbType.VarChar).Value = raz_soc;

                    cmd.Parameters.Add("@porc", SqlDbType.VarChar).Value = porc;

                    cmd.Parameters.Add("@ban_id", SqlDbType.VarChar).Value = banc_id;
                    cmd.Parameters.Add("@ban_des", SqlDbType.VarChar).Value = banc_des;
                    cmd.Parameters.Add("@ban_cta", SqlDbType.VarChar).Value = banc_cta;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

        }

        public static void Elimina_PagosTerceros(string cod_ent, string tip_ent)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Elimina_PagoTercero";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_loc", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tip_loc", SqlDbType.VarChar).Value = tip_ent;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
        }


        public static void Actualiza_RutaSeg(string cod_doc, string tip_doc, string new_ruta)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Actualiza_RUTA_Archivos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_doc", SqlDbType.VarChar).Value = cod_doc;
                    cmd.Parameters.Add("@tip_doc", SqlDbType.VarChar).Value = tip_doc;

                    cmd.Parameters.Add("@tip_ruta", SqlDbType.VarChar).Value = "SEGU";
                    cmd.Parameters.Add("@new_ruta", SqlDbType.VarChar).Value = new_ruta;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
        }

        public static DataTable Lista_CartaFianza(string cod_ent, string tip_ent)
        {
            DataTable lista = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_CartaFianza";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tip_ent", SqlDbType.VarChar).Value = tip_ent;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(lista);

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
            return lista;
        }

        public static void Grabar_Modificar_CartaFianza(    string cod_ent, string tip_ent,
                                                            string id, DateTime fec_ini, DateTime fec_fin,
                                                            string banc_id, string banc_des, string nro_doc,
                                                            string ruc, string raz_soc, decimal monto,
                                                            string ruta)
        {
            //DataTable lista = new DataTable();
            //string res = "";

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    //cmd.CommandText = "USP_GTDA_Inserta_Linea_CartaFianza";
                    cmd.CommandText = "USP_GTDA_Grabar_Modificar_CartaFianza";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@ent_cod", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@ent_tip", SqlDbType.VarChar).Value = tip_ent;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@fec_ini", SqlDbType.VarChar).Value = fec_ini.ToShortDateString();
                    cmd.Parameters.Add("@fec_fin", SqlDbType.VarChar).Value = fec_fin.ToShortDateString();

                    cmd.Parameters.Add("@ban_id", SqlDbType.VarChar).Value = banc_id;
                    cmd.Parameters.Add("@ban_des", SqlDbType.VarChar).Value = banc_des;
                    cmd.Parameters.Add("@nro_doc", SqlDbType.VarChar).Value = nro_doc;

                    cmd.Parameters.Add("@ruc", SqlDbType.VarChar).Value = ruc;
                    cmd.Parameters.Add("@raz_soc", SqlDbType.VarChar).Value = raz_soc;
                    cmd.Parameters.Add("@monto", SqlDbType.VarChar).Value = monto;

                    cmd.Parameters.Add("@ruta", SqlDbType.VarChar).Value = ruta;

                    cmd.ExecuteNonQuery();

                    con.Close();
                    /*SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(lista);

                    con.Close();

                    res = lista.Rows[0]["codigo"].ToString();*/
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
            //return res;
        }

        public static void Elimina_CartaFianza(string cod_cont, string tipo_cont)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Elimina_CartaFianza";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tipo_cont;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

        }

        public static void Actualiza_RutaCarta(string cod_doc, string new_ruta)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Actualiza_RUTA_Archivos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_doc", SqlDbType.VarChar).Value = cod_doc;
                    cmd.Parameters.Add("@tip_doc", SqlDbType.VarChar).Value = "";

                    cmd.Parameters.Add("@tip_ruta", SqlDbType.VarChar).Value = "CART";
                    cmd.Parameters.Add("@new_ruta", SqlDbType.VarChar).Value = new_ruta;

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
