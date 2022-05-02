--Tự động cập nhật số lượng hiện còn ở bảng SanPham mỗi khi insert/ update/ delete vào bảng ChiTietDonHang
--Tự động cập nhật giá trị cột DonGia vào bảng ChiTietDonHang sau khi insert/ update/ delete vào bảng ChiTietDonHang



--Tự động cập nhật số lượng hiện còn ở bảng SanPham và giá trị cột DonGia vào bảng ChiTietDonHang sau khi insert vào bảng ChiTietDonHang

create or alter trigger tg_insert_chiTietDonHang
on ChiTietDonHang
after insert
as
begin
update ChiTietDonHang
set donGia = donGiaBan
from SanPham,inserted
where SanPham.maSP = inserted.maSP and ChiTietDonHang.maDH = inserted.maDH
and ChiTietDonHang.maSP = inserted.maSP



update SanPham
set soLuongHienCon = soLuongHienCon - inserted.soLuongDat
from inserted
where SanPham.maSP = inserted.maSP

if((select soLuongHienCon from SanPham) < 0)			
		rollback transaction;


end


/*
insert into ChiTietDonHang
values('DH0013','SP0010',1,NULL),
	  ('DH0001','SP0004',2,NULL)
*/

--Tự động cập nhật số lượng hiện còn ở bảng SanPham và giá trị cột DonGia vào bảng ChiTietDonHang mỗi khi  update vào bảng ChiTietDonHang


create or alter trigger tg_update_chiTietDonHang
on ChiTietDonHang
after update
as
begin
update SanPham
set soLuongHienCon = soLuongHienCon - 
(select inserted.soLuongDat 
 from ChiTietDonHang,inserted 
 where  inserted.maSP= sp.maSP and inserted.maDH=ChiTietDonHang.maDH and sp.maSP=ChiTietDonHang.maSP)+
(select deleted .soLuongDat
 from ChiTietDonHang,deleted 
 where  deleted.maSP= sp.maSP and deleted.maDH=ChiTietDonHang.maDH and sp.maSP=ChiTietDonHang.maSP)
from SanPham as sp
join deleted on sp.maSP= deleted.maSP

update ChiTietDonHang
set donGia = donGiaBan
from SanPham,inserted
where SanPham.maSP = inserted.maSP and ChiTietDonHang.maDH = inserted.maDH
and ChiTietDonHang.maSP = inserted.maSP

if((select soLuongHienCon from SanPham) < 0)			
		rollback transaction;

end




--Tự động cập nhật số lượng hiện còn ở bảng SanPham mỗi khi  delete vào bảng ChiTietDonHang

create or alter trigger tg_delete_chiTietDonHang
on ChiTietDonHang
after delete
as
begin
update SanPham
set soLuongHienCon = soLuongHienCon + deleted.soLuongDat
from deleted
where SanPham.maSP = deleted.maSP
end


--Tự động cập nhật số lượng hiện còn ở bảng SanPham số lượng DonGiaBan ở bảng SanPham mỗi khi insert 
--vào bảng ChiTietPhieuNhap (công thức Đơn giá nhập * 30% - 30% chính là tiền lời)

create or alter trigger tg_insert_chiTietPhieuNhap
on ChiTietPhieuNhap
after insert
as
begin
update SanPham
set  donGiaBan = ChiTietPhieuNhap.giaNhap + (ChiTietPhieuNhap.giaNhap*0.3)
from ChiTietPhieuNhap,inserted
where SanPham.maSP = inserted.maSP and ChiTietPhieuNhap.maSP = inserted.maSP
and ChiTietPhieuNhap.maPN = inserted.maPN



update SanPham
set soLuongHienCon = soLuongHienCon - inserted.soLuongNhap
from inserted
where SanPham.maSP = inserted.maSP

if((select soLuongHienCon from SanPham) < 0)			
		rollback transaction;

end

--Tự động cập nhật số lượng hiện còn ở bảng SanPham mỗi khi update vào bảng ChiTietDonHang

create or alter trigger tg_update_chiTietPhieuNhap
on ChiTietPhieuNhap
after update
as
begin
update SanPham
set soLuongHienCon = soLuongHienCon - 
(select inserted.soLuongNhap
 from ChiTietPhieuNhap,inserted 
 where   sp.maSP=inserted.maSP and ChiTietPhieuNhap.maPN=inserted.maPN and ChiTietPhieuNhap.maPN=inserted.maPN )+
(select deleted.soLuongNhap
 from ChiTietPhieuNhap,deleted 
 where ChiTietPhieuNhap.maPN= deleted.maPN and sp.maSP=deleted.maSP and ChiTietPhieuNhap.maPN=deleted.maPN)
from SanPham as sp
join deleted on sp.maSP= deleted.maSP 

if((select soLuongHienCon from SanPham) < 0)			
		rollback transaction;

end



--Tự động cập nhật số lượng hiện còn ở bảng SanPham mỗi khi delete vào bảng ChiTietDonHang

create or alter trigger tg_delete_chiTietPhieuNhap
on ChiTietPhieuNhap
after delete
as
begin
update SanPham
set soLuongHienCon = soLuongHienCon + deleted.soLuongNhap
from deleted
where SanPham.maSP = deleted.maSP

if((select soLuongHienCon from SanPham) < 0)			
		rollback transaction;

end
---------- cập nhật khi xoá bảng ở bảng PhieuDoXe
create or alter trigger tg_delete_PhieuDoXe
on PhieuDoXe
after delete
as
begin
update Khu
set soChoConTrong = soChoConTrong + 1


end

---------cập nhật khi insert bảng ở bảng PhieuDoXe
create or alter trigger tg_delete_PhieuDoXe
on PhieuDoXe
after insert
as
begin
update Khu
set soChoConTrong = soChoConTrong - 1
from inserted
where PhieuDoXe.idPDX = inserted.idPDX

---------cập nhật khi delete bảng ở bảng XeDangKyLauDai

create or alter trigger tg_delete_DKLD
on XeDangKyLauDai
after delete
as
begin
update Khu
set soChoConTrong = soChoConTrong + 1
from deleted
where PhieuDoXe.idXe = deleted.idXe



end

---------cập nhật khi insert bảng ở bảng XeDangKyLauDai

end

create or alter trigger tg_delete_DKLD
on XeDangKyLauDai
after insert
as
begin
update Khu
set soChoConTrong = soChoConTrong + 1
from inserted
where XeDangKyLauDai.idXe = deleted.idXe



end