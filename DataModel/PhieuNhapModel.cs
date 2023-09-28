using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class PhieuNhapModel
    {
        public int MaPhieuNhap { get; set; }
        public string MaNV { get; set; }
        public DateTime NgaylapPN { get; set; }
        public int MaNCC { get; set; }
        public float TrietKhauNhap { get; set; }
    }
}
