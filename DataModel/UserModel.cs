﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class UserModel
    {
        public int AccountID { get; set; }
        public string Displayname { get; set; }
        public string Usernames { get; set; }
        public string Passwords { get; set; }
        public string Email { get; set; }
        public string Sdt { get; set; }
        public int Roles { get; set; }
        public string token { get; set; }
    }
}
