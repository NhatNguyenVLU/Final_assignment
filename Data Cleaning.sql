Các bạn chú ý: Đây chỉ là ví dụ một trường hợp đơn giản trong làm sạch dữ liệu.

Bước 1. Kiểm tra các giá trị nhập liệu thiếu (hay hiển thị là null)
Select * from Sales where OrderQuantity is null

Bước 2. Điều chỉnh các giá trị hiển thị sai hoặc hiểu thị là null
Chúng ta không thể tùy tiện điều chỉnh theo ý muốn mà cần tham chiếu các cơ sở trong bảng dữ liệu
Ở đây để điều chỉnh OrderQuantity, chúng ta có thể kiểm tra xem các khách hàng thiếu dữ liệu trung bình mua bao nhiêu sản phẩm
Đây là cơ sở điều chỉnh các dữ liệu thiếu
Lệnh kiểm tra theo khách hàng:
Select * from Sales where customerkey = 22785

Sau khi lấy giá trị trung bình mua hàng của khách, chúng ta cập nhật vào dữ liệu thiếu
Update sales
set orderquantity = 1
where CustomerKey = 22785

Tương tự như trên, các bạn làm sạch các dữ liệu khác

