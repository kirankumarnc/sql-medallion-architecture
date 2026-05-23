# SQL Medallion Architecture

Building a modern data warehouse with SQL Server using Medallion Architecture 
(Bronze, Silver, Gold) — covering ETL processes, data modelling, and 
analytics-ready star schema design.

---

## Project Overview

This project demonstrates the implementation of a modern data warehouse
using SQL Server and the Medallion Architecture pattern (Bronze, Silver, Gold),
consolidating sales data from CRM and ERP source systems to enable analytical
reporting and informed decision-making.

---

## Architecture

Need to work on the architecture diagram

> Architecture diagram showing the data flow from CRM and ERP source systems 
> through Bronze, Silver, and Gold layers into the final star schema.

---

## What This Project Covers

- Ingesting raw CRM and ERP data into a bronze layer without transformation
- Cleansing, standardising, and validating data in the silver layer before use
- Integrating multiple sources into a unified star schema in the gold layer
- Building ETL pipelines using SQL Server stored procedures with logging, 
  duration tracking, and error handling
- Maintaining clear documentation at every stage for reproducibility 
  and portfolio presentation

---

## Project Scope

- **Data Sources** — CRM and ERP data ingested from CSV files representing 
  a fictional manufacturing company (AdventureWorks).
- **Data Quality** — Quality issues identified and resolved during the 
  silver layer transformation before data is used for analysis.
- **Data Integration** — CRM and ERP sources unified into a single, 
  analytics-friendly data model in the gold layer.
- **Historisation** — Out of scope; project focuses on the latest 
  snapshot of data only.
- **Documentation** — Each layer documented with data flow, transformation 
  logic, and design decisions for stakeholder and analyst reference.

---

## Medallion Layers

### Bronze — Raw Ingestion
Stores raw data loaded as-is from CRM and ERP CSV source files into SQL Server. 
No transformations are applied at this stage.

### Silver — Cleansed and Standardised
Applies data cleansing, normalisation, and standardisation to prepare data 
for analysis. Quality checks are performed at this layer.

### Gold — Analytics Ready
Integrates cleansed data from both source systems into a unified star schema 
with fact and dimension tables optimised for reporting and analytical queries.

---

## Folder Structure
