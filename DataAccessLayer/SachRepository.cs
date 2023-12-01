using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
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
                    "@TacGia", model.TacGia,
                    "@Bookcover", model.BookCover);
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
                    "@TacGia", model.TacGia,
                    "@Bookcover", model.BookCover);
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
        public bool Delete(string model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_sach_delete",
                "@MaSach", model);
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
        public List<SachModel> DanhSachHangTheoGiaTang()
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "LayDanhSachSachTheoGiaTang");
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<SachModel> DanhSachHangTheoGiaGiam()
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "LayDanhSachSachTheoGiaGiam");
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public List<SachModel> LayDanhSachSachTheoTheLoai(string maloai)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "LayDanhSachSachTheoTheLoai",
                    "@MaLoai",maloai);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<SachModel> TopSachBanChayToanThoiGian(string top)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "TopSachBanChayToanThoiGian",
                    "@Top",top);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public List<SachModel> TopSachBanChay(string top)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "TopSachBanChay",
                    "@Top", top);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<SachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public List<ThongKeSachModel> Search(int pageIndex, int pageSize, out long total, string ten_sach, string tacgia)
        {
            string msgError = "";
            total = 0;

            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_sach_search",
                    "@page_index", pageIndex,
                    "@page_size", pageSize,
                    "@ten_sach", ten_sach,
                    "@tac_gia", tacgia);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                if (dt.Rows.Count > 0) total = (long)dt.Rows[0]["RecordCount"];
                return dt.ConvertTo<ThongKeSachModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
