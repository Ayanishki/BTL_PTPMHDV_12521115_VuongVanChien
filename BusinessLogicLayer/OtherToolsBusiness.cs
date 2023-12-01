
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLogicLayer
{
    public class OTherToolsBusiness : IOtherToolsBusiness
    {
        private IConfiguration _configuration;
        public OTherToolsBusiness(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public string CreatePathFile(string RelativePathFileName)
        {
            try
            {
                string serverRootPathFolder = _configuration["AppSettings:PATH"].ToString();
                string fullPathFile = $@"{serverRootPathFolder}\{RelativePathFileName}";
                string fullPathFolder = System.IO.Path.GetDirectoryName(fullPathFile);
                if (!Directory.Exists(fullPathFolder))
                    Directory.CreateDirectory(fullPathFolder);
                return fullPathFile;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
    }
}
