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
    /// Lógica de interacción para Listado_Documentos.xaml
    /// </summary>
    public partial class Listado_Documentos : Window
    {

        #region Var Locales
        public static bool _activo_form = false;
        public static string _cod_ent = "";
        public static string _tipo_ent = "";
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Listado_Documentos()
        {
            InitializeComponent();
        }
        public Listado_Documentos(string cod_entid, string tipo_ent)
        {
            _cod_ent = cod_entid;
            _tipo_ent = tipo_ent;

            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            DataTable dat_docs = new DataTable();
            try
            {
                dat_docs = Contratos.ListaDocumentos(_cod_ent, _tipo_ent);
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error Obtener Información de Documentos del Local " + _tipo_ent + " - " + _cod_ent + ". " + ex.Message + ".",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            dg_documentos.ItemsSource = dat_docs.AsDataView();
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
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

        private void Nuevo_Doc_Closed(object sender, EventArgs e)
        {
            Nuevo_Doc ventana = sender as Nuevo_Doc;

            // (refrescar)
            QuitarEfecto(this);
        }

        #endregion

        private void btn_adenda_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Nuevo_Doc._activo_form)
            {
                Nuevo_Doc frm2 = new Nuevo_Doc(codigo, tipo, "A");
                frm2.Owner = this;
                AplicarEfecto(this);
                frm2.Show();
                Nuevo_Doc._activo_form = true;
                frm2.Closed += Nuevo_Doc_Closed;
            }
        }

        private void btn_contrato_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Nuevo_Doc._activo_form)
            {
                Nuevo_Doc frm2 = new Nuevo_Doc(codigo, tipo, "C");
                frm2.Owner = this;
                AplicarEfecto(this);
                frm2.Show();
                Nuevo_Doc._activo_form = true;
                frm2.Closed += Nuevo_Doc_Closed;
            }
        }

        private void btn_ver_doc_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_ver_fin_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btn_editar_Click_1(object sender, RoutedEventArgs e)
        {

        }
    }
}
