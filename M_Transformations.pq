# DAX Implementation

Create a dedicated table named `_Measures` and store all measures there. Format currency measures as currency, rate measures as percentage, and counts as whole numbers.

## Total Revenue

```DAX
Total Revenue =
SUM ( FactSales[SalesAmount] )
```

Business purpose: Measures net sales after discounts.

Explanation: Aggregates the sales amount column from the sales fact table.

## Total Profit

```DAX
Total Profit =
SUM ( FactSales[ProfitAmount] )
```

Business purpose: Measures gross profit after cost of goods sold.

Explanation: Aggregates line-level profit calculated as revenue minus cost.

## Profit Margin %

```DAX
Profit Margin % =
DIVIDE ( [Total Profit], [Total Revenue] )
```

Business purpose: Tracks profitability quality across regions, categories, and channels.

Explanation: Uses `DIVIDE` to avoid divide-by-zero errors.

## Total Orders

```DAX
Total Orders =
DISTINCTCOUNT ( FactSales[OrderID] )
```

Business purpose: Counts unique customer orders.

Explanation: Uses order ID rather than sales rows to handle multi-line orders.

## Average Order Value

```DAX
Average Order Value =
DIVIDE ( [Total Revenue], [Total Orders] )
```

Business purpose: Indicates average customer transaction value.

Explanation: Divides net revenue by distinct orders in the current filter context.

## Customer Count

```DAX
Customer Count =
DISTINCTCOUNT ( FactSales[CustomerKey] )
```

Business purpose: Measures unique purchasing customers.

Explanation: Counts customers with sales activity in the current filter context.

## Repeat Customer %

```DAX
Repeat Customer % =
VAR CustomerOrderCounts =
    ADDCOLUMNS (
        VALUES ( DimCustomer[CustomerKey] ),
        "OrderCount", CALCULATE ( [Total Orders] )
    )
VAR RepeatCustomers =
    COUNTROWS ( FILTER ( CustomerOrderCounts, [OrderCount] > 1 ) )
RETURN
    DIVIDE ( RepeatCustomers, [Customer Count] )
```

Business purpose: Measures customer stickiness and second-purchase behavior.

Explanation: Counts customers with more than one order and divides by purchasing customers.

## Customer Retention Rate

```DAX
Customer Retention Rate =
VAR CurrentCustomers =
    VALUES ( FactSales[CustomerKey] )
VAR PreviousCustomers =
    CALCULATETABLE (
        VALUES ( FactSales[CustomerKey] ),
        DATEADD ( DimDate[FullDate], -1, MONTH )
    )
VAR RetainedCustomers =
    INTERSECT ( CurrentCustomers, PreviousCustomers )
RETURN
    DIVIDE ( COUNTROWS ( RetainedCustomers ), COUNTROWS ( PreviousCustomers ) )
```

Business purpose: Shows the share of previous-period customers who returned this period.

Explanation: Compares active customers in current context with customers from the previous month.

## Customer Churn Rate

```DAX
Customer Churn Rate =
1 - [Customer Retention Rate]
```

Business purpose: Highlights customer attrition risk.

Explanation: Calculates churn as the inverse of retention.

## YoY Growth %

```DAX
YoY Growth % =
VAR PriorYearRevenue =
    CALCULATE ( [Total Revenue], SAMEPERIODLASTYEAR ( DimDate[FullDate] ) )
RETURN
    DIVIDE ( [Total Revenue] - PriorYearRevenue, PriorYearRevenue )
```

Business purpose: Tracks annual growth.

Explanation: Compares current revenue to the same period last year.

## MoM Growth %

```DAX
MoM Growth % =
VAR PriorMonthRevenue =
    CALCULATE ( [Total Revenue], DATEADD ( DimDate[FullDate], -1, MONTH ) )
RETURN
    DIVIDE ( [Total Revenue] - PriorMonthRevenue, PriorMonthRevenue )
```

Business purpose: Tracks short-term momentum.

Explanation: Compares current revenue to previous month revenue.

## Rolling 12 Month Revenue

```DAX
Rolling 12 Month Revenue =
CALCULATE (
    [Total Revenue],
    DATESINPERIOD (
        DimDate[FullDate],
        MAX ( DimDate[FullDate] ),
        -12,
        MONTH
    )
)
```

Business purpose: Smooths seasonality and shows trailing revenue health.

