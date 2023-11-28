------------------------------------------------STORE PROCEDURE---------------------------------------------------------------------
--------Hoa Don Get by ID----------

create PROCEDURE [dbo].[sp_hoadon_get_by_id](@MaHoaDon        int)
AS
    BEGIN
        SELECT h.*, 
        (
            SELECT c.*
            FROM ChiTietHoaDon AS c
            WHERE h.MaHoaDon = c.MaHoaDon FOR JSON PATH
        ) AS list_json_chitiethoadon
        FROM HoaDon AS h
        WHERE  h.MaHoaDon = @MaHoaDon;
    END;

----------Hoa Don Create------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_hoadon_create]    Script Date: 9/22/2023 4:00:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_hoadon_create]
(@TenKH              NVARCHAR(50), 
 @SdtKH				nvarchar(50),
 @Diachi          NVARCHAR(250), 
 @Email				nvarchar(50),
 @NgayLapHD			datetime,
 @TrangThai         bit,  
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaHoaDon INT;
        INSERT INTO HoaDon
                (TenKH, 
				 SdtKH,
                 Diachi, 
				 Email,
				 NgayLapHD,
                 TrangThai               
                )
                VALUES
                (@TenKH, 
				 @SdtKH,
                 @Diachi,
				 @Email,
				 @NgayLapHD,
                 @TrangThai
                );

				SET @MaHoaDon = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitiethoadon IS NOT NULL)
                    BEGIN
                        INSERT INTO Chitiethoadon
						 (MaSach, 
						  MaHoaDon,
                          Slban, 
                          Giaban              
                        )
                    SELECT JSON_VALUE(p.value, '$.maSach'), 
                            @MaHoaDon, 
                            JSON_VALUE(p.value, '$.slban'), 
                            JSON_VALUE(p.value, '$.giaban')    
                    FROM OPENJSON(@list_json_chitiethoadon) AS p;
                END;
        SELECT '';
    END;
