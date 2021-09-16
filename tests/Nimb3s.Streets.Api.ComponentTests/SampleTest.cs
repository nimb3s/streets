using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Nimb3s.Streets.Api.ComponentTests
{
    public class SampleTest : ComponentBase
    {
        [Test]
        public async Task YouShouldReplaceThisSampleTest()
        {
            var httpClient = new HttpClient
            {
                BaseAddress = new Uri(config.ServiceUri)
            };

            var response = await httpClient.GetAsync("WeatherForecast");

            Assert.AreEqual(1, 1);
        }
    }
}
