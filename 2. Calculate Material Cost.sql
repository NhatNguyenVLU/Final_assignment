Các bạn chú ý: Có rất nhiều phương pháp tính và công cụ tính khác nhau.
Ở đây Thầy chỉ giới thiệu một phương pháp cơ bản các bạn có thể tham khảo
Tuy nhiên các dữ liệu trong ví dụ này Thầy cố tình để sai, 
các nhóm phải điều chỉnh theo dữ liệu của nhóm mình


Yêu cầu ở đây là tính chi phí nguyên liệu để có thể sản xuất được các sản phẩm
bán trong ô dữ liệu Sales.
Sự liên kết giữa các bảng như sau:
1. Dữ liệu định mức nguyên liệu được hiển thị trong bảng Categories
	dữ liệu này theo categorykey
2. Dữ liệu categorykey sẽ được liên kết với dữ liệu Productkey trong
	bảng Products
3. Dữ liệu Products sẽ liên kết với số liệu orderquatity trong bảng Sales
==> Vậy chúng ta sẽ truy ngược từ bảng sales, products và categories để
tính chi phí nguyên liệu cần thiết cho sản xuất.

Bước 1: Trước tiên tạo một bảng Nguyên liệu mà chúng ta cần tính bao gồm:
	Tên nguyên liệu: đã có trong bảng Categories
	Tổng số nguyên liệu: chúng ta cần tính
	Giá từng nguyên liệu: mỗi nhóm tự tìm giá trung bình của từng loại sản phẩm, Thầy sẽ cho ví dụ SAI
	Tổng chi phí nguyên liệu: tích của số nguyên liệu và giá nguyên liệu

Tạo bảng:
Create table requiredingredients (
	ingredientname nvarchar (50),
	totalquantity float,
	unitprice float,
	totalcost as (totalquantity * unitprice))

Kiểm tra bảng: Refresh lại data
Select * from requiredingredients

Bước 2: Tạo một bảng tính số lượng sản phẩm bán theo từng Categorykey
		Dữ liệu được lấy từ bảng Sales và Products
		Bảng này là tiền đề để tính nguyên liệu cần cho việc sản xuất
		CÁC NHÓM NÊN BỔ SUNG YẾU TỐ GIỚI HẠN THỜI GIAN, THẦY ĐANG ĐỂ FULL 3 NĂM (SAI)

Tạo bảng:
SELECT 
    Sales.ProductKey,
    Sales.OrderQuantity,
    (SELECT CategoryKey 
     FROM Products 
     WHERE Products.ProductKey = Sales.ProductKey) AS CategoryKey
INTO Sales_With_Category
FROM Sales;

Kiểm tra bảng: Refresh lại data
select * from Sales_With_Category

Bước 3: Tạo một bảng tính TỔNG số lượng sản phẩm bán theo từng Categorykey

Tạo bảng:
SELECT 
    CategoryKey,
    SUM(OrderQuantity) AS TotalOrderQuantity
INTO Category_Order_Summary
FROM Sales_With_Category
GROUP BY CategoryKey;	

Kiểm tra bảng: Refresh lại data
select * from Category_Order_Summary

Bước 4: Tính số nguyên liệu cần thiết để sản xuất ra các Categorykey
		Nhập giá mua từng nguyên liệu (Thầy sẽ cho số Sai, các bạn tự tính)
		Chúng ta sẽ tính cho từng nguyên liệu
		Sau khi chạy query mỗi nguyên liệu có thể kiểm tra đã cập nhật chưa
		Sau khi chạy toàn bộ query, các bạn sẽ ra được tổng chi phí cho từng nguyên liệu
		Có thể dùng Power BI để lập báo cáo ma trận Kraljic từ dữ liệu này + Phân tích rủi ro (do nhóm tự phân tích)

Tính cho Orange:
INSERT INTO RequiredIngredients (ingredientname, totalquantity, unitprice)
SELECT 
    'Orange_g',
    SUM(Category_Order_Summary.TotalOrderQuantity * Categories.Orange_g),
    1000
FROM Category_Order_Summary
JOIN Categories
    ON Categories.CategoryKey = Category_Order_Summary.CategoryKey;

Tính cho Gauva:
INSERT INTO RequiredIngredients (ingredientname, totalquantity, unitprice)
SELECT 
    'Guava_g',
    SUM(Category_Order_Summary.TotalOrderQuantity * Categories.Guava_g),
    5560
FROM Category_Order_Summary
JOIN Categories
    ON Categories.CategoryKey = Category_Order_Summary.CategoryKey;

Tính cho Syrup:
INSERT INTO RequiredIngredients (ingredientname, totalquantity, unitprice)
SELECT 
    'Syrup_g',
    SUM(Category_Order_Summary.TotalOrderQuantity * CAST(Categories.Syrup_g AS FLOAT)),
    1289
FROM Category_Order_Summary
JOIN Categories
    ON Categories.CategoryKey = Category_Order_Summary.CategoryKey;

Tính cho Naturalsweetener_g
INSERT INTO RequiredIngredients (ingredientname, totalquantity, unitprice)
SELECT 
    'Naturalsweetener_g',
    SUM(Category_Order_Summary.TotalOrderQuantity * Categories.Naturalsweetener_g),
    5220
FROM Category_Order_Summary
JOIN Categories
    ON Categories.CategoryKey = Category_Order_Summary.CategoryKey;

Tính cho PackagingBottle_500ml
INSERT INTO RequiredIngredients (ingredientname, totalquantity, unitprice)
SELECT 
    'PackagingBottle_500ml',
    SUM(Category_Order_Summary.TotalOrderQuantity * Categories.PackagingBottle_500ml),
    189200
FROM Category_Order_Summary
JOIN Categories
    ON Categories.CategoryKey = Category_Order_Summary.CategoryKey;







Chú ý: Nếu khi tính toán bị báo lỗi kiểu dữ liệu, các bạn có thể dùng lệnh sau để kiểm tra
Lệnh kiểm tra kiểu dữ liệu trong bảng
exec sp_help Sales_With_Category

Lệnh thay kiểu dữ liệu của cột
alter table Sales_With_Category
alter column OrderQuantity float;