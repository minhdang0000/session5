create table gioi1.customers (
    customer_id serial primary key,
    customer_name varchar,
    city varchar 
);


create table gioi1.orders (
    order_id int primary key,
    customer_id int references gioi1.customers(customer_id),
    order_date date ,
    total_price numeric(12,2)
);


create table gioi1.order_items (
    item_id serial primary key,
    order_id int references gioi1.orders(order_id),
    product_id int,
    quantity int,
    price numeric(12,2) 
);

insert into gioi1.customers (customer_name, city) values
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Hà Nội');


insert into gioi1.orders (order_id, customer_id, order_date, total_price) values
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-05', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);


insert into gioi1.order_items (order_id, product_id, quantity, price) values
(101, 1, 2, 1500),
(102, 2, 1, 1500),
(103, 3, 5, 500),
(104, 2, 4, 1000);

--Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
--Chỉ hiển thị khách hàng có tổng doanh thu > 2000
select 
    c.customer_id,
    c.customer_name,
    c.city,
    sum(o.total_price) as total_revenue,
	count(o.order_id) as order_count
from 
    gioi1.customers c
    join gioi1.orders o on c.customer_id = o.customer_id
group by 
    c.customer_id, c.customer_name, c.city
having 
    sum(o.total_price) > 2000;
--Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
--Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
select 
    c.customer_name,
    c.city,
    sum(o.total_price) as total_revenue
from 
    gioi1.customers c
    join gioi1.orders o on c.customer_id = o.customer_id
group by 
    c.customer_id, c.customer_name, c.city
having 
    sum(o.total_price) > (
        select avg(total_revenue)
        from (
            select sum(total_price) as total_revenue
            from gioi1.orders
            group by customer_id
        ) as sub
    )
order by 
    total_revenue desc;

--Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
select 
    c.city,
    sum(o.total_price) as total_revenue
from 
    gioi1.customers c
    join gioi1.orders o on c.customer_id = o.customer_id
group by 
    c.city
having 
    sum(o.total_price) = (
        select max(city_revenue)
        from (
            select sum(o2.total_price) as city_revenue
            from gioi1.orders o2
            join gioi1.customers c2 on o2.customer_id = c2.customer_id
            group by c2.city
        ) as sub
    )
order by 
    total_revenue desc;
-- (Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
-- Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu
select 
    c.customer_name,
    c.city,
    sum(oi.quantity) as total_quantity,
    sum(oi.quantity * oi.price) as total_spent
from 
    gioi1.customers c
    inner join gioi1.orders o on c.customer_id = o.customer_id
    inner join gioi1.order_items oi on o.order_id = oi.order_id
group by 
    c.customer_id, c.customer_name, c.city
order by 
    total_spent desc;