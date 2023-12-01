using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataModel
{
    public class ThongKeSachModel
    {
        public int MaSach { get; set; }
        public int MaLoai { get; set; }
        public string TenLoai { get; set; }
        public string TenSach { get; set; }
        public int Gia { get; set; }
        public int SoLuong { get; set; }
        public string TacGia { get; set; }
        public string BookCover { get; set; }
    }
}
