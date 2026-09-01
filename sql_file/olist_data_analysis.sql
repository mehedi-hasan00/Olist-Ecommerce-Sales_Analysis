
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
order by month;

/*
=============================================================================================
=================================Customer ANalysis===========================================
*/
-- 1. Recency, Frequency, Monetary(RFM)
select
c.customer_unique_id,
datediff(
(select max(order_purchase_timestamp) from orders),
max(o.order_purchase_timestamp) 
) as recency_days,
count(distinct o.order_id) as frequency,
round(sum(p.payment_value),2) as monetary
from orders o 
join payments p on o.order_id = p.order_id
join customers c on o.customer_id = c.customer_id
where o.order_status = 'delivered'
and o.order_purchase_timestamp is not null
and p.payment_value is not null
group by c.customer_unique_id
order by frequency desc

-- 2. New vs Repeat Customers
select 
	case 
		when order_count = 1 then 'New Customer'
        else 'Repeat Customer'
	end as customer_type,
    count(*) as customer_count
from (
select 
	c.customer_unique_id,
    count(o.order_id) as order_count
    from orders o
    join customers c on o.customer_id = c.customer_id
    where o.order_status = 'delivered'
    group by c.customer_unique_id
) sub
group by customer_type


-- 3. RFM Segmentation
with rfm_base as (
select
	c.customer_unique_id,
    datediff(
    (select max(order_purchase_timestamp) from orders),
    max(o.order_purchase_timestamp)
    ) as recency_days,
    count(distinct o.order_id) as frequency,
    round(sum(p.payment_value),2) as monetary
    from orders o 
    join customers c on  o.customer_id = c.customer_id
    join payments p on o.order_id = p.order_id
    where o.order_status = 'delivered'
    and o.order_purchase_timestamp is not null
    and p.payment_value is not null
group by c.customer_unique_id
)
select customer_unique_id, 
		recency_days,
        frequency,
        monetary,
        case 
			when recency_days <= 90 and frequency > 1 then 'Loyal Customer'
            when recency_days <= 90 and frequency = 1 then "New/Recent Customer"
            when recency_days >90 and recency_days <= 365 then 'At Risk'
            else 'Churned'
            end as customer_segment
	from rfm_base
    order by monetary desc;  
    
-- 4. Top Customers by Spend
select 
c.customer_unique_id,
round(sum(p.payment_value),2) as total_spend,
count(distinct o.order_id) as total_orders
from orders o
join customers c on o.customer_id = c.customer_id
join payments p on o.order_id = p.order_id
where o.order_status = 'delivered'
group by c.customer_unique_id
order by total_spend desc
limit 10;


/*
===============================================================================================================
========================================Seller Analysis========================================================
*/

-- 1. Top Sellers by Revenue and Order Count
select 
	oi.seller_id,
    round(sum(oi.price),2) as total_revenue,
    count(distinct oi.order_id) as total_order
    
from order_items oi
join orders o on oi.order_id = o.order_id
where o.order_status = 'delivered'
and oi.price is not null
group by oi.seller_id
order by 2 desc
limit 10;

-- 2. Sellers Performance - Avg Review Score per Seller
select
	oi.seller_id,
    round(avg(r.review_score),2) as avg_review_score,
    count(distinct r.review_id) as total_review
from order_items oi
join orders o on oi.order_id = o.order_id
join reviews r on o.order_id = r.order_id
where o.order_status = 'delivered'
and r.review_score is not null
group by oi.seller_id
having count(distinct r.review_id) >= 50
order by avg_review_score desc;

-- getting highet total review
select
	oi.seller_id,
    round(avg(r.review_score),2) as avg_review_score,
    count(distinct r.review_id) as total_review
from order_items oi
join orders o on oi.order_id = o.order_id
join reviews r on o.order_id = r.order_id
where o.order_status = 'delivered'
and r.review_score is not null
group by oi.seller_id
order by total_review desc;


-- 3. Seller Delivery Performance
select 
		oi.seller_id,
        round(avg(datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date)),2) as avg_delay_days,
        count(distinct o.order_id) as total_order
from order_items oi
join orders o on oi.order_id = o.order_id
where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
and o.order_estimated_delivery_date is not null
group by oi.seller_id
having count(distinct o.order_id) >=5
order by avg_delay_days desc;


-- 4. Number of Products per Seller
select 
oi.seller_id,
count(distinct oi.order_id) as total_unique_order,
count(oi.order_item_id) as total_item_sold
from order_items oi
join orders o on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by oi.seller_id
order by 2 desc;

-- 5. Revenue Concentration (Pareto/80-20 Analysis)

with seller_revenue as (
select 
oi.seller_id,
round(sum(oi.price),2) as revenue
from order_items oi
join orders o on oi.order_id = o.order_id
where o.order_status = 'delivered'
and oi.price is not null
group by oi.seller_id

),
ranked as (
select
	seller_id,
    revenue,
    rank() over(order by revenue desc) as seller_rank,
    sum(revenue) over (order by revenue desc) as running_total,
    sum(revenue) over () as grand_total,
    count(*) over() as total_sellers
    from seller_revenue
)
select
	seller_id,
    revenue,
    seller_rank,
    round(running_total/grand_total * 100, 2) as cumulative_revenue_pct,
    round(seller_rank/total_sellers * 100,2) as cumulative_seller_pct
    from ranked
    order by seller_rank;

/*
==============================================================================================================
=======================================Order & Delivery Performance===========================================
*/
-- 1. Order Status Breakdown

select 
	order_status,
    count(*) as order_count,
    round(count(*) * 100.0 / (select count(*) from orders),2) as percentage
    from orders
    group by order_status
    order by order_count desc;

-- 2. Average Delivery Time(purchase to delivery)
select 
	round( avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),2) as avg_delivery_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_purchase_timestamp  is not null



-- 3. Late Delivery % (actual vs estimated)
select 
	sum(case 
			when order_delivered_customer_date > order_estimated_delivery_date then 1 else 0 end) as late_orders,
            count(*) as total_orders,
            round(sum(case
							when order_delivered_customer_date > order_estimated_delivery_date then 1 else 0 end)* 100.0/ count(*),2) as late_delivery_pct
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
and order_estimated_delivery_date is not null




































