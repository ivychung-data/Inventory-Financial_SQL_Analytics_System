
# Husky Corp Operational & Financial Performance Analytics | SQL

## Project Name:
Husky Corp Operational & Financial Performance Analytics

---

## Project Overview:

This project focuses on developing and querying a structured Oracle SQL database to support inventory control, financial tracking, and operational decision making across multiple warehouses.

The system enables the company to:

- Maintain accurate stock visibility across warehouse locations  
- Monitor high-value Category A products that drive financial performance  
- Track purchase costs and sales revenue at the transaction level  
- Identify stockout risks before operational disruption  
- Analyze supplier spending and customer revenue contribution  

The objective was to apply structured SQL to answer operational and financial business questions while maintaining data integrity across interconnected tables.


---

## Key Skills Demonstrated:

- Relational database design and normalization  
- Primary and foreign key constraint implementation  
- Multi table JOIN operations  
- Filtering and sorting with conditional logic  
- Aggregate functions: SUM, AVG, MIN, MAX, COUNT  
- Date functions: MONTHS_BETWEEN, EXTRACT  
- Data manipulation: INSERT, UPDATE, DELETE  
- Transaction control: COMMIT  
- Business driven SQL analysis  

---

## Database Schema:

The database consists of 8 interconnected tables structured using normalized relational modeling principles.

| Table | Description | Key Fields |
|-------|------------|------------|
| Categories | Product classification categories | CategoryID (PK), CategoryName |
| InventoryItems | Product catalog | SKU (PK), ItemName, CategoryID (FK), UnitPrice |
| Warehouses | Storage locations | WarehouseID (PK), WarehouseName, Location |
| InventoryWarehouse | Stock levels by warehouse (junction table) | SKU (PK, FK), WarehouseID (PK, FK), StockCount |
| Suppliers | Vendor information | SupplierID (PK), SupplierName |
| Consumers | Customer information | ConsumerID (PK), ConsumerFirstName, ConsumerLastName |
| Invoices | Transaction headers | InvoiceID (PK), InvoiceDate, SupplierID (FK), ConsumerID (FK), TotalValue |
| InventoryLogs | Line level transaction details | LogID (PK), SKU (FK), InvoiceID (FK), Quantity, Value, LogType, LogDate |

The schema enforces referential integrity and resolves many to many relationships through composite primary keys.

---

## SQL Queries

### 1. Product Inventory Analysis 

Business Question: What products are currently available and how are they priced?

```sql
SELECT SKU, ItemName, UnitPrice
FROM InventoryItems;
```
Business Impact: Provides a clear view of the company’s product catalog and pricing structure. It helps management evaluate product value positioning and supports pricing strategy decisions.

### 2. High-Value Invoices for Supplier 1 

Business Question: Which invoices for Supplier ID 1 have a total value greater than 10,000?

```sql
SELECT InvoiceID, InvoiceDate, SupplierID, TotalValue
FROM Invoices
WHERE SupplierID = 1
  AND TotalValue > 10000;
```
Business Impact: Identifies major purchasing activity with a key supplier, helping track large spending, support vendor negotiation, and monitor procurement risk.

### 3. Items Sorted by Unit Price 

Business Question: Which inventory items are the most expensive based on unit price?

```sql
SELECT SKU, ItemName, UnitPrice
FROM InventoryItems
ORDER BY UnitPrice DESC;
```
Business Impact: Highlights high-value products that may require tighter controls, higher service levels, and stronger inventory monitoring.

### 4. Most Recent Invoices

Business Question: What are the most recent invoices recorded in the system?

```sql
SELECT *
FROM Invoices
ORDER BY InvoiceDate DESC;
```
Business Impact: Helps the business monitor recent financial activity and operational flow, supporting month-end review and transaction auditing.

### 5. Time Since Item Transaction

Business Question: How many months have passed since each inventory item was involved in an invoice transaction?

```sql
SELECT
  i.SKU,
  i.ItemName,
  ROUND(MONTHS_BETWEEN(SYSDATE, inv.InvoiceDate), 1) AS MonthsBetween
FROM InventoryItems i
JOIN InventoryLogs l ON l.SKU = i.SKU
JOIN Invoices inv ON inv.InvoiceID = l.InvoiceID;

```
Business Impact: Supports detection of slow-moving items and inactive inventory, helping optimize replenishment, promotions, and stock rotation.

### 6. Filtered Product Search

Business Question: Which inventory items match the criteria of price above 50, CategoryID equals 2, and contain the word 'Chair'?

```sql
SELECT *
FROM InventoryItems
WHERE UnitPrice > 50
  AND CategoryID = 2
  AND ItemName LIKE '%Chair%';
```
Business Impact: Helps narrow down specific product segments for targeted analysis, marketing decisions, and category-level pricing review.

### 7. Average Stock by Warehouse

Business Question: What is the average stock count of inventory items in each warehouse?

```sql
SELECT WarehouseID,
       AVG(StockCount) AS AvgStockCount
FROM InventoryWarehouse
GROUP BY WarehouseID;

```
Business Impact: Provides a baseline measure of how inventory is distributed across warehouses, supporting capacity planning and warehouse balancing decisions.

### 8. Unique Consumers in 2023

Business Question: How many unique consumers made purchases in 2023?

