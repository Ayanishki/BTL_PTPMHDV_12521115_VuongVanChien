using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer
{
    public partial interface ILoaiSachBusiness
    {
        LoaiSachModel GetDatabyID(int id);
        bool Create(LoaiSachModel model);
        bool Update(LoaiSachModel model);
        bool Delete(LoaiSachModel model);
        public List<LoaiSachModel> Search(int pageIndex, int pageSize, out long total, string ten_loai);
    }
}
