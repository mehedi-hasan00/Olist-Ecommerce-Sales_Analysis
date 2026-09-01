
/*-------------------------------------------------------------------------
------------------Revenue and Sales Trends---------------------------------
*/
-- 1. Monthly Revenue
select
		date_format(o.order_purchase_timestamp, '%Y-%m') as month,
        sum(p.payment_value) as total_revenue,
        count(distinct o.order_id) as total_orders
from orders o
join payments p on o.order_id = p.order_id
where o.order_status = 'delivered'
		and o.order_purchase_timestamp is not null
        and p.payment_value is not null
group by month
order by month;

-- 2. Averagr Order Value(AOV)
select
	round(sum(p.payment_value)/ count(distinct o.order_id),2) as avg_order_value
from orders o
join payments p on o.order_id = p.order_id
where o.order_status = 'delivered'
and p.payment_value is not null;

-- 3. Revenue by Category 
select
pr.product_category_name,
round(sum(oi.price),2) as total_revenue,
count(oi.order_id) as total_items_sold
from order_items oi
join products pr on oi.product_id = pr.product_id
join orders o on oi.order_id = o.order_id
where o.order_status = 'delivered'
	and pr.product_category_name is not null
    and oi.price is not null
group by pr.product_category_name
order by total_revenue desc;


-- 4. MoM Growth(Month over Month)
with monthly_rev as (
select
date_format(o.order_purchase_timestamp, '%Y-%m') as month,
round(sum(p.payment_value),2) as revenue
from orders o 
join payments p on o.order_id = p.order_id
where o.order_status = 'delivered'
and o.order_purchase_timestamp is not null
and p.payment_value is not null
group by month
)
select 
	month,
    revenue,
    lag(revenue) over (order by month) as prev_month_revenue,
    round(
    (revenue - lag(revenue) over(order by month))/lag(revenue) over(order by month)*100,
    2
    ) as mom_growth_pct
from monthly_rev
order by month



























