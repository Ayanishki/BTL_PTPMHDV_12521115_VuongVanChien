use master
drop database if exists Quanlybansach
go
create database Quanlybansach
go
use Quanlybansach
go
create table Users
(
AccountID int Identity(1,1) constraint pk_user primary key(accountid) not null,
Displayname nvarchar(50),
Usernames varchar(50),
Passwords varchar(50) null,
Email varchar(90) check(Email like '%@%') null,
Sdt char(11) null,
Roles int check(Roles in (1,2,3)) null
)
create table LoaiSach
(
MaLoai int identity(1,1) constraint pk_loaisach primary key(Maloai) not null,
TenLoai nvarchar(50) null,
MoTa nvarchar(100),
Cover nvarchar(250)
)
create table Sach
(
MaSach int identity(1,1) constraint pk_sach primary key(masach) not null,
MaLoai int foreign key references LoaiSach(MaLoai) on delete cascade on update cascade,
TenSach nvarchar(100) null,
Gia int,
Soluong int,
TacGia nvarchar(50),
BookCover nvarchar(250)
)

create table KhachHang
(
MaKH int identity(1,1) constraint pk_khachhang primary key(makh) not null ,
TenKH nvarchar(90) null,
SdtKH char(11) null,
Email varchar(100) check(Email like '%@%') null,
Diachi nvarchar(100)
)
create table NhanVien
(
MaNV int identity(1,1) constraint pk_nhanvien primary key(manv) not null,
TenNV nvarchar(90) null,
SdtNV char(11) null,
Email varchar(100) check(Email like '%@%') null,
Diachi nvarchar(100) null,
Ngayvao datetime null,
)
create table NhaCC
(
MaNCC int identity(1,1) constraint pk_nhacc primary key not null,
TenNCC nvarchar(100) null,
Diachi nvarchar(100) null,
SdtNCC char(11) null,
Email varchar(100) check(Email like '%@%') null,
)
create table PhieuNhap
(
	MaPhieuNhap int identity(1,1) constraint pk_phieunhap primary key(maphieunhap) not null,
	MaNV int foreign key references NhanVien(MaNV) on delete cascade on update cascade null,
	NgayLapPN datetime null,
	Email char(100) check (Email like '%@%') null,
	SdtNCC char(11) null,
	Diachi nvarchar(100) null,
	MaNCC int foreign key references NhaCC(MaNCC) on delete cascade on update cascade null,
	TrangThai bit null
)
create table HoaDon
(
	MaHoaDon int identity(1,1) constraint pk_hoadon primary key(mahoadon) not null, 
	NgayLapHD datetime null,
	TenKH nvarchar(90) null,
	SdtKH char(11) null,
	Email varchar(100) check(Email like '%@%')  null,
	Diachi nvarchar(100) null,
	TrangThai bit null
)
create table Chitietphieunhap
(
	MaChiTietPhieuNhap int identity(1,1) not null,
	MaPhieuNhap int foreign key references PhieuNhap(MaPhieuNhap) on delete cascade on update cascade null,
	MaSach int foreign key references Sach(MaSach) on delete cascade on update cascade null, 
	SLnhap int null,
	Gianhap int null,
	constraint P_Chitietphieunhap
	primary key(MaChiTietPhieuNhap)
)

