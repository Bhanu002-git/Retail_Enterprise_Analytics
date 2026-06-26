# Power BI Data Model Guide

## Star Schema Design

Build the model using five dimensions around three fact tables:

- Dimensions: `DimDate`, `DimCustomer`, `DimProduct`, `DimStore`, `DimRegion`
- Facts: `FactSales`, `FactReturns`, `FactInventory`

Keep dimensions denormalized enough for reporting. For example, product category and subcategory remain in `DimProduct`; market tier and regional manager remain in `DimRegion`.

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Filter Direction | Active |
|---|---|---|---|---|---|---|
| DimDate | DateKey | FactSales | DateKey | 1:* | Single | Yes |
| DimDate | DateKey | FactReturns | DateKey | 1:* | Single | Yes |
| DimDate | DateKey | FactInventory | DateKey | 1:* | Single | Yes |
| DimCustomer | CustomerKey | FactSales | CustomerKey | 1:* | Single | Yes |
| DimCustomer | CustomerKey | FactReturns | CustomerKey | 1:* | Single | Yes |
| DimProduct | ProductKey | FactSales | ProductKey | 1:* | Single | Yes |
| DimProduct | ProductKey | FactReturns | ProductKey | 1:* | Single | Yes |
| DimProduct | ProductKey | FactInventory | ProductKey | 1:* | Single | Yes |
| DimStore | StoreKey | FactSales | StoreKey | 1:* | Single | Yes |
| DimStore | StoreKey | FactReturns | StoreKey | 1:* | Single | Yes |
| DimStore | StoreKey | FactInventory | StoreKey | 1:* | Single | Yes |
| DimRegion | RegionKey | FactSales | RegionKey | 1:* | Single | Yes |
| DimRegion | RegionKey | FactInventory | RegionKey | 1:* | Single | Yes |
| DimRegion | RegionKey | DimCustomer | RegionKey | 1:* | Single | Optional |
| DimRegion | RegionKey | DimStore | RegionKey | 1:* | Single | Optional |

## Cardinality

All reporting relationships should be one-to-many from dimension to fact. Avoid many-to-many relationships. If a future business requirement introduces multi-region customers, create a bridge table instead of using bidirectional filters.

## Filter Direction

Use single-direction filtering from dimensions to facts. This keeps DAX measures predictable, reduces ambiguity, and follows Power BI modeling best practices.

## Date Table

- Mark `DimDate[FullDate]` as the official date table.
- Sort `DimDate[MonthName]` by `DimDate[MonthNumber]`.
- Sort custom labels using numeric sequence columns.
- Disable Power BI auto date/time.

## Best Practices

- Hide surrogate key columns from report view after relationships are created.
- Hide technical validation columns unless used by developers.
- Use a dedicated measures table named `_Measures`.
- Format currency and percentage measures consistently.
- Create display folders: `Revenue`, `Profitability`, `Customer`, `Inventory`, `Time Intelligence`, `Forecast`.
- Use explicit DAX measures, not implicit aggregation in visuals.
- Keep star schema simple before adding advanced calculation groups.

## Model Diagram

See `Images/star_schema_model.mmd` and `Images/star_schema_model.svg`.
