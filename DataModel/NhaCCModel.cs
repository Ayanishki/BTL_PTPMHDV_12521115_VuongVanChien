using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class NhaCCModel
    {
        public int MaNCC {  get; set; }
        public string TenNCC { get; set; } 
        public string Diachi { get; set; }
        public string SdtNCC { get; set; }
        public string Email { get; set; }
    }
}
