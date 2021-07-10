using System;
using System.Threading.Tasks;

namespace Nimb3s.Streets.Samples.Client
{
    class Program
    {
        const string BaseUrl = "https://localhost:18089";

        static async Task Main()
        {
            Console.WriteLine("Hello World!");

            await RequestTokenUsingClientCredentialsAsync();
        }

        private static async Task RequestTokenUsingClientCredentialsAsync()
        {
            throw new NotImplementedException();
        }
    }
}