select * from Sach
select * from chitiethoadon
select * from HoaDon
select * from Nhanvien
-----------Hoa Don Update-----------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_hoa_don_update]    Script Date: 9/22/2023 3:56:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_hoa_don_update]
(@MaHoaDon        int, 
 @TenKH              NVARCHAR(50), 
 @SdtKH				varchar(9),
 @Diachi          NVARCHAR(250), 
 @Email				Varchar(50),
 @NgayLapHD			datetime,
 @TrangThai         bit,  
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		UPDATE HoaDon
		SET
			TenKH  = @TenKH ,
			Diachi = @Diachi,
			SdtKH = @SdtKH,
			Email = @Email,
			NgayLapHD = @NgayLapHD,
			TrangThai = @TrangThai
		WHERE MaHoaDon = @MaHoaDon;
		
		IF(@list_json_chitiethoadon IS NOT NULL) 
		BEGIN
			 -- Insert data to temp table 
		   SELECT
			  JSON_VALUE(p.value, '$.maChiTietHoaDon') as maChiTietHoaDon,
			  JSON_VALUE(p.value, '$.maHoaDon') as maHoaDon,
			  JSON_VALUE(p.value, '$.maSach') as maSach,
			  JSON_VALUE(p.value, '$.slban') as slBan,
			  JSON_VALUE(p.value, '$.giaban') as giaBan,
			  JSON_VALUE(p.value, '$.status') AS status 
			  INTO #Results 
		   FROM OPENJSON(@list_json_chitiethoadon) AS p;
		 
		  --Insert data to table with STATUS = 1;
			INSERT INTO Chitiethoadon (MaSach, 
						  MaHoaDon,
                          Slban, 
                          Giaban ) 
			   SELECT
				  #Results.maSach,
				  @MaHoaDon,		  
				  #Results.slBan,
				  #Results.giaBan			 
			   FROM  #Results 
			   WHERE #Results.status = '1' 
			
			 --Update data to table with STATUS = 2
			  UPDATE Chitiethoadon
			  SET
				 SLban = #Results.slBan,
				 Giaban = #Results.giaBan
			  FROM #Results 
			  WHERE  Chitiethoadon.MaChiTietHoaDon = #Results.maChiTietHoaDon AND #Results.status = '2';
			
			 --Delete data to table with STATUS = 3
			DELETE C
			FROM Chitiethoadon C
			INNER JOIN #Results R
				ON C.MaChiTietHoaDon=R.maChiTietHoaDon
			WHERE R.status = '3';
			DROP TABLE #Results;
		END;
        SELECT '';
    END;

	
-------------Hoa Don Search----------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_thong_ke_khach]    Script Date: 9/22/2023 2:11:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_thong_ke_khach] (@page_index  INT, 
                                       @page_size   INT,
									   @ten_khach Nvarchar(50),
									   @fr_NgayTao datetime, 
									   @to_NgayTao datetime
									   )
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY h.NgayLapHD ASC)) AS RowNumber, 
							  h.MaHoaDon,
                              s.MaSach,	
							  s.TenSach,
							  c.SLban,
							  c.Giaban,
							  h.NgayLapHD,
							  h.TenKH,
							  h.SdtKH,
							  h.Email,
							  h.Diachi
                        INTO #Results1
                        FROM HoaDon  h
						inner join Chitiethoadon c on c.MaHoaDon = h.MaHoaDon
						inner join Sach s on s.MaSach= c.MaSach
					    WHERE  (@ten_khach = '' Or h.TenKH like N'%'+@ten_khach+'%') and						
						((@fr_NgayTao IS NULL
                        AND @to_NgayTao IS NULL)
                        OR (@fr_NgayTao IS NOT NULL
                            AND @to_NgayTao IS NULL
                            AND h.NgayLapHD >= @fr_NgayTao)
                        OR (@fr_NgayTao IS NULL
                            AND @to_NgayTao IS NOT NULL
                            AND h.NgayLapHD <= @to_NgayTao)
                        OR (h.NgayLapHD BETWEEN @fr_NgayTao AND @to_NgayTao))              
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY h.NgayLapHD ASC)) AS RowNumber, 
                              h.MaHoaDon,
                              s.MaSach,
							  s.TenSach,
							  c.SLban,
							  c.Giaban,
							  h.NgayLapHD,
							  h.TenKH,
							  h.SdtKH,
							  h.Email,
							  h.Diachi
                        INTO #Results2
                        FROM HoaDon h
						inner join Chitiethoadon c on c.MaHoaDon = h.MaHoaDon
						inner join Sach s on s.MaSach = c.MaSach
					    WHERE  (@ten_khach = '' Or h.TenKH like N'%'+@ten_khach+'%') and						
						((@fr_NgayTao IS NULL
                        AND @to_NgayTao IS NULL)
                        OR (@fr_NgayTao IS NOT NULL
                            AND @to_NgayTao IS NULL
                            AND h.NgayLapHD >= @fr_NgayTao)
                        OR (@fr_NgayTao IS NULL
						AND @to_NgayTao IS NOT NULL
                            AND h.NgayLapHD <= @to_NgayTao)
                        OR (h.NgayLapHD BETWEEN @fr_NgayTao AND @to_NgayTao))              
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2                        
                        DROP TABLE #Results2; 
        END;
    END;
select * from HoaDon
select * from Chitiethoadon
select * from Users

exec sp_thong_ke_khach 1,0,'',null,null


--------Hóa đơn xóa---------------

USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_thong_ke_khach]    Script Date: 9/22/2023 2:11:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_hoa_don_delete] (@id int)
as	
	begin
		delete from HoaDon
		where MaHoaDon = @id
		delete from Chitiethoadon 
		where MaHoaDon = @id
	end

-------get khach by id-----
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_khach_get_by_id](@id int)
AS
    BEGIN
      SELECT  *
      FROM KhachHang
      where MaKH= @id
    END;
---------Khach create-------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_create]    Script Date: 9/15/2023 3:09:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_khach_create](
@TenKH nvarchar(50),																																																																																															
@SDT nvarchar(50),
@Email nvarchar(250),
@DiaChi nvarchar(250))
AS
    BEGIN
       insert into KhachHang(TenKH,SdtKH,Email,Diachi)
	   values(@TenKH,@SDT,@Email,@Diachi);
    END;			

