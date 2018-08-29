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
    /// Lógica de interacción para Carta_Fianza.xaml
    /// </summary>
    public partial class Carta_Fianza : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public Boolean _ok = false;

        public static string _cod_ent;
        public static string _tipo_ent;
        public static string _desc_ent;
        public static DateTime _fec_ini;
        public static DateTime _fec_fin;

        public DataTable datos = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Carta_Fianza()
        {
            InitializeComponent();
        }

        public Carta_Fianza(DataTable dat_ini, DateTime fec_ini, DateTime fec_fin)
        {
            _fec_ini = fec_ini;
            _fec_fin = fec_fin;
            datos = dat_ini;
            InitializeComponent();
            
        }
        
        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            _ok = false;
            /******************************************/
            /*--------Listamos Bancos en Combo--------*/
            /******************************************/
            DataTable lista_banc = new DataTable();
            //int contar = 0;
            lista_banc = Contratos.ListaBancos();
            foreach (DataRow row in lista_banc.Rows)
            {
                ComboBoxItem item = new ComboBoxItem();
                item.Uid = row["id"].ToString();
                item.Content = row["razon_soc"].ToString();
                cbx_banco.Items.Add(item);
            }

            /* Combo Cartas */
            ComboBoxItem item1 = new ComboBoxItem();
            item1.Uid = "";
            item1.Content = "[NUEVA CARTA FIANZA]";
            item1.IsSelected = true;
            cbx_Carta.Items.Add(item1);
            foreach (DataRow row in datos.Rows)
            {
                ComboBoxItem item = new ComboBoxItem();
                item.Uid = row["Id"].ToString();
                item.Content = " de :" + row["Fecha_Ini"].ToString() + " hasta : "+ row["Fecha_Fin"].ToString();
                cbx_Carta.Items.Add(item);
            }

            // Limpiando campos
            Limpiar_Campos();

            /*datos = new DataTable();
            // Declara Tablas usadas en los grid
            datos.TableName = "Carta_Fianza";
            datos.Columns.Add("Fecha_Ini", typeof(string));
            datos.Columns.Add("Fecha_Fin", typeof(string));
            datos.Columns.Add("Nro_Doc", typeof(string));
            datos.Columns.Add("Benef_RUC", typeof(string));
            datos.Columns.Add("Benef_desc", typeof(string));
            datos.Columns.Add("Monto", typeof(string));*/
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
        {

            if (Convert.ToDateTime(date_ini.Text.ToString()) < _fec_ini || Convert.ToDateTime(date_fin.Text.ToString()) > _fec_fin)
            {
                MessageBox.Show("Las Fechas de la Carta exceden el rango de Fechas del documento; Inicio: "+ _fec_ini .ToShortDateString()+ " Fin: " + _fec_fin.ToShortDateString() + ".",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            else
            {
                ComboBoxItem escoger = (ComboBoxItem)(cbx_Carta.SelectedValue);
                string _valor = escoger.Uid.ToString();

                if (date_ini.Text.ToString() != "" && date_ini != null && date_fin.Text.ToString() != "" && date_fin != null)
                {
                    if (Convert.ToDateTime(date_ini.Text.ToString()) < Convert.ToDateTime(date_fin.Text.ToString()))
                    {
                        if (cbx_banco.SelectedIndex != -1)
                        {
                            ComboBoxItem escoge_bco = (ComboBoxItem)(cbx_banco.SelectedValue);
                            string banco_id = escoge_bco.Uid.ToString();
                            string banco_des = escoge_bco.Content.ToString();

                            if (txt_num_doc.Text.ToString() != "" && txt_num_doc != null)
                            {
                                if (txt_ruc_benef.Text.ToString() != "" && txt_ruc_benef != null && txt_benef.Text.ToString() != "" && txt_benef != null)
                                {
                                    if (txt_monto.Text.ToString() != "" && txt_monto != null && Convert.ToDecimal(txt_monto.Text.ToString()) > 0)
                                    {
                                        if (_valor != "")
                                        {
                                            // Actualizar
                                            foreach (DataRow row in datos.Rows)
                                            {
                                                if (_valor == row["Id"].ToString())
                                                {
                                                    row["Fecha_Ini"] = Convert.ToDateTime(date_ini.Text.ToString()).ToShortDateString();
                                                    row["Fecha_Fin"] = Convert.ToDateTime(date_fin.Text.ToString()).ToShortDateString();
                                                    row["Bco_Id"] = banco_id;
                                                    row["Bco_Des"] = banco_des;
                                                    row["Nro_Doc"] = txt_num_doc.Text.ToString();
                                                    row["Benef_RUC"] = txt_ruc_benef.Text.ToString();
                                                    row["Benef_desc"] = txt_benef.Text.ToString();
                                                    row["Monto"] = txt_monto.Text.ToString();
                                                    MessageBox.Show("Carta Fianza " + row["Id"].ToString() + " Actualizada.",
                                                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);
                                                    _ok = true;
                                                    this.Close();
                                                }
                                            }
                                        }
                                        else
                                        {
                                            // Agregar
                                            datos.Rows.Add((datos.Rows.Count + 1).ToString().PadLeft(3, '0'),
                                                        Convert.ToDateTime(date_ini.Text.ToString()).ToShortDateString(),
                                                        Convert.ToDateTime(date_fin.Text.ToString()).ToShortDateString(),
                                                        banco_id,
                                                        banco_des,
                                                        txt_num_doc.Text.ToString(),
                                                        txt_ruc_benef.Text.ToString(),
                                                        txt_benef.Text.ToString(),
                                                        txt_monto.Text.ToString());
                                            MessageBox.Show("Carta Fianza " + datos.Rows.Count.ToString().PadLeft(3, '0') + " Agregada.",
                                            "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);
                                            _ok = true;
                                            this.Close();
                                        }
                                    }
                                    else
                                    {
                                        MessageBox.Show("Los campos de Valor no puede ser vacío ni 0.",
                                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                                    }
                                }
                                else
                                {
                                    MessageBox.Show("Los campos de Beneficiario no puede ser vacío.",
                                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                                }
                            }
                            else
                            {
                                MessageBox.Show("El campo Nro de Documento no puede ser vacío.",
                                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                            }
                        }
                        else
                        {
                            MessageBox.Show("Debe Seleccionar Entidad Bancaria.",
                            "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                        }
                    }
                    else
                    {
                        MessageBox.Show("La Fecha de Inicio no puede ser mayor a la Fecha de Fin.",
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
                else
                {
                    MessageBox.Show("Los campos de Vigencia, no pueden ser vacíos.",
                    "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void cbx_Carta_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBoxItem escoger = (ComboBoxItem)(cbx_Carta.SelectedValue);
            string _valor = escoger.Uid.ToString();

            if (_valor != "")
            {
                Llenar_Datos_carta();
            }
            else
            {
                Limpiar_Campos();
            }
        }
        #endregion

        #region Funciones de Programa
        private void Llenar_Datos_carta()
        {
            ComboBoxItem escoger = (ComboBoxItem)(cbx_Carta.SelectedValue);
            string _valor = escoger.Uid.ToString();

            foreach(DataRow row in datos.Rows)
            {
                if(_valor == row["Id"].ToString())
                {
                    date_ini.Text = row["Fecha_Ini"].ToString();
                    date_fin.Text = row["Fecha_Fin"].ToString();

                    foreach (ComboBoxItem item in cbx_banco.Items)
                    {
                        if (item.Uid.ToString() == row["Bco_Id"].ToString())
                        { item.IsSelected = true; }
                    }

                    txt_num_doc.Text = row["Nro_Doc"].ToString();
                    txt_ruc_benef.Text = row["Benef_RUC"].ToString();
                    txt_benef.Text = row["Benef_desc"].ToString();
                    txt_monto.Text = row["Monto"].ToString();

                    date_ini.IsEnabled = false;
                    date_fin.IsEnabled = false;
                }
            }
        }

        private void Limpiar_Campos()
        {
            cbx_banco.SelectedIndex = -1;

            date_ini.Text = "";
            date_fin.Text = "";

            txt_num_doc.Text = "";
            txt_ruc_benef.Text = "";
            txt_benef.Text = "";
            txt_monto.Text = "0";

            date_ini.IsEnabled = true;
            date_fin.IsEnabled = true;
        }
        #endregion

    }
}
