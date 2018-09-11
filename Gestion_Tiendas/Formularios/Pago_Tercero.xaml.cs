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
    /// Lógica de interacción para Pago_Tercero.xaml
    /// </summary>
    public partial class Pago_Tercero : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public Boolean _ok = false;

        public static string _cod_entidad = "";
        public static string _tip_entidad = "";
        public DataTable datos = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Pago_Tercero()
        {
            InitializeComponent();
        }

        /*public Pago_Tercero(DataTable datos, string cod_cont, string tip_cont)
        {
            _cod_contrato = cod_cont;
            _tipo_contrato = tip_cont;
            _accion = "A";
            datos_ini = datos;
            InitializeComponent();
        }

        public Pago_Tercero(string accion, DataTable datos, string cod_cont, string tip_cont)
        {
            _cod_contrato = cod_cont;
            _tipo_contrato = tip_cont;
            _accion = accion;
            datos_ini = datos;
            InitializeComponent();
        }*/

        public Pago_Tercero(string cod_ent, string tip_ent)
        {
            _cod_entidad = cod_ent;
            _tip_entidad = tip_ent;
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SolidColorBrush color1 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 167, 167));
            SolidColorBrush color2 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 224, 224));

            this.dg_pagos.RowBackground = color1;
            this.dg_pagos.AlternatingRowBackground = color2;

            _ok = false;
            /******************************************/
            /*-------Listamos Bancos en Combo-------*/
            /******************************************/
            DataTable lista_banc = new DataTable();
            //int contar = 0;
            lista_banc = Contratos.ListaBancos();
            foreach (DataRow row in lista_banc.Rows)
            {
                ComboBoxItem item = new ComboBoxItem();
                item.Uid = row["id"].ToString();
                item.Content = row["razon_soc"].ToString();
                /*contar = contar + 1;
                if (contar == 1)
                {
                    item.IsSelected = true;
                }*/
                cbx_banco.Items.Add(item);
            }

            // Limpiando campos
            txt_RUC.Text = "";
            txt_razsoc.Text = "";
            txt_ctabco.Text = "";
            txt_porc.Text = "";

            /*datos = new DataTable();
            // Declara Tablas usadas en los grid
            datos.TableName = "Pago_Terceros";
            datos.Columns.Add("Id", typeof(string));
            datos.Columns.Add("RUC", typeof(string));
            datos.Columns.Add("raz_soc", typeof(string));
            datos.Columns.Add("porcentaje", typeof(string));
            datos.Columns.Add("banco_id", typeof(string));
            datos.Columns.Add("banco_desc", typeof(string));
            datos.Columns.Add("banco_cta", typeof(string));
            
            if (_accion == "A") { btn_guardar.Visibility = Visibility.Visible; }
            else                { btn_guardar.Visibility = Visibility.Hidden; }*/

            //datos = Contratos.Lista_PagoTerceros(_cod_contrato, _tipo_contrato);
            //datos = datos_ini;
            datos = Locales.Lista_PagoTerceros(_cod_entidad, _tip_entidad);
            dg_pagos.ItemsSource = datos.AsDataView();

            
        }

        private void btn_agregar_Click(object sender, RoutedEventArgs e)
        {
            if(txt_RUC.Text.ToString() == "")
            {
                MessageBox.Show("El campo RUC debe estar lleno.",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            else
            {
                if(txt_razsoc.Text.ToString() == "")
                {
                    MessageBox.Show("El campo Razón Social debe estar lleno.",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
                else
                {
                    if (cbx_banco.SelectedIndex == -1)
                    {
                        MessageBox.Show("Debe Seleccionar el Banco del Tercero.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                    else
                    {
                        ComboBoxItem escoger = (ComboBoxItem)(cbx_banco.SelectedValue);
                        string banco_id = escoger.Uid.ToString();

                        if (txt_ctabco.Text.ToString() == "")
                        {
                            MessageBox.Show("El campo Cuenta Bancaria debe estar lleno.",
                            "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                        }
                        else
                        {
                            if (txt_porc.Text.ToString() == "")
                            {
                                MessageBox.Show("El campo Porcentaje debe estar lleno.",
                                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                            }
                            else
                            {
                                string banco_desc = escoger.Content.ToString();

                                datos.Rows.Add( (datos.Rows.Count+1).ToString().PadLeft(2,'0'),
                                                    txt_RUC.Text.ToString(), txt_razsoc.Text.ToString(),
                                                    txt_porc.Text.ToString(),
                                                    banco_id, banco_desc, txt_ctabco.Text.ToString());

                                dg_pagos.ItemsSource = datos.AsDataView();
                            }
                        }
                    }
                }
            }
        }

        private void btn_guardar_Click(object sender, RoutedEventArgs e)
        {
            _ok = true;

            DataView dv = datos.DefaultView;
            decimal suma = dv.Table.AsEnumerable().Sum(y => y.Field<Decimal>("porcentaje"));
            if (suma != 100 && datos.Rows.Count>0)
            {
                MessageBox.Show("La Suma de Porcentajes debe ser 100, favor verificar.",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            else
            {
                try
                {
                    Locales.Elimina_PagosTerceros(_cod_entidad, _tip_entidad);
                    foreach (DataRow pag in datos.Rows)
                    { Locales.Graba_PagosTerceros(_cod_entidad, _tip_entidad, pag["id"].ToString(), pag["ruc"].ToString(), pag["raz_soc"].ToString(), Convert.ToDecimal(pag["porcentaje"]), pag["banco_id"].ToString(), pag["banco_desc"].ToString(), pag["banco_cta"].ToString()); }

                    MessageBox.Show("La información se guardo Correctamente.",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error en grabar la información. " + ex.Message,
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
                //MessageBox.Show("Esta Información se grabará al guardar el Documento.",
                //"Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);

                this.Close();
            }
        }

        private void btn_limpiar_Click(object sender, RoutedEventArgs e)
        {
            //datos = datos_ini;
            datos.Clear();
            dg_pagos.ItemsSource = datos.AsDataView();
        }

        private void btn_resta_Click(object sender, RoutedEventArgs e)
        {
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;
            
            datos.Rows.Remove(row.Row);
            dg_pagos.ItemsSource = datos.DefaultView;
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
            _cod_entidad = "";
            _tip_entidad = "";
        }

        private void txt_RUC_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumero(e);
        }

        private void txt_razsoc_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_porc_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloDecimal(e);
        }

        private void txt_ctabco_PreviewTextInput(object sender, TextCompositionEventArgs e)
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
