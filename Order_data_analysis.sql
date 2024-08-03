#select * from orders

-- Find top 10 highest revenue generating product
select product_id,round(sum(sale_price),2) as sales
from orders
group by product_id
order by sales desc
limit 10;

-- Find top 5 highest selling products in each region

with sales_ranking as (
select 
region,
product_id,
round(sum(sale_price)) as sales,
row_number() over( partition by region order by sum(sale_price) desc ) as row_num
from orders
group by region,product_id )

select 
region,
product_id,
sales
from sales_ranking
where row_num <=5
order by region,sales desc;


-- Find month over month comparison fro 2022 and 2023 sales e.g Feb 2022 vs Feb 2023

with cte as (select
 year(order_date) as year,
 month(order_date) as month,
 round(sum(sale_price)) as sales
 from orders
 group by year,month
 order by year,month)
 
 select
 month,
 sum(case when year = 2022 then sales else 0 end )as sales_2022,
 sum(case when year = 2023 then sales else 0 end )as sales_2023
 from cte
 group by month
 order by month;
 
 -- for each category which month has highest sales
 
 with cte as 
 (select category ,month(order_date) as month ,year(order_date) as year,
 round(sum(sale_price)) as sales
 from orders
 group by category,month,year
 order by category,month,year),
 
 ranking as (
 select category,month,year,sales,
 row_number() over (partition by category order by sales desc) as rn
 from cte)
 
 select category,
 year,
 month ,
 sales
 from ranking
 where rn = 1
 order by category;
 
-- Which subcategory had highest growth by profit in 2023 compare to 2022

with cte as (select  sub_category,
year(order_date) as year,
round(sum(profit),2) as total_profit
from orders
group by sub_category,year(order_date)),

agg as (
select sub_category,
sum(case when year = 2022 then total_profit else 0 end) as year_2022,
sum(case when year  = 2023 then total_profit else 0 end) as year_2023
from cte
group by sub_category)

select sub_category,
year_2022,
year_2023,
round(year_2023 - year_2022,2) as profit
from agg
order by profit desc
limit 5
