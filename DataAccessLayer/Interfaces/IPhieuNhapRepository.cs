using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public partial interface IPhieuNhapRepository
    {
        PhieuNhapModel GetDatabyID(int id);
        bool Create(PhieuNhapModel model);
        bool Update(PhieuNhapModel model);
        bool Delete(PhieuNhapModel model);
        public List<ThongKeNCCModel> Search(int pageIndex, int pageSize, out long total,string ten_ncc, DateTime? fr_NgayTao, DateTime? to_NgayTao);
    }
}
