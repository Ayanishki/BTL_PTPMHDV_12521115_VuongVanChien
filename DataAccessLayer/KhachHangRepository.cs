using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataModel; 

namespace DataAccessLayer
{
    public class KhachHangRepository
    {
        private IDatabaseHelper _dbHelper;
        public KhachHangRepository(IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }
        public KhachHangRepository GetDatabyID(string id)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_khach_get_by_id",
                    "@id", id);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
            }
            catch (Exception ex) 
            {
                throw ex;
            }
        }
        public bool Create(KhachHangModel model)
        {
            string msgError;
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp)_khach_create",
                    "@TenKH", model.TenKH,
                    "@SdtKH", model.SdtKH,
                    "@Diachi", model.Diachi,
                    "@");
            }
        }
    }
}
