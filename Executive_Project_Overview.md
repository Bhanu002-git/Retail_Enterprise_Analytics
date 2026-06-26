# ETL Design

## Overview

The ETL workflow simulates a real corporate BI implementation where POS, e-commerce, returns, CRM, product master, store master, and inventory feeds are extracted into a curated reporting model.

## Extract

| Source Feed | Example Source | Frequency | Target Table |
|---|---|---|---|
| POS Sales | Store transaction exports | Daily | FactSales |
| E-Commerce Orders | Web/mobile order management system | Daily | FactSales |
| Returns | Customer service and POS return system | Daily | FactReturns |
| Inventory Snapshot | Warehouse/store inventory system | Daily or intraday | FactInventory |
| Customer Master | CRM/CDP | Daily | DimCustomer |
| Product Master | Merchandising/PIM | Daily | DimProduct |
| Store Master | Operations master data | Weekly or ad hoc | DimStore |
| Calendar | Generated date dimension | Static/annual refresh | DimDate |

## Transform

### Data Cleansing

- Trim leading/trailing spaces from text columns.
- Standardize casing for categories, regions, channels, and statuses.
- Convert dates to ISO format and Power BI Date type.
- Convert currency fields to fixed decimal type.
- Convert indicators such as `MarketingOptIn` and `DiscontinuedFlag` to Boolean/whole number.

### Duplicate Handling

- De-duplicate dimensions by business keys such as `CustomerID`, `SKU`, and `StoreCode`.
- De-duplicate facts by transaction business keys such as `OrderID` plus product and store.
- Use latest update timestamp in production. This sample uses stable surrogate keys.

### Missing Values

- Required keys should not be null. Reject records with missing dimension keys into an exception table.
- Missing optional attributes should be replaced with `Unknown` to avoid blank slicer values.
- Missing cost or price values should be quarantined because they impact profitability.

### Data Validation

- Sales amount must equal `Quantity * UnitPrice - DiscountAmount` within tolerance.
- Profit amount must equal `SalesAmount - CostAmount`.
- Return amount must not exceed original sales amount.
- Inventory quantity fields must be non-negative.
- Product list price must be greater than or equal to unit cost.

### Data Quality Checks

| Check | Rule | Action |
|---|---|---|
| Referential Integrity | Every fact key exists in its related dimension. | Reject or map to Unknown member. |
| Amount Reconciliation | Calculated sales/profit equals stored value. | Flag mismatch for finance review. |
| Negative Inventory | Inventory fields must be >= 0. | Reject snapshot row. |
| Duplicate Sales | Same order/product/store/date should not duplicate. | Keep latest, log duplicate. |
| Return Control | Return amount cannot exceed sale amount. | Flag for returns audit. |

## Load

- Load dimensions first: Date, Region, Product, Store, Customer.
- Load facts second: Sales, Returns, Inventory.
- In Power BI, disable auto date/time and use `DimDate` as the marked date table.
- In SQL Server, enforce primary keys, foreign keys, and check constraints.
- In production, use incremental load windows for FactSales, FactReturns, and FactInventory.

## Orchestration Pattern

1. Land raw files in a staging area.
2. Validate schema and required columns.
3. Apply cleansing and standardization.
4. Load/update dimensions using business keys.
5. Load fact tables after dimension lookups.
6. Refresh Power BI semantic model.
7. Run data quality report and notify owners of exceptions.
