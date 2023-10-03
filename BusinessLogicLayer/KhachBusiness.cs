using DataAccessLayer;
using DataAccessLayer.Interfaces;
using DataModel;
using System.Reflection;
namespace BusinessLogicLayer
{
    public class KhachBusiness:IKhachRepository
    {
        private IKhachRepository _res;
        public KhachBusiness(IKhachRepository res)
        {
            _res = res;
        }
        public KhachHangModel GetDatabyID(int id)
        {
            return _res.GetDatabyID(id);
        }
        public bool Create(KhachHangModel model)
        {
            return _res.Create(model);
        }
        public bool Update(KhachHangModel model)
        {
            return _res.Update(model);
        }
        public List<KhachHangModel> Search(int pageIndex, int pageSize, out long total, string ten_khach, string)
        {
            return _res.Search(pageIndex, pageSize, out total, ten_khach, fr_NgayTao, toNgayTao);
        }
    }
}