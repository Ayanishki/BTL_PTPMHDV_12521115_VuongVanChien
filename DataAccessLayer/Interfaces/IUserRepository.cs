using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{ 
    public interface IUserRepository
    {
        UserModel Login(string username, string password);
    }
}
