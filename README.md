# Retail Enterprise Performance Analytics & Customer Intelligence Dashboard

A complete industry-grade BI portfolio project that simulates a corporate retail analytics implementation using SQL, Power BI, Power Query, DAX, star schema modeling, KPI design, and business storytelling.

## Project Overview

This project builds an end-to-end retail BI solution for a national retailer that needs to analyze sales performance, profitability, customer behavior, retention, inventory health, returns, and regional growth opportunities.

## Architecture

The model follows a star schema:

- Fact tables: `FactSales`, `FactReturns`, `FactInventory`
- Dimension tables: `DimCustomer`, `DimProduct`, `DimStore`, `DimRegion`, `DimDate`
- BI layer: Power BI semantic model, DAX measures, dashboard pages, drill-through, tooltips, RLS, and incremental refresh guidance

## Business Problem

Retail leadership needs one reliable analytics layer for weekly trading reviews, margin protection, customer retention, replenishment decisions, and regional planning.

## KPIs

| KPI | Sample Result |
|---|---:|
| Total Revenue | $23,522.38 |
| Total Profit | $9,224.05 |
| Profit Margin % | 39.2% |
| Total Orders | 50 |
| Average Order Value | $470.45 |
| Customer Count | 32 |
| Repeat Customer % | 56.2% |
| Return Rate % | 15.7% |
| Inventory Risk Count | 14 |

## Repository Structure

```text
Retail-Enterprise-Analytics/
|-- Dataset/
|   |-- DimCustomer.csv
|   |-- DimProduct.csv
|   |-- DimStore.csv
|   |-- DimRegion.csv
|   |-- DimDate.csv
|   |-- FactSales.csv
|   |-- FactReturns.csv
|   |-- FactInventory.csv
|   `-- data_dictionary.md
|-- SQL/
|   |-- 01_create_database_tables.sql
|   |-- 02_insert_sample_data.sql
|   `-- 03_bi_queries.sql
|-- PowerBI/
|   |-- Advanced_Features_Guide.md
|   |-- DAX_Measures.md
|   |-- Dashboard_Design_Spec.md
|   |-- Data_Model_Guide.md
|   |-- M_Transformations.pq
|   `-- Power_Query_Guide.md
|-- Documentation/
|   |-- Business_Insights_Report.md
|   |-- Dataset_Architecture.md
|   |-- ETL_Design.md
|   |-- Executive_Project_Overview.md
|   `-- Interview_Talking_Points.md
|-- Images/
|   |-- er_diagram.mmd
|   |-- er_diagram.svg
|   |-- star_schema_model.mmd
|   `-- star_schema_model.svg
`-- README.md
```

## Tech Stack

- SQL Server / T-SQL
- Power BI Desktop
- Power Query
- DAX
- Star Schema Modeling
- Data Storytelling
- CSV sample data
- Mermaid/SVG diagrams

## Installation Steps

### Quick Power BI Project Option

Open this file in Power BI Desktop:

```text
PowerBI/RetailEnterpriseAnalytics_PBIP/RetailEnterpriseAnalytics.pbip
```

The PBIP project already contains CSV connections, the semantic model, relationships, DAX measures, and five named dashboard pages.

### Manual SQL / CSV Option

1. Clone or download this repository.
2. Open SQL Server Management Studio or Azure Data Studio.
3. Run `SQL/01_create_database_tables.sql`.
4. Run `SQL/02_insert_sample_data.sql`.
5. Use `SQL/03_bi_queries.sql` to validate analytical outputs.
6. Open Power BI Desktop.
7. Load the CSV files from the `Dataset` folder or connect to the SQL Server database.
8. Apply the Power Query transformations from `PowerBI/Power_Query_Guide.md`.
9. Create relationships using `PowerBI/Data_Model_Guide.md`.
10. Create measures using `PowerBI/DAX_Measures.md`.
11. Build dashboard pages using `PowerBI/Dashboard_Design_Spec.md`.

## Screenshots Placeholder

Add screenshots after building the `.pbix` report:

- Executive Summary dashboard
- Sales Performance dashboard
- Customer Intelligence dashboard
- Inventory & Operations dashboard
- Forecasting & Strategic Insights dashboard

Suggested location: `Images/dashboard_executive_summary.png`, etc.

## Results

The included sample data and BI design support analysis of:

- Revenue and profit performance
- Regional and store-level opportunities
- Product/category growth and margin
- Customer segmentation, retention, and churn
- Return root causes and refund exposure
- Inventory risk, replenishment needs, and overstock
- Forecast revenue and target achievement

## Future Enhancements

- Add a formal `FactTargets` table for sales quotas.
- Add a promotion dimension for discount and campaign ROI.
- Add a customer cohort table for advanced retention analysis.
- Add incremental refresh using production date parameters.
- Add dynamic RLS using a user-to-region security mapping table.
- Publish to Power BI Service with scheduled refresh and deployment pipelines.

## Interview Positioning

This project demonstrates practical BI consulting skills: requirement framing, dimensional modeling, SQL development, Power Query data shaping, DAX measures, dashboard design, and executive storytelling.
