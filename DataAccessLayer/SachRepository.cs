using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public class SachRepository:ISachRepository
    {
        private IDatabaseHelper _dbHelper;
        public SachRepository(IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }
        public SachModel GetDatabyID(string masach)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_sach_get_by_id",
                    "@MaSach",masach);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Create(SachModel model)
        {
            string msgError;
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_sach_create",
                    "@MaLoai", model.MaLoai,
                    "@TenSach", model.TenSach,
                    "@Gia", model.Gia,
                    "@SoLuong", model.SoLuong,
                    "@TacGia", model.TacGia);
                if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Update(SachModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_sach_update",
                "@MaSach", model.MaSach,
                "@MaLoai", model.MaLoai,
                "@TenSach", model.TenSach,
                "@Gia", model.Gia,
                "@SoLuong", model.SoLuong,
                "@TacGia", model.TacGia);
                if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Delete(SachModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_sach_delete",
                "@MaSach", model.MaSach);
                if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(Convert.ToString(result) + msgError);
                }
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<SachModel> Search(int pageIndex, int pageSize, out long total, string ten_sach, string tacgia)
        {
            string msgError = "";
            total = 0;

            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_sach_search",
                    "@page_index", pageIndex,
                    "@page_size", pageSize,
                    "@ten_khach", ten_sach,
                    "@tac_gia", tacgia);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                if (dt.Rows.Count > 0) total = (long)dt.Rows[0]["RecordCount"];
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
