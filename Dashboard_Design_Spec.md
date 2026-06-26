# Advanced Power BI Features

## Drill Through

Implementation steps:

1. Create drill-through pages for `Product Detail`, `Customer Detail`, and `Store Detail`.
2. Add the relevant key or name field to the Drill-through well.
3. Add contextual visuals such as trend, margin, returns, and inventory status.
4. Add a back button using Power BI's built-in back action.

Recommended use:

- Right-click a product on the Sales Performance page to inspect product return reasons and margin.
- Right-click a store to inspect fulfillment status and inventory risk.

## Bookmarks

Implementation steps:

1. Create alternate states for executive view, operations view, and finance view.
2. Open the Bookmarks pane and capture each state.
3. Use buttons to switch between bookmarks.
4. Turn off Data in bookmark settings when you only want to save visibility/layout.

Recommended use:

- Toggle between revenue-focused and profit-focused charts on the Executive Summary page.

## Report Page Tooltips

Implementation steps:

1. Create a tooltip page and set Page Information > Tooltip to On.
2. Set canvas size to Tooltip.
3. Add compact visuals for revenue, profit margin, return rate, and inventory risk.
4. Assign the tooltip page to product, store, and region visuals.

Recommended use:

- Hover over product rankings to show margin, return rate, and inventory status.

## Dynamic Titles

Example DAX:

```DAX
Executive Title =
"Retail Performance - "
    & COALESCE ( SELECTEDVALUE ( DimRegion[RegionName] ), "All Regions" )
    & " | "
    & FORMAT ( MIN ( DimDate[FullDate] ), "MMM d, yyyy" )
    & " to "
    & FORMAT ( MAX ( DimDate[FullDate] ), "MMM d, yyyy" )
```

Implementation steps:

1. Create a title measure.
2. Select a visual title.
3. Click conditional formatting.
4. Bind the title to the measure.

## Field Parameters

Implementation steps:

1. Use Modeling > New parameter > Fields.
2. Add fields such as Category, Subcategory, Brand, Region, Store Type, Customer Segment.
3. Place the parameter in slicers and chart axes.
4. Rename it to `Analysis Dimension Parameter`.

Recommended use:

- Let users switch a bar chart between product, customer, region, and store views.

## Row Level Security

Example roles:

- `Executive`: access to all regions.
- `Regional Manager`: filtered to assigned `DimRegion[RegionName]`.
- `Store Manager`: filtered to assigned `DimStore[StoreCode]`.

Example DAX filter for a regional role:

```DAX
DimRegion[RegionName] = "West"
```

Production approach:

- Create a security mapping table with user email and region/store assignment.
- Use `USERPRINCIPALNAME()` to dynamically filter the model.

## Incremental Refresh

Implementation steps:

1. Create Power Query parameters `RangeStart` and `RangeEnd` as Date/Time.
2. Filter `FactSales`, `FactReturns`, and `FactInventory` date fields using these parameters.
3. In table settings, configure incremental refresh.
4. Store five years and refresh the latest seven days for sales/returns.
5. For inventory, store two years and refresh the latest two days.

## Navigation Buttons

Implementation steps:

1. Add a top navigation bar with five buttons.
2. Assign each button to a page navigation action.
3. Use consistent active/inactive states.
4. Add a home button and reset filter button.
