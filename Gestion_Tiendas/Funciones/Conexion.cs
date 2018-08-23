using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql; //Npgsql .NET Data Provider for PostgreSQL
using System.Data.SqlClient;

namespace Gestion_Tiendas.Funciones
{
    class Conexion
    {
        public static NpgsqlConnection getConexionPGS()
        {
            NpgsqlConnection pgs = new NpgsqlConnection("Host=10.10.10.104;Username=web;Password=web;Database=scomercial");
            return pgs;
        }
        public static SqlConnection getConexionSQL()
        {
            SqlConnection sql = new SqlConnection("Data Source=10.10.10.208;Initial Catalog=BdFinanzas;Integrated Security=False;User ID=cquinto;Password=cquinto123;Connect Timeout=60;Encrypt=False;TrustServerCertificate=True;ApplicationIntent=ReadWrite;MultiSubnetFailover=False");
            return sql;
        }
    }
}
