using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NUnit.Engine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;

namespace Nimb3s.Streets.Api.HostedServices
{
    public class E2EHostedService : IHostedService, IDisposable
    {
        private int executionCount = 0;
        private readonly ILogger<E2EHostedService> _logger;
        private Timer _timer;

        public E2EHostedService(ILogger<E2EHostedService> logger)
        {
            _logger = logger;
        }

        public Task StartAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Timed Hosted Service running.");

            DoWork();

            return Task.CompletedTask;
        }

        private async Task DoWork()
        {
            var count = Interlocked.Increment(ref executionCount);

            _logger.LogInformation(
                "Timed Hosted Service is working. Count: {Count}", count);

            // Get an interface to the engine
            ITestEngine engine = TestEngineActivator.CreateInstance();

            // Create a simple test package - one assembly, no special settings
            TestPackage package = new TestPackage(@"C:\git\streets\tests\e2e\Nimb3s.Streets.Api.E2E\bin\Release\net5.0\Nimb3s.Streets.Api.E2E.dll");

            // Get a runner for the test package
            ITestRunner runner = engine.GetRunner(package);

            // Run all the tests in the assembly

            var attr3 = Attribute
                .GetCustomAttributes(
                     Assembly.GetEntryAssembly(),
                     typeof(AssemblyInformationalVersionAttribute))
                as AssemblyInformationalVersionAttribute[];


            var xml = runner.Run(listener: null, TestFilter.Empty);
        }

        public Task StopAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Timed Hosted Service is stopping.");

            _timer?.Change(Timeout.Infinite, 0);

            return Task.CompletedTask;
        }

        public void Dispose()
        {
            _timer?.Dispose();
        }
    }
}