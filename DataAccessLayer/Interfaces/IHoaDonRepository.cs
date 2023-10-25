using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel;

namespace DataAccessLayer
{
    public partial interface IHoaDonRepository
    {
        HoaDonModel GetDatabyID(int id);
        bool Create(HoaDonModel model);
        bool Update(HoaDonModel model);
        bool Delete(HoaDonModel model);
        public List<ThongKeKhachModel> Search(int pageIndex, int pageSize, out long total, string ten_khach, DateTime? fr_NgayTao, DateTime? to_NgayTao);
    }
}
