using DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public class PhieuNhapRepository : IPhieuNhapRepository
    {
        private IDatabaseHelper _dbHelper;
        public PhieuNhapRepository (IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }
        public PhieuNhapModel GetDatabyID(int id)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_phieunhap_get_by_id", "@MaPhieuNhap", id);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                return dt.ConvertTo<PhieuNhapModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Create(PhieuNhapModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_phieunhap_create",
                    "@MaNV", model.MaNV,
                    "@MaNCC",model.MaNCC,
                    "@Diachi", model.Diachi,
                    "@SdtNCC", model.SdtNCC,
                    "@Email", model.Email,
                    "@NgayLapPN", model.NgaylapPN,
                    "@TrangThai", model.TrangThai,
                    "@list_json_chitietphieunhap", model.list_json_chitietphieunhap != null ? MessageConvert.SerializeObject(model.list_json_chitietphieunhap) : null);
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
        public bool Update(PhieuNhapModel model)
        {
            string msgError = "";
            try
            {
                // CẦN XEM LẠI 
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_phieu_nhap_update",
                    "@MaPhieuNhap", model.MaPhieuNhap,
                    "@MaNV", model.MaNV,
                    "@MaNCC", model.MaNCC,
                    "@Diachi", model.Diachi,
                    "@SdtNCC", model.SdtNCC,
                    "@Email", model.Email,
                    "@NgayLapPN", model.NgaylapPN,
                    "@TrangThai", model.TrangThai,
                    "@list_json_chitietphieunhap", model.list_json_chitietphieunhap != null ? MessageConvert.SerializeObject(model.list_json_chitietphieunhap) : null);
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
        public bool Delete(PhieuNhapModel model)
        {
            string msgError = "";
            try
            {
                // CẦN XEM LẠI 
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_phieu_nhap_delete",
                    "@id", model.MaPhieuNhap);
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
        public List<ThongKeNCCModel> Search(int pageIndex, int pageSize, out long total, string ten_ncc, DateTime? fr_NgayTao, DateTime? to_NgayTao)
        {
            string msgError = "";
            total = 0;
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_thong_ke_ncc",
                    "@page_index", pageIndex,
                    "@page_size", pageSize,
                    "@ten_ncc", ten_ncc,
                    "@fr_NgayTao", fr_NgayTao,
                    "@to_NgayTao", to_NgayTao
                     );
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                if (dt.Rows.Count > 0) total = (long)dt.Rows[0]["RecordCount"];
                return dt.ConvertTo<ThongKeNCCModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
