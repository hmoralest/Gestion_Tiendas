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
    /// Lógica de interacción para Prog_Pagos.xaml
    /// </summary>
    public partial class Prog_Pagos : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public  Boolean _ok = false;
        public DataTable datos_ini = null;
        public DataTable datos = null;

        public string _cod_cont = "";
        public string _tipo_cont = "";

        public DateTime fecha_f = new DateTime();
        public DateTime fecha_i = new DateTime();
        public string fija = null;
        public string var = null;

        public string _accion = "";
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Prog_Pagos()
        {
            InitializeComponent();
        }
        public Prog_Pagos(string accion, string cod_cont, string tipo_cont, DataTable dt, DateTime fec_ini_cont, DateTime fec_fin_cont, string renta_fija, string renta_variable)
        {
            datos_ini = dt;
            fecha_f = fec_fin_cont;
            fecha_i = fec_ini_cont;
            fija = renta_fija;
            var = renta_variable;
            _accion = accion;

            _cod_cont = cod_cont;
            _tipo_cont = tipo_cont;
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SolidColorBrush color1 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 167, 167));
            SolidColorBrush color2 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 224, 224));

            this.dg_datos.RowBackground = color1;
            this.dg_datos.AlternatingRowBackground = color2;
            
            _ok = false;

            datos = new DataTable();
            // Declara Tablas usadas en los grid
            datos.TableName = "Programa_Renta";
            datos.Columns.Add("Cod_Cont", typeof(string));
            datos.Columns.Add("Tipo_Cont", typeof(string));
            datos.Columns.Add("Nro", typeof(string));
            datos.Columns.Add("Fijo", typeof(string));
            datos.Columns.Add("Variable", typeof(string));
            datos.Columns.Add("Fec_Ini", typeof(string));
            datos.Columns.Add("Fec_Fin", typeof(string));
            datos.Columns.Add("Fecha", typeof(string));

            if (_accion == "A")  { btn_grabar.Visibility = Visibility.Visible; }
            else                { btn_grabar.Visibility = Visibility.Hidden; }

            genera_Registros();
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            datos_ini = null;
            datos = null;
            _activo_form = false;
        }

        private void btn_limpiar_Click(object sender, RoutedEventArgs e)
        {
            genera_Registros();
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
        {
            _ok = true;
            MessageBox.Show("Esta Información se grabará al guardar el Documento.",
            "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);
            this.Close();
        }
        #endregion

        #region Funciones de Programa
    
        private void genera_Registros()
        {
            datos.Clear();
            // Se crean registros
            if (datos_ini == null || datos_ini.Rows.Count==0)
            {
                Int32 contador = 1;
                // De Mayor a Menor
                /*DateTime evalua_f = fecha_f;
                DateTime evalua_i = evalua_f.AddMonths(-1).AddDays(1);
                while (evalua_f >= fecha_i)
                {
                    string rango = "";
                    if(evalua_i < fecha_i) { evalua_i = fecha_i; }
                    rango = "de: " + evalua_i.ToShortDateString() + " hasta: " + evalua_f.ToShortDateString();
                    datos.Rows.Add(contador.ToString().PadLeft(2,'0'), fija, var, rango, evalua_i.ToShortDateString(), evalua_f.ToShortDateString());

                    evalua_f = evalua_i.AddDays(-1);
                    evalua_i = evalua_f.AddMonths(-1).AddDays(1);
                    contador = contador + 1;
                }*/

                // De Menor a Mayor
                DateTime evalua_i = fecha_i;
                DateTime evalua_f = fecha_i.AddMonths(1).AddDays(-1);
                // Ini Cerrando meses
                if(evalua_i.Day!=1)
                {
                    DateTime fecha_completa = Convert.ToDateTime("01/" + evalua_i.Month.ToString().PadLeft(2, '0') + "/" + evalua_i.Year.ToString());
                    evalua_f = fecha_completa.AddMonths(1).AddDays(-1);
                    string rango_completa = "";
                    rango_completa = "de: " + evalua_i.ToShortDateString() + " hasta: " + evalua_f.ToShortDateString();

                    decimal monto_fija_comp = Decimal.Round((30 - evalua_i.Day + 1) * Convert.ToDecimal(fija) / 30, 2);

                    datos.Rows.Add(_cod_cont, _tipo_cont, contador.ToString().PadLeft(2, '0'), monto_fija_comp.ToString(), var, evalua_i.ToShortDateString(), evalua_f.ToShortDateString(), rango_completa);

                    evalua_i = fecha_completa.AddMonths(1);
                    evalua_f = evalua_i.AddMonths(1).AddDays(-1);
                    contador = contador + 1;
                }
                // Fin Cerrando meses
                while(evalua_i <= fecha_f)
                {
                    string rango = "";
                    decimal monto_fija = Decimal.Round(Convert.ToDecimal(fija), 2);
                    if (evalua_f > fecha_f) {
                        evalua_f = fecha_f;
                        monto_fija = Decimal.Round(fecha_f.Day * Convert.ToDecimal(fija) / 30, 2); }
                    rango = "de: " + evalua_i.ToShortDateString() + " hasta: " + evalua_f.ToShortDateString();
                    

                    datos.Rows.Add(_cod_cont, _tipo_cont, contador.ToString().PadLeft(2, '0'), monto_fija, var, evalua_i.ToShortDateString(), evalua_f.ToShortDateString(), rango);

                    evalua_i = evalua_i.AddMonths(1);
                    evalua_f = evalua_i.AddMonths(1).AddDays(-1);
                    contador = contador + 1;
                }
            }
            else
            {
                //datos = datos_ini;
                datos = datos_ini.Copy();
            }
            datos.AcceptChanges();
            dg_datos.ItemsSource = datos.AsDataView();
        }

        #endregion
    }
}
