# SQL Server Data Warehouse

This folder contains the SQL scripts used to build the dimensional data warehouse for the UARU FPSO NDT Operations Analytics project.

## SQL Components

- Database creation
- Dimension tables
- Fact table
- Primary keys
- Foreign keys
- Data validation
- Analytical SQL queries

## Star Schema

The warehouse follows a star schema consisting of:

- fact_ndt_inspection
- dim_calendar
- dim_method
- dim_module
- dim_discipline

The model is designed to support Power BI reporting and operational analytics.
