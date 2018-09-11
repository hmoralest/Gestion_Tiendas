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
    /// Lógica de interacción para Datos_Arrendador.xaml
    /// </summary>
    public partial class Datos_Arrendador : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public DataTable datos = null;
        #endregion
        
        #region Funciones de Interfaz e Iniciacion
        public Datos_Arrendador()
        {
            InitializeComponent();
        }

        private void btn_guardar_Click(object sender, RoutedEventArgs e)
        {
            if (txt_ruc.Text.Length > 0 && txt_razsoc.Text.Length > 0 /*&& txt_porc.Text.Length > 0*/)
            {
                DataTable dt = new DataTable();
                dt.TableName = "Arrendatario";
                dt.Columns.Add("ruc", typeof(string));
                dt.Columns.Add("raz_soc", typeof(string));
                //dt.Columns.Add("porc", typeof(decimal));

                string razon = "";
                razon = Contratos.Valida_Proveedor(txt_ruc.Text.ToString());
                if (razon.Length > 0)
                {
                    dt.Rows.Add(txt_ruc.Text.ToString(), razon/*, Convert.ToDecimal(txt_porc.Text.ToString())*/);
                    datos = dt;
                    //this.DialogResult = false;
                    this.Close();
                }
                else
                {
                    txt_razsoc.Text = "";
                    MessageBox.Show("No se encontró proveedor. Es necesario registrar el RUC en Intranet como Proveedor.",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }

            }
            else
            {
                txt_razsoc.Text = "";
                MessageBox.Show("Es Obligatorio ingresar esta informacion",
               "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            //MessageBox.Show("Ingrese nuevamente DNI.",
            //"Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            _activo_form = false;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            txt_ruc.Text = "";
            txt_razsoc.Text = "";
            txt_ruc.Focus();
            //txt_porc.Text = "";
        }

        private void txt_ruc_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key >= Key.D0 && e.Key <= Key.D9 || e.Key >= Key.NumPad0 && e.Key <= Key.NumPad9)
                e.Handled = false;
            else
            {
                e.Handled = true;
            }

            if (e.Key == Key.Enter)
            {
                string razon = "";
                razon =Contratos.Valida_Proveedor(txt_ruc.Text.ToString());
                if (razon.Length > 0)
                {
                    txt_razsoc.Text = razon;
                }
                else
                {
                    MessageBox.Show("No se encontró proveedor. Es necesario registrar el RUC en Intranet como Proveedor.",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            else
            {
                txt_razsoc.Text = "";
            }
        }

        private void txt_ruc_LostFocus(object sender, RoutedEventArgs e)
        {
            txt_razsoc.Text = "";
            string razon = "";
            razon = Contratos.Valida_Proveedor(txt_ruc.Text.ToString());
            if (razon.Length > 0)
            {
                txt_razsoc.Text = razon;
            }
            else
            {
                MessageBox.Show("No se encontró proveedor. Es necesario registrar el RUC en Intranet como Proveedor.",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txt_ruc_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {

            SoloNumero(e);
        }
        #endregion

        #region Funciones de Programa
        /// <summary>
        /// método que evalúa las teclas presionadas y permite que sólo los números y letras sean escritas
        /// </summary>
        /// <param name="e">texto tecla presionada</param>
        public void SoloNumerosLetras(TextCompositionEventArgs e)
        {
            if (e.Text != "")
            {
                //se convierte a Ascci del la tecla presionada
                int ascci = Convert.ToInt32(Convert.ToChar(e.Text));
                //verificamos que se encuentre en ese rango que son entre el 0 y el 9
                if ((ascci >= 48 && ascci <= 57) || (ascci >= 65 && ascci <= 90) || (ascci >= 97 && ascci <= 122))
                    e.Handled = false;
                else
                    e.Handled = true;
            }
        }

        /// <summary>
        /// método que evalúa las teclas presionadas y permite que sólo los números sean escritas
        /// </summary>
        /// <param name="e">texto tecla presionada</param>
        public void SoloNumero(TextCompositionEventArgs e)
        {
            if (e.Text != "")
            {
                //se convierte a Ascci del la tecla presionada
                int ascci = Convert.ToInt32(Convert.ToChar(e.Text));
                //verificamos que se encuentre en ese rango que son entre el 0 y el 9
                if (ascci >= 48 && ascci <= 57)
                    e.Handled = false;
                else
                    e.Handled = true;
            }
        }

        /// <summary>
        /// método que evalúa las teclas presionadas y permite que sólo los números y separadores decimales (.) sean escritas
        /// </summary>
        /// <param name="e">texto tecla presionada</param>
        public void SoloDecimal(TextCompositionEventArgs e)
        {
            if (e.Text != "")
            {
                //se convierte a Ascci del la tecla presionada
                int ascci = Convert.ToInt32(Convert.ToChar(e.Text));
                //verificamos que se encuentre en ese rango que son entre el 0 y el 9
                if ((ascci >= 48 && ascci <= 57) || ascci == 46)
                    e.Handled = false;
                else
                    e.Handled = true;
            }

        }
        #endregion
    }
}
