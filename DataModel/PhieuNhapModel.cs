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
        public int MaNV { get; set; }
        public DateTime NgaylapPN { get; set; }
        public string Email { get; set; }
        public string SdtNCC { get; set; }
        public string Diachi {  get; set; }
        public int MaNCC { get; set; }
        public bool TrangThai { get; set; }
        public List<ChitietphieunhapModel>list_json_chitietphieunhap {  get; set; }
    }
    public class ChitietphieunhapModel
    {
        public int MaChiTietPhieuNhap { get; set; }
        public int MaPhieuNhap { get; set; }
        public int MaSach { get; set; }
        public int Slnhap { get; set; }
        public int Gianhap { get; set; }
        public int status { get; set; }
    }
}
