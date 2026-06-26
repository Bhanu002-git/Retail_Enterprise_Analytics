// Power Query helper functions for the Retail Enterprise Analytics project.
// Paste into a blank query and rename functions as needed.

let
    fnCleanText = (value as nullable text) as text =>
        if value = null or Text.Trim(value) = "" then "Unknown"
        else Text.Proper(Text.Clean(Text.Trim(value))),

    fnValidateSalesAmount = (
        quantity as number,
        unitPrice as number,
        discountAmount as number,
        salesAmount as number,
        costAmount as number,
        profitAmount as number
    ) as text =>
        let
            expectedSales = quantity * unitPrice - discountAmount,
            expectedProfit = salesAmount - costAmount,
            salesValid = Number.Abs(expectedSales - salesAmount) <= 0.01,
            profitValid = Number.Abs(expectedProfit - profitAmount) <= 0.01
        in
            if salesValid and profitValid then "Valid" else "Review",

    fnInventoryStatus = (
        onHandQty as number,
        reorderPoint as number,
        safetyStockQty as number,
        unitsSoldLast30Days as number
    ) as text =>
        if onHandQty <= safetyStockQty then "Critical"
        else if onHandQty <= reorderPoint then "Reorder"
        else if onHandQty > unitsSoldLast30Days * 2.2 then "Overstock"
        else "Healthy"
in
    [
        fnCleanText = fnCleanText,
        fnValidateSalesAmount = fnValidateSalesAmount,
        fnInventoryStatus = fnInventoryStatus
    ]
