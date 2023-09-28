using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class ThongKeKhachModel
    {
        public int MaSach { get; set; }
        public string TenSach { get; set; }
        public int SoLuong { get; set; }
        //public Decimal TongGia { get; set; }
        public DateTime NgayLapHD { get; set; }
        public string TenKH { get; set; }
        public string Diachi { get; set; }
    }
}
