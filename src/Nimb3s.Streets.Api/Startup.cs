using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json.Converters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Nimb3s.Streets.Api.HostedServices;

namespace Nimb3s.Streets.Api
{
    public partial class Startup
    {

        public Startup(IConfiguration configuration, IWebHostEnvironment environment)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            
            services.AddControllers();
            services.AddHttpContextAccessor();
            services.AddControllersWithViews().AddNewtonsoftJson(i =>
            {
                i.SerializerSettings.Converters.Add(new StringEnumConverter());

                i.SerializerSettings.TypeNameHandling = TypeNameHandling.All;
                i.SerializerSettings.Formatting = Formatting.Indented;
                i.SerializerSettings.NullValueHandling = NullValueHandling.Ignore;
                i.SerializerSettings.ContractResolver = new DefaultContractResolver { NamingStrategy = new CamelCaseNamingStrategy() };
            });

            services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));

            ConfigureSwaggerServices(services);

            //services.AddHostedService<E2EHostedService>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Nimb3s.Streets.Api v1"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
