----Câu2: Viết thủ tục
------tăng tự động các column ID

create function fn_id
(
	@bang nvarchar(20)
)
returns nvarchar(20)
as 
begin
	if(@bang = N'KhachHang')
		declare @idkhmax int
		declare @khnext char(10)
		set @idkhmax = (select max(right(maKH,8))

		from KhachHang)
	
	
		set @khnext = CONCAT('KH',format(@idkhmax+1,'D4')) 
		
		return @khnext


	if(@bang = N'NhanVien')
		declare @idnvmax int
		declare @nvnext char(10)
		set @idnvmax = (select max(right(maNV,8))

		from NhanVien)
	
	
		set @nvnext = CONCAT('NV',format(@idnvmax+1,'D4')) 
		return @nvnext

	if(@bang = N'SanPham')
		declare @idspmax int
		declare @spnext char(10)
		set @idspmax = (select max(right(maSP,8))

		from SanPham)

	
		set @spnext = CONCAT('SP',format(@idspmax+1,'D4')) 
		return @spnext
	
	
end

select dbo.fn_id(N'KhachHang')

--b.Thống kê những sản phẩm bán chạy(có tham số)
create proc Pr_SanPhamBanChay
	@top int
as
begin
	select S.maSP,tenSP,sum(soLuongDat) as N'Số Lượng Đặt'
	from ChiTietDonHang as C, SanPham as S
	where C.maSP = S.maSP
	group by S.maSP,tenSP
	having SUM(soLuongDat) in (select distinct top (@top) SUM(soLuongDat)
								from ChiTietDonHang
								group by maSP
								order by SUM(soLuongDat) desc)
end
--gọi thủ tục
exec Pr_SanPhamBanChay 3



-------Câu2.c. Những tháng có doanh thu trên 200000(có tham số là định mức tiền)
create  procedure sp_DoanhThuThang

AS
begin
select month(ngayTaoDH) as N'Tháng', year(ngayTaoDH) as N'Năm', format(sum(donGia * soLuongDat), '##,#\ $ ') as N'Tổng tiền'
from DonDatHang_HoaDon as d
 join ChiTietDonHang as c
on d.maHD = c.maDH
group by month(ngayTaoDH), year(ngayTaoDH)
having sum(donGia * soLuongDat) > 20
end

exec sp_DoanhThuThang


--------Câu2.d. Thống kê số lượng khách theo từng tỉnh/thành phố(sắp xếp giảm dần)

create  procedure sp_KhachTheoTinh

AS
begin
select tenTinhThanhPho, count(Tinh.idTinhThanhPho) as N'Số lượng khách mua hàng'
from DonDatHang_HoaDon
	join KhachHang on DonDatHang_HoaDon.maKH=KhachHang.maKH
	left join Xa on KhachHang.idXa= Xa.idXa
	left join Huyen on Xa.idHuyen= Huyen.idHuyen
	left join Tinh on Huyen.idTinhThanhPho= Tinh.idTinhThanhPho
	group by Tinh.idTinhThanhPho,tenTinhThanhPho
	order by count(Tinh.idTinhThanhPho) desc
end

exec sp_KhachTheoTinh

-------Câu2.e. Thống kê giá trung bình, giá max, giá min ở các phiếu nhập hàng cho mỗi sản phẩm

create  procedure sp_GiaSPNhap

AS
begin
select a.maSP,tenSP,AVG(giaNhap) as N'Giá trung bình', max(giaNhap) as N'Giá Max', min(giaNhap) as N'Giá Min'
from ChiTietPhieuNhap as a
join SanPham as b
on a.maSP=b.maSP
group by a.maSP,tenSP
end

exec sp_GiaSPNhap

-------Câu2.f. thống kê số lần khách hàng mua hàng(sắp xếp giảm dần)

create  procedure sp_SoLanKhachMua

AS
begin
select a.maKH,tenKH,count(a.maKH) as N'Số lần mua hàng'
from DonDatHang_HoaDon as a
join KhachHang as b
on a.maKH=b.maKH
group by a.maKH,tenKH 
order by count(a.maKH) desc
end

exec sp_SoLanKhachMua

-----Câu2.g. Thống kê năm có doanh thu lớn nhất(cả thông tin năm và doanh thu)

create  procedure sp_DoanhThuNamMax

AS
begin
select top 1 with ties  year(ngayTaoDH) as N'Năm', format(sum(donGia * soLuongDat), '##,#\ $ ') as N'Doanh Thu'
from DonDatHang_HoaDon as d
 join ChiTietDonHang as c
on d.maHD = c.maDH
group by  year(ngayTaoDH) 
order by sum(donGia * soLuongDat) desc
end

exec sp_DoanhThuNamMax


---câu 3 viết hàm 
----a. Thành tiền khi biết đơn giá và số lượng đặt

create function fn_tinhtien
(
	
	@soLuongMua int,
	@donGia money
)
returns money
as
begin
	
	return @soLuongMua*@donGia

end

select dbo.fn_tinhtien(5,5000)

-------Câu3.b. tổng tiền cho mỗi đơn hàng khi biết mã đơn hàng




CREATE FUNCTION fn_tientheomadh(@maDH nvarchar(30)) 
RETURNS int AS 
BEGIN 
 DECLARE @end int; 
 set @end = (select sum(soLuongDat*donGia)
 from ChiTietDonHang
 where maDH=@maDH)
 return @end
END
select dbo.fn_tientheomadh('DH0006')





----Câu3.c. tính thành tiên sau khi đã áp dụng khuyến mãi



create function fn_tinhtiensaukm
(
	@maKM nvarchar(20),
	@soLuongDat int,
	@donGia money
)
returns nvarchar(20)
as 
begin
		declare @tong int 
		if(@maKM = N'KM0001')
			set @tong=@soLuongDat*@donGia-5000
			return @tong

		if(@maKM = 'KM0002')
			set @tong=(@soLuongDat*@donGia-10000)
			return @tong;
	
		if(@maKM = 'KM0003')
			set @tong=(@soLuongDat*@donGia-15000)
			return @tong;

		if(@maKM = 'KM0004')
			set @tong=(@soLuongDat*@donGia-20000)
			return @tong;
		
		if(@maKM = 'KM0005')
			set @tong=(@soLuongDat*@donGia-25000)
			return @tong;

		if(@maKM = 'KM0006')
			set @tong=(@soLuongDat*@donGia-30000)
			return @tong;

		if(@maKM = 'KM0007')
			set @tong=(@soLuongDat*@donGia-35000)
			return @tong;

		if(@maKM = 'KM0008')
			set @tong=(@soLuongDat*@donGia-40000)
			return @tong;

		if(@maKM = 'KM0009')
			set @tong=(@soLuongDat*@donGia-45000)
			return @tong;

		if(@maKM = 'KM0010')
			set @tong=(@soLuongDat*@donGia-50000)
			return @tong;
	
end 

select dbo.fn_tinhtiensaukm(N'KM0001','1','20000')

-------Câu3.d tổng tiền thu vào theo từng tháng-năm
create  function sp_DoanhThuThangNam
(
	@thang int,
	@nam int
)
returns money 
AS
begin
declare @tongdoanhthu money
set @tongdoanhthu = (select sum(soLuongDat*donGia)
from DonDatHang_HoaDon as a
join ChiTietDonHang as b
on a.maHD=b.maDH
where @thang=month(ngayTaoDH) and @nam=year(ngayTaoDH))

return @tongdoanhthu
end

select dbo.sp_DoanhThuThangNam('1','2021')





