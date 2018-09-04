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

        public DataTable datos = new DataTable();
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Seguros()
        {
            InitializeComponent();
        }
        public Seguros(DataTable dat)
        {
            datos = dat;
            InitializeComponent();
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
        {
            _ok = true;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
            _ok = false;
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = true;
        }
        #endregion

        #region Funciones de Programa
        #endregion
    }
}
