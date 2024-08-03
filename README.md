# orders_analysis
Developed a comprehensive data analysis project utilizing Python in Jupyter Notebook for data manipulation and cleaning, and SQL in MySQL for efficient data querying and aggregation.
# Data Analysis Project

This project involves SQL queries designed for analyzing sales data from an `orders` table. The queries derive insights about product performance, regional sales, monthly comparisons, and category growth.

## SQL Queries

### 1. Top 10 Highest Revenue Generating Products

```sql
SELECT product_id, ROUND(SUM(sale_price), 2) AS sales
FROM orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;
```

### 2. Top 5 Highest Selling Products in Each Region

``` sql
WITH RankedProducts AS (
    SELECT product_id, region, 
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) AS rank
    FROM orders
    GROUP BY product_id, region
)
SELECT product_id, region, SUM(sale_price) AS sales
FROM RankedProducts
WHERE rank <= 5
GROUP BY product_id, region
ORDER BY region, sales DESC;
```
### 3. Month Over Month Comparison for 2022 and 2023
```sql
-- Find month over month comparison for 2022 and 2023 sales (e.g., Feb 2022 vs Feb 2023)
WITH cte AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        ROUND(SUM(sale_price)) AS sales
    FROM orders
    GROUP BY year, month
    ORDER BY year, month
)
SELECT
    month,
    SUM(CASE WHEN year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY month
ORDER BY month;
```
### 4. Highest Sales Month for Each Category

```sql
-- For each category, which month has the highest sales

WITH cte AS (
    SELECT category, MONTH(order_date) AS month, YEAR(order_date) AS year,
           ROUND(SUM(sale_price)) AS sales
    FROM orders
    GROUP BY category, month, year
    ORDER BY category, month, year
),
ranking AS (
    SELECT category, month, year, sales,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cte
)
SELECT category,
       year,
       month,
       sales
FROM ranking
WHERE rn = 1
ORDER BY category;
```
### 5. Subcategory with Highest Profit Growth (2023 vs 2022)
```sql
-- Which subcategory had highest growth by profit in 2023 compared to 2022
WITH cte AS (
    SELECT sub_category,
           YEAR(order_date) AS year,
           ROUND(SUM(profit), 2) AS total_profit
    FROM orders
    GROUP BY sub_category, YEAR(order_date)
),
agg AS (
    SELECT sub_category,
           SUM(CASE WHEN year = 2022 THEN total_profit ELSE 0 END) AS year_2022,
           SUM(CASE WHEN year = 2023 THEN total_profit ELSE 0 END) AS year_2023
    FROM cte
    GROUP BY sub_category
)
SELECT sub_category,
       year_2022,
       year_2023,
       ROUND(year_2023 - year_2022, 2) AS profit
FROM agg
ORDER BY profit DESC
LIMIT 5;

```
