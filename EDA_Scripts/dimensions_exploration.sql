/*
EDA – Dimensions Exploration
=========================================================
Script Purpose:
    Explores the distinct values within dimension tables to understand the
    range and distribution of categorical data. This helps validate dimension
    quality and identify the key groupings available for analysis.

Queries Included:
    1. Unique customer countries
       Source: gold.dim_customers
    2. Unique product category hierarchy (category - subcategory - product)
       Source: gold.dim_products

SQL Functions Used:
    - DISTINCT
    - ORDER BY
*/

USE DataWarehouse;

-- Explore all countries our customers come from.
SELECT 
    DISTINCT country 
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT 
    DISTINCT category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;