/*
                DDL Script: Gold Layer — Star Schema Views
===============================================================================
Purpose:
    This script builds the Gold layer of the data warehouse by creating three
    views that together form a Star Schema: two dimension views and one fact view.

    The Gold layer is the analytics-ready output of the pipeline. It draws from
    the cleansed and standardised Silver layer, applies final business logic,
    integrates data across CRM and ERP sources, and exposes a consistent, 
    query-friendly structure for reporting and downstream consumption.

    Views created:
      - gold.dim_customers  : Customer dimension combining CRM identity data 
                              with ERP demographic and location attributes.
                              CRM is the primary source; ERP fills gaps where 
                              CRM data is absent (e.g., gender fallback).

      - gold.dim_products   : Product dimension joining CRM product records 
                              with ERP category metadata. Restricted to 
                              currently active products only.

      - gold.fact_sales     : Central fact table capturing transactional sales 
                              data, linked to dimensions via surrogate keys for 
                              efficient analytical querying.

Usage:
    These views can be queried directly for analytics, reporting, and 
    BI tool integration. No additional transformation is required.
===============================================================================
*/


-- Create Dimension: gold.dim_customers

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
    ci.cst_id                           AS customer_id,
    ci.cst_key                          AS customer_number,
    ci.cst_firstname                    AS first_name,
    ci.cst_lastname                     AS last_name,
    la.cntry                            AS country,
    ci.cst_marital_status               AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
        ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data
    END                                 AS gender,
    ca.bdate                            AS birthdate,
    ci.cst_create_date                  AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

-- Create Dimension: gold.dim_products
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;       -- Exclude expired products; retain only currently active products
GO

-- Create Fact Table: gold.fact_sales
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num   AS order_number,
    pr.product_key   AS product_key,
    cu.customer_key  AS customer_key,
    sd.sls_order_dt  AS order_date,
    sd.sls_ship_dt   AS shipping_date,
    sd.sls_due_dt    AS due_date,
    sd.sls_sales     AS sales_amount,
    sd.sls_quantity  AS quantity,
    sd.sls_price     AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO