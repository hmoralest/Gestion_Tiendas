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
using System.Windows.Navigation;
using System.Windows.Shapes;
using WPF.Themes;

namespace Gestion_Tiendas.Formularios
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            Application.Current.ApplyTheme("ExpressionLight");

            btn1.Visibility = Visibility.Hidden;
            btn2.Visibility = Visibility.Hidden;
            btn3.Visibility = Visibility.Hidden;
            //btn4.Visibility = Visibility.Hidden;
            btn5.Visibility = Visibility.Hidden;
            btn6.Visibility = Visibility.Hidden;

            lbl1.Visibility = Visibility.Hidden;
            lbl2.Visibility = Visibility.Hidden;
            lbl3.Visibility = Visibility.Hidden;
            //lbl4.Visibility = Visibility.Hidden;
            lbl5.Visibility = Visibility.Hidden;
            lbl6.Visibility = Visibility.Hidden;
        }

        private void btn4_Click(object sender, RoutedEventArgs e)
        {
            if (!Listado_Locales._activo_form)
            {
                Listado_Locales frm2 = new Listado_Locales();
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.Visibility = Visibility.Hidden;
                frm2.Show();
                Listado_Locales._activo_form = true;
                frm2.Closed += Listado_Locales_Closed;
            }
        }

        private void Listado_Locales_Closed(object sender, EventArgs e)
        {
            Listado_Locales ventana = sender as Listado_Locales;

            // (refrescar)
            this.Visibility = Visibility.Visible;
            //QuitarEfecto(this);

        }
    }
}