select * from KhachHang

------------ khach search------------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_search]    Script Date: 9/15/2023 3:09:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create PROCEDURE [dbo].[sp_khach_search] (@page_index  INT, 
                                       @page_size   INT,
									   @ten_khach Nvarchar(50),
									   @dia_chi Nvarchar(250)
									   )
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenKH ASC)) AS RowNumber, 
                              k.MaKH,
							  k.TenKH,
							  k.Email,
							  k.SdtKH,
							  k.Diachi
                        INTO #Results1
                        FROM KhachHang AS k
					    WHERE  (@ten_khach = '' Or k.TenKH like N'%'+@ten_khach+'%') and						
						(@dia_chi = '' Or k.DiaChi like N'%'+@dia_chi+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenKH ASC)) AS RowNumber, 
                              k.MaKH,
							  k.TenKH,
							  k.Email,
							  k.SdtKH,
							  k.Diachi
                        INTO #Results2
                        FROM KhachHang AS k
					    WHERE  (@ten_khach = '' Or k.TenKH like N'%'+@ten_khach+'%') and						
						(@dia_chi = '' Or k.DiaChi like N'%'+@dia_chi+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2;                        
                        DROP TABLE #Results2; 
        END;
    END;
exec sp_khach_search 1,0,'',''

--------------khach update------------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_khach_update](@id int,
@TenKH nvarchar(50),
@Diachi nvarchar(250),
@SdtKH nvarchar(50),
@Email nvarchar(50))
AS
	BEGIN
		update KhachHang
		set 
			TenKH = @TenKH,
			Diachi = @Diachi,
			SdtKH = @SdtKH,
			Email = @Email
		where MaKH = @id
	END
use Quanlybansach
go
select * from KhachHang

select * from Khachhangs

exec sp_khach_search 1,2,'',''
-----khach_delete-------
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_khach_delete](@id int)
AS
    BEGIN
      delete from KhachHang
      where MaKH =@id
    END;
-------Sach_delete--------
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_sach_delete](@id int)
AS
    BEGIN
      delete from Sach
      where MaSach = @id
    END;

----user_delete------


-----------Tài khoản----------------
-------login----------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_login](@taikhoan nvarchar(50), @matkhau nvarchar(50))
AS
    BEGIN
      SELECT  *
      FROM Users
      where Usernames= @taikhoan and Passwords = @matkhau;
    END;
exec sp_login 'chien295','chien'
select * from Users
select * from Chitiethoadon

---------get acc id--------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_user_get_by_id](@id int)
AS
    BEGIN
      SELECT  *
      FROM Users
      where AccountID = @id;
    END;
-------user_create-----
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_user_create](
@displayname nvarchar(50),
@username nvarchar(50),
@password nvarchar(50),
@email nvarchar(50),
@sdt nvarchar(5),
@role int)
AS
    BEGIN
      insert into Users(Displayname,Usernames,Passwords,Email,Sdt,Roles)
	  values(@displayname,@username,@password,@email,@sdt,@role)
    END;
------acc_delete-----
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_user_delete](@id int)
AS
    BEGIN
      delete from Users
      where AccountID =@id
    END;
-----user_update-------
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_user_update](
@id int,
@displayname nvarchar(50),
@username nvarchar(50),
@password nvarchar(50),
@email nvarchar(50),
@sdt nvarchar(5),
@role int
)
AS
    BEGIN
      update Users
	  set 
		Displayname = @displayname,
		Passwords = @password,
		Email = @email,
		Sdt = @sdt,
		Roles = @role
      where AccountID = @id;
    END;

---------get sach by id----------------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_sach_get_by_id](@MaSach int)
AS
    BEGIN
		DECLARE @MaLoaiSach int;
		set @MaLoaiSach = (select MaLoai from Sach where MaSach = @MaSach);
        SELECT s.*, 
        (
            SELECT top 6 sp.*
            FROM Sach AS sp
            WHERE sp.MaLoai = s.MaLoai FOR JSON PATH
        ) AS list_json_chitiethoadon

        FROM Sach AS s
        WHERE  s.MaSach = @MaSach;
    END;

