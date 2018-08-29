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
    class Contratos
    {
        #region [atributos]
        public string cont_codigo { set; get; }
        public string cont_tipoDoc { set; get; }
        public string cont_padreId { set; get; }
        public string cont_entidId { set; get; }
        public string Cont_TipEnt { set; get; }
        public Int32 Cont_Area { set; get; }
        public DateTime Cont_FecIni { set; get; }
        public DateTime Cont_FecFin { set; get; }
        public string Cont_Moneda { set; get; }
	    public decimal Cont_RentFija { set; get; }
	    public decimal Cont_RentVar { set; get; }
	    public decimal Cont_Adela { set; get; }
	    public decimal Cont_Garantia { set; get; }
	    public decimal Cont_Ingreso { set; get; }
	    public decimal Cont_RevProy { set; get; }
	    public decimal Cont_FondProm { set; get; }
	    public decimal Cont_GComunFijo { set; get; }
	    public decimal Cont_GComunVar { set; get; }
	    public Int32 Cont_DbJul { set; get; }
        public Int32 Cont_DbDic { set; get; }
        public Int32 Cont_ServPub { set; get; }
        public Int32 Cont_ArbMunic { set; get; }
        public Int32 Cont_IPC_RentFija { set; get; }
        public Int32 Cont_IPC_FondProm { set; get; }
        public Int32 Cont_IPC_GComun { set; get; }
        public Int32 Cont_IPC_Frecue { set; get; }
	    public DateTime Cont_IPC_Fec { set; get; }
	    public Int32 Cont_PagoTercer { set; get; }
	    public Int32 Cont_CartFianza { set; get; }
	    public Int32 Cont_OblSegur { set; get; }
	    public string Cont_RutaPlano { set; get; }
	    public string Cont_RutaCont { set; get; }
        #endregion

        #region [metodos]
        public static DataTable Ver_Contrato_Actual(string codigo, string id_local, string tipo)
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();
            DateTime hoy = DateTime.Now;
            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Ver_Contrato_Actual";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@codigo", SqlDbType.VarChar).Value = codigo;
                    cmd.Parameters.Add("@cod_tda", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    //cmd.Parameters.Add("@Fecha", SqlDbType.VarChar).Value = hoy.ToString();
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

        public static DataTable Ver_Contrato_Real(string codigo, string id_local, string tipo)
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();
            DateTime hoy = DateTime.Now;
            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Ver_Contrato_Real";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@codigo", SqlDbType.VarChar).Value = codigo;
                    cmd.Parameters.Add("@cod_tda", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    //cmd.Parameters.Add("@Fecha", SqlDbType.VarChar).Value = hoy.ToString();
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

        public static DataTable Ver_Documento_Actual(string codigo, string tipo_cont, string id_local, string tipo)
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();
            DateTime hoy = DateTime.Now;
            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Ver_Documento_Actual";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = codigo;
                    cmd.Parameters.Add("@tipo_cont", SqlDbType.VarChar).Value = tipo_cont;
                    cmd.Parameters.Add("@cod_tda", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    //cmd.Parameters.Add("@Fecha", SqlDbType.VarChar).Value = hoy.ToString();
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

        public static DataTable Ver_Documento_Real(string codigo, string tipo_cont, string id_local, string tipo)
        //public static List<Locales> Listar_Locales()
        {
            DataTable result = new DataTable();
            DateTime hoy = DateTime.Now;
            //List<Locales> listado = new List<Locales>();
            //Locales local = new Locales();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Ver_Documento_Real";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = codigo;
                    cmd.Parameters.Add("@tipo_cont", SqlDbType.VarChar).Value = tipo_cont;
                    cmd.Parameters.Add("@cod_tda", SqlDbType.VarChar).Value = id_local;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = tipo;
                    //cmd.Parameters.Add("@Fecha", SqlDbType.VarChar).Value = hoy.ToString();
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

        public static string Ingresa_Contrato(string _codigo, string _tipo, string _tipo_doc, string _cont_pad, DateTime _fechaini, DateTime _fechafin, decimal _area, string _moneda,
                                            string _arrenda, string _adminis,
                                            decimal _rent_fij, decimal _rent_var, decimal _adelanto, decimal _garantia, decimal _der_ingr, decimal _rev_proy, decimal _promocio, decimal _promoc_v, decimal _gast_com, decimal _gs_com_p, decimal _gs_com_v,
                                            int _dbJulio, int _dbDiciembre, int _serv_public, int _arbitrios,
                                            int _IPC_renta, int _IPC_promo, int _IPC_comun, int _IPC_frecu, DateTime _fecha_IPC,
                                            int _pag_terce, int _obl_segur, int _obl_carta,
                                            string _ruta_plano, string _ruta_contr)
        {
            DataTable result = new DataTable();
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Inserta_Contrato";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@codigo", SqlDbType.VarChar).Value = _codigo;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = _tipo;
                    cmd.Parameters.Add("@tipo_doc", SqlDbType.VarChar).Value = _tipo_doc;
                    cmd.Parameters.Add("@cont_pad", SqlDbType.VarChar).Value = _cont_pad;
                    cmd.Parameters.Add("@fechaini", SqlDbType.VarChar).Value = _fechaini.ToShortDateString();
                    cmd.Parameters.Add("@fechafin", SqlDbType.VarChar).Value = _fechafin.ToShortDateString();
                    cmd.Parameters.Add("@area", SqlDbType.VarChar).Value = _area;
                    cmd.Parameters.Add("@moneda", SqlDbType.VarChar).Value = _moneda;

                    cmd.Parameters.Add("@arrendador", SqlDbType.VarChar).Value = _arrenda;
                    cmd.Parameters.Add("@administra", SqlDbType.VarChar).Value = _adminis;

                    cmd.Parameters.Add("@rent_fij", SqlDbType.VarChar).Value = _rent_fij;
                    cmd.Parameters.Add("@rent_var", SqlDbType.VarChar).Value = _rent_var;
                    cmd.Parameters.Add("@adelanto", SqlDbType.VarChar).Value = _adelanto;
                    cmd.Parameters.Add("@garantia", SqlDbType.VarChar).Value = _garantia;
                    cmd.Parameters.Add("@der_ingr", SqlDbType.VarChar).Value = _der_ingr;
                    cmd.Parameters.Add("@rev_proy", SqlDbType.VarChar).Value = _rev_proy;
                    cmd.Parameters.Add("@promocio", SqlDbType.VarChar).Value = _promocio;
                    cmd.Parameters.Add("@promoc_v", SqlDbType.VarChar).Value = _promoc_v;
                    cmd.Parameters.Add("@gast_com", SqlDbType.VarChar).Value = _gast_com;
                    cmd.Parameters.Add("@gs_com_p", SqlDbType.VarChar).Value = _gs_com_p;
                    cmd.Parameters.Add("@gs_com_v", SqlDbType.VarChar).Value = _gs_com_p;

                    cmd.Parameters.Add("@dbJulio", SqlDbType.VarChar).Value = _dbJulio;
                    cmd.Parameters.Add("@dbDiciembre", SqlDbType.VarChar).Value = _dbDiciembre;
                    cmd.Parameters.Add("@serv_public", SqlDbType.VarChar).Value = _serv_public;
                    cmd.Parameters.Add("@arbitrios", SqlDbType.VarChar).Value = _arbitrios;

                    cmd.Parameters.Add("@IPC_renta", SqlDbType.VarChar).Value = _IPC_renta;
                    cmd.Parameters.Add("@IPC_promo", SqlDbType.VarChar).Value = _IPC_promo;
                    cmd.Parameters.Add("@IPC_comun", SqlDbType.VarChar).Value = _IPC_comun;
                    cmd.Parameters.Add("@IPC_frecu", SqlDbType.VarChar).Value = _IPC_frecu;
                    cmd.Parameters.Add("@fecha_IPCa", SqlDbType.VarChar).Value = _fecha_IPC.ToShortDateString();

                    cmd.Parameters.Add("@pag_terce", SqlDbType.VarChar).Value = _pag_terce;
                    cmd.Parameters.Add("@obl_segur", SqlDbType.VarChar).Value = _obl_segur;
                    cmd.Parameters.Add("@obl_carta", SqlDbType.VarChar).Value = _obl_carta;

                    cmd.Parameters.Add("@ruta_plano", SqlDbType.VarChar).Value = _ruta_plano;
                    cmd.Parameters.Add("@ruta_contr", SqlDbType.VarChar).Value = _ruta_contr;

                    //cmd.ExecuteNonQuery();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);
                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }
            return result.Rows[0]["codigo"].ToString();
        }

        public static void Actualiza_Contrato(  string _codigo, string _tipo, string cod_contrato, DateTime _fechaini, DateTime _fechafin, decimal _area, string _moneda,
                                                string _arrenda, string _adminis,
                                                decimal _rent_fij, decimal _rent_var, decimal _adelanto, decimal _garantia, decimal _der_ingr, decimal _rev_proy, decimal _promocio, decimal _promoc_v, decimal _gast_com, int _gs_com_p, decimal _gs_com_v,
                                                int _dbJulio, int _dbDiciembre, int _serv_public, int _arbitrios,
                                                int _IPC_renta, int _IPC_promo, int _IPC_comun, int _IPC_frecu, DateTime _fecha_IPC,
                                                int _pag_terce, int _obl_segur, int _obl_carta,
                                                string _ruta_plano, string _ruta_contr)
        {

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Actualiza_Contrato";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@codigo", SqlDbType.VarChar).Value = _codigo;
                    cmd.Parameters.Add("@tipo", SqlDbType.VarChar).Value = _tipo;
                    cmd.Parameters.Add("@Id", SqlDbType.VarChar).Value = cod_contrato;
                    cmd.Parameters.Add("@fechaini", SqlDbType.VarChar).Value = _fechaini.ToShortDateString();
                    cmd.Parameters.Add("@fechafin", SqlDbType.VarChar).Value = _fechafin.ToShortDateString();
                    cmd.Parameters.Add("@area", SqlDbType.VarChar).Value = _area;
                    cmd.Parameters.Add("@moneda", SqlDbType.VarChar).Value = _moneda;

                    cmd.Parameters.Add("@arrendador", SqlDbType.VarChar).Value = _arrenda;
                    cmd.Parameters.Add("@administra", SqlDbType.VarChar).Value = _adminis;

                    cmd.Parameters.Add("@rent_fij", SqlDbType.VarChar).Value = _rent_fij;
                    cmd.Parameters.Add("@rent_var", SqlDbType.VarChar).Value = _rent_var;
                    cmd.Parameters.Add("@adelanto", SqlDbType.VarChar).Value = _adelanto;
                    cmd.Parameters.Add("@garantia", SqlDbType.VarChar).Value = _garantia;
                    cmd.Parameters.Add("@der_ingr", SqlDbType.VarChar).Value = _der_ingr;
                    cmd.Parameters.Add("@rev_proy", SqlDbType.VarChar).Value = _rev_proy;
                    cmd.Parameters.Add("@promocio", SqlDbType.VarChar).Value = _promocio;
                    cmd.Parameters.Add("@promoc_v", SqlDbType.VarChar).Value = _promoc_v;
                    cmd.Parameters.Add("@gast_com", SqlDbType.VarChar).Value = _gast_com;
                    cmd.Parameters.Add("@gs_com_p", SqlDbType.VarChar).Value = _gs_com_p;
                    cmd.Parameters.Add("@gs_com_v", SqlDbType.VarChar).Value = _gs_com_v;

                    cmd.Parameters.Add("@dbJulio", SqlDbType.VarChar).Value = _dbJulio;
                    cmd.Parameters.Add("@dbDiciembre", SqlDbType.VarChar).Value = _dbDiciembre;
                    cmd.Parameters.Add("@serv_public", SqlDbType.VarChar).Value = _serv_public;
                    cmd.Parameters.Add("@arbitrios", SqlDbType.VarChar).Value = _arbitrios;

                    cmd.Parameters.Add("@IPC_renta", SqlDbType.VarChar).Value = _IPC_renta;
                    cmd.Parameters.Add("@IPC_promo", SqlDbType.VarChar).Value = _IPC_promo;
                    cmd.Parameters.Add("@IPC_comun", SqlDbType.VarChar).Value = _IPC_comun;
                    cmd.Parameters.Add("@IPC_frecu", SqlDbType.VarChar).Value = _IPC_frecu;
                    cmd.Parameters.Add("@fecha_IPCa", SqlDbType.VarChar).Value = _fecha_IPC.ToShortDateString();

                    cmd.Parameters.Add("@pag_terce", SqlDbType.Bit).Value = _pag_terce;
                    cmd.Parameters.Add("@obl_segur", SqlDbType.Bit).Value = _obl_segur;
                    cmd.Parameters.Add("@obl_carta", SqlDbType.Bit).Value = _obl_carta;

                    cmd.Parameters.Add("@ruta_plano", SqlDbType.VarChar).Value = _ruta_plano;
                    cmd.Parameters.Add("@ruta_contr", SqlDbType.VarChar).Value = _ruta_contr;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

        }

        public static string Valida_Proveedor(string RUC)
        {
            string razon = "";
            DataTable result = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Valida_Proveedor";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@RUC", SqlDbType.VarChar).Value = RUC;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(result);

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

            if (result.Rows.Count > 0)
            {
                foreach (DataRow row in result.Rows)
                {
                    razon = row["razon_social"].ToString();
                }
            }
            return razon;
        }
        public static DataTable ListaDocumentos(string cod_ent, string tipo_ent)
        {
            DataTable lista = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Documentos_TDA";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tipo_ent", SqlDbType.VarChar).Value = tipo_ent;
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

        public static DataTable ListaBancos()
        {
            DataTable lista = new DataTable();
            
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Bancos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    /*cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tipo_ent", SqlDbType.VarChar).Value = tipo_ent;*/
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

        public static DataTable ListaContratos(string cod_ent, string tipo_ent)
        {
            DataTable lista = new DataTable();
            
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_Contratos_TDA";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_ent", SqlDbType.VarChar).Value = cod_ent;
                    cmd.Parameters.Add("@tipo_ent", SqlDbType.VarChar).Value = tipo_ent;
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

        public static DataTable Lista_CronogramaPagos(string cod_cont, string tip_cont)
        {
            DataTable lista = new DataTable();

            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Lista_CronogramaPagos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tip_cont;
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

        public static void Graba_CronogramaPagos(string cod_cont, string tipo_cont,
                                                 string nro, decimal fijo, decimal variable, 
                                                 DateTime fec_ini, DateTime fec_fin, string vigencia)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Inserta_Linea_CronogramaPagos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tipo_cont;

                    cmd.Parameters.Add("@nro", SqlDbType.VarChar).Value = nro;
                    cmd.Parameters.Add("@fijo", SqlDbType.VarChar).Value = fijo;
                    cmd.Parameters.Add("@variable", SqlDbType.VarChar).Value = variable;

                    cmd.Parameters.Add("@fec_ini", SqlDbType.VarChar).Value = fec_ini.ToShortDateString();
                    cmd.Parameters.Add("@fec_fin", SqlDbType.VarChar).Value = fec_fin.ToShortDateString();
                    cmd.Parameters.Add("@vigencia", SqlDbType.VarChar).Value = vigencia;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

        }

        public static void Elimina_CronogramaPagos( string cod_cont, string tipo_cont/*,
                                                    string nro, decimal fijo, decimal variable,
                                                    DateTime fec_ini, DateTime fec_fin, string vigencia*/)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Elimina_CronogramaPagos";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tipo_cont;

                    /*cmd.Parameters.Add("@nro", SqlDbType.VarChar).Value = nro;
                    cmd.Parameters.Add("@fijo", SqlDbType.VarChar).Value = fijo;
                    cmd.Parameters.Add("@variable", SqlDbType.VarChar).Value = variable;

                    cmd.Parameters.Add("@area", SqlDbType.VarChar).Value = fec_ini.ToShortDateString();
                    cmd.Parameters.Add("@moneda", SqlDbType.VarChar).Value = fec_fin.ToShortDateString();
                    cmd.Parameters.Add("@arrendador", SqlDbType.VarChar).Value = vigencia;*/

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

        }

        public static DataTable Lista_PagoTerceros(string cod_cont, string tip_cont, string cod_ent, string tip_ent)
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

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tip_cont;
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

        public static void Graba_PagosTerceros(string cod_cont, string tipo_cont,
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

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tipo_cont;

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

        public static void Elimina_PagosTerceros(string cod_cont, string tipo_cont)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Elimina_PagosTerceros";
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
        
        public static DataTable Lista_CartaFianza(string cod_cont, string tip_cont)
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

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tip_cont;
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

        public static void Graba_CartaFianza(string cod_cont, string tipo_cont,
                                                 string id, DateTime fec_ini, DateTime fec_fin,
                                                 string banc_id, string banc_des, string nro_doc,
                                                 string ruc, string raz_soc, decimal monto)
        {
            using (SqlConnection con = Conexion.getConexionSQL())
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "USP_GTDA_Inserta_Linea_CartaFianza";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;

                    cmd.Parameters.Add("@cod_cont", SqlDbType.VarChar).Value = cod_cont;
                    cmd.Parameters.Add("@tip_cont", SqlDbType.VarChar).Value = tipo_cont;

                    cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = id;
                    cmd.Parameters.Add("@fec_ini", SqlDbType.VarChar).Value = fec_ini.ToShortDateString();
                    cmd.Parameters.Add("@fec_fin", SqlDbType.VarChar).Value = fec_fin.ToShortDateString();

                    cmd.Parameters.Add("@ban_id", SqlDbType.VarChar).Value = banc_id;
                    cmd.Parameters.Add("@ban_des", SqlDbType.VarChar).Value = banc_des;
                    cmd.Parameters.Add("@nro_doc", SqlDbType.VarChar).Value = nro_doc;

                    cmd.Parameters.Add("@ruc", SqlDbType.VarChar).Value = ruc;
                    cmd.Parameters.Add("@raz_soc", SqlDbType.VarChar).Value = raz_soc;
                    cmd.Parameters.Add("@monto", SqlDbType.VarChar).Value = monto;

                    cmd.ExecuteNonQuery();

                    con.Close();
                }
                catch (Exception Ex)
                {
                    throw Ex;
                }
            }

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
        #endregion

    }
}
