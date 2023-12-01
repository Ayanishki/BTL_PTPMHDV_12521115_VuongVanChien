using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public partial interface ISachRepository
    {
        SachModel GetDatabyID(string id);
        bool Create(SachModel model);
        bool Update(SachModel model);
        bool Delete(string model);
        public List<SachModel> DanhSachHangTheoGiaTang();
        public List<SachModel> DanhSachHangTheoGiaGiam();
        public List<SachModel> LayDanhSachSachTheoTheLoai(string maloai);
        public List<SachModel> TopSachBanChayToanThoiGian( string top);
        public List<SachModel> TopSachBanChay(string top);
        public List<ThongKeSachModel> Search(int pageIndex, int pageSize, out long total, string ten_sach, string tac_gia);
    }
}
