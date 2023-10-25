using DataModel;

namespace DataAccessLayer
{
    public class UserRepository : IUserRepository
    {
        private IDatabaseHelper _dbHelper;
        public UserRepository(IDatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }
        public UserModel Login(string taikhoan, string matkhau)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_login",
                     "@taikhoan", taikhoan,
                     "@matkhau", matkhau
                     );
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                return dt.ConvertTo<UserModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public UserModel GetDatabyID(string accountid)
        {
            string msgError = "";
            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_user_get_by_id",
                    "@id", accountid);
                if (!string.IsNullOrEmpty(msgError))
                {
                    throw new Exception(msgError);
                }
                return dt.ConvertTo<UserModel>().FirstOrDefault();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public bool Create(UserModel model)
        {
            string msgError;
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_user_create",
                    "@MaSach", model.AccountID,
                    "@MaLoai", model.Usernames,
                    "@TenSach", model.Passwords,
                    "@Gia", model.Email,
                    "@SoLuong", model.Roles);
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
        public bool Update(UserModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_sach_update",
                "@MaSach", model.AccountID,
                "@MaLoai", model.Usernames,
                "@TenSach", model.Passwords,
                "@Gia", model.Email,
                "@SoLuong", model.Roles
                );
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
        public bool Delete(UserModel model)
        {
            string msgError = "";
            try
            {
                var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_user_delete",
                "@MaSach", model.AccountID);
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
        public List<UserModel> Search(int pageIndex, int pageSize, out long total, string username, string email)
        {
            string msgError = "";
            total = 0;

            try
            {
                var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_sach_search",
                    "@page_index", pageIndex,
                    "@page_size", pageSize,
                    "@username", username,
                    "@email", email);
                if (!string.IsNullOrEmpty(msgError))
                    throw new Exception(msgError);
                if (dt.Rows.Count > 0) total = (long)dt.Rows[0]["RecordCount"];
                return dt.ConvertTo<UserModel>().ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
