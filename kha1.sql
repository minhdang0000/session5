
CREATE TABLE products (
    product_id serial PRIMARY KEY,
    product_name varchar(100) NOT NULL,
    category varchar(50) NOT NULL
);


CREATE TABLE orders (
    order_id int PRIMARY KEY,
    product_id int REFERENCES products(product_id),
    quantity int NOT NULL,
    total_price numeric(12,2) NOT NULL
);


INSERT INTO products ( product_name, category) VALUES
('Laptop Dell', 'Electronics'),
('IPhone 15', 'Electronics'),
('Bàn học gỗ', 'Furniture'),
('Ghế xoay', 'Furniture');


INSERT INTO orders (order_id, product_id, quantity, total_price) VALUES
(101, 1, 2, 2200),
(102, 2, 3, 3300),
(103, 3, 5, 2500),
(104, 4, 4, 1600),
(105, 1, 1, 1100);

--Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
-- Phần 1: Tính tổng doanh thu và tổng số lượng theo từng category
select p.category,sum(o.total_price) as "total_sales", sum(o.quantity) as "total_quantity"
from orders o
join products p on o.product_id = p.product_id
group by p.category
-- Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select p.category,sum(o.total_price) as "total_sales", sum(o.quantity) as "total_quantity"
from orders o
join products p on o.product_id = p.product_id
group by p.category
having sum(o.total_price) > 2000
-- Sắp xếp kết quả theo tổng doanh thu giảm dần
select p.category,sum(o.total_price) as "total_sales", sum(o.quantity) as "total_quantity"
from orders o 
join products p on o.product_id = p.product_id
group by p.category
order by sum(o.total_price) desc