# Dashboard Design Specification

## Shared Design System

- Canvas: 16:9 executive layout, 1280 x 720.
- Palette: Deep navy `#1F2937`, retail teal `#008C8C`, profit green `#2E7D32`, warning amber `#F59E0B`, risk red `#C62828`, neutral gray `#F3F4F6`, white `#FFFFFF`.
- Typography: Segoe UI or Aptos. Use bold headings, compact labels, and consistent KPI formatting.
- Slicers: Date, Region, Store Type, Product Category, Customer Segment, Channel.
- Navigation: Button-based tabs for the five report pages.

## Dashboard 1: Executive Summary

### Layout

- Top row: KPI cards for Revenue, Profit, Margin, Orders, Customers, Return Rate.
- Middle left: Revenue and profit trend by month.
- Middle right: Region contribution matrix with revenue, profit, margin, return rate.
- Bottom left: Category revenue and margin combo chart.
- Bottom right: Inventory risk and return risk alert list.

### Visuals

- Cards with conditional indicators.
- Line and clustered column chart.
- Matrix with conditional formatting.
- Bar chart for category performance.
- Alert table with traffic-light status.

### Business Insights

- Identifies whether growth is profitable or discount-driven.
- Connects financial performance with operational risk.
- Gives executives a single weekly trading review page.

## Dashboard 2: Sales Performance

### Layout

- Left slicer rail: Region, category, channel, date.
- Top: Revenue, units sold, AOV, discount value.
- Center: Regional sales map or filled shape map.
- Right: Top and bottom product ranking.
- Bottom: Store performance by revenue and margin.

### Visuals

- Filled map or bar chart by region.
- Decomposition tree for revenue drivers.
- Product ranking tables with Top N parameter.
- Scatter chart: revenue vs margin by store.

### Business Insights

- Reveals which regions and stores are growing.
- Separates volume-led growth from margin-led growth.
- Helps merchandising identify products to scale or rationalize.

## Dashboard 3: Customer Intelligence

### Layout

- Top row: customer count, repeat customer %, retention rate, churn rate, CLV.
- Left: Customer segment distribution.
- Center: Retention trend and cohort-style matrix.
- Right: Loyalty tier performance.
- Bottom: Customer action list for VIP, nurture, and win-back campaigns.

### Visuals

- KPI cards.
- Stacked bar by segment.
- Line chart for retention/churn.
- Matrix by segment and loyalty tier.
- Customer table with conditional action segment.

### Business Insights

- Shows which customer segments have the highest value.
- Highlights churn risk and second-purchase gaps.
- Gives marketing a campaign-ready prioritization view.

## Dashboard 4: Inventory & Operations

### Layout

- Top row: inventory risk count, critical items, reorder items, overstock items, return rate.
- Left: Inventory status by category.
- Center: Days of supply by product/store.
- Right: Return reasons and refund status.
- Bottom: Store operations matrix for stock status and fulfillment.

### Visuals

- KPI cards with red/amber/green status.
- Bar chart for stock status.
- Heatmap-style matrix for store/product risk.
- Return reason Pareto chart.
- Drill-through table for replenishment action.

### Business Insights

- Flags where stockouts may reduce sales.
- Flags overstock items that may need transfer or markdown.
- Connects returns to product and fulfillment root causes.

## Dashboard 5: Forecasting & Strategic Insights

### Layout

- Top row: forecast revenue, sales target achievement %, YoY growth %, MoM growth %.
- Center: Actual revenue vs forecast and target.
- Left: Region opportunity quadrant.
- Right: Category growth and margin bubble chart.
- Bottom: Strategic recommendation table.

### Visuals

- Forecast line chart.
- KPI gauge or bullet chart for target achievement.
- Scatter chart: growth vs margin, sized by revenue.
- Risk/opportunity matrix.
- Executive recommendation table.

### Business Insights

- Prioritizes regions and categories with scalable profitable growth.
- Identifies risk areas requiring operational or commercial intervention.
- Gives leadership a clear next-quarter action list.
