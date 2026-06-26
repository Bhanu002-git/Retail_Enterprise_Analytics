/*
Retail Enterprise Performance Analytics & Customer Intelligence Dashboard
SQL Server implementation script

Purpose:
- Create a clean BI reporting database
- Implement fact and dimension tables using a star schema
- Enforce primary and foreign key relationships for data quality
*/

IF DB_ID('RetailEnterpriseAnalytics') IS NULL
    CREATE DATABASE RetailEnterpriseAnalytics;
GO

USE RetailEnterpriseAnalytics;
GO

CREATE TABLE dbo.DimDate (
    DateKey INT NOT NULL PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayName VARCHAR(12) NOT NULL,
    WeekNumber INT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(12) NOT NULL,
    QuarterNumber INT NOT NULL,
    YearNumber INT NOT NULL,
    IsWeekend BIT NOT NULL,
    FiscalYear INT NOT NULL
);

CREATE TABLE dbo.DimRegion (
    RegionKey INT NOT NULL PRIMARY KEY,
    RegionName VARCHAR(30) NOT NULL,
    TerritoryName VARCHAR(80) NOT NULL,
    Country VARCHAR(60) NOT NULL,
    StateName VARCHAR(60) NOT NULL,
    City VARCHAR(60) NOT NULL,
    MarketTier VARCHAR(20) NOT NULL,
    RegionalManager VARCHAR(80) NOT NULL
);

CREATE TABLE dbo.DimProduct (
    ProductKey INT NOT NULL PRIMARY KEY,
    SKU VARCHAR(30) NOT NULL UNIQUE,
    ProductName VARCHAR(120) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Subcategory VARCHAR(50) NOT NULL,
    Brand VARCHAR(60) NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,
    ListPrice DECIMAL(10,2) NOT NULL,
    LaunchDate DATE NOT NULL,
    DiscontinuedFlag BIT NOT NULL,
    CONSTRAINT CK_DimProduct_Price CHECK (ListPrice >= UnitCost AND UnitCost >= 0)
);

CREATE TABLE dbo.DimStore (
    StoreKey INT NOT NULL PRIMARY KEY,
    StoreCode VARCHAR(20) NOT NULL UNIQUE,
    StoreName VARCHAR(120) NOT NULL,
    RegionKey INT NOT NULL,
    StoreType VARCHAR(40) NOT NULL,
    OpeningDate DATE NOT NULL,
    SquareFeet INT NOT NULL,
    StoreManager VARCHAR(80) NOT NULL,
    Channel VARCHAR(40) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    CONSTRAINT FK_DimStore_DimRegion
        FOREIGN KEY (RegionKey) REFERENCES dbo.DimRegion(RegionKey)
);

CREATE TABLE dbo.DimCustomer (
    CustomerKey INT NOT NULL PRIMARY KEY,
    CustomerID VARCHAR(30) NOT NULL UNIQUE,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(30) NOT NULL,
    Age INT NOT NULL,
    Email VARCHAR(120) NOT NULL,
    City VARCHAR(60) NOT NULL,
    StateName VARCHAR(60) NOT NULL,
    RegionKey INT NOT NULL,
    Segment VARCHAR(40) NOT NULL,
    LoyaltyTier VARCHAR(30) NOT NULL,
    SignupDate DATE NOT NULL,
    MarketingOptIn BIT NOT NULL,
    CONSTRAINT CK_DimCustomer_Age CHECK (Age BETWEEN 13 AND 110),
    CONSTRAINT FK_DimCustomer_DimRegion
        FOREIGN KEY (RegionKey) REFERENCES dbo.DimRegion(RegionKey)
);

CREATE TABLE dbo.FactSales (
    SalesKey INT NOT NULL PRIMARY KEY,
    OrderID VARCHAR(30) NOT NULL,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    StoreKey INT NOT NULL,
    RegionKey INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    DiscountAmount DECIMAL(12,2) NOT NULL,
    SalesAmount DECIMAL(12,2) NOT NULL,
    CostAmount DECIMAL(12,2) NOT NULL,
    ProfitAmount DECIMAL(12,2) NOT NULL,
    PaymentMethod VARCHAR(40) NOT NULL,
    OrderChannel VARCHAR(30) NOT NULL,
    FulfillmentStatus VARCHAR(40) NOT NULL,
    CONSTRAINT CK_FactSales_PositiveAmounts CHECK (
        Quantity > 0 AND UnitPrice >= 0 AND DiscountAmount >= 0 AND SalesAmount >= 0 AND CostAmount >= 0
    ),
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_DimStore FOREIGN KEY (StoreKey) REFERENCES dbo.DimStore(StoreKey),
    CONSTRAINT FK_FactSales_DimRegion FOREIGN KEY (RegionKey) REFERENCES dbo.DimRegion(RegionKey)
);

CREATE TABLE dbo.FactReturns (
    ReturnKey INT NOT NULL PRIMARY KEY,
    ReturnID VARCHAR(30) NOT NULL,
    SalesKey INT NOT NULL,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    StoreKey INT NOT NULL,
    QuantityReturned INT NOT NULL,
    ReturnAmount DECIMAL(12,2) NOT NULL,
    ReturnReason VARCHAR(80) NOT NULL,
    RefundStatus VARCHAR(40) NOT NULL,
    CONSTRAINT CK_FactReturns_PositiveAmounts CHECK (QuantityReturned > 0 AND ReturnAmount >= 0),
    CONSTRAINT FK_FactReturns_FactSales FOREIGN KEY (SalesKey) REFERENCES dbo.FactSales(SalesKey),
    CONSTRAINT FK_FactReturns_DimDate FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactReturns_DimCustomer FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactReturns_DimProduct FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey),
    CONSTRAINT FK_FactReturns_DimStore FOREIGN KEY (StoreKey) REFERENCES dbo.DimStore(StoreKey)
);

CREATE TABLE dbo.FactInventory (
    InventoryKey INT NOT NULL PRIMARY KEY,
    DateKey INT NOT NULL,
    ProductKey INT NOT NULL,
    StoreKey INT NOT NULL,
    RegionKey INT NOT NULL,
    OnHandQty INT NOT NULL,
    ReorderPoint INT NOT NULL,
    SafetyStockQty INT NOT NULL,
    UnitsSoldLast30Days INT NOT NULL,
    UnitsReceived INT NOT NULL,
    StockStatus VARCHAR(30) NOT NULL,
    CONSTRAINT CK_FactInventory_NonNegative CHECK (
        OnHandQty >= 0 AND ReorderPoint >= 0 AND SafetyStockQty >= 0 AND
        UnitsSoldLast30Days >= 0 AND UnitsReceived >= 0
    ),
    CONSTRAINT FK_FactInventory_DimDate FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactInventory_DimProduct FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey),
    CONSTRAINT FK_FactInventory_DimStore FOREIGN KEY (StoreKey) REFERENCES dbo.DimStore(StoreKey),
    CONSTRAINT FK_FactInventory_DimRegion FOREIGN KEY (RegionKey) REFERENCES dbo.DimRegion(RegionKey)
);

CREATE INDEX IX_FactSales_Date ON dbo.FactSales(DateKey);
CREATE INDEX IX_FactSales_Customer ON dbo.FactSales(CustomerKey);
CREATE INDEX IX_FactSales_Product ON dbo.FactSales(ProductKey);
CREATE INDEX IX_FactSales_Store ON dbo.FactSales(StoreKey);
CREATE INDEX IX_FactReturns_Date ON dbo.FactReturns(DateKey);
CREATE INDEX IX_FactInventory_ProductStore ON dbo.FactInventory(ProductKey, StoreKey);
GO
