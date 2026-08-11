/*
            Analytics – Change Over Time Analysis
===============================================================================
Script Purpose:
    Tracks trends and growth in key sales metrics across time periods.
    Demonstrates three alternative approaches to date-based grouping:
    YEAR/MONTH functions, DATETRUNC(), and FORMAT(). Useful for identifying
    seasonality and measuring period-over-period performance.

Queries Included:
    1. Annual sales trends using YEAR()
       Source: gold.fact_sales
    2. Monthly sales trends using MONTH()
       Source: gold.fact_sales
    3. Monthly sales trends using DATETRUNC()
       Source: gold.fact_sales
    4. Year and month combined trends using YEAR() and MONTH()
       Source: gold.fact_sales

SQL Functions Used:
    - YEAR(), MONTH()
    - DATETRUNC()
    - SUM(), COUNT()
===============================================================================
*/
-- Change over time analyze how a measure evolves over time. 
-- Helps track trends and identify seasonality in the data. 

-- sales performance over time 
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT( DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

SELECT
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT( DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Both year and month 
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);