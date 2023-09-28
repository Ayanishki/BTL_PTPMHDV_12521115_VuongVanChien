using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Interfaces
{
    public partial interface IKhachRepository
    {
        KhachHangModel GetDatabyID(string id);
        bool Create(KhachHangModel model);
        bool Update(KhachHangModel model);
        public List<KhachHangModel> Search(int pageIndex, int pageSize, out long total, string ten_khach, string dia_chi);
    }
}
