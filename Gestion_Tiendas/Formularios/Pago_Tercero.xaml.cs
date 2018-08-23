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
        public static string _cod_contrato = "";
        public static string _tipo_contrato = "";
        public DataTable datos = new DataTable();
        public static DataTable datos_ini = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Pago_Tercero()
        {
            InitializeComponent();
        }
        public Pago_Tercero(DataTable datos, string cod_cont, string tip_cont)
        {
            _cod_contrato = cod_cont;
            _tipo_contrato = tip_cont;
            datos_ini = datos;
            InitializeComponent();
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
                    ComboBoxItem escoger = (ComboBoxItem)(cbx_banco.SelectedValue);
                    string banco_id = escoger.Uid.ToString();
                    if (banco_id == "")
                    {
                        MessageBox.Show("El campo Razón Social debe estar lleno.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                    else
                    {
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

                                datos.Rows.Add( datos.Rows.Count.ToString().PadLeft(2,'0'),
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
            MessageBox.Show("Esta Información se grabará al guardar el Documento.",
            "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            this.Close();
        }

        private void btn_limpiar_Click(object sender, RoutedEventArgs e)
        {
            datos = datos_ini;
            dg_pagos.ItemsSource = datos.AsDataView();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
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

            datos = new DataTable();
            // Declara Tablas usadas en los grid
            datos.TableName = "Pago_Terceros";
            datos.Columns.Add("Id", typeof(string));
            datos.Columns.Add("RUC", typeof(string));
            datos.Columns.Add("raz_soc", typeof(string));
            datos.Columns.Add("porcentaje", typeof(string));
            datos.Columns.Add("banco_id", typeof(string));
            datos.Columns.Add("banco_desc", typeof(string));
            datos.Columns.Add("banco_cta", typeof(string));

            //datos = Contratos.Lista_PagoTerceros(_cod_contrato, _tipo_contrato);
            datos = datos_ini;
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
            _cod_contrato = "";
            _tipo_contrato = "";
        }
        #endregion

        #region Funciones de Programa
        #endregion
    }
}
