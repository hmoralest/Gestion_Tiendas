using System;
using System.Collections.Generic;
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
        public static string _cod_ent;
        public static string _tipo_ent;
        public static string _desc_ent;
        public static DateTime _fec_ini;
        public static DateTime _fec_fin;
        #endregion

        #region Funciones de Interfaz e Iniciacion
        public Carta_Fianza()
        {
            InitializeComponent();
        }

        public Carta_Fianza(string cod_ent, string tipo_ent, string desc_ent, DateTime fec_ini, DateTime fec_fin)
        {
            _cod_ent = cod_ent;
            _tipo_ent = tipo_ent;
            _desc_ent = desc_ent;
            _fec_ini = fec_ini;
            _fec_fin = fec_fin;
            InitializeComponent();

            label_02.Content = _tipo_ent + " - " + _cod_ent + " - " + _desc_ent;
            date_fec_ini.Text = _fec_ini.ToShortDateString();
            date_fec_fin.Text = _fec_fin.ToShortDateString();
        }

        private void btn_grabar_Click(object sender, RoutedEventArgs e)
        {

        }
        #endregion

        #region Funciones de Programa
        #endregion
    }
}
