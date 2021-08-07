using Microsoft.Extensions.Configuration;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nimb3s.Streets.Api.ComponentTests
{
    public class ComponentBase
    {
        protected ComponentTestConfig config { get; set; } = new ComponentTestConfig();
        
        [OneTimeSetUp]
        public void OneTimeSetup()
        {
            config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", false, true)
                .AddEnvironmentVariables()
                .Build()
                .GetSection("ComponentTests")
                .Get<ComponentTestConfig>();
        }
    }
}
