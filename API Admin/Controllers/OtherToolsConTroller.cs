using BusinessLogicLayer;
using BusinessLogicLayer.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace API_Admin.Controllers
{
    [Route("api-admin/[controller]")]
    [ApiController]
    public class OtherToolsConTroller : ControllerBase
    {
        private IOtherToolsBusiness _other;
        public OtherToolsConTroller(IOtherToolsBusiness othertools)
        {
            _other = othertools;
        }
        [Route("upload-images")]
        [HttpPost]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            try
            {
                if (file.Length > 0)
                {
                    string filePath = $"IMG/{file.FileName.Replace("-", "_").Replace("%", "")}";
                    var fullPath = _other.CreatePathFile(filePath);
                    using (var fileStream = new FileStream(fullPath, FileMode.Create))
                    {
                        await file.CopyToAsync(fileStream);
                    }
                    return Ok(new { fullPath });
                }
                else
                {
                    return BadRequest();
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Không thể upload tệp");
            }
        }
    }
}
