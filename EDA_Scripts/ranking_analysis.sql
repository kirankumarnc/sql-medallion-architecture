/*

                    EDA – Ranking Analysis
===============================================================================
Script Purpose:
    Ranks products, subcategories, and customers by revenue and order volume
    to identify top and bottom performers. Demonstrates both TOP N filtering
    and window function approaches to ranking.

Queries Included:
    1. Top 5 products by revenue (TOP N)
       Source: gold.fact_sales, gold.dim_products
    2. Top 5 products by revenue (ROW_NUMBER window function)
       Source: gold.fact_sales, gold.dim_products
    3. Bottom 5 products by revenue
       Source: gold.fact_sales, gold.dim_products
    4. Top 5 subcategories by revenue
       Source: gold.fact_sales, gold.dim_products
    5. Bottom 5 subcategories by revenue
       Source: gold.fact_sales, gold.dim_products
    6. Top 10 customers by revenue
       Source: gold.fact_sales, gold.dim_customers
    7. Bottom 3 customers by order count
       Source: gold.fact_sales, gold.dim_customers

SQL Functions Used:
    - TOP
    - ROW_NUMBER(), RANK()
    - SUM(), COUNT()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generate the highest revenue?

SELECT
    TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM  gold.fact_sales AS f
JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- alternate to use windows function
SELECT 
    product_name,
    total_revenue,
    rank_products
FROM(
        SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products 
        -- ROW_NUMBER() assigns unique ranks with no ties.
        -- Use RANK() if you want tied products to share the same rank.
        FROM  gold.fact_sales AS f
        JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
        GROUP BY p.product_name
    ) AS t
WHERE rank_products <= 5;

-- What are the 5 worst performing products in terms of sales. 
SELECT
    TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM  gold.fact_sales AS f
JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Which 5 sub category generate the highest revenue?

SELECT
    TOP 5
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM  gold.fact_sales AS f
JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;

-- Which 5 sub category generate the worst performing revenue?

SELECT
    TOP 5
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM  gold.fact_sales AS f
JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue ASC;

-- Find the top-10 customers who have generated the highest revenue 
SELECT
    TOP 10
    c.customer_key,
    c.first_name, 
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed.
SELECT
    TOP 3
    c.customer_key,
    c.first_name, 
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales AS f
JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;
