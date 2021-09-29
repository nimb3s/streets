using Microsoft.Playwright;
using NUnit.Framework;
using System.Threading.Tasks;

namespace Nimb3s.Streets.Api.E2ETests
{
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public async Task Test1()
        {
            using var playwright = await Playwright.CreateAsync();
            var chromium = playwright.Chromium;
            // Can be "msedge", "chrome-beta", "msedge-beta", "msedge-dev", etc.
            var browser = await chromium.LaunchAsync(new BrowserTypeLaunchOptions { Channel = "chrome" });
            var page = await browser.NewPageAsync();
            await page.GotoAsync("https://playwright.dev/dotnet");
            await page.ScreenshotAsync(new PageScreenshotOptions { Path = "screenshot.png" });
            Assert.Pass();
        }
    }
}