Explanation: Uses a rolling 12-month date window ending on the current max date.

## Top N Product Revenue

```DAX
Top N Product Revenue =
VAR SelectedN =
    SELECTEDVALUE ( 'Top N Parameter'[Top N], 10 )
VAR ProductRank =
    RANKX (
        ALLSELECTED ( DimProduct[ProductName] ),
        [Total Revenue],
        ,
        DESC,
        Dense
    )
RETURN
    IF ( ProductRank <= SelectedN, [Total Revenue] )
```

Business purpose: Supports dynamic top product analysis.

Explanation: Requires a What-if parameter table named `Top N Parameter`.

## Inventory Turnover

```DAX
Inventory Turnover =
VAR AverageInventoryValue =
    AVERAGEX (
        FactInventory,
        FactInventory[OnHandQty] * RELATED ( DimProduct[UnitCost] )
    )
RETURN
DIVIDE (
    SUM ( FactSales[CostAmount] ),
    AverageInventoryValue
)
```

Business purpose: Shows how efficiently inventory converts into sales.

Explanation: Uses cost of goods sold divided by estimated average inventory value.

## Return Rate %

```DAX
Return Rate % =
DIVIDE (
    SUM ( FactReturns[ReturnAmount] ),
    [Total Revenue]
)
```

Business purpose: Measures revenue erosion due to returns.

Explanation: Divides total return value by total revenue.

## Forecast Revenue

```DAX
Forecast Revenue =
VAR LastVisibleDate =
    MAX ( DimDate[FullDate] )
VAR LastSixMonths =
    DATESINPERIOD ( DimDate[FullDate], LastVisibleDate, -6, MONTH )
VAR MonthlyRevenue =
    SUMMARIZE (
        LastSixMonths,
        DimDate[YearNumber],
        DimDate[MonthNumber],
        "Revenue", [Total Revenue]
    )
VAR AverageMonthlyRevenue =
    AVERAGEX ( MonthlyRevenue, [Revenue] )
VAR TrendAdjustment =
    1 + COALESCE ( [MoM Growth %], 0 )
RETURN
    AverageMonthlyRevenue * TrendAdjustment
```

Business purpose: Provides a lightweight forward-looking revenue estimate.

Explanation: Uses recent monthly average revenue adjusted by current momentum.

## Revenue Target

```DAX
Revenue Target =
VAR PriorYearRevenue =
    CALCULATE ( [Total Revenue], SAMEPERIODLASTYEAR ( DimDate[FullDate] ) )
RETURN
    COALESCE ( PriorYearRevenue * 1.12, [Total Revenue] * 1.10 )
```

Business purpose: Creates a simple target when no formal target table is available.

Explanation: Uses prior year plus 12 percent or current revenue plus 10 percent as fallback.

## Sales Target Achievement %

```DAX
Sales Target Achievement % =
DIVIDE ( [Total Revenue], [Revenue Target] )
```

Business purpose: Shows progress against sales ambition.

Explanation: Divides actual revenue by the target measure.

## Customer Lifetime Value

```DAX
Customer Lifetime Value =
VAR AverageCustomerRevenue =
    AVERAGEX (
        VALUES ( DimCustomer[CustomerKey] ),
        CALCULATE ( [Total Revenue] )
    )
VAR AverageCustomerMargin =
    AVERAGEX (
        VALUES ( DimCustomer[CustomerKey] ),
        CALCULATE ( [Profit Margin %] )
    )
VAR RetentionMultiplier =
    DIVIDE ( 1, MAX ( 0.05, [Customer Churn Rate] ) )
RETURN
    AverageCustomerRevenue * AverageCustomerMargin * RetentionMultiplier
```

Business purpose: Estimates the long-term value of retained customers.

Explanation: Combines customer revenue, margin, and churn-based retention multiplier.

## Supporting Measures

```DAX
Total Units Sold =
SUM ( FactSales[Quantity] )

Total Discount =
SUM ( FactSales[DiscountAmount] )

Return Amount =
SUM ( FactReturns[ReturnAmount] )

Inventory Risk Count =
CALCULATE (
    COUNTROWS ( FactInventory ),
    FactInventory[StockStatus] IN { "Critical", "Reorder" }
)

Average Days of Supply =
AVERAGEX (
    FactInventory,
    DIVIDE ( FactInventory[OnHandQty], FactInventory[UnitsSoldLast30Days] / 30 )
)
```
