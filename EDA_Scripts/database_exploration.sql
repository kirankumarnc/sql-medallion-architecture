/*

EDA – Database Exploration
=========================================================
Purpose:
    Explores the structure of the DataWarehouse database by listing all tables
    across schemas and inspecting column-level metadata for individual tables.
    This is typically the first step in EDA — understanding what exists before
    querying any data.

Queries Included:
    1. All tables in the database (schema, name, type)
       Source: INFORMATION_SCHEMA.TABLES

    2. Column metadata for a specific table (name, data type, nullability,
       max length)
       Source: INFORMATION_SCHEMA.COLUMNS
       Note: Replace the TABLE_NAME filter value to inspect any other table.
*/

USE DataWarehouse;

SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

SELECT 
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';