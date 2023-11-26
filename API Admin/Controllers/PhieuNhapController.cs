using BusinessLogicLayer;
using BusinessLogicLayer.Interfaces;
using DataModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace API_Admin.Controllers
{
    [Route("api-admin/[controller]")]
    [ApiController]
    public class PhieuNhapController : ControllerBase
    {
        private IPhieuNhapBusiness _phieunhapBusiness;
        public PhieuNhapController(IPhieuNhapBusiness phieunhapBusiness)
        {
            _phieunhapBusiness = phieunhapBusiness;
        }
        [Route("get-by-id/{id}")]
        [HttpGet]
        public PhieuNhapModel GetDatabyID(int id)
        {
            return _phieunhapBusiness.GetDatabyID(id);
        }
        [Route("create-phieunhap")]
        [HttpPost]
        public PhieuNhapModel CreateItem([FromBody] PhieuNhapModel model)
        {
            _phieunhapBusiness.Create(model);
            return model;
        }
        [Route("update-phieunhap")]
        [HttpPost]
        public PhieuNhapModel Update([FromBody] PhieuNhapModel model)
        {
            _phieunhapBusiness.Update(model);
            return model;
        }
        [Route("delete-phieunhap")]
        [HttpDelete]
        public PhieuNhapModel Delete([FromBody] PhieuNhapModel model)
        {
            _phieunhapBusiness.Delete(model);
            return model;
        }

        [Route("search")]
        [HttpPost]
        public IActionResult Search([FromBody] Dictionary<string, object> formData)
        {
            try
            {
                var page = int.Parse(formData["page"].ToString());
                var pageSize = int.Parse(formData["pageSize"].ToString());
                string ten_ncc = "";
                if (formData.Keys.Contains("ten_ncc") && !string.IsNullOrEmpty(Convert.ToString(formData["ten_ncc"]))) { ten_ncc = Convert.ToString(formData["ten_ncc"]); }
                DateTime? fr_NgayTao = null;
                if (formData.Keys.Contains("fr_NgayTao") && formData["fr_NgayTao"] != null && formData["fr_NgayTao"].ToString() != "")
                {
                    var dt = Convert.ToDateTime(formData["fr_NgayTao"].ToString());
                    fr_NgayTao = new DateTime(dt.Year, dt.Month, dt.Day, 0, 0, 0, 0);
                }
                DateTime? to_NgayTao = null;
                if (formData.Keys.Contains("to_NgayTao") && formData["to_NgayTao"] != null && formData["to_NgayTao"].ToString() != "")
                {
                    var dt = Convert.ToDateTime(formData["to_NgayTao"].ToString());
                    to_NgayTao = new DateTime(dt.Year, dt.Month, dt.Day, 23, 59, 59, 999);
                }
                long total = 0;
                var data = _phieunhapBusiness.Search(page, pageSize, out total, ten_ncc, fr_NgayTao, to_NgayTao);
                return Ok(
                    new
                    {
                        TotalItems = total,
                        Data = data,
                        Page = page,
                        PageSize = pageSize
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
