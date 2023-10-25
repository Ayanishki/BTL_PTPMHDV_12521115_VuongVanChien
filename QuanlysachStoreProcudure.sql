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
 @Diachi          NVARCHAR(250), 
 @TrangThai         bit,  
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaHoaDon INT;
        INSERT INTO HoaDon
                (TenKH, 
                 Diachi, 
                 TrangThai               
                )
                VALUES
                (@TenKH, 
                 @Diachi, 
                 @TrangThai
                );

				SET @MaHoaDon = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitiethoadon IS NOT NULL)
                    BEGIN
                        INSERT INTO ChiTietHoaDon
						 (MaSach, 
						  MaHoaDon,
                          Slban, 
                          Giaban              
                        )
                    SELECT JSON_VALUE(p.value, '$.maSanPham'), 
                            @MaHoaDon, 
                            JSON_VALUE(p.value, '$.slBan'), 
                            JSON_VALUE(p.value, '$.giaBan')    
                    FROM OPENJSON(@list_json_chitiethoadon) AS p;
                END;
        SELECT '';
    END;



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
			  JSON_VALUE(p.value, '$.slBan') as slBan,
			  JSON_VALUE(p.value, '$.giaBan') as giaBan,
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
                              s.MaSach,
							  s.TenSach,
							  c.SLban,
							  c.Giaban,
							  h.NgayLapHD,
							  h.TenKH,
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
                              s.MaSach,
							  s.TenSach,
							  c.SLban,
							  c.Giaban,
							  h.NgayLapHD,
							  h.TenKH,
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
select * from Sach

exec sp_thong_ke_khach 1,0,'',null,null


--------Hóa đơn xóa---------------

USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_thong_ke_khach]    Script Date: 9/22/2023 2:11:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[sp_hoa_don_delete] (@id int)
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
 
alter PROCEDURE [dbo].[sp_khach_search] (@page_index  INT, 
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
alter PROCEDURE [dbo].[sp_khach_update](@id int,
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
alter PROCEDURE [dbo].[sp_login](@taikhoan nvarchar(50), @matkhau nvarchar(50))
AS
    BEGIN
      SELECT  *
      FROM Users
      where Usernames= @taikhoan and Passwords = @matkhau;
    END;
exec sp_login 'chien295','chien'
select * from Users
select * from LoaiSach

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
@TacGia nvarchar(50))
AS
    BEGIN
       insert into Sach(MaLoai,TenSach,Gia,SoLuong,TacGia)
	   values(@MaLoai,@TenSach,@Gia,@SoLuong,@TacGia);
    END;			

exec sp_sach_create 1,'dd',2,2,'2'
select * from Sach

-----------sach update--------------
USE [Quanlybansach]
GO
/****** Object:  StoredProcedure [dbo].[sp_khach_get_by_id]    Script Date: 9/15/2023 2:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_sach_update](@MaSach int,
@MaLoai int,
@TenSach nvarchar(250),
@Gia int,
@SoLuong int,
@TacGia nvarchar(50))
AS
	BEGIN
		update Sach
		set 
			MaLoai = @MaLoai,
			TenSach = @TenSach,
			Gia = @Gia,
			SoLuong = @SoLuong,
			TacGia =  @TacGia

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
							  s.TacGia
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
							  s.TacGia
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
