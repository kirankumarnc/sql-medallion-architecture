/*

                Analytics – Part-to-Whole Analysis
===============================================================================
Script Purpose:
    Calculates each product category's contribution to overall sales revenue
    as a percentage. Helps identify which categories have the greatest business
    impact and where revenue is concentrated.

Queries Included:
    1. Sales contribution by product category (% of total revenue)
       Source: gold.fact_sales, gold.dim_products

SQL Functions Used:
    - SUM(), ROUND()
    - SUM() OVER() for overall total
    - CAST(), CONCAT()
    - CTE (WITH)
*/

-- Which categories contribute the most to overall sales?

WITH category_sales AS (
SELECT
    category, 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales AS f
INNER JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((CAST (total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;