using Gestion_Tiendas.Funciones;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace Gestion_Tiendas.Formularios
{
    /// <summary>
    /// Lógica de interacción para Modif_Ver_Doc.xaml
    /// </summary>
    public partial class Modif_Ver_Doc : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public static string _cod_tda = "";
        public static string _tipo = "";
        public static string _cod_contrato = "";
        public static string _tipo_contrato = "";
        public static string _accion = "";  // A: Actualizar; V: Ver

        public static string contrato_lista = "";
        public static string ult_cont = ""; // almacena el último contrato para activar boton guardar
        public static string ult_doc = ""; // almacena el último contrato para activar boton guardar
        public static string ult_tipo_cont = "";

        public static Boolean _error = false;

        public static DataTable dt_arrend = new DataTable();
        public static DataTable dt_admin = new DataTable();

        public static DataTable dt_programa = null;
        public static string val_fec_ini = "";
        public static string val_fec_fin = "";
        public static string val_ren_fija = "";
        public static string val_ren_var = "";

        public static DataTable dt_pago_terc = null;

        // Carta Fianza
        public static DataTable dt_carta_fianza = null;
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Modif_Ver_Doc()
        {
            InitializeComponent();
        }
        public Modif_Ver_Doc(string codigo, string tipo, string codigo_loc, string tipo_loc, string accion)
        {
            _cod_contrato = codigo;
            _tipo_contrato = tipo;
            _cod_tda = codigo_loc;
            _tipo = tipo_loc;
            _accion = accion;
            InitializeComponent();
            contrato_lista = codigo;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            DataTable dat_gral = new DataTable();
            DataTable dat_rel = new DataTable();
            //DataTable dat_cont = new DataTable();

            // Declara Tablas usadas en los grid
            dt_arrend.TableName = "Arrendatario";
            dt_arrend.Columns.Add("ruc", typeof(string));
            dt_arrend.Columns.Add("raz_soc", typeof(string));
            /*dt_arrend.Columns.Add("porc", typeof(decimal));*/

            dt_admin.TableName = "Administrador";
            dt_admin.Columns.Add("ruc", typeof(string));
            dt_admin.Columns.Add("raz_soc", typeof(string));
            /*dt_admin.Columns.Add("porc", typeof(decimal));*/
            

            try
            {
                /******************************************/
                /*-------Listamos Contrato en Combo-------*/
                /******************************************/
                DataTable lista_cont = new DataTable();
                int contar = 0;
                lista_cont = Contratos.ListaContratos(_cod_tda, _tipo);
                foreach (DataRow row in lista_cont.Rows)
                {
                    ComboBoxItem item = new ComboBoxItem();
                    item.Uid = row["Id"].ToString();
                    item.Content = row["descripcion"].ToString();
                    contar = contar + 1;
                    if (contar == 1)
                    {
                        item.IsSelected = true;
                        ult_cont = row["Id"].ToString();
                    }

                    cbx_contrato.Items.Add(item);
                }
                DataTable lista_docs = new DataTable();
                lista_docs = Contratos.ListaDocumentos(_cod_tda, _tipo);
                foreach (DataRow row in lista_docs.Rows)
                { ult_doc = row["Id"].ToString();  }

                    /******************************************/
                    /*-------------Buscamos datos-------------*/
                    /******************************************/
                    dat_gral = Locales.Consulta_Datos_Locales(_cod_tda, _tipo);
                dat_rel = Locales.Consulta_Relacion_Locales(_cod_tda, _tipo);
                Llena_datos_Documento();
            }
            catch (Exception ex)
            {
                _error = true;
                MessageBox.Show("Error Obtener Información " + _tipo + " " + _cod_tda + ". " + ex.Message + ".",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }

            /******************************************/
            /*-------Llenamos datos principales-------*/
            /******************************************/
            txt_cod.Text = dat_gral.Rows[0]["Id"].ToString().Trim();
            txt_desc.Text = dat_gral.Rows[0]["nombre"].ToString().Trim();
            txt_dist.Text = dat_gral.Rows[0]["dist"].ToString().Trim();
            txt_direc.Text = dat_gral.Rows[0]["direc"].ToString().Trim();
            txt_tipo.Text = dat_gral.Rows[0]["tipo"].ToString().Trim();

            dg_loc_asoc.ItemsSource = dat_rel.DefaultView;

            txt_area.Focus(); txt_area.SelectAll();
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            //MessageBox.Show("Ingrese nuevamente DNI.",
            //"Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            _activo_form = false;
            _cod_tda = "";
            _tipo = "";
            contrato_lista = "";
            _error = false;
            dt_arrend.Reset();
            dt_admin.Reset();
        }

        private void btn_ruta_cont_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_ruta_plano_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_programa_Click(object sender, RoutedEventArgs e)
        {
            if (dt_programa == null) { dt_programa = Contratos.Lista_CronogramaPagos(_cod_contrato, _tipo_contrato); }
            if (dt_programa.Rows.Count > 0 || _accion == "A")
            {
                // Se debe capturar el código
                if (!Prog_Pagos._activo_form)
                {
                    Prog_Pagos frm2 = new Prog_Pagos(_accion, _cod_contrato, _tipo_contrato, dt_programa, Convert.ToDateTime(date_ini.Text.ToString()), Convert.ToDateTime(date_fin.Text.ToString()), txt_rent.Text.ToString(), txt_rent_v.Text.ToString());
                    frm2.Owner = this;
                    //AplicarEfecto(this);
                    this.IsEnabled = false;
                    frm2.Show();
                    Prog_Pagos._activo_form = true;
                    frm2.Closed += Prog_Pagos_Closed;
                }
            }
            else
            {
                MessageBox.Show("No se encontraron registros que mostrar. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void btn_pago_tercero_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            if (!Pago_Tercero._activo_form)
            {
                Pago_Tercero frm2 = new Pago_Tercero(_accion ,dt_pago_terc, _cod_contrato, _tipo_contrato);
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Pago_Tercero._activo_form = true;
                frm2.Closed += Pago_tercero_Closed;
            }
        }

        private void btn_carta_Click(object sender, RoutedEventArgs e)
        {
            if (date_fin.Text.ToString() != "" && date_ini.Text.ToString() != "")
            {
                if (Convert.ToDateTime(date_ini.Text.ToString()) < Convert.ToDateTime(date_fin.Text.ToString()))
                {
                    // Se debe capturar el código
                    if (!Carta_Fianza._activo_form)
                    {
                        Carta_Fianza frm2 = new Carta_Fianza(dt_carta_fianza, Convert.ToDateTime(date_ini.Text.ToString()), Convert.ToDateTime(date_fin.Text.ToString()));
                        frm2.Owner = this;
                        //AplicarEfecto(this);
                        this.IsEnabled = false;
                        frm2.Show();
                        Carta_Fianza._activo_form = true;
                        frm2.Closed += Carta_Fianza_Closed;
                    }
                }
                else
                {
                    MessageBox.Show("Las Fechas no guardan Relación, favor verificar. ",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            else
            {
                MessageBox.Show("Es necesario ingresar Fechas de Contrato para continuar. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void btn_seguro_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_resta_alma_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_resta_arren_Click(object sender, RoutedEventArgs e)
        {
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            //string _barra = (String)row["Cod_Barra"].ToString();

            dt_arrend.Rows.Remove(row.Row);
            dg_arrendatario.ItemsSource = dt_arrend.DefaultView;
        }

        /*private void btn_resta_prop_Click(object sender, RoutedEventArgs e)
        {

        }*/

        private void btn_resta_admin_Click(object sender, RoutedEventArgs e)
        {
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            //string _barra = (String)row["Cod_Barra"].ToString();

            dt_admin.Rows.Remove(row.Row);
            dg_admins.ItemsSource = dt_admin.DefaultView;
        }

        /*private void btn_suma_alma_Click(object sender, RoutedEventArgs e)
        {

        }*/

        /*private void btn_suma_prop_Click(object sender, RoutedEventArgs e)
        {

        }*/

        private void btn_suma_arren_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            if (!Datos_Arrendador._activo_form)
            {
                Datos_Arrendador frm2 = new Datos_Arrendador();
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Datos_Arrendador._activo_form = true;
                frm2.Closed += Datos_Arrendador_Closed;
            }
        }

        private void btn_suma_admin_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            if (!Datos_Administrador._activo_form)
            {
                Datos_Administrador frm2 = new Datos_Administrador();
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Datos_Administrador._activo_form = true;
                frm2.Closed += Datos_Administrador_Closed;
            }
        }

        private void btn_guardar_Click(object sender, RoutedEventArgs e)
        {
            Boolean valida = true;

            if (txt_area.Text == "") {
                valida = false;
                MessageBox.Show("Campo de área no puede ser vacío. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error); }
            if (date_fin.Text == "" || date_ini.Text == "") {
                valida = false;
                MessageBox.Show("Campos de Vigencia no pueden ser vacíos (Fecha Inicio y Fin). ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error); }
            if (txt_rent.Text == "" && _tipo_contrato != "A") {
                valida = false;
                MessageBox.Show("Campo de Renta Fija no puede ser vacío. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error); }
           if ((dt_arrend == null || dt_arrend.Rows.Count == 0) && _tipo_contrato != "A") {
                valida = false;
                MessageBox.Show("Es necesario agregar Arrendatarios. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error); }
            if (dt_programa == null || dt_programa.Rows.Count == 0
                || val_fec_ini != Convert.ToDateTime(date_ini.Text.ToString()).ToShortDateString()
                || val_fec_fin != Convert.ToDateTime(date_fin.Text.ToString()).ToShortDateString()
                || val_ren_fija != txt_rent.Text.ToString() || val_ren_var != txt_rent_v.Text.ToString()) {
                valida = false;
                MessageBox.Show("Es necesario verificar el Cronograma de Pagos antes de Guardar. ",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error); }

            //-- Usamos Valida --//
            if (valida) { GuardarDocumento(); }
                        
        }

        private void rdb_mes_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void cbx_contrato_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            /*ComboBoxItem escoger = (ComboBoxItem)(cbx_contrato.SelectedValue);
            contrato_lista = escoger.Uid.ToString();
            Llena_datos_Documento();*/
        }

        private void txt_area_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { date_ini.Focus(); }
        }

        private void date_ini_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { date_fin.Focus(); }
        }

        private void date_fin_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_rent.Focus(); txt_rent.SelectAll(); }
        }

        private void txt_rent_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_rent_v.Focus(); txt_rent_v.SelectAll(); }
        }

        private void txt_rent_v_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_adela.Focus(); txt_adela.SelectAll(); }
        }

        private void txt_adela_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_garan.Focus(); txt_garan.SelectAll(); }
        }

        private void txt_garan_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_ingreso.Focus(); txt_ingreso.SelectAll(); }
        }

        private void txt_ingreso_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_rev_proy.Focus(); txt_rev_proy.SelectAll(); }
        }

        private void txt_rev_proy_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_promoc.Focus(); txt_promoc.SelectAll(); }
        }

        private void txt_promoc_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_promoc_var.Focus(); txt_promoc_var.SelectAll(); }
        }

        private void txt_promoc_var_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_comun.Focus(); txt_comun.SelectAll(); }
        }

        private void txt_comun_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_comun_v.Focus(); txt_comun_v.SelectAll(); }
        }
        #endregion

        #region Funciones de Programa
        private void AplicarEfecto(Window win)
        {
            var objBlur = new System.Windows.Media.Effects.BlurEffect();
            objBlur.Radius = 5;
            win.Effect = objBlur;
        }

        private void QuitarEfecto(Window win)
        {
            win.Effect = null;
        }

        private void Datos_Arrendador_Closed(object sender, EventArgs e)
        {
            Datos_Arrendador ventana = sender as Datos_Arrendador;
            Boolean _valida_existe = true;

            if (ventana.datos != null)
            {
                foreach (var item in ventana.datos.Rows)
                {
                    if (dt_arrend.Rows.Count > 0)
                    {
                        DataRow[] fila_existe = dt_arrend.Select("ruc='" + ((DataRow)item)["ruc"] + "'");
                        _valida_existe = (fila_existe.Length == 0) ? true : false;
                    }

                    if (_valida_existe)
                    {
                        dt_arrend.ImportRow((DataRow)item);
                    }
                    else
                    {
                        MessageBox.Show("El RUC ingresado ya existe como Arrendador.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }

            // (refrescar)
            dg_arrendatario.ItemsSource = dt_arrend.DefaultView;
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Datos_Administrador_Closed(object sender, EventArgs e)
        {
            Datos_Administrador ventana = sender as Datos_Administrador;
            Boolean _valida_existe = true;

            if (ventana.datos != null)
            {
                foreach (var item in ventana.datos.Rows)
                {
                    if (dt_admin.Rows.Count > 0)
                    {
                        DataRow[] fila_existe = dt_admin.Select("ruc='" + ((DataRow)item)["ruc"] + "'");
                        _valida_existe = (fila_existe.Length == 0) ? true : false;
                    }

                    if (_valida_existe)
                    {
                        dt_admin.ImportRow((DataRow)item);
                    }
                    else
                    {
                        MessageBox.Show("El RUC ingresado ya existe como Administrador.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }

            // (refrescar)
            dg_admins.ItemsSource = dt_admin.DefaultView;
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }
        
        private void Prog_Pagos_Closed(object sender, EventArgs e)
        {
            Prog_Pagos ventana = sender as Prog_Pagos;

            if (ventana.datos != null && ventana.datos.Rows.Count > 0 && ventana._ok)
            {
                dt_programa = ventana.datos.Copy();
                val_fec_ini = ventana.fecha_i.ToShortDateString();
                val_fec_fin = ventana.fecha_f.ToShortDateString();
                val_ren_fija = ventana.fija;
                val_ren_var = ventana.var;
            }
            // (refrescar)
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Pago_tercero_Closed(object sender, EventArgs e)
        {
            Pago_Tercero ventana = sender as Pago_Tercero;

            if (ventana._ok)
            { dt_pago_terc = ventana.datos; }

            if (dt_pago_terc != null && dt_pago_terc.Rows.Count > 0)
            {
                chk_Pago_Tercero.IsChecked = true;
            }
            else
            {
                chk_Pago_Tercero.IsChecked = false;
            }
            // (refrescar)
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Carta_Fianza_Closed(object sender, EventArgs e)
        {
            Carta_Fianza ventana = sender as Carta_Fianza;
            if (ventana._ok)
            { dt_carta_fianza = ventana.datos; }

            if (dt_carta_fianza != null && dt_carta_fianza.Rows.Count > 0)
            {
                chk_obl_carta.IsChecked = true;
            }
            else
            {
                chk_obl_carta.IsChecked = false;
            }
            // (refrescar)
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Llena_datos_Documento()
        {
            DataTable dat_cont = new DataTable();
            DataTable dt_arrend_ini = new DataTable();
            DataTable dt_admin_ini = new DataTable();

            dt_arrend_ini.TableName = "Arrendatario";
            dt_arrend_ini.Columns.Add("ruc", typeof(string));
            dt_arrend_ini.Columns.Add("raz_soc", typeof(string));

            dt_admin_ini.TableName = "Administrador";
            dt_admin_ini.Columns.Add("ruc", typeof(string));
            dt_admin_ini.Columns.Add("raz_soc", typeof(string));

            //-- LLena datos de Pagos a Terceros
            dt_pago_terc = Contratos.Lista_PagoTerceros(_cod_contrato, _tipo_contrato, _cod_tda, _tipo);
            //-- LLena datos de Carta Fianza
            dt_carta_fianza = Contratos.Lista_CartaFianza(_cod_contrato, _tipo_contrato); ;

            try
            {
                if(_accion == "V"){ dat_cont = Contratos.Ver_Documento_Real(_cod_contrato, _tipo_contrato, _cod_tda, _tipo); }
                else              { dat_cont = Contratos.Ver_Documento_Actual(_cod_contrato, _tipo_contrato, _cod_tda, _tipo); }

                if (dat_cont.Rows.Count > 0)
                {
                    //_cod_contrato = dat_cont.Rows[0]["Cont_Id"].ToString().Trim();
                    ult_tipo_cont = dat_cont.Rows[0]["Cont_TipoCont"].ToString().Trim();

                    if (dat_cont.Rows[0]["Cont_Area"].ToString() == "") { txt_area.Text = ""; }
                    else { txt_area.Text = dat_cont.Rows[0]["Cont_Area"].ToString().Trim(); }

                    //Data Genérica//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_FecIni"].ToString() == "") { date_ini.Text = ""; }
                    else { date_ini.Text = dat_cont.Rows[0]["Cont_FecIni"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_FecFin"].ToString() == "") { date_fin.Text = ""; }
                    else { date_fin.Text = dat_cont.Rows[0]["Cont_FecFin"].ToString().Trim(); }
                    
                    foreach (ComboBoxItem item in cbx_moneda.Items)
                    {
                        if (item.Uid.ToString() == dat_cont.Rows[0]["Cont_Moneda"].ToString().Trim())
                        { item.IsSelected = true; }
                    }
                    //cbx_moneda.Items = dat_cont.Rows[0]["Cont_Moneda"].ToString().Trim();

                    //ComboBoxItem escoger = (ComboBoxItem)(cbx_moneda.SelectedValue);
                    //string _moneda = escoger.Uid.ToString();

                    if (dat_cont.Rows[0]["Cont_Arrenda"].ToString() == "") {  }
                    else {
                        string[] arrendas = dat_cont.Rows[0]["Cont_Arrenda"].ToString().Trim().Split('/');
                        foreach (string dat_arrenda in arrendas)
                        {
                            string[] datos = dat_arrenda.Trim().Split('-');
                            dt_arrend_ini.Rows.Add(datos[0].Trim(), datos[1].Trim());
                        }
                        dt_arrend = dt_arrend_ini;
                        dg_arrendatario.ItemsSource = dt_arrend.AsDataView();
                    }

                    if (dat_cont.Rows[0]["Cont_Adminis"].ToString() == "") { }
                    else
                    {
                        string[] adminis = dat_cont.Rows[0]["Cont_Adminis"].ToString().Trim().Split('/');
                        foreach (string dat_adminis in adminis)
                        {
                            string[] datos = dat_adminis.Trim().Split('-');
                            dt_admin_ini.Rows.Add(datos[0].Trim(), datos[1].Trim());
                        }
                        dt_admin = dt_admin_ini;
                        dg_admins.ItemsSource = dt_admin.AsDataView();
                    }
                    

                    //Data Numérica//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_RentFija"].ToString() == "") { txt_rent.Text = ""; }
                    else { txt_rent.Text = dat_cont.Rows[0]["Cont_RentFija"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_RentVar"].ToString() == "") { txt_rent_v.Text = ""; }
                    else { txt_rent_v.Text = dat_cont.Rows[0]["Cont_RentVar"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_Adela"].ToString() == "") { txt_adela.Text = ""; }
                    else { txt_adela.Text = dat_cont.Rows[0]["Cont_Adela"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_Garantia"].ToString() == "") { txt_garan.Text = ""; }
                    else { txt_garan.Text = dat_cont.Rows[0]["Cont_Garantia"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_Ingreso"].ToString() == "") { txt_ingreso.Text = ""; }
                    else { txt_ingreso.Text = dat_cont.Rows[0]["Cont_Ingreso"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_RevProy"].ToString() == "") { txt_rev_proy.Text = ""; }
                    else { txt_rev_proy.Text = dat_cont.Rows[0]["Cont_RevProy"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_FondProm"].ToString() == "") { txt_promoc.Text = ""; }
                    else { txt_promoc.Text = dat_cont.Rows[0]["Cont_FondProm"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_FondPromVar"].ToString() == "") { txt_promoc_var.Text = ""; }
                    else { txt_promoc_var.Text = dat_cont.Rows[0]["Cont_FondPromVar"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_GComunFijo"].ToString() == "") { txt_comun.Text = ""; }
                    else { txt_comun.Text = dat_cont.Rows[0]["Cont_GComunFijo"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_GComunVar"].ToString() == "") { txt_comun_v.Text = ""; }
                    else { txt_comun_v.Text = dat_cont.Rows[0]["Cont_GComunVar"].ToString().Trim(); }

                    if (dat_cont.Rows[0]["Cont_GComunFijo_P"].ToString() == "") {  }
                    else { chk_gcomun_p.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_GComunFijo_P"]); }


                    //Data Elegir//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_Reten"].ToString() == "") { }
                    else { chk_reten.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_Reten"]); }
                    if (dat_cont.Rows[0]["Cont_DbJul"].ToString() == "") { }
                    else { chk_julio.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_DbJul"]); }
                    if (dat_cont.Rows[0]["Cont_DbDic"].ToString() == "") { }
                    else { chk_diciembre.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_DbDic"]); }
                    if (dat_cont.Rows[0]["Cont_ServPub"].ToString() == "") { }
                    else { chk_publico.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_ServPub"]); }
                    if (dat_cont.Rows[0]["Cont_ArbMunic"].ToString() == "") { }
                    else { chk_arbitrio.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_ArbMunic"]); }

                    //Data IPC//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_IPC_RentFija"].ToString() == "") { }
                    else { chk_ipc_renta.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_IPC_RentFija"]); }
                    if (dat_cont.Rows[0]["Cont_IPC_FondProm"].ToString() == "") { }
                    else { chk_ipc_promo.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_IPC_FondProm"]); }
                    if (dat_cont.Rows[0]["Cont_IPC_GComun"].ToString() == "") { }
                    else { chk_ipc_comun.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_IPC_GComun"]); }
                    if (dat_cont.Rows[0]["Cont_IPC_GComun"].ToString() == "") { }
                    else {
                        rdb_06mes.IsChecked = (dat_cont.Rows[0]["Cont_IPC_Frecue"].ToString().Trim() == "6") ? true : false;
                        rdb_12mes.IsChecked = (dat_cont.Rows[0]["Cont_IPC_Frecue"].ToString().Trim() == "12") ? true : false;
                    }

                    if (dat_cont.Rows[0]["Cont_IPC_Fec"].ToString() == "") { date_ipc.Text = ""; }
                    else { date_ipc.Text = dat_cont.Rows[0]["Cont_IPC_Fec"].ToString().Trim(); }


                    //Data Adicional//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_PagoTercer"].ToString() == "") { }
                    else { chk_Pago_Tercero.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_PagoTercer"]); }
                    if (dat_cont.Rows[0]["Cont_CartFianza"].ToString() == "") { }
                    else { chk_obl_carta.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_CartFianza"]); }
                    if (dat_cont.Rows[0]["Cont_OblSegur"].ToString() == "") { }
                    else { chk_obl_seg.IsChecked = Convert.ToBoolean(dat_cont.Rows[0]["Cont_OblSegur"]); }

                    //Data Rutas//
                    //------------------------------------------//
                    if (dat_cont.Rows[0]["Cont_RutaPlano"].ToString() == "") { txt_ruta_plano.Text = ""; }
                    else { txt_ruta_plano.Text = dat_cont.Rows[0]["Cont_RutaPlano"].ToString().Trim(); }
                    if (dat_cont.Rows[0]["Cont_RutaCont"].ToString() == "") { txt_ruta_cont.Text = ""; }
                    else { txt_ruta_cont.Text = dat_cont.Rows[0]["Cont_RutaCont"].ToString().Trim(); }
                    
                    valida_btn_guardar();
                }
                else
                {
                        _cod_contrato = "";
                        txt_area.Text = "";
                        //Data Genérica//
                        //------------------------------------------//
                        date_ini.Text = "";
                        date_fin.Text = "";
                        cbx_moneda.SelectedValue = "";

                        //Data Numérica//
                        //------------------------------------------//
                        txt_rent.Text = "";
                        txt_rent_v.Text = "0";
                        txt_adela.Text = "0";
                        txt_garan.Text = "0";
                        txt_ingreso.Text = "0";
                        txt_rev_proy.Text = "0";
                        txt_promoc.Text = "0";
                        txt_promoc_var.Text = "0";
                        txt_comun.Text = "0";
                        chk_gcomun_p.IsChecked = false;
                        txt_comun_v.Text = "0";

                        //Data Elegir//
                        //------------------------------------------//
                        chk_reten.IsChecked = false;
                        chk_julio.IsChecked = false;
                        chk_diciembre.IsChecked = false;
                        chk_publico.IsChecked = false;
                        chk_arbitrio.IsChecked = false;

                        //Data IPC//
                        //------------------------------------------//
                        chk_ipc_renta.IsChecked = false;
                        chk_ipc_promo.IsChecked = false;
                        chk_ipc_comun.IsChecked = false;
                        rdb_06mes.IsChecked = false;
                        rdb_12mes.IsChecked = false;
                        date_ipc.Text = "";

                        //Data Adicional//
                        //------------------------------------------//
                        chk_Pago_Tercero.IsChecked = false;
                        chk_obl_carta.IsChecked = false;
                        chk_obl_seg.IsChecked = false;

                        //Data Rutas//
                        //------------------------------------------//
                        txt_ruta_plano.Text = "";
                        txt_ruta_cont.Text = "";

                        // NO SE PUEDE MODIFICAR //
                        //------------------------------------------//

                        _error = true;
                        MessageBox.Show("No se encontraron Contratos Registrados. Necesita Ingresar un Contrato previamente.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                        btn_guardar.Visibility = Visibility.Hidden;
                }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error al listar datos de Contratos Anteriores." + ex.Message,
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }

        private void valida_btn_guardar()
        {
            if (_accion == "A")
            {
                //if ((contrato_lista == "" || contrato_lista == ult_cont) && ult_tipo_cont != "A")
                if(contrato_lista == "" || contrato_lista == ult_doc)
                {
                    btn_guardar.Visibility = Visibility.Visible;
                }
                else
                {
                    btn_guardar.Visibility = Visibility.Hidden;
                }
            }
            else
            {
                btn_guardar.Visibility = Visibility.Hidden;
            }
        }

        private void GuardarDocumento()
        {
            // Declara variables
            string _codigo = txt_cod.Text.ToString();
            DateTime _fechaini = Convert.ToDateTime(date_ini.Text.ToString());
            DateTime _fechafin = Convert.ToDateTime(date_fin.Text.ToString());
            decimal _area = Convert.ToDecimal(txt_area.Text.ToString());

            decimal _rent_fij = Convert.ToDecimal(txt_rent.Text.ToString());
            decimal _rent_var = Convert.ToDecimal(txt_rent_v.Text.ToString());
            decimal _adelanto = Convert.ToDecimal(txt_adela.Text.ToString());
            decimal _garantia = Convert.ToDecimal(txt_garan.Text.ToString());
            decimal _der_ingr = Convert.ToDecimal(txt_ingreso.Text.ToString());
            decimal _rev_proy = Convert.ToDecimal(txt_rev_proy.Text.ToString());
            decimal _promocio = Convert.ToDecimal(txt_promoc.Text.ToString());
            decimal _promoc_v = Convert.ToDecimal(txt_promoc_var.Text.ToString());
            decimal _gast_com = Convert.ToDecimal(txt_comun.Text.ToString());
            int _gs_com_p = (Convert.ToBoolean(chk_gcomun_p.IsChecked)) ? 1 : 0;
            decimal _gs_com_v = Convert.ToDecimal(txt_comun_v.Text.ToString());

            ComboBoxItem escoger = (ComboBoxItem)(cbx_moneda.SelectedValue);
            string _moneda = escoger.Uid.ToString();

            string _arrenda = "";
            foreach (DataRow row in dt_arrend.Rows)
            {
                if (_arrenda.Length != 0) { _arrenda = _arrenda + "/"; }
                _arrenda = _arrenda + row["ruc"].ToString().Trim() + "-" + row["raz_soc"].ToString().Trim();
            }
            string _adminis = "";
            foreach (DataRow row in dt_admin.Rows)
            {
                if (_adminis.Length != 0) { _adminis = _adminis + "/"; }
                _adminis = _adminis + row["ruc"].ToString().Trim() + "-" + row["raz_soc"].ToString().Trim();
            }

            int _Reten = (Convert.ToBoolean(chk_reten.IsChecked)) ? 1 : 0;
            int _dbJulio = (Convert.ToBoolean(chk_julio.IsChecked)) ? 1 : 0;
            int _dbDiciembre = (Convert.ToBoolean(chk_diciembre.IsChecked)) ? 1 : 0;
            int _serv_public = (Convert.ToBoolean(chk_publico.IsChecked)) ? 1 : 0;
            int _arbitrios = (Convert.ToBoolean(chk_arbitrio.IsChecked)) ? 1 : 0;

            int _IPC_renta = (Convert.ToBoolean(chk_ipc_renta.IsChecked)) ? 1 : 0;
            int _IPC_promo = (Convert.ToBoolean(chk_ipc_promo.IsChecked)) ? 1 : 0;
            int _IPC_comun = (Convert.ToBoolean(chk_ipc_comun.IsChecked)) ? 1 : 0;

            int _IPC_frecu = 0;
            DateTime _fecha_IPC = new DateTime();

            if (_IPC_renta == 1 || _IPC_promo == 1 || _IPC_comun == 1)
            {
                if (Convert.ToBoolean(rdb_06mes.IsChecked)) { _IPC_frecu = 6; }
                if (Convert.ToBoolean(rdb_12mes.IsChecked)) { _IPC_frecu = 12; }
                _fecha_IPC = Convert.ToDateTime(date_ipc.Text.ToString());
            }

            int _pag_terce = (Convert.ToBoolean(chk_Pago_Tercero.IsChecked)) ? 1 : 0;
            int _obl_segur = (Convert.ToBoolean(chk_obl_seg.IsChecked)) ? 1 : 0;
            int _obl_carta = (Convert.ToBoolean(chk_obl_carta.IsChecked)) ? 1 : 0;

            string _ruta_plano = txt_ruta_plano.Text.ToString();
            string _ruta_contr = txt_ruta_cont.Text.ToString();

            try
            {
                //-- Enviar a Método de Actualización
                Contratos.Actualiza_Contrato(_codigo, _tipo, _cod_contrato, _fechaini, _fechafin, _area, _moneda,
                                             _arrenda, _adminis,
                                             _rent_fij, _rent_var, _adelanto, _garantia, _der_ingr, _rev_proy, _promocio, _promoc_v, _gast_com, _gs_com_p, _gs_com_v,
                                             _Reten, _dbJulio, _dbDiciembre, _serv_public, _arbitrios,
                                             _IPC_renta, _IPC_promo, _IPC_comun, _IPC_frecu, _fecha_IPC,
                                             _pag_terce, _obl_segur, _obl_carta,
                                             _ruta_plano, _ruta_contr);

                Contratos.Elimina_CronogramaPagos(_cod_contrato, "C");
                foreach (DataRow cron in dt_programa.Rows)
                { Contratos.Graba_CronogramaPagos(_cod_contrato, "C", cron["Nro"].ToString(), Convert.ToDecimal(cron["Fijo"]), Convert.ToDecimal(cron["Variable"]), Convert.ToDateTime(cron["Fec_Ini"]), Convert.ToDateTime(cron["Fec_Fin"]), cron["Fecha"].ToString()); }

                Contratos.Elimina_PagosTerceros(_cod_contrato, _tipo_contrato);
                foreach (DataRow pag in dt_pago_terc.Rows)
                { Contratos.Graba_PagosTerceros(_cod_contrato, _tipo_contrato, pag["id"].ToString(), pag["ruc"].ToString(), pag["raz_soc"].ToString(), Convert.ToDecimal(pag["porcentaje"]), pag["banco_id"].ToString(), pag["banco_desc"].ToString(), pag["banco_cta"].ToString()); }

                Contratos.Elimina_CartaFianza(_cod_contrato, _tipo_contrato);
                foreach (DataRow car in dt_carta_fianza.Rows)
                { Contratos.Graba_CartaFianza(_cod_contrato, _tipo_contrato, car["Id"].ToString(), Convert.ToDateTime(car["Fecha_Ini"].ToString()), Convert.ToDateTime(car["Fecha_Fin"].ToString()), car["Bco_Id"].ToString(), car["Bco_Des"].ToString(), car["Nro_Doc"].ToString(), car["Benef_RUC"].ToString(), car["Benef_desc"].ToString(), Convert.ToDecimal(car["Monto"].ToString())); }

                //this.DialogResult = false;
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Actualizar Datos de Contrato " + _codigo + ". " + ex.Message + ".",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        #endregion
        
    }
}
