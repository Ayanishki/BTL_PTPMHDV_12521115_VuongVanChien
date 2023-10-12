using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel;
using DataAccessLayer;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;

namespace BusinessLogicLayer
{
    public class UserBusiness:IUserBusiness
    {
        private IUserBusiness _res;
        private string secret;
        public UserBusiness(IUserBusiness res, IConfiguration configuration)
        {
            _res = res;
            secret = configuration["AppSetting:Secret"];
        }
        public UserModel Login(string username, string password)
        {
            var user = _res.Login(username, password);
            if (user == null)
            {
                return null;
            }
            var tokenHadler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.Username.ToString()),
                    new Claim(ClaimTypes.Email, user.Email)

                }),
                Expires = DateTime.UtcNow.AddDays(7),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.Aes128CbcHmacSha256),
            };
            var token = tokenHadler.CreateToken(tokenDescriptor);
            user.token = tokenHadler.WriteToken(token);
            return user;
        }
    }
}
