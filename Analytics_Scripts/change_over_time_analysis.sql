/*
            Analytics – Change Over Time Analysis
===============================================================================
Script Purpose:
    Tracks trends and growth in key sales metrics across time periods.
    Demonstrates three alternative approaches to date-based grouping:
    YEAR/MONTH functions, DATETRUNC(), and FORMAT(). Useful for identifying
    seasonality and measuring period-over-period performance.

Queries Included:
    1. Monthly sales trends using YEAR() and MONTH()
       Source: gold.fact_sales
    2. Monthly sales trends using DATETRUNC()
       Source: gold.fact_sales
    3. Monthly sales trends using FORMAT()
       Source: gold.fact_sales

SQL Functions Used:
    - YEAR(), MONTH()
    - DATETRUNC()
    - FORMAT()
    - SUM(), COUNT()
===============================================================================
*/