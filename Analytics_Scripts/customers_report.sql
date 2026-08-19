/*
					Analytics – Customer Report
===============================================================================
Script Purpose:
    Consolidates key customer metrics and behaviours into a reusable Gold layer view. 
	Designed to support customer-level reporting and segmentation analysis.

Highlights:
    1. Gathers essential fields: customer details, age, and transaction data
    2. Segments customers by spending behaviour (VIP, Regular, New) and age group
    3. Aggregates customer-level metrics:
       - Total orders, sales, quantity, and distinct products purchased
       - Lifespan in months (first to last order)
    4. Calculates KPIs:
       - Recency (months since last order)
       - Average order value
       - Average monthly spend

Source Tables:
    - gold.fact_sales
    - gold.dim_customers

Output:
    - View: gold.report_customers
*/
USE DataWarehouse;

-- Create Report: gold.customers_report
IF OBJECT_ID('gold.customers_report', 'V') IS NOT NULL
    DROP VIEW gold.customers_report;
GO

CREATE VIEW gold.customers_report AS

WITH base_query AS (
-- Base Query: Retrieves core columns from tables
SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	DATEDIFF(year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales AS f
INNER JOIN gold.dim_customers AS c
	ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
),
customer_segmentation AS (
-- Customer Aggregations: Summarizes key metrics at the customer level
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 and 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS customer_age_group,
	CASE
        WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN life_span >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'NEW'
    END AS customer_segment,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	life_span,
	-- compute average order value
	CASE
		WHEN total_sales = 0 THEN 0 
		ELSE total_sales / total_orders
	END AS avg_order_value,
	--compute average monthly spend
	CASE
		WHEN life_span = 0 THEN total_sales
		ELSE total_sales / life_span
	END AS avg_monthly_spend
FROM customer_segmentation;
