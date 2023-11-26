using BusinessLogicLayer.Interfaces;
using DataAccessLayer;
using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer
{
    public class PhieuNhapBusiness : IPhieuNhapBusiness
    {
        private IPhieuNhapRepository _res;
        public PhieuNhapBusiness(IPhieuNhapRepository res)
        {
            _res = res;
        }
        public PhieuNhapModel GetDatabyID(int id)
        {
            return _res.GetDatabyID(id);
        }
        public bool Create(PhieuNhapModel model)
        {
            return _res.Create(model);
        }
        public bool Update(PhieuNhapModel model)
        {
            return _res.Update(model);
        }
        public bool Delete(PhieuNhapModel model)
        {
            return _res.Delete(model);
        }
        public List<ThongKeNCCModel> Search(int pageIndex, int pageSize, out long total, string ten_ncc, DateTime? fr_NgayTao, DateTime? toNgayTao)
        {
            return _res.Search(pageIndex, pageSize, out total, ten_ncc, fr_NgayTao, toNgayTao);
        }

    }
    
}
