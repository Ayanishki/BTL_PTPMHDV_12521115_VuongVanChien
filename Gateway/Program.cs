using Ocelot.Middleware;
using Ocelot.DependencyInjection;
using BusinessLogicLayer;
using DataAccessLayer;
using DataModel;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using BanMayTinh_Gateway;


namespace API.Gateway
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            builder.Configuration.SetBasePath(builder.Environment.ContentRootPath)
                                 .AddJsonFile("json.json", optional: false, reloadOnChange: true);
            builder.Services.AddControllers();
            builder.Services.AddOcelot();

            IConfiguration configuration = builder.Configuration;
            var appSettingsSection = configuration.GetSection("AppSettings");
            builder.Services.Configure<AppSettings>(appSettingsSection);

            var appSettings = appSettingsSection.Get<AppSettings>();
            var key = Encoding.ASCII.GetBytes(appSettings.Secret);

            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                            .AddJwtBearer(options =>
                            {
                                options.TokenValidationParameters = new TokenValidationParameters
                                {
                                    ValidateLifetime = true,
                                    ValidateIssuer = false,
                                    ValidateAudience = false,
                                    IssuerSigningKey = new SymmetricSecurityKey(key)
                                };

                            });
            builder.Services.AddTransient<IDatabaseHelper, DatabaseHelper>();
            builder.Services.AddTransient<IUserRepository, UserRepository>();
            builder.Services.AddTransient<IUserBusiness, UserBusiness>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();

            app.MapControllers();

            app.UseMiddleware<JwtMiddleware>();

            app.UseOcelot().Wait();

            app.Run();
        }
    }
}