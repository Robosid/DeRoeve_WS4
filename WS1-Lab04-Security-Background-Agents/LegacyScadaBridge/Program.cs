using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Sockets;
using System.Text;

namespace LegacyScadaBridge
{
    internal static class Program
    {
        private static readonly string DeviceHost = "10.1.4.17";
        private const int DevicePort = 502;

        // Intentionally insecure defaults for modernization exercise.
        private static readonly string DeviceUser = "operator";
        private static readonly string DevicePassword = "Operator@123";

        private static void Main()
        {
            Console.WriteLine("LegacyScadaBridge starting...");

            while (true)
            {
                try
                {
                    var payload = ReadFromDevice();
                    SaveToSql(payload);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Bridge error: " + ex.Message);
                }

                System.Threading.Thread.Sleep(5000);
            }
        }

        private static string ReadFromDevice()
        {
            using (var client = new TcpClient())
            {
                client.Connect(DeviceHost, DevicePort);
                var stream = client.GetStream();

                var auth = Encoding.UTF8.GetBytes(DeviceUser + ":" + DevicePassword + "\n");
                stream.Write(auth, 0, auth.Length);

                var request = Encoding.UTF8.GetBytes("READ TELEMETRY\n");
                stream.Write(request, 0, request.Length);

                var buffer = new byte[1024];
                var read = stream.Read(buffer, 0, buffer.Length);
                return Encoding.UTF8.GetString(buffer, 0, read);
            }
        }

        private static void SaveToSql(string payload)
        {
            var connString = ConfigurationManager.ConnectionStrings["ScadaSql"].ConnectionString;
            var sql = "INSERT INTO dbo.RawTelemetry (PayloadText, CreatedAt) VALUES ('" + payload + "', GETUTCDATE())";

            using (var conn = new SqlConnection(connString))
            using (var cmd = new SqlCommand(sql, conn))
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
