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
	round(sum)