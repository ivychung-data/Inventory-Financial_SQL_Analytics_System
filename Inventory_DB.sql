-- CREATE TABLES FOR INVENTORY DATABASE

-- 0. Uncomment and run while recreating the database
-- DROP TABLE InventoryLogs CASCADE CONSTRAINTS;
-- DROP TABLE Invoices CASCADE CONSTRAINTS;
-- DROP TABLE Consumers CASCADE CONSTRAINTS;
-- DROP TABLE Suppliers CASCADE CONSTRAINTS;
-- DROP TABLE InventoryWarehouse CASCADE CONSTRAINTS;
-- DROP TABLE Warehouses CASCADE CONSTRAINTS;
-- DROP TABLE InventoryItems CASCADE CONSTRAINTS;
-- DROP TABLE Categories CASCADE CONSTRAINTS;

-- 1. Categories Table
CREATE TABLE Categories (
    CategoryID NUMBER NOT NULL,
    CategoryName VARCHAR2(100) NOT NULL,
    CONSTRAINT Categories_PK PRIMARY KEY(CategoryID)
);

-- 2. Inventory Items Table
CREATE TABLE InventoryItems (
    SKU NUMBER NOT NULL,
    ItemName VARCHAR2(100) NOT NULL,
    CategoryID NUMBER,
    UnitPrice NUMBER(10, 2),
    CONSTRAINT InventoryItems_PK PRIMARY KEY(SKU),
    CONSTRAINT InventoryItems_FK_Category FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID)
);

-- 3. Warehouses Table
CREATE TABLE Warehouses (
    WarehouseID NUMBER NOT NULL,
    WarehouseName VARCHAR2(100) NOT NULL,
    Location VARCHAR2(200),
    CONSTRAINT Warehouses_PK PRIMARY KEY(WarehouseID)
);

-- 4. Inventory-Warehouse Table (Junction Table for Inventory Warehouse Many-to-Many relationship)
CREATE TABLE InventoryWarehouse (
    SKU NUMBER NOT NULL,
    WarehouseID NUMBER NOT NULL,
    StockCount NUMBER,
    CONSTRAINT ProductWarehouse_PK PRIMARY KEY(SKU, WarehouseID),
    CONSTRAINT ProductWarehouse_FK_InventoryItems FOREIGN KEY(SKU) REFERENCES InventoryItems(SKU),
    CONSTRAINT ProductWarehouse_FK_Warehouses FOREIGN KEY(WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- 5. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID NUMBER NOT NULL,
    SupplierName VARCHAR2(100) NOT NULL,
    SupplierEmail VARCHAR2(100),
    SupplierPhone VARCHAR2(15),
    CONSTRAINT Suppliers_PK PRIMARY KEY(SupplierID)
);

-- 6. Consumers Table
CREATE TABLE Consumers (
    ConsumerID NUMBER NOT NULL,
    ConsumerFirstName VARCHAR2(100) NOT NULL,
    ConsumerLastName VARCHAR2(100) NOT NULL,
    ConsumerEmail VARCHAR2(100),
    ConsumerPhone VARCHAR2(15),
    CONSTRAINT Consumers_PK PRIMARY KEY(ConsumerID)
);

-- 7. Invoices Table
CREATE TABLE Invoices (
    InvoiceID NUMBER NOT NULL,
    InvoiceDate DATE NOT NULL,
    SupplierID NUMBER,
    ConsumerID NUMBER,
    TotalValue NUMBER(10, 2),
    CONSTRAINT Invoices_PK PRIMARY KEY(InvoiceID),
    CONSTRAINT Invoices_FK_Supplier FOREIGN KEY(SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT Invoices_FK_Consumer FOREIGN KEY(ConsumerID) REFERENCES Consumers(ConsumerID)
);

-- 8. Inventory Logs Table
CREATE TABLE InventoryLogs (
    LogID NUMBER NOT NULL,
    SKU NUMBER NOT NULL,
    InvoiceID NUMBER NOT NULL,
    Quantity NUMBER,
    Value NUMBER(10, 2),
    LogType VARCHAR2(20) CHECK (LogType IN ('Purchase', 'Sale')),
    LogDate DATE NOT NULL,
    CONSTRAINT InventoryLogs_PK PRIMARY KEY(LogID),
    CONSTRAINT InventoryLogs_FK_Invoice FOREIGN KEY(InvoiceID) REFERENCES Invoices(InvoiceID),
    CONSTRAINT InventoryLogs_FK_InventoryItems FOREIGN KEY(SKU) REFERENCES InventoryItems(SKU)
);

COMMIT;

-- INSERT DATA INTO INVENTORY DATABASE

-- 1. Categories Table (with A, B, C categories)
INSERT INTO Categories (CategoryID, CategoryName) VALUES (1, 'A');
INSERT INTO Categories (CategoryID, CategoryName) VALUES (2, 'B');
INSERT INTO Categories (CategoryID, CategoryName) VALUES (3, 'C');

-- 2. InventoryItems Table (with A, B, C categories and updated UnitPrices)
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1001, 'Laptop', 1, 1200.00);  -- A category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1002, 'Smartphone', 1, 800.00);  -- A category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1003, 'Office Chair', 2, 150.00);  -- B category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1004, 'T-Shirt', 3, 20.00);  -- C category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1005, 'Monitor', 1, 250.00);  -- A category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1006, 'Desk Lamp', 2, 49.36);  -- B category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1007, 'Headphones', 3, 75.00);  -- C category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1008, 'Table', 2, 65.66);  -- B category
INSERT INTO InventoryItems (SKU, ItemName, CategoryID, UnitPrice) VALUES (1009, 'Chair', 2, 120.00);  -- B category

