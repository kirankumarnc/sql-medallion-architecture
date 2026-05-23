/*
                Create Database and Schemas
=========================================================
Purpose:
    Creates the 'DataWarehouse' database and defines three schemas — 'bronze', 'silver', and 'gold' —
    representing the Medallion Architecture layers.

Schema Descriptions:
    bronze : Raw ingestion layer — data loaded as-is from source systems. Here data is ingested from CSV files into SQL Server DB.
    silver : Cleansed and standardised layer — data cleansing, normalisation, 
             and standardisation applied to prepare data for analysis.
    gold   : Analytics-ready layer — star schema modelled data for reporting and analysis

Warnings:
    - This script will fail if 'DataWarehouse' already exists. Drop it manually before re-running.

Usage:
    - Intended for portfolio and learning purposes. Not for production use.
*/

USE master;
GO

-- Create the database called "DataWarehouse"
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas representing the Medallion Architecture layers.

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
