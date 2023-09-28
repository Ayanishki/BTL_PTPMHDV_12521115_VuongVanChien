using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.ComponentModel;
using System.Data;
using System.Reflection;


namespace DataAccessLayer.Helper.Interfaces
{
    public static class MessageConvert
    {
        private static readonly JsonSerializerSettings Settings;
        static MessageConvert()
        {
            Settings = new JsonSerializerSettings
            {
                Formatting = Formatting.None,
                DateFormatHandling = DateFormatHandling.IsoDateFormat,
                NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
            };
        }
        public static string SerializeObject(this object obj)
        {
            if (obj == null)
                return "";
            return JsonConvert.SerializeObject(obj, Settings);
        }
        public static T DeserializeObject<T>(this string json)
        {

            return JsonConvert.DeserializeObject<T>(json, Settings);

        }

        public static Object DeserializeObject(this string json, Type type)
        {
            try
            {
                return JsonConvert.DeserializeObject(json, type, Settings);
            }
            catch
            {
                return null;
            }
        }
    }
    public static class CollectionHelper
    {
        private static string GetExcelColumnName(int columnNumber)
        {
            int dividend = columnNumber;
            string columnName = string.Empty;
            int modulo;
            while (dividend > 0)
            {
                modulo = (dividend - 1) % 26;
                columnName = Convert.ToChar(65 + modulo).ToString() + columnName;
                dividend = (int)((dividend - modulo) / 26);
            }
            return columnName;
        }
        public static object GetPropertyValue(this object T, string propName)
        {
            return T.GetType().GetProperty(propName) == null ? null : T.GetType().GetProperty(propName).GetValue(T, null);
        }
        public static string GetProvertyValueToString(this object T, string propName)
        {
            return T.GetType().GetProperty(propName) == null ? "" : Convert.ToString(T.GetType().GetProperty(propName).GetValue(T,null));
        }
        public static List<T> GetSourceWithPaging<T>(IEnumerable<T> source,int pageSize, int pageIndex, ref int totalPage)
        {
            var enumerable = source as T[] ?? source.ToArray();
            int totalRow = enumerable.Count();
            totalPage = totalRow % pageSize == 0 ? totalRow / pageSize : (totalRow / pageSize) + 1;
            int skip = (pageIndex - 1) * pageSize;
            var rows = enumerable.Skip(skip).Take(pageSize);
            return rows.ToList();
        }
        public static DataTable ConvertTo<T>(this IList<T> list)
        {
            DataTable table = CreateTable
        }
    }
}
