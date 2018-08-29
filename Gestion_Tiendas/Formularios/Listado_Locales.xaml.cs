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
using Gestion_Tiendas.Funciones;
using WPF.Themes;

namespace Gestion_Tiendas.Formularios
{
    /// <summary>
    /// Lógica de interacción para Listado_Locales.xaml
    /// </summary>
    public partial class Listado_Locales : Window
    {

        #region Var Locales
        private DataTable dt_grid = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Listado_Locales()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            dt_grid = Locales.Listar_Locales();
            dtg_locales.ItemsSource = dt_grid.DefaultView;
            Application.Current.ApplyTheme("BureauBlue");

            SolidColorBrush color1 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 191, 229, 255));
            SolidColorBrush color2 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 224, 241, 253));
            
            this.dtg_locales.RowBackground  = color1;
            this.dtg_locales.AlternatingRowBackground = color2;
        }

        private void txt_nombre_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                Buscar_Locales();
            }
        }

        private void txt_codigo_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                Buscar_Locales();
            }
        }

        private void txt_distrit_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                Buscar_Locales();
            }
        }

        private void txt_arrend_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                Buscar_Locales();
            }
        }

        private void btn_buscar_Click(object sender, RoutedEventArgs e)
        {
            Buscar_Locales();
        }

        private void btn_detale_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Listado_Documentos._activo_form)
            {
                Listado_Documentos frm2 = new Listado_Documentos(codigo, tipo);
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Listado_Documentos._activo_form = true;
                frm2.Closed += Listado_Documentos_Closed;
            }
        }

        private void btn_editar_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Modif_Ver_Local._activo_form)
            {
                Modif_Ver_Local frm2 = new Modif_Ver_Local(codigo, tipo);
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Modif_Ver_Local._activo_form = true;
                frm2.Closed += Modif_Ver_Local_Closed;
            }
        }

        private void btn_nue_cont_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Nuevo_Doc._activo_form)
            {
                Nuevo_Doc frm2 = new Nuevo_Doc(codigo, tipo, "C");
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Nuevo_Doc._activo_form = true;
                frm2.Closed += Nuevo_Doc_Closed;
            }
        }

        private void btn_nue_adenda_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Nuevo_Doc._activo_form)
            {
                Nuevo_Doc frm2 = new Nuevo_Doc(codigo, tipo, "A");
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Nuevo_Doc._activo_form = true;
                frm2.Closed += Nuevo_Doc_Closed;
            }
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

        private void Listado_Documentos_Closed(object sender, EventArgs e)
        {
            Listado_Documentos ventana = sender as Listado_Documentos;

            // (refrescar)
            this.IsEnabled = true;
            //QuitarEfecto(this);
        }

        private void Modif_Ver_Local_Closed(object sender, EventArgs e)
        {
            Modif_Ver_Local ventana = sender as Modif_Ver_Local;

            // (refrescar)
            this.IsEnabled = true;
            //QuitarEfecto(this);
        }

        private void Nuevo_Doc_Closed(object sender, EventArgs e)
        {
            Nuevo_Doc ventana = sender as Nuevo_Doc;

            // (refrescar)
            this.IsEnabled = true;
            //QuitarEfecto(this);
        }

        private void Buscar_Locales()
        {
            ComboBoxItem escoger_tipo = (ComboBoxItem)(cbx_tipo.SelectedValue);
            ComboBoxItem escoger_estado = (ComboBoxItem)(cbx_estado.SelectedValue);

            string _id = txt_codigo.Text.ToString().Trim();
            string _des = txt_nombre.Text.ToString().Trim();
            string _tipo = (escoger_tipo != null) ? escoger_tipo.Uid.ToString().Trim() : "";//escoger_tipo.Uid.ToString().Trim();
            string _super = ""; // txt_codigo.Text.ToString().Trim();
            string _arren = txt_arrend.Text.ToString().Trim();
            string _ubic = txt_distrit.Text.ToString().Trim();
            string _direc = ""; // txt_codigo.Text.ToString().Trim();
            string _estado = (escoger_estado != null) ? escoger_estado.Uid.ToString().Trim() : "";

            dt_grid = Locales.Buscar_Locales(_id, _des, _tipo, _super, _arren, _ubic, _direc, _estado);
            dtg_locales.ItemsSource = dt_grid.DefaultView;
        }

        #endregion

    }
}
