
using BusinessLogicLayer;
using DataModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Ocelot.Responses;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Text;

namespace BanMayTinh_Gateway
{
    public class JwtMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly AppSettings _appSettings;
        private IUserBusiness _userbusniness;
        public JwtMiddleware(RequestDelegate next, IOptions<AppSettings> appSettings, IConfiguration configuration)
        {
            _next = next;
            _appSettings = appSettings.Value;
            
        }

        public Task Invoke(HttpContext context)
        {
            context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
            context.Response.Headers.Add("Access-Control-Expose-Headers", "*");
            if (!context.Request.Path.Equals("/api/token", StringComparison.Ordinal))
            {
                return _next(context);
            }
            if (context.Request.Method.Equals("POST") && context.Request.HasFormContentType)
            {
                return GenerateToken(context);
            }
            context.Response.StatusCode = 400;
            return context.Response.WriteAsync("Bad request.");
        }

        public async Task GenerateToken(HttpContext context)
        {
            var Taikhoan = context.Request.Form["Taikhoan"].ToString();
            var Matkhau = context.Request.Form["Matkhau"].ToString();
            var user = _userbusniness.Login(Taikhoan, Matkhau);           
            var response = new { MaNguoiDung = user.AccountID, Email = user.Email, Token = user.token };
            var serializerSettings = new JsonSerializerSettings
            {
                Formatting = Formatting.Indented
            };
            context.Response.ContentType = "application/json";
            await context.Response.WriteAsync(JsonConvert.SerializeObject(response, serializerSettings));
            return;
        }
    }
}
