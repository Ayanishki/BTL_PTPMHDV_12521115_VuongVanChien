using BusinessLogicLayer;
using DataModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace API_Quanlybansach.Controllers
{
    [Route("api-admin/[controller]")]
    [ApiController]
    public class SachController : ControllerBase
    {
        private ISachBusiness _sachBusiness;
        public SachController(ISachBusiness sachBusiness)
        {
            _sachBusiness = sachBusiness;
        }
        [Route("get-by-id/{id}")]
        [HttpGet]
        public SachModel GetDatabyID(string id)
        {
            return _sachBusiness.GetDatabyID(id);
        }
        [Route("create-sach")]
        [HttpPost]
        public SachModel CreateItem([FromBody] SachModel model)
        {
            _sachBusiness.Create(model);
            return model;
        }
        [Route("update-sach")]
        [HttpPost]
        public SachModel UpdateItem([FromBody] SachModel model)
        {
            _sachBusiness.Update(model);
            return model;
        }
        [Route("danhmuc")]
        [HttpGet]
        public SachModel Item([FromBody] SachModel model)
        {
            _sachBusiness.Update(model);
            return model;
        }
        [Route("delete-sach")]
        [HttpDelete]
        public string Deleteitem(string model)
        {
            _sachBusiness.Delete(model);
            return model;
        }
        [Route("danhsachhangtheogiatang")]
        [HttpGet]
        public List<SachModel> DanhSachHangTheoGiaTang()
        {
            return _sachBusiness.DanhSachHangTheoGiaTang();
        }
        [Route("danhsachhangtheogiagiam")]
        [HttpGet]
        public List<SachModel> DanhSachHangTheoGiaGiam()
        {
            return _sachBusiness.DanhSachHangTheoGiaGiam();
        }
        [Route("topsachbanchaytoanthoigian")]
        [HttpGet]
        public List<SachModel> TopSachBanChayToanThoiGian(string top)
        {
            return _sachBusiness.TopSachBanChayToanThoiGian(top);
        }
        [Route("topsachbanchay")]
        [HttpGet]
        public List<SachModel> TopSachBanChay(string top)
        {
            return _sachBusiness.TopSachBanChay(top);
        }
        [Route("danhsachtheotheloai")]
        [HttpGet]
        public List<SachModel> LayDanhSachSachTheoTheLoai(string maloai)
        {
            return _sachBusiness.LayDanhSachSachTheoTheLoai(maloai);
        }
        [Route("search")]
        [HttpPost]
        public IActionResult Search([FromBody] Dictionary<string, object> formData)
        {
            try
            {
                var page_index = int.Parse(formData["page"].ToString());
                var page_size = int.Parse(formData["pageSize"].ToString());
                string ten_sach = "";
                if (formData.Keys.Contains("ten_sach") && !string.IsNullOrEmpty(Convert.ToString(formData["ten_sach"]))) { ten_sach = Convert.ToString(formData["ten_sach"]); }
                string tac_gia = "";
                if (formData.Keys.Contains("tac_gia") && !string.IsNullOrEmpty(Convert.ToString(formData["tac_gia"]))) { tac_gia = Convert.ToString(formData["tac_gia"]); }
                long total = 0;
                var data = _sachBusiness.Search(page_index, page_size, out total, ten_sach, tac_gia);
                return Ok(
                    new
                    {
                        TotalItems = total,
                        Data = data,
                        Page = page_index,
                        PageSize = page_size
                    }
                    );
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
