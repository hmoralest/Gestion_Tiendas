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
    /// Lógica de interacción para Seguros.xaml
    /// </summary>
    public partial class Seguros : Window
    {
        #region Var Locales
        public static Boolean _activo_form = false;
        public Boolean _ok = false;

        public static string _cod_ent;
        public static string _tipo_ent;
        public static string _desc_ent;
        public static DateTime _fec_ini;
        public static DateTime _fec_fin;

        public static string _ult_seg;

        public static string sel_tipo = "";
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Seguros()
        {
            InitializeComponent();
        }
        public Seguros(string ent_cod, string ent_tip, string ent_des)
        {
            _cod_ent = ent_cod;
            _tipo_ent = ent_tip;
            _desc_ent = ent_des;
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            _activo_form = true;

            lbl_Titulo.Content = _tipo_ent + " - " + _cod_ent + " - " + _desc_ent;

            /******************************************/
            /*-------Listamos Tipos de Seguros -------*/
            /******************************************/
            DataTable lista_tseg = new DataTable();
            int contar = 0;
            lista_tseg = Locales.Lista_TipoSeguros();
            foreach (DataRow row in lista_tseg.Rows)
            {
                ComboBoxItem item = new ComboBoxItem();
                item.Uid = row["Id"].ToString();
                item.Content = row["descripcion"].ToString();
                contar = contar + 1;
                if (contar == 1)
                {
                    item.IsSelected = true;
                    sel_tipo = row["Id"].ToString();
                }
                cbx_tipo.Items.Add(item);
            }

            Listar_Vigencias();

            Limpiar_Campos();

            _ok = false;
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
        {
            _ok = true;

            Grabar_Seguros();
            this.Close();
        }

        private void cbx_tipo_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBoxItem escoger = (ComboBoxItem)(cbx_tipo.SelectedValue);
            sel_tipo = escoger.Uid.ToString();
            cbx_vigen.Items.Clear();

            Listar_Vigencias();
        }

        private void btn_ruta_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new OpenFileDialog();
            dialog.Multiselect = false;
            dialog.Title = "Seleccione el Seguro a Anexar...";
            if (dialog.ShowDialog(this) == true)
            {
                txt_ruta.Text = dialog.FileName;
            }
        }

        private void cbx_vigen_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBoxItem escoger = (ComboBoxItem)(cbx_vigen.SelectedValue);
            if(escoger != null) { 
                string dato = escoger.Uid.ToString();

                if (dato != "")
                {
                    try
                    {
                        DataTable datos = new DataTable();
                        datos = Locales.Obten_Seguro(_cod_ent, _tipo_ent, sel_tipo, dato);

                        date_ini.Text = datos.Rows[0]["Fec_Ini"].ToString();
                        date_ini.IsEnabled = false;
                        date_fin.Text = datos.Rows[0]["Fec_Fin"].ToString();
                        date_fin.IsEnabled = false;
                        txt_ruc_aseg.Text = datos.Rows[0]["Aseg_RUC"].ToString();
                        txt_raz_aseg.Text = datos.Rows[0]["Aseg_Raz"].ToString();
                        txt_cod.Text = datos.Rows[0]["Nro_Doc"].ToString();
                        txt_ruc_benef.Text = datos.Rows[0]["Benef_RUC"].ToString();
                        txt_raz_benef.Text = datos.Rows[0]["Benef_Raz"].ToString();
                        txt_cant.Text = datos.Rows[0]["Cantidad"].ToString();
                        foreach (ComboBoxItem item in cbx_unid.Items)
                        {
                            if (item.Uid.ToString() == datos.Rows[0]["Unidad"].ToString())
                            { item.IsSelected = true; }
                        }
                        txt_val_seg.Text = datos.Rows[0]["Valor"].ToString();
                        txt_ruta.Text = datos.Rows[0]["Ruta"].ToString();
                    }
                    catch(Exception ex)
                    {
                        MessageBox.Show("Error en Obtener información de Seguros. "+ ex.Message,
                        "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
                else
                {
                    Limpiar_Campos();
                }
            }
        }

        private void txt_ruc_aseg_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumero(e);
        }

        private void txt_raz_aseg_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_cod_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_ruc_benef_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumero(e);
        }

        private void txt_raz_benef_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloNumerosLetras(e);
        }

        private void txt_cant_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloDecimal(e);
        }

        private void txt_val_seg_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            SoloDecimal(e);
        }
        #endregion

        #region Funciones de Programa
        private void Grabar_Seguros()
        {
            ComboBoxItem escoger1 = (ComboBoxItem)(cbx_tipo.SelectedValue);
            string tipo = escoger1.Uid.ToString();

            ComboBoxItem escoger2 = (ComboBoxItem)(cbx_vigen.SelectedValue);
            string vigen = escoger2.Uid.ToString();

            DateTime fec_ini = Convert.ToDateTime(date_ini.Text.ToString());
            DateTime fec_fin = Convert.ToDateTime(date_fin.Text.ToString());
            string aseg_ruc = txt_ruc_aseg.Text.ToString();
            string aseg_raz = txt_raz_aseg.Text.ToString();
            string nro_doc = txt_cod.Text.ToString();
            string benef_ruc = txt_ruc_benef.Text.ToString();
            string benef_raz = txt_raz_benef.Text.ToString();
            Decimal cant = Convert.ToDecimal(txt_cant.Text.ToString());
            ComboBoxItem escoger3 = (ComboBoxItem)(cbx_unid.SelectedValue);
            string unid = escoger3.Uid.ToString();
            Decimal valor = Convert.ToDecimal(txt_val_seg.Text.ToString());
            string ruta = txt_ruta.Text.ToString();

            try
            {
                Locales.Grabar_Modificar_Seguros(_cod_ent, _tipo_ent,
                                                    tipo, vigen, fec_ini, fec_fin,
                                                    aseg_ruc, aseg_raz, nro_doc, benef_ruc, benef_raz,
                                                    cant, unid, valor, ruta);

                string cod_seg = vigen;
                if (cod_seg == "")
                {
                    cod_seg = (Convert.ToInt32(_ult_seg) + 1).ToString().PadLeft(5, '0');
                }

                string patha = Environment.CurrentDirectory;
                string nombre = "Archivos";
                if (!Directory.Exists(patha + "\\" + nombre))
                {   //Crea el directorio
                    DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre);
                }
                string carpeta = _tipo_ent + "_" + _cod_ent;
                if (!Directory.Exists(patha + "\\" + nombre + "\\" + carpeta))
                {   //Crea el directorio
                    DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre + "\\" + carpeta);
                }
                string carpeta2 = "SEGUROS";
                if (!Directory.Exists(patha + "\\" + nombre + "\\" + carpeta + "\\" + carpeta2))
                {   //Crea el directorio
                    DirectoryInfo di = Directory.CreateDirectory(patha + "\\" + nombre + "\\" + carpeta + "\\" + carpeta2);
                }

                // Copia Archivo
                if (txt_ruta.Text.ToString() != "" && txt_ruta.Text != null)
                {
                    string file = "SG_" + tipo.PadLeft(2, '0') + "_" + cod_seg + System.IO.Path.GetExtension(txt_ruta.Text.ToString());
                    // Elimina si existe
                    //if (File.Exists(System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file)))
                    //{ File.Delete(System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file)); }
                    // Ingresa nuevo archivo
                    File.Copy(txt_ruta.Text, System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file), true);
                    // Actualiza datos en BD
                    Locales.Actualiza_RutaSeg(cod_seg, tipo, System.IO.Path.Combine(patha, nombre, carpeta, carpeta2, file).ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error en Guardar Información de Seguros. " + ex.Message,
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Listar_Vigencias()
        {
            cbx_vigen.Items.Clear();

            /******************************************/
            /*-------    Listamos Vigencias    -------*/
            /******************************************/
            /* Combo Cartas */
            ComboBoxItem item1 = new ComboBoxItem();
            item1.Uid = "";
            item1.Content = "[NUEVO REGISTRO]";
            item1.IsSelected = true;
            cbx_vigen.Items.Add(item1);
            DataTable lista_vigen = new DataTable();
            try
            {
                lista_vigen = Locales.Lista_Seguros(_cod_ent, _tipo_ent, sel_tipo);
                foreach (DataRow row in lista_vigen.Rows)
                {
                    ComboBoxItem item = new ComboBoxItem();
                    item.Uid = row["Id"].ToString();
                    item.Content = " de :" + row["Fec_Ini"].ToString() + " hasta : " + row["Fec_Fin"].ToString();
                    cbx_vigen.Items.Add(item);
                    _ult_seg = row["Id"].ToString();
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error en Obtener Información de Seguros. " + ex.Message,
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }

        }

        private void Limpiar_Campos()
        {
            date_ini.Text = "";
            date_ini.IsEnabled = true;
            date_fin.Text = "";
            date_fin.IsEnabled = true;
            txt_ruc_aseg.Text = "";
            txt_raz_aseg.Text = "";
            txt_cod.Text = "";
            txt_ruc_benef.Text = "";
            txt_raz_benef.Text = "";
            txt_cant.Text = "0";
            txt_val_seg.Text = "0";
            txt_ruta.Text = "";

            date_ini.Focus();
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
