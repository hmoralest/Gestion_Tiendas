﻿using Gestion_Tiendas.Funciones;
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
            SolidColorBrush color1 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 167, 167));
            SolidColorBrush color2 = new SolidColorBrush(System.Windows.Media.Color.FromArgb(100, 255, 224, 224));

            this.dg_documentos.RowBackground = color1;
            this.dg_documentos.AlternatingRowBackground = color2;
            Refresh_Docs();
        }

        private void Window_Unloaded(object sender, RoutedEventArgs e)
        {
            _activo_form = false;
        }

        private void btn_adenda_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = _cod_ent;
            //string codigo = (String)row["id"].ToString();
            string tipo = _tipo_ent;
            //string tipo = (String)row["tipo"].ToString();

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

        private void btn_contrato_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = _cod_ent;
            //string codigo = (String)row["id"].ToString();
            string tipo = _tipo_ent;
            //string tipo = (String)row["tipo"].ToString();

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

        private void btn_ver_doc_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Modif_Ver_Doc._activo_form)
            {
                Modif_Ver_Doc frm2 = new Modif_Ver_Doc(codigo, tipo, _cod_ent, _tipo_ent, "V");
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Modif_Ver_Doc._activo_form = true;
                frm2.Closed += Modif_Ver_Doc_Closed;
            }
        }

        private void btn_ver_fin_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Modif_Ver_Doc._activo_form)
            {
                Modif_Ver_Doc frm2 = new Modif_Ver_Doc(codigo, tipo, _cod_ent, _tipo_ent, "VA");
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Modif_Ver_Doc._activo_form = true;
                frm2.Closed += Modif_Ver_Doc_Closed;
            }
        }

        private void btn_editar_Click(object sender, RoutedEventArgs e)
        {
            // Se debe capturar el código
            DataRowView row = (DataRowView)((Button)e.Source).DataContext;

            string codigo = (String)row["id"].ToString();
            string tipo = (String)row["tipo"].ToString();

            if (!Modif_Ver_Doc._activo_form)
            {
                Modif_Ver_Doc frm2 = new Modif_Ver_Doc(codigo, tipo, _cod_ent, _tipo_ent, "A");
                frm2.Owner = this;
                //AplicarEfecto(this);
                this.IsEnabled = false;
                frm2.Show();
                Modif_Ver_Doc._activo_form = true;
                frm2.Closed += Modif_Ver_Doc_Closed;
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

        private void Nuevo_Doc_Closed(object sender, EventArgs e)
        {
            Nuevo_Doc ventana = sender as Nuevo_Doc;
            Refresh_Docs();

            // (refrescar)
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Modif_Ver_Doc_Closed(object sender, EventArgs e)
        {
            Modif_Ver_Doc ventana = sender as Modif_Ver_Doc;
            Refresh_Docs();
            // (refrescar)
            //QuitarEfecto(this);
            this.IsEnabled = true;
        }

        private void Refresh_Docs()
        {
            DataTable dat_docs = new DataTable();
            try
            {
                dat_docs = Contratos.ListaDocumentos(_cod_ent, _tipo_ent);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Obtener Información de Documentos del Local " + _tipo_ent + " - " + _cod_ent + ". " + ex.Message + ".",
                "Bata - Mensaje De Advertencia", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            dg_documentos.ItemsSource = dat_docs.AsDataView();
        }

        #endregion

    }
}
