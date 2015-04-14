using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Customers
{
    public partial class Customers : System.Web.UI.Page
    {
        // The name of the connection string.
        private static readonly string _connectionStringName = "ConnectionStringName";
        // The name of the database to connect to.
        private static readonly string _databaseName = "[dbo].[customers]";
        // The table columns to read. 
        private static readonly string[] _columns = { "[id]", "[first_name]", "[last_name]", "[email]" };

        protected void Page_Load(object sender, EventArgs e)
        {
            // Connect to the database.
            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings[_connectionStringName].ToString()))
            {
                // Read from the database.
                var cmd = new SqlCommand(string.Format("SELECT {0} FROM {1}", string.Join(",", _columns), _databaseName), cn);
                cn.Open();
                // Add an HTML table row for each database record.
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        var row = new TableRow();
                        for (int column = 0; column < _columns.Length; ++column)
                        {
                            var cell = new TableCell();
                            cell.Text = rdr[column].ToString();
                            row.Cells.Add(cell);
                        }
                        Table1.Rows.Add(row);
                    }
                }
            }
        }
    }
}