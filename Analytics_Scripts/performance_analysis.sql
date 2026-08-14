/*
            Analytics – Performance Analysis (Year-over-Year)
===============================================================================
Script Purpose:
    Measures yearly product sales performance by comparing each year's sales
    against two benchmarks: the product's historical average and the prior
    year's sales. Identifies whether performance is improving, declining, or
    holding steady.

Queries Included:
    1. Yearly product sales vs. average and prior year (YoY analysis)
       Source: gold.fact_sales, gold.dim_products

SQL Functions Used:
    - CTE (WITH)
    - LAG()
    - AVG() OVER()
    - CASE
    - SUM(), YEAR()
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
SELECT 
    YEAR(f.order_date) AS order_year,
    p.product_name, 
    SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 
    YEAR(f.order_date), 
    p.product_name
)
SELECT 
    order_year, 
    product_name, 
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_Sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS difference_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS average_change,
    -- year to year analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_previous_year,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No change'
    END AS yoy_change
FROM yearly_product_sales
ORDER BY product_name, order_year;