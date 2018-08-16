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
            DataTable dat_docs = new DataTable();

            _cod_ent = cod_entid;
            _tipo_ent = tipo_ent;

            dat_docs=Contratos.ListaDocumentos(_cod_ent, _tipo_ent);

            dg_documentos.ItemsSource = dat_docs.AsDataView();

            InitializeComponent();
        }
        #endregion

        #region Funciones de Programa
        #endregion
    }
}