```sql
SELECT COUNT(DISTINCT ConsumerID) AS UniqueConsumers
FROM Invoices
WHERE ConsumerID IS NOT NULL
  AND EXTRACT(YEAR FROM InvoiceDate) = 2023;
```
Business Impact: Measures customer activity and reach for the year, supporting performance tracking, retention analysis, and growth reporting.

### 9. Category Price Range

Business Question: What are the minimum and maximum unit prices of items within each category?

```sql
SELECT CategoryID,
       MIN(UnitPrice) AS MinUnitPrice,
       MAX(UnitPrice) AS MaxUnitPrice
FROM InventoryItems
GROUP BY CategoryID;
```
Business Impact: Helps evaluate pricing spread and product positioning within categories, supporting pricing strategy and category management.

### 10. Total Revenue from Sales

Business Question: What is the total revenue generated from all sales transactions?
```sql
SELECT SUM(Quantity * Value) AS TotalRevenue
FROM InventoryLogs
WHERE LogType = 'Sale';
```
Business Impact: Provides a core sales performance metric used for revenue reporting and high-level profitability tracking.

---

## Database Management Operations

### 11. Insert New Category, Item, and Stock

Business Question: How can the business add a new product category, introduce a new product, and record its stock while ensuring data integrity?

```sql
INSERT INTO Categories (CategoryID, CategoryName)
VALUES (4, 'D');

INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice)
VALUES (1010, 'Ergonomic Chair', 4, 125.00);

INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount)
VALUES (1010, 1, 40);
```

Business Impact: Ensures new products can be added in a controlled way while keeping category relationships and warehouse stock records consistent.

### 12. Update Item Price

Business Question: How can the business update pricing when product costs or pricing strategy changes?

```sql
UPDATE InventoryItems
SET UnitPrice = 79.99
WHERE SKU = 1007;
```

Business Impact: Keeps pricing accurate for reporting, invoicing, and margin analysis, ensuring decisions are made using current product prices.

### 13. Delete Supplier Record

Business Question: How can the business remove outdated or inactive supplier records?

```sql
DELETE FROM Suppliers
WHERE SupplierID = 4;
```

Business Impact: Maintains clean master data, reduces confusion in reporting, and ensures supplier lists reflect current vendor relationships.

### 14. Commit the Changes

Business Question: How does the database ensure changes are saved and finalized after updates?

```sql
COMMIT;
```

Business Impact: Confirms all inserts, updates, and deletes are permanently saved, protecting transaction integrity and preventing accidental data loss.

---

## Complex Join Queries

---

### 15. Consumer Spending Summary

Business Question: Which consumers have made purchases and what is the total value of their invoices?

```sql
SELECT
  c.ConsumerID,
  c.ConsumerFirstName,
  SUM(inv.TotalValue) AS TotalInvoiceValue
FROM Consumers c
JOIN Invoices inv ON inv.ConsumerID = c.ConsumerID
GROUP BY c.ConsumerID, c.ConsumerFirstName;
```
Business Impact: Identifies high-value consumers and supports customer segmentation, loyalty strategies, and revenue concentration analysis.

### 16. Low Stock Items Across Warehouses

Business Question: Which items have stock levels below 20 and where are they stored?

```sql
SELECT
  w.WarehouseName,
  i.ItemName,
  iw.StockCount
FROM InventoryWarehouse iw
JOIN Warehouses w ON w.WarehouseID = iw.WarehouseID
JOIN InventoryItems i ON i.SKU = iw.SKU
WHERE iw.StockCount < 20;
```
Business Impact: Flags replenishment risk early, helping prevent stockouts and operational disruption.

### 17. Category A Item Stock Visibility

Business Question: Where are Category A items located and what are their stock levels?

```sql
SELECT
  i.SKU,
  i.ItemName,
  iw.StockCount,
  w.WarehouseName
FROM InventoryItems i
JOIN InventoryWarehouse iw ON iw.SKU = i.SKU
JOIN Warehouses w ON w.WarehouseID = iw.WarehouseID
WHERE i.CategoryID = 1;
```
Business Impact: Helps prioritize monitoring of high-value inventory, reducing risk of stockouts for critical products and improving service levels.


---

## Operational & Financial Impact

### Inventory Optimization 
- Identified slow-moving SKUs and low-stock risks to support proactive replenishment and inventory control.

### Procurement Oversight 
- Analyzed high-value supplier transactions to enhance cost transparency and vendor performance evaluation.

### Revenue & Customer Analysis 
- Quantified total sales revenue and assessed customer contribution to overall financial performance.

### Pricing & Category Assessment 
- Evaluated price dispersion across product categories to inform pricing and portfolio decisions.

### Data Governance 
- Ensured database integrity through disciplined use of relational constraints and transaction management.

---

## Key takeaways

### Advanced SQL Application
- Demonstrated proficiency in Oracle SQL, including multi-table joins, aggregations, conditional filtering, date functions, and transaction control.

### Relational Database Expertise
- Applied normalized schema design principles, leveraging primary keys, foreign keys, and junction tables to maintain data integrity and support scalable querying.

### Business-Oriented Analytics
- Translated operational requirements into structured SQL queries that generate measurable insights across inventory, procurement, and revenue performance.

### Operational & Financial Alignment
- Connected transactional data to business performance metrics, reinforcing how inventory systems directly influence cost management and revenue outcomes.

### Analytical Rigor & Data Governance
- Maintained consistency and reliability of the database through disciplined data manipulation and integrity enforcement.








































