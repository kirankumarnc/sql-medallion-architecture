/*
                Analytics – Product Report
===============================================================================
Script Purpose:
    Consolidates key product metrics and behaviours into a reusable Gold layer
    view. Designed to support product-level reporting and performance segmentation.

Highlights:
    1. Gathers essential fields: product name, category, subcategory, and cost
    2. Segments products by total revenue (High-Performer, Mid-Range, Low-Performer)
    3. Aggregates product-level metrics:
       - Total orders, sales, quantity, and unique customers
       - Lifespan in months (first to last sale)
    4. Calculates KPIs:
       - Recency (months since last sale)
       - Average selling price
       - Average order revenue
       - Average monthly revenue

Source Tables:
    - gold.fact_sales
    - gold.dim_products

Output:
    - View: gold.products_report
*/
USE DataWarehouse;

-- Create Report: gold.products_report
IF OBJECT_ID('gold.products_report', 'V') IS NOT NULL
    DROP VIEW gold.products_report;
GO

CREATE VIEW gold.products_report AS

WITH base_query AS (
-- Base Query: Retrieves core columns from fact_sales and dim_products
SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM gold.fact_sales AS f
INNER JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
WHERE order_date IS NOT NULL  -- only consider valid sales dates
),
product_aggregations AS (
-- Product Aggregations: Summarizes key metrics at the product level
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
-- Final Query: Combines all product results into one output
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	life_span,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE
		WHEN life_span = 0 THEN total_sales
		ELSE total_sales / life_span
	END AS avg_monthly_revenue
FROM product_aggregations;