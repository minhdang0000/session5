-- ALIAS:
-- Hiển thị danh sách tất cả các đơn hàng với các cột:
-- Tên khách (customer_name)
-- Ngày đặt hàng (order_date)
-- Tổng tiền (total_amount)
select 
    c.customer_name as ten_khach,
    o.order_date as ngay_dat_hang,
    o.total_amount as tong_tien
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id
order by o.order_date;

-- Aggregate Functions:
-- Tính các thông tin tổng hợp:
-- Tổng doanh thu (SUM(total_amount))
-- Trung bình giá trị đơn hàng (AVG(total_amount))
-- Đơn hàng lớn nhất (MAX(total_amount))
-- Đơn hàng nhỏ nhất (MIN(total_amount))
-- Số lượng đơn hàng (COUNT(order_id))
select 
    sum(total_amount) as tong_doanh_thu,
    avg(total_amount) as trung_binh_don_hang,
    max(total_amount) as don_hang_lon_nhat,
    min(total_amount) as don_hang_nho_nhat,
    count(order_id) as so_luong_don_hang
from gioi2.orders;
-- GROUP BY / HAVING:
-- Tính tổng doanh thu theo từng thành phố
-- chỉ hiển thị những thành phố có tổng doanh thu lớn hơn 10.000
select 
    c.city as thanh_pho,
    sum(o.total_amount) as tong_doanh_thu
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id
group by c.city
having sum(o.total_amount) > 10000

-- JOIN:
-- Liệt kê tất cả các sản phẩm đã bán, kèm:
-- Tên khách hàng
-- Ngày đặt hàng
-- Số lượng và giá
-- (JOIN 3 bảng customers, orders, order_items)
select 
    c.customer_name as ten_khach_hang,
    o.order_date as ngay_dat_hang,
    oi.product_name as san_pham,
    oi.quantity as so_luong,
    oi.price as gia,
    (oi.quantity * oi.price) as thanh_tien
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id
join gioi2.order_items oi on o.order_id = oi.order_id
order by o.order_date, oi.item_id;
--Subquery:
select 
    c.customer_name as ten_khach_hang,
    sum(o.total_amount) as tong_doanh_thu
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_amount) = (
    select max(tong)
    from (
        select sum(total_amount) as tong
        from gioi2.orders
        group by customer_id
    ) as sub
)
order by tong_doanh_thu desc;
-- UNION và INTERSECT:
-- Dùng UNION để hiển thị danh sách tất cả thành phố có khách hàng hoặc có đơn hàng

select city as thanh_pho
from gioi2.customers

union

select distinct c.city
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id;

-- Dùng INTERSECT để hiển thị các thành phố vừa có khách hàng vừa có đơn hàng
select city as thanh_pho
from gioi2.customers

intersect

select distinct c.city
from gioi2.customers c
join gioi2.orders o on c.customer_id = o.customer_id;