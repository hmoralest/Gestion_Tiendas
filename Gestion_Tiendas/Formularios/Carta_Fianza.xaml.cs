using Gestion_Tiendas.Funciones;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
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
        public static string _tip_ent;
        /*public static string _desc_ent;
        public static DateTime _fec_ini;
        public static DateTime _fec_fin;*/
        public static string _ult_carta;

        public DataTable datos = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Carta_Fianza()
        {
            InitializeComponent();
        }

        /*public Carta_Fianza(DataTable dat_ini, DateTime fec_ini, DateTime fec_fin)
        {
            _fec_ini = fec_ini;
            _fec_fin = fec_fin;
            datos = dat_ini;
            InitializeComponent();
            
        }*/

        public Carta_Fianza(string cod_ent, string tip_ent)
        {
            _cod_ent = cod_ent;
            _tip_ent = tip_ent;
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
            datos = Locales.Lista_CartaFianza(_cod_ent, _tip_ent); ;
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
                _ult_carta = row["Id"].ToString();
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

        private void txt_num_doc_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_ruc_benef_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumero(e);
        }

        private void txt_benef_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_monto_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloDecimal(e);
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
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
                                    try
                                    {
                                        Locales.Grabar_Modificar_CartaFianza(   _cod_ent, _tip_ent, _valor,
                                                                                Convert.ToDateTime(date_ini.Text.ToString()),
                                                                                Convert.ToDateTime(date_fin.Text.ToString()),
                                                                                banco_id, banco_des,
                                                                                txt_num_doc.Text.ToString(), txt_ruc_benef.Text.ToString(), txt_benef.Text.ToString(),
                                                                                Convert.ToDecimal(txt_monto.Text.ToString()),
                                                                                txt_ruta.Text.ToString());

                                        string cod_carta = _valor;
                                        if(cod_carta == "")
                                        {
                                            cod_carta = (Convert.ToInt32(_ult_carta) + 1).ToString().PadLeft(4, '0');
                                        }

                                        string patha = Environment.CurrentDirectory;
                                        string nombre = "Archivos";
                                        if (!Directory.Exists(patha + "\\" + nombre))
                                        {   //Crea el directorio
                                            DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre);
                                        }
                                        string carpeta = _tip_ent + "_" + _cod_ent;
                                        if (!Directory.Exists(patha + "\\" + nombre + "\\" + carpeta))
                                        {   //Crea el directorio
                                            DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre + "\\" + carpeta);
                                        }
                                        string carpeta2 = "CART_FIANZA";
                                        if (!Directory.Exists(patha + "\\" + nombre + "\\" + carpeta + "\\" + carpeta2))
                                        {   //Crea el directorio
                                            DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre + "\\" + carpeta + "\\" + carpeta2);
                                        }

                                        // Copia Archivo
                                        if (txt_ruta.Text.ToString() != "" && txt_ruta.Text != null)
                                        {
                                            string file = "CF_" + cod_carta + System.IO.Path.GetExtension(txt_ruta.Text.ToString());
                                            // Elimina si existe
                                            if (File.Exists(System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file)))
                                            { File.Delete(System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file)); }
                                            // Ingresa nuevo archivo
                                            File.Copy(txt_ruta.Text, System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file));
                                            // Actualiza datos en BD
                                            Locales.Actualiza_RutaCarta(cod_carta, System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file).ToString());
                                        }

                                        MessageBox.Show("Carta Fianza Creada Satisfactoriamente Agregada.",
                                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Information);
                                        _ok = true;
                                        this.Close();
                                    }
                                    catch(Exception ex)
                                    {
                                        MessageBox.Show("Error al grabar información de Carta Fianza. " + ex.Message,
                                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                                    }
                                    /*if (_valor != "")
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
                                    }*/
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

        private void btn_ruta_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new OpenFileDialog();
            dialog.Multiselect = false;
            dialog.Title = "Seleccione la Carta Fianza a Anexar...";
            if (dialog.ShowDialog(this) == true)
            {
                txt_ruta.Text = dialog.FileName;
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

        private void txt_ruc_benef_LostFocus(object sender, RoutedEventArgs e)
        {
            string razon = "";
            razon = Contratos.Valida_Proveedor(txt_benef.Text.ToString());
            if (razon.Length > 0)
            {
                txt_benef.Text = razon;
            }
            else
            {
                MessageBox.Show("No se encontró Proveedor. Es necesario registrar el RUC en Intranet como Proveedor.",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                txt_benef.Text = "";
            }
        }

        private void txt_num_doc_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_ruc_benef.Focus(); txt_ruc_benef.SelectAll(); }
        }

        private void txt_ruc_benef_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) { txt_monto.Focus(); txt_monto.SelectAll(); }
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

                    txt_ruta.Text = row["Ruta"].ToString();

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

            txt_ruta.Text = "";

            date_ini.IsEnabled = true;
            date_fin.IsEnabled = true;
        }

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