----------sach create---------------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_sach_create](
@MaLoai int,		
@TenSach nvarchar(250),
@Gia int,
@SoLuong int,
@TacGia nvarchar(50),
@BookCover nvarchar(250))
AS
    BEGIN
       insert into Sach(MaLoai,TenSach,Gia,SoLuong,TacGia,BookCover)
	   values(@MaLoai,@TenSach,@Gia,@SoLuong,@TacGia,@BookCover);
    END;			

exec sp_sach_create 1,'dd',2,2,'2',''
select * from Sach

-----------sach update--------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_sach_update](@MaSach int,
@MaLoai int,		
@TenSach nvarchar(250),
@Gia int,
@SoLuong int,
@TacGia nvarchar(50),
@BookCover nvarchar(250))
AS
	BEGIN
		update Sach
		set 
			MaLoai = @MaLoai,
			TenSach = @TenSach,
			Gia = @Gia,
			SoLuong = @SoLuong,
			TacGia =  @TacGia,
			BookCover = @BookCover

		where MaSach = @MaSach
	END
-------Sach Search-----------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_search]    Script Date: 9/15/2023 3:09:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
alter PROCEDURE [dbo].[sp_sach_search] (@page_index  INT, 
                                       @page_size   INT,
									   @ten_sach Nvarchar(50),
									   @tac_gia Nvarchar(250)
									   )
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenSach ASC)) AS RowNumber, 
                              s.MaSach,
							  s.MaLoai,
							  s.TenSach,
							  s.Gia,
							  s.SoLuong,
							  s.TacGia,
							  s.BookCover
                        INTO #Results1
                        FROM Sach AS s
					    WHERE  (@ten_sach = '' Or s.TenSach like N'%'+@ten_sach+'%') and						
						(@tac_gia = '' Or s.TacGia like N'%'+@tac_gia+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenSach ASC)) AS RowNumber, 
                              s.MaSach,
							  s.MaLoai,
							  s.TenSach,
							  s.Gia,
							  s.SoLuong,
							  s.TacGia,
							  s.BookCover
                        INTO #Results2
                        FROM Sach AS s
					    WHERE  (@ten_sach = '' Or s.TenSach like N'%'+@ten_sach+'%') and						
						(@tac_gia = '' Or s.TacGia like N'%'+@tac_gia+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2;                        
                        DROP TABLE #Results2; 
        END;
    END;
exec sp_sach_search 1,0,'',''


-------get loaisach by id-----
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_loaisach_get_by_id](@id int)
AS
    BEGIN
      SELECT  *
      FROM LoaiSach
      where MaLoai= @id
    END;
select * from LoaiSach
---------Loaisach create-------------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_loaisach_create](
@TenLoai nvarchar(50),																																																																																															
@MoTa nvarchar(50),
@Cover nvarchar(250))
AS
    BEGIN
       insert into LoaiSach(TenLoai,MoTa,Cover)
	   values(@TenLoai,@MoTa,@Cover);
    END;			

select * from LoaiSach

------------ loai sach search------------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_search]    Script Date: 9/15/2023 3:09:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
alter PROCEDURE [dbo].[sp_loaisach_search] (@page_index  INT, 
                                       @page_size   INT,
									   @ten_loai Nvarchar(50)
									   )
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenLoai ASC)) AS RowNumber, 
                              ls.MaLoai,
							  ls.TenLoai,
							  ls.MoTa,
							  ls.Cover
                        INTO #Results1
                        FROM LoaiSach AS ls
					    WHERE  (@ten_loai = '' Or ls.TenLoai like N'%'+@ten_loai+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY TenLoai ASC)) AS RowNumber, 
                              ls.MaLoai,
							  ls.TenLoai,
							  ls.MoTa,
							  ls.Cover
                        INTO #Results2
                        FROM LoaiSach AS ls
					    WHERE  (@ten_loai = '' Or ls.TenLoai like N'%'+@ten_loai+'%');                   
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2;                        
                        DROP TABLE #Results2; 
        END;
    END;
exec sp_loaisach_search 1,0,'',''

