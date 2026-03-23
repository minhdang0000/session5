--Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
select 
    p.product_name,
    sum(o.total_price) as total_revenue
from 
    products p
    join orders o on p.product_id = o.product_id
group by 
    p.product_id, p.product_name
having 
    sum(o.total_price) = (
        select max(revenue_per_product)
        from (
            select sum(total_price) as revenue_per_product
            from orders
            group by product_id
        ) 
    );

-- Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
select 
    p.category,
    sum(o.total_price) as total_revenue
from 
    products p
    join orders o on p.product_id = o.product_id
group by 
    p.category
-- Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cũng nằm trong danh sách nhóm có tổng doanh thu lớn hơn 3000
select p.category
from products p
join orders o on p.product_id = o.product_id
group by p.category, p.product_id
having sum(o.total_price) = (
    select max(revenue)
    from (
        select sum(total_price) as revenue
        from orders
        group by product_id
    ) 
)
intersect
select p.category
from products p
join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) > 3000;