create table Chitiethoadon
(
	MaChiTietHoaDon int identity(1,1) not null,
	MaHoaDon int foreign key references HoaDon(MaHoaDon) on delete cascade on update cascade null,
	MaSach int foreign key references Sach(MaSach) on delete cascade on update cascade null, 
	SLban int null,
	Giaban int null,
	constraint P_Chitieyhoadon
	primary key(MaChiTietHoaDon)
)
----Thêm User
insert into Users(Displayname,Usernames,Passwords,Email,Sdt,Roles)
values('Chien','chien295','chien','ayanokouji295@gmail.com','0985221320',1),
('Chien','chien2951','chien1','ayanokouji295@gmail.com','0985221320',1),
('Chien','chien2952','chien2','kiuopon295@gmail.com','0985221320',1),
('Chien','chien2953','chien3','ayfesfsji295@gmail.com','0985221320',1),
('Chien','chien2954','chien4','ayafsdfji295@gmail.com','0985221320',1),
('Chien','chien2955','chien5','ayafdsuji295@gmail.com','0985221320',1),
('Chien','chien2956','chien6','ayfdsuji295@gmail.com','0985221320',1),
('Chien','chien2957','chien7','afdsuji295@gmail.com','0985221320',1),
('Chien','chien2958','chien8','ayafdsji295@gmail.com','0985221320',1)
----Thêm LoaiSach
insert into LoaiSach
values(N'Giáng sinh',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Gi_ng_Sinh.jpg'),
(N'Thế Giới Pop Mart',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Thang-11-2023/Cat_PopMart_100x100.jpg'),
(N'Tiểu thuyết tình cảm',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/Ti_u_Thuy_t.jpg'),
(N'Tiểu thuyết kinh dị',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/T_m_linh.jpg'),
(N'Khoa học viễn tưởng',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/Thao_t_ng.jpg'),
(N'Ngôn tình Đam Mỹ',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/_am_m_.jpg'),
(N'Khoa học ngoại ngữ',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/8935246917176.jpg'),
(N'Đầu tư bền vững',N'là tiểu thuyết...','	https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/_u_t_.jpg'),
(N'Manga',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/Manga.jpg'),
(N'Light Novel',N'là tiểu thuyết...','https://cdn0.fahasa.com/media/wysiwyg/Duy-VHDT/Danh-muc-san-pham/lightnovel.jpg')
----Thêm Sách
insert into Sach(MaLoai ,TenSach, Gia, Soluong, TacGia,BookCover)
values(6,'Overlord',36000, 72, 'Kugane Maruyama','https://cdn0.fahasa.com/media/catalog/product/o/v/overlord-14-_manga_---b_a-1.jpg'),
(1,'Sword art online',22000, 55, 'Reki Kawahara','https://cdn0.fahasa.com/media/catalog/product/b/_/b_a-1-sao-14.jpg'),
(2,'Classroom of the elite',36000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/9/7/9784040695327.jpg'),
(2,'Attack on Titan',36000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/9/7/9781632367839.jpg'),
(2,'Danmachi',108000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/l/i/lieu-co-sai-lam-khi-tim-kiem-cuoc-gap-go-dinh-menh-trong-dungeon_vol-1.jpg'),
(2,'Jujutsu Kaisen',72000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/i/m/image_209062.jpg'),
(2,N'Dược sư tự sự',69000, 72, 'Natsu Hyuuga','https://cdn0.fahasa.com/media/catalog/product/d/u/duoc-su-tu-su---ln---tap-2---tang-bookmark_postcard.jpg'),
(2,N'Thiên sứ nhà bên',70000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/t/h/thien_su_nha_ben_-_tap_3_3_1.jpg'),
(2,N'Hội chứng tuổi thanh xuân',54000, 72, 'Syougo Kinugasa','https://cdn0.fahasa.com/media/catalog/product/h/o/hoi-chung-thanh-xuan-7_ban-gioi-han.jpg')

----Thêm khách hàng
insert into Khachhang
values(N'KH1',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH2',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH3',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH4',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH5',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH6',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH7',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH8',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH9',N'fbweujfr','fwsfwe@bfdbrdf','53464654'),
(N'KH10',N'fbweujfr','fwsfwe@bfdbrdf','53464654')

----Thêm Nhân Viên
insert into NhanVien
values(N'NV1',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV2',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV3',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV4',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV5',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV6',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV7',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV8',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV9',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV10',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06'),
(N'NV11',N'fbweujfr','uygyu@hvyg','53464654','2023/06/06')
----Thêm Hoá Đơn
insert into HoaDon
values('2023/11/28',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1),
('2023/06/06',N'Chiến','0985221320','fwsfwe@bfdbrdf','5435gfdgerge',1)

----THêm Nhà Cung Cấp
insert into NhaCC(TenNCC,Diachi,SdtNCC,Email)
values(N'Wings Books',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC2',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC3',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC4',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC5',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC6',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC7',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC8',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC9',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC10',N'fdsnf','fefesfse','fesfsfds@f'),
(N'NhaCC11',N'fdsnf','fefesfse','fesfsfds@f')
----Thêm Phiếu nhập
insert into PhieuNhap(MaNV,NgayLapPN,Email,SdtNCC,DiaChi,MaNCC,TrangThai)
values(1,'2023/06/06','chien@gmail.com','0985221329',N'Hưng Yên',1,1),
(2,'2023/06/06','chien@gmail.com','0985221329',N'Hà Nội',1,1),
(3,'2023/06/06','chien@gmail.com','0985221329',N'Hải Phòng',1,1),
(4,'2023/06/06','chien@gmail.com','0985221329',N'Thái Bình',1,1),
(5,'2023/06/06','chien@gmail.com','0985221329',N'Hải Dương',1,1),
(6,'2023/06/06','chien@gmail.com','0985221329',N'Ninh Bình',1,1),
(7,'2023/06/06','chien@gmail.com','0985221329',N'Thái Nguyên',1,1),
(8,'2023/06/06','chien@gmail.com','0985221329',N'Bắc Giang',1,1),
(1,'2023/06/06','chien@gmail.com','0985221329',N'Bắc Ninh',1,1),
(2,'2023/06/06','chien@gmail.com','0985221329',N'Hưng Yên',1,1),
(3,'2023/06/06','chien@gmail.com','0985221329',N'Hưng Yên',1,1)
select * from hoadon
----Thêm chi tiết hoá đơn
insert into Chitiethoadon(MaHoaDon,MaSach,SLban,Giaban)
values(18,7,7,36000)
INSERT INTO Chitiethoadon (MaHoaDon, MaSach, SLban, Giaban)
VALUES (1, 1, 2, 20);

INSERT INTO Chitiethoadon (MaHoaDon, MaSach, SLban, Giaban)
VALUES (2, 1, 3, 18);

INSERT INTO Chitiethoadon (MaHoaDon, MaSach, SLban, Giaban)
VALUES (2, 3, 2, 30);
----Thêm Chitietphieunhap
insert into Chitietphieunhap(MaPhieuNhap,MaSach,SLnhap,Gianhap)
values(1,1,456,657)

INSERT INTO Chitietphieunhap (MaPhieuNhap, MaSach, SLnhap, Gianhap)
VALUES (2, 1, 2, 8);

INSERT INTO Chitietphieunhap (MaPhieuNhap, MaSach, SLnhap, Gianhap)
VALUES (2, 3, 4, 12)


