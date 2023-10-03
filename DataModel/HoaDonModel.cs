namespace DataModel
{
    public class HoaDonModel
    {
        public int MaHoaDon {  get; set; }
        public DateTime NgayLapHD { get; set; }
        public string TenKH {  get; set; }
        public string SdtKH { get; set; }
        public string Email { get; set; }
        public string Diachi { get; set; }
        public List<ChitiethoadonModel>list_json_chitiethoadon { get; set; }
    }
    public class ChitiethoadonModel
    {
        public int MaHoaDon { get; set; }
        public int MaSach { get; set; }
        public int SLban { get; set; }
        public int Giaban { get; set; }
    }
}