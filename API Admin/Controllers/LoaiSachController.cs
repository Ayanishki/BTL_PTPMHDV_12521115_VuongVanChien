using BusinessLogicLayer;
using DataModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace API_Admin.Controllers
{
    [Route("api-admin[controller]")]
    [ApiController]
    public class LoaiSachController : ControllerBase
    {
        private ILoaiSachBusiness _loaisachBusiness;
        public LoaiSachController(ILoaiSachBusiness loaisachBusiness)
        {
            _loaisachBusiness = loaisachBusiness;
        }
        [Route("get-by-id/{id}")]
        [HttpGet]
        public LoaiSachModel GetDatabyID(string id)
        {
            return _loaisachBusiness.GetDatabyID(id);
        }
        [Route("create-loaisach")]
        [HttpPost]
        public LoaiSachModel CreateItem([FromBody] LoaiSachModel model)
        {
            _loaisachBusiness.Create(model);
            return model;
        }
        [Route("update-loaisach")]
        [HttpPost]
        public LoaiSachModel UpdateItem([FromBody] LoaiSachModel model)
        {
            _loaisachBusiness.Update(model);
            return model;
        }
        [Route("delete-loaisach")]
        [HttpDelete]
        public LoaiSachModel DeleteItem([FromBody] LoaiSachModel model)
        {
            _loaisachBusiness.Delete(model);
            return model;
        }
        [Route("search")]
        [HttpPost]
        public IActionResult Search([FromBody] Dictionary<string, object> formData)
        {
            try
            {
                var page_index = int.Parse(formData["page"].ToString());
                var page_size = int.Parse(formData["pageSize"].ToString());
                string ten_loai = "";
                if (formData.Keys.Contains("ten_khach") && !string.IsNullOrEmpty(Convert.ToString(formData["ten_khach"]))) { ten_loai = Convert.ToString(formData["ten_khach"]); }
                //string email = "";
                //if (formData.Keys.Contains("email") && !string.IsNullOrEmpty(Convert.ToString(formData["email"]))) { email = Convert.ToString(formData["email"]); }
                //string sdtkh = "";
                //if (formData.Keys.Contains("sdtkh") && !string.IsNullOrEmpty(Convert.ToString(formData["sdtkh"]))) { dia_chi = Convert.ToString(formData["dia_chi"]); }
                long total = 0;
                var data = _loaisachBusiness.Search(page_index, page_size, out total, ten_loai);
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
