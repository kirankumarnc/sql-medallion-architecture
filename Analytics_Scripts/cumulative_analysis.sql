/*
                    Analytics – Cumulative Analysis
===============================================================================
Script Purpose:
    Aggregates key sales metrics progressively over time to reveal whether the
    business is growing or declining. Covers running totals and moving averages
    using window functions, helping identify long-term trends that period-level
    snapshots alone would miss.

Queries Included:
    1. Running total of sales over all time (monthly granularity)
       Source: gold.fact_sales
    2. Running total of sales reset per year (monthly granularity, partitioned by year)
       Source: gold.fact_sales
    3. Moving average of selling price over time (annual granularity)
       Source: gold.fact_sales

SQL Functions Used:
    - DATETRUNC()
    - SUM() OVER(), AVG() OVER()
    - PARTITION BY, ORDER BY
===============================================================================
*/

-- Calculate the total sales per month and the running total of sales over all time. 
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM (
SELECT 
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
) AS total;

-- Calculate the total sales per month and the running total reset at the start of each year
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY order_year ORDER BY order_date) AS running_total_sales
FROM (
SELECT 
    DATETRUNC(month, order_date) AS order_date,
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date), YEAR(order_date)
) AS total;

-- Calculate the annual running total of sales and the moving average selling price
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM (
SELECT 
    DATETRUNC(YEAR, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
) AS total;