-- 3. Warehouses Table
INSERT INTO Warehouses (WarehouseID, WarehouseName, Location) VALUES (1, 'Main Warehouse', 'New York');
INSERT INTO Warehouses (WarehouseID, WarehouseName, Location) VALUES (2, 'West Coast Warehouse', 'Los Angeles');
INSERT INTO Warehouses (WarehouseID, WarehouseName, Location) VALUES (3, 'Midwest Warehouse', 'Chicago');

-- 4. ProductWarehouse Table (with more data)
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1001, 1, 50);  -- Laptop in Main Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1001, 2, 20);  -- Laptop in West Coast Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1002, 1, 30);  -- Smartphone in Main Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1003, 3, 40);  -- Office Chair in Midwest Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1004, 3, 100); -- T-Shirt in Midwest Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1005, 2, 15);  -- Monitor in West Coast Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1006, 3, 60);  -- Desk Lamp in Midwest Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1007, 1, 25);  -- Headphones in Main Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1008, 3, 10);  -- Table in Midwest Warehouse
INSERT INTO InventoryWarehouse (SKU, WarehouseID, StockCount) VALUES (1009, 2, 50);  -- Chair in West Coast Warehouse

-- 5. Suppliers Table
INSERT INTO Suppliers (SupplierID, SupplierName, SupplierEmail, SupplierPhone) VALUES (1, 'Tech Supplies Inc.', 'contact@techsupplies.com', '123-456-7890');
INSERT INTO Suppliers (SupplierID, SupplierName, SupplierEmail, SupplierPhone) VALUES (2, 'Office World', 'sales@officeworld.com', '555-123-4567');
INSERT INTO Suppliers (SupplierID, SupplierName, SupplierEmail, SupplierPhone) VALUES (3, 'Apparel Co.', 'contact@apparelco.com', '987-654-3210');
INSERT INTO Suppliers (SupplierID, SupplierName, SupplierEmail, SupplierPhone) VALUES (4, 'Tech Gadgets Ltd.', 'sales@techgadgets.com', '333-444-5555');

-- 6. Consumers Table
INSERT INTO Consumers (ConsumerID, ConsumerFirstName, ConsumerLastName, ConsumerEmail, ConsumerPhone) VALUES (1, 'John', 'Doe', 'john@example.com', '987-654-3210');
INSERT INTO Consumers (ConsumerID, ConsumerFirstName, ConsumerLastName, ConsumerEmail, ConsumerPhone) VALUES (2, 'Jane', 'Smith', 'jane@example.com', '654-987-3210');
INSERT INTO Consumers (ConsumerID, ConsumerFirstName, ConsumerLastName, ConsumerEmail, ConsumerPhone) VALUES (3, 'Alice', 'Johnson', 'alice.johnson@email.com', '555-444-3333');
INSERT INTO Consumers (ConsumerID, ConsumerFirstName, ConsumerLastName, ConsumerEmail, ConsumerPhone) VALUES (4, 'Michael', 'Brown', 'michael.brown@email.com', '555-777-8888');
INSERT INTO Consumers (ConsumerID, ConsumerFirstName, ConsumerLastName, ConsumerEmail, ConsumerPhone) VALUES (5, 'Sophia', 'Davis', 'sophia.davis@email.com', '555-999-0000');