--------------loaisach update------------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_loaisach_update](@id int,
@TenLoai nvarchar(50),																																																																																															
@MoTa nvarchar(50),
@Cover nvarchar(250))
AS
	BEGIN
		update LoaiSach
		set 
			TenLoai = @TenLoai,
			MoTa = @MoTa,
			Cover = @Cover
		where MaLoai = @id
	END
use Quanlybansach
go
select * from LoaiSach


exec sp_khach_search 1,2,'',''
-----loai sach_delete-------
USE [Quanlybansach]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_loaisach_delete](@id int)
AS
    BEGIN
      delete from LoaiSach
      where MaLoai =@id
    END;

--------Phiếu Nhập Get by ID----------
use[Quanlybansach]
go
create PROCEDURE [dbo].[sp_phieunhap_get_by_id](@MaPhieuNhap int)
AS
    BEGIN
        SELECT pn.*, 
        (
            SELECT c.*
            FROM Chitietphieunhap AS c
            WHERE pn.MaPhieuNhap = c.MaPhieuNhap FOR JSON PATH
        ) AS list_json_chitiethoadon
        FROM PhieuNhap AS pn
        WHERE  pn.MaPhieuNhap = @MaPhieuNhap;
    END;

----------phiếu nhập Create------------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_phieunhap_create]
(@MaNV              int, 
 @MaNCC				int,
 @Diachi          NVARCHAR(250), 
 @SdtNCC			nvarchar(50),
 @Email				nvarchar(250),
 @NgayLapPN		datetime,
 @TrangThai         bit,  
 @list_json_chitietphieunhap NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaPhieuNhap INT;
        INSERT INTO PhieuNhap
                (MaNV, 
				 MaNCC,
                 Diachi, 
				 SdtNCC,
				 Email,
				 NgayLapPN,
                 TrangThai               
                )
                VALUES
                (@MaNV, 
				 @MaNCC,
                 @Diachi,
				 @SdtNCC,
				 @Email,
				 @NgayLapPN,
                 @TrangThai
                );

				SET @MaPhieuNhap = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitietphieunhap IS NOT NULL)
                    BEGIN
                        INSERT INTO Chitietphieunhap
						 (MaSach, 
						  MaPhieuNhap,
                          SLnhap, 
                          Gianhap             
                        )
                    SELECT JSON_VALUE(p.value, '$.maSach'), 
                            @MaPhieuNhap, 
                            JSON_VALUE(p.value, '$.slnhap'), 
                            JSON_VALUE(p.value, '$.gianhap')    
                    FROM OPENJSON(@list_json_chitietphieunhap) AS p;
                END;
        SELECT '';
    END;
select * from Sach
select * from chitietphieunhap
select * from PhieuNhap

-----------Phiếu nhập Update-----------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_hoa_don_update]    Script Date: 9/22/2023 3:56:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_phieu_nhap_update]
(@MaPhieuNhap        int, 
 @MaNV              int, 
 @MaNCC				int,
 @Diachi          NVARCHAR(250), 
 @SdtNCC			nvarchar(50),
 @Email				nvarchar(250),
 @NgayLapPN		datetime,
 @TrangThai         bit,  
 @list_json_chitietphieunhap NVARCHAR(MAX)
)
AS
    BEGIN
		UPDATE PhieuNhap
		SET
			MaNV  =  @MaNV,
			MaNCC = @MaNCC,
			Diachi = @Diachi,
			SdtNCC = @SdtNCC,
			Email = @Email,
			NgayLapPN = @NgayLapPN,
			TrangThai = @TrangThai
		WHERE MaPhieuNhap = @MaPhieuNhap;
		
		IF(@list_json_chitietphieunhap IS NOT NULL) 
		BEGIN
			 -- Insert data to temp table 
		   SELECT
			  JSON_VALUE(p.value, '$.maChiTietPhieuNhap') as maChiTietPhieuNhap,
			  JSON_VALUE(p.value, '$.maPhieuNhap') as maPhieuNhap,
			  JSON_VALUE(p.value, '$.maSach') as maSach,
			  JSON_VALUE(p.value, '$.slnhap') as slNhap,
			  JSON_VALUE(p.value, '$.gianhap') as giaNhap,
			  JSON_VALUE(p.value, '$.status') AS status 
			  INTO #Results 
		   FROM OPENJSON(@list_json_chitietphieunhap) AS p;
		 
		  --Insert data to table with STATUS = 1;
			INSERT INTO Chitietphieunhap(MaSach, 
						  MaPhieuNhap,
                          SLnhap, 
                          Gianhap ) 
			   SELECT
				  #Results.maSach,
				  @MaPhieuNhap,		  
				  #Results.slNhap,
				  #Results.giaNhap			 
			   FROM  #Results 
			   WHERE #Results.status = '1' 
			
			 --Update data to table with STATUS = 2
			  UPDATE Chitietphieunhap
			  SET
				 SLnhap = #Results.slNhap,
				 Gianhap = #Results.giaNhap
			  FROM #Results 
			  WHERE  Chitietphieunhap.MaChiTietPhieuNhap = #Results.maChiTietPhieuNhap AND #Results.status = '2';
			
			 --Delete data to table with STATUS = 3
			DELETE C
			FROM Chitietphieunhap C
			INNER JOIN #Results R
				ON C.MaChiTietPhieuNhap=R.maChiTietPhieuNhap
			WHERE R.status = '3';
			DROP TABLE #Results;
		END;
        SELECT '';
    END;

	
