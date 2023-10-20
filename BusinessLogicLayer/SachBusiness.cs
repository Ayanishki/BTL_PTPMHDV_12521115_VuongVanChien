using DataAccessLayer;
using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer
{
    public class SachBusiness:ISachBusiness 
    {
        private ISachRepository _res;
        public SachBusiness(ISachRepository res)
        {
            _res = res;
        }
        public SachModel GetDatabyID(string id)
        {
            return _res.GetDatabyID(id);
        }
        public bool Create(SachModel model)
        {
            return _res.Create(model);
        } 
        public bool Update(SachModel model)
        {
            return _res.Update(model);
        }
        public  List<SachModel> Search(int pageIndex, int pageSize, out long total,string ten_sach,string tacgia) 
        { 
            return _res.Search(pageIndex,pageSize, out total, ten_sach, tacgia);
        }
    }
}
