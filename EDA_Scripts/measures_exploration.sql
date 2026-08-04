/*

EDA – Measures Exploration (Key Metrics)
===============================================================================
Script Purpose:
    Calculates aggregated measures across the fact and dimension tables to
    establish a baseline understanding of business scale. These metrics serve
    as a sanity check on data completeness and a starting point for deeper
    analysis.

Queries Included:
    1. Total sales amount
    2. Total quantity sold
    3. Average selling price
    4. Total number of distinct products
    5. Total number of distinct orders
    6. Total number of distinct customers
    7. Consolidated key metrics report (UNION ALL summary)
       Sources: gold.fact_sales, gold.dim_products, gold.dim_customers

SQL Functions Used:
    - SUM(), AVG(), COUNT()
    - UNION ALL
*/


-- Find the total sales
SELECT 
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT
	SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT
	AVG(price) AS avg_price 
FROM gold.fact_sales;

--Find the total number of products
SELECT
	COUNT(DISTINCT product_name) AS total_products
FROM gold.dim_products;
	
--Find the total number of orders
SELECT
	COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- Find the total number of customers
SELECT
	COUNT(customer_key) AS total_customers 
FROM gold.dim_customers;

--Find the total number of customers that has placed an order
SELECT
	COUNT(DISTINCT customer_key) AS total_customers 
FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business
SELECT 'Total_Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average_Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total_Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total_Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total_Customers', COUNT(customer_key) FROM gold.dim_customers;