-------------phiếu nhập Search----------------
USE [Quanlybansach]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_thong_ke_ncc] (@page_index  INT, 
                                       @page_size   INT,
									   @ten_ncc Nvarchar(50),
									   @fr_NgayTao datetime, 
									   @to_NgayTao datetime
									   )
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY pn.NgayLapPN ASC)) AS RowNumber, 
                              s.MaSach,
							  s.TenSach,
							  c.SLnhap,
							  c.Gianhap,
							  pn.NgayLapPN,
							  pn.MaNCC,
							  pn.Diachi,
							  ncc.TenNCC
                        INTO #Results1
                        FROM PhieuNhap pn
						inner join Chitietphieunhap c on c.MaPhieuNhap = pn.MaPhieuNhap
						inner join Sach s on s.MaSach= c.MaSach
						inner join NhaCC ncc on pn.MaNCC = ncc.MaNCC
					    WHERE  (@ten_ncc = '' Or ncc.TenNCC like N'%'+@ten_ncc+'%') and						
						((@fr_NgayTao IS NULL
                        AND @to_NgayTao IS NULL)
                        OR (@fr_NgayTao IS NOT NULL
                            AND @to_NgayTao IS NULL
                            AND pn.NgayLapPN >= @fr_NgayTao)
                        OR (@fr_NgayTao IS NULL
                            AND @to_NgayTao IS NOT NULL
                            AND pn.NgayLapPN <= @to_NgayTao)
                        OR (pn.NgayLapPN BETWEEN @fr_NgayTao AND @to_NgayTao))              
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results1;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results1
                        WHERE ROWNUMBER BETWEEN(@page_index - 1) * @page_size + 1 AND(((@page_index - 1) * @page_size + 1) + @page_size) - 1
                              OR @page_index = -1;
                        DROP TABLE #Results1; 
            END;
            ELSE
            BEGIN
						SET NOCOUNT ON;
                        SELECT(ROW_NUMBER() OVER(
                              ORDER BY pn.NgayLapPN ASC)) AS RowNumber, 
                              s.MaSach,
							  s.TenSach,
							  c.SLnhap,
							  c.Gianhap,
							  pn.NgayLapPN,
							  pn.MaNCC,
							  pn.Diachi,
							  ncc.TenNCC
                        INTO #Results2
                        FROM PhieuNhap pn
						inner join Chitietphieunhap c on c.MaPhieuNhap = pn.MaPhieuNhap
						inner join Sach s on s.MaSach = c.MaSach
						inner join NhaCC ncc on pn.MaNCC = ncc.MaNCC
					    WHERE  (@ten_ncc = '' Or ncc.TenNCC like N'%'+@ten_ncc+'%') and						
						((@fr_NgayTao IS NULL
                        AND @to_NgayTao IS NULL)
                        OR (@fr_NgayTao IS NOT NULL
                            AND @to_NgayTao IS NULL
                            AND pn.NgayLapPN >= @fr_NgayTao)
                        OR (@fr_NgayTao IS NULL
						AND @to_NgayTao IS NOT NULL
                            AND pn.NgayLapPN <= @to_NgayTao)
                        OR (pn.NgayLapPN BETWEEN @fr_NgayTao AND @to_NgayTao))              
                        SELECT @RecordCount = COUNT(*)
                        FROM #Results2;
                        SELECT *, 
                               @RecordCount AS RecordCount
                        FROM #Results2                        
                        DROP TABLE #Results2; 
        END;
    END;
