/*
                    Analytics – Data Segmentation Analysis
===============================================================================
Script Purpose:
    Groups data into meaningful segments based on defined ranges and business
    rules. Reveals distribution patterns across products and customers, and
    supports targeted decision-making by identifying which segments drive the
    most volume or revenue.

Queries Included:
    1. Product count by cost range (cost segmentation)
       Source: gold.dim_products
    2. Customer count by spending segment (VIP, Regular, New)
       Source: gold.fact_sales, gold.dim_customers

SQL Functions Used:
    - CASE
    - CTE (WITH)
    - SUM(), COUNT(), MIN(), MAX()
    - DATEDIFF()
    - GROUP BY, ORDER BY
*/

USE DataWarehouse;

-- Segment products into cost ranges and count how many products fall into each segment

WITH product_segments AS (
SELECT
    product_key,
    product_name,
    cost,
    CASE
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost < 500 THEN '100 to 499'
        WHEN cost < 1000 THEN '500 to 999'
        ELSE 'Above 1000'
    END AS cost_range
FROM gold.dim_products 
)
SELECT 
    cost_range, 
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_spending AS 
(
SELECT
    c.customer_key,
    SUM(f.sales_amount) AS total_spending,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span
FROM gold.fact_sales AS f
INNER JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
SELECT
    customer_key,
    total_spending,
    life_span,
    CASE
        WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
        WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
        ELSE 'NEW'
    END AS customer_segment
FROM customer_spending
) AS cs
GROUP BY customer_segment
ORDER BY total_customers;