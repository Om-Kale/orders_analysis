# orders_analysis
Developed a comprehensive data analysis project utilizing Python in Jupyter Notebook for data manipulation and cleaning, and SQL in MySQL for efficient data querying and aggregation.
# Data Analysis Project

This project involves SQL queries designed for analyzing sales data from an `orders` table. The queries derive insights about product performance, regional sales, monthly comparisons, and category growth.

## SQL Queries

### 1. Top 10 Highest Revenue Generating Products

This query retrieves the top 10 products based on total sales revenue.

```sql
SELECT product_id, ROUND(SUM(sale_price), 2) AS sales
FROM orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10; 

### 2. Top 5 Highest Selling Products in Each Region**
-- Assuming you have a region column in your orders table
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