select * from PhieuNhap
select * from Chitietphieunhap
select * from NhaCC

exec sp_thong_ke_khach 1,0,'',null,null


--------phiếu nhập xóa---------------

USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_thong_ke_khach]    Script Date: 9/22/2023 2:11:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_phieu_nhap_delete] (@id int)
as	
	begin
		delete from PhieuNhap
		where MaPhieuNhap = @id
		delete from Chitietphieunhap 
		where MaPhieuNhap = @id
	end

-----------topbanchay-------------
alter Procedure TopSachBanChayTrongThang 
as
	begin
		declare @Thang int
		declare @Nam int
		
		--set @Thang = MONTH(dateadd(month,-1,GETDATE()))
		--set @Nam = YEAR(dateadd(YEAR,-1,GETDATE()))
		set @Thang = MONTH(GETDATE())
		set @Nam = YEAR(GETDATE())
		select top 10
			s.MaSach,
			s.TenSach,
			s.TacGia,
			s.Gia,
			COUNT(*) as soluongban
		from HoaDon hd
		inner join Chitiethoadon cthd on cthd.MaHoaDon = hd.MaHoaDon
		inner join Sach s on s.MaSach = cthd.MaSach
		where 
			MONTH(hd.NgayLapHD) = @Thang
			and YEAR(hd.NgayLapHD) = @Nam
		group by 
			s.MaSach,
			s.TenSach,
			s.TacGia,
			s.Gia
		order by 
			soluongban desc
	end
exec TopSachBanChayThangTruoc

create Procedure TopSachBanChayThangtruoc
as
	begin
		declare @Thang int
		declare @Nam int
		
		set @Thang = MONTH(dateadd(month,-1,GETDATE()))
		set @Nam = YEAR(dateadd(YEAR,-1,GETDATE()))
		select top 10
			s.MaSach,
			s.TenSach,
			s.TacGia,
			s.Gia,
			COUNT(*) as soluongban
		from HoaDon hd
		inner join Chitiethoadon cthd on cthd.MaHoaDon = hd.MaHoaDon
		inner join Sach s on s.MaSach = cthd.MaSach
		where 
			MONTH(hd.NgayLapHD) = @Thang
			and YEAR(hd.NgayLapHD) = @Nam
		group by 
			s.MaSach,
			s.TenSach,
			s.TacGia,
			s.Gia
		order by 
			soluongban desc
	end
CREATE PROCEDURE TopSachBanChayToanThoiGian
AS
BEGIN
    SELECT TOP 10
        s.MaSach,
        s.TenSach,
        s.TacGia,
        s.Gia,
        COUNT(*) AS SoLuongBan
    FROM
        HoaDon hd
    INNER JOIN
        Chitiethoadon cthd ON hd.MaHoaDon = cthd.MaHoaDon
    INNER JOIN
        Sach s ON cthd.MaSach = s.MaSach
    GROUP BY
        s.MaSach,
        s.TenSach,
        s.TacGia,
        s.Gia
    ORDER BY
        SoLuongBan DESC
END

CREATE PROCEDURE LayDanhSachSachTheoTheLoai
    @Maloai int
AS
BEGIN
    SELECT
        s.MaSach,
        s.TenSach,
        s.TacGia,
        s.Gia
    FROM
        Sach s
	inner join LoaiSach ls on s.MaLoai = ls.MaLoai
    WHERE
        s.MaLoai = @MaLoai
END