-- 7. Invoices Table (updated for all products to have suppliers)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (1, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 1, NULL, 12000.00);  -- Supplier for Laptop
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (2, TO_DATE('2023-08-05', 'YYYY-MM-DD'), 1, NULL, 16000.00);  -- Supplier for Smartphone
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (3, TO_DATE('2023-09-10', 'YYYY-MM-DD'), 2, NULL, 4000.00);  -- Supplier for Office Chair
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (4, TO_DATE('2023-09-12', 'YYYY-MM-DD'), 2, NULL, 2250.00);  -- Supplier for Desk Lamp
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (5, TO_DATE('2023-09-14', 'YYYY-MM-DD'), 3, NULL, 6000.00);  -- Supplier for T-Shirt
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (6, TO_DATE('2023-09-16', 'YYYY-MM-DD'), 1, NULL, 5000.00);  -- Supplier for Monitor
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (7, TO_DATE('2023-09-17', 'YYYY-MM-DD'), 2, NULL, 3000.00);  -- Supplier for Table
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (8, TO_DATE('2023-09-18', 'YYYY-MM-DD'), 3, NULL, 4000.00);  -- Supplier for Chair
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (9, TO_DATE('2023-09-19', 'YYYY-MM-DD'), 2, NULL, 2000.00);  -- Supplier for Headphones
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (10, TO_DATE('2023-09-20', 'YYYY-MM-DD'), NULL, 1, 6000.00); -- Sale to John Doe (Laptop)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (11, TO_DATE('2023-09-21', 'YYYY-MM-DD'), NULL, 2, 12000.00); -- Sale to Jane Smith (Smartphone)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (12, TO_DATE('2023-09-22', 'YYYY-MM-DD'), NULL, 3, 3000.00); -- Sale to Alice Johnson (Office Chair)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (13, TO_DATE('2023-09-23', 'YYYY-MM-DD'), NULL, 4, 2500.00); -- Sale to Michael Brown (Desk Lamp)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (14, TO_DATE('2023-09-24', 'YYYY-MM-DD'), NULL, 5, 3500.00); -- Sale to Sophia Davis (T-Shirt)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (15, TO_DATE('2023-09-25', 'YYYY-MM-DD'), NULL, 3, 4500.00); -- Sale to Alice Johnson (Monitor)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (16, TO_DATE('2023-09-26', 'YYYY-MM-DD'), NULL, 4, 4000.00); -- Sale to Michael Brown (Table)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (17, TO_DATE('2023-09-27', 'YYYY-MM-DD'), NULL, 1, 5000.00); -- Sale to John Doe (Chair)
INSERT INTO Invoices (InvoiceID, InvoiceDate, SupplierID, ConsumerID, TotalValue) VALUES (18, TO_DATE('2023-09-28', 'YYYY-MM-DD'), NULL, 2, 1500.00); -- Sale to Jane Smith (Headphones)

-- 8. InventoryLogs Table (ensuring all products have suppliers)
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (1, 1001, 1, 10, 12000.00, 'Purchase', TO_DATE('2023-08-01', 'YYYY-MM-DD'));  -- Laptop from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (2, 1002, 2, 20, 16000.00, 'Purchase', TO_DATE('2023-08-05', 'YYYY-MM-DD'));  -- Smartphone from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (3, 1003, 3, 40, 4000.00, 'Purchase', TO_DATE('2023-09-10', 'YYYY-MM-DD'));  -- Office Chair from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (4, 1006, 4, 60, 2250.00, 'Purchase', TO_DATE('2023-09-12', 'YYYY-MM-DD'));  -- Desk Lamp from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (5, 1004, 5, 50, 6000.00, 'Purchase', TO_DATE('2023-09-14', 'YYYY-MM-DD'));  -- T-Shirt from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (6, 1005, 6, 20, 5000.00, 'Purchase', TO_DATE('2023-09-16', 'YYYY-MM-DD'));  -- Monitor from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (7, 1008, 7, 10, 3000.00, 'Purchase', TO_DATE('2023-09-17', 'YYYY-MM-DD'));  -- Table from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (8, 1009, 8, 30, 4000.00, 'Purchase', TO_DATE('2023-09-18', 'YYYY-MM-DD'));  -- Chair from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (9, 1007, 9, 25, 2000.00, 'Purchase', TO_DATE('2023-09-19', 'YYYY-MM-DD'));  -- Headphones from Supplier
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (10, 1001, 10, 5, 6000.00, 'Sale', TO_DATE('2023-09-20', 'YYYY-MM-DD'));  -- Laptop sold to John Doe
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (11, 1002, 11, 10, 12000.00, 'Sale', TO_DATE('2023-09-21', 'YYYY-MM-DD'));  -- Smartphone sold to Jane Smith
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (12, 1003, 12, 20, 3000.00, 'Sale', TO_DATE('2023-09-22', 'YYYY-MM-DD'));  -- Office Chair sold to Alice Johnson
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (13, 1006, 13, 40, 2500.00, 'Sale', TO_DATE('2023-09-23', 'YYYY-MM-DD'));  -- Desk Lamp sold to Michael Brown
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (14, 1004, 14, 50, 3500.00, 'Sale', TO_DATE('2023-09-24', 'YYYY-MM-DD'));  -- T-Shirt sold to Sophia Davis
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (15, 1005, 15, 15, 4500.00, 'Sale', TO_DATE('2023-09-25', 'YYYY-MM-DD'));  -- Monitor sold to Alice Johnson
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (16, 1008, 16, 10, 4000.00, 'Sale', TO_DATE('2023-09-26', 'YYYY-MM-DD'));  -- Table sold to Michael Brown
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (17, 1009, 17, 10, 5000.00, 'Sale', TO_DATE('2023-09-27', 'YYYY-MM-DD'));  -- Chair sold to John Doe
INSERT INTO InventoryLogs (LogID, SKU, InvoiceID, Quantity, Value, LogType, LogDate) 
VALUES (18, 1007, 18, 5, 1500.00, 'Sale', TO_DATE('2023-09-28', 'YYYY-MM-DD'));  -- Headphones sold to Jane Smith

COMMIT;