/*

EDA – Date Range Exploration
=========================================================
Script Purpose:
    Explores the temporal boundaries of key data to understand the historical
    range available for analysis. Covers both transactional history (orders)
    and customer demographic data (birthdates).

Queries Included:
    1. Order date range and total duration in months
       Source: gold.fact_sales

    2. Youngest and oldest customer by birthdate, with approximate age
       Source: gold.dim_customers
       Note: Age is calculated using DATEDIFF(YEAR), which counts year
             boundaries crossed rather than exact completed years.

SQL Functions Used:
    - MIN(), MAX()
    - DATEDIFF()
    - GETDATE()
*/

-- Find the data of the first and last order, how many years of sales are available. 
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;