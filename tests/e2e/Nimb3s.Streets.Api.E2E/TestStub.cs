using NUnit.Framework;
using PlaywrightSharp;
using System.Threading.Tasks;

namespace Nimb3s.Streets.Api.E2E
{
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public async Task ReplaceMe()
        {
            using var playwright = await Playwright.CreateAsync();
            await using var browser = await playwright.Chromium.LaunchAsync(headless: true);

            // Go to google.com
            var page = await browser.NewPageAsync();
            await page.GoToAsync("https://www.google.com/");

            // Click on how search works
            await page.ClickAsync("a[href='https://google.com/search/howsearchworks/?fg=1']");

            Assert.AreEqual(page.Url, "https://www.google.com/search/howsearchworks/?fg=1");

        }
    }
}
