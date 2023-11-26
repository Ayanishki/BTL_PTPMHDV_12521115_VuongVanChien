
using DataAccessLayer;
using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer
{
    public class LoaiSachBusiness:ILoaiSachBusiness
    {
        private ILoaiSachRepository _res;
        public LoaiSachBusiness(ILoaiSachRepository res)
        {
            _res = res;
        }
        public LoaiSachModel GetDatabyID(int id)
        {
            return _res.GetDatabyID(id);
        }
        public bool Create(LoaiSachModel model)
        {
            return _res.Create(model);
        }
        public bool Update(LoaiSachModel model)
        {
            return _res.Update(model);
        }
        public bool Delete(LoaiSachModel model)
        {
            return _res.Delete(model);
        }
        public List<LoaiSachModel> Search(int pageIndex, int pageSize, out long total, string ten_loai)
        {
            return _res.Search(pageIndex, pageSize, out total, ten_loai);
        }
    }
}
