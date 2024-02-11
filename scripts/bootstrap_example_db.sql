-- Check if the database exists, create it if it doesn't
IF NOT EXISTS (
    SELECT name
    FROM master.dbo.sysdatabases
    WHERE name = N'CarPartsInventoryDB'
)
CREATE DATABASE CarPartsInventoryDB;
GO

-- Use the newly created database
USE CarPartsInventoryDB;
GO

-- Create Inventory table
DROP TABLE IF EXISTS Inventory;
CREATE TABLE Inventory (
    PartID INT PRIMARY KEY,
    PartName NVARCHAR(100),
    Quantity INT,
    Price DECIMAL(10, 2)
);
GO

-- Create Movements table
DROP TABLE IF EXISTS Movements;
CREATE TABLE Movements (
    MovementID INT,
    PartID INT,
    MovementType NVARCHAR(50),
    MovementDate DATE,
    QuantityChanged INT,
    Location NVARCHAR(100)
);
GO

-- Insert sample data into Inventory table
TRUNCATE TABLE Inventory;
INSERT INTO Inventory (PartID, PartName, Quantity, Price)
VALUES
    (1, 'Brake Pads', 50, 35.99),
    (2, 'Oil Filter', 100, 8.49),
    (3, 'Spark Plugs', 75, 4.99),
    (4, 'Air Filter', 80, 12.99),
    (5, 'Radiator Hose', 30, 24.99),
    (6, 'Headlights', 40, 45.99),
    (7, 'Alternator', 25, 149.99),
    (8, 'Starter Motor', 20, 99.99),
    (9, 'Fuel Pump', 15, 79.99),
    (10, 'Battery', 10, 129.99);
GO

-- Insert sample data into Movements table
TRUNCATE TABLE Movements;
INSERT INTO Movements (MovementID, PartID, MovementType, MovementDate, QuantityChanged, Location)
VALUES
    (1, 1, 'Purchase', '2024-01-01', 50, 'Supplier A'),
    (2, 2, 'Purchase', '2024-01-02', 100, 'Supplier B'),
    (3, 3, 'Purchase', '2024-01-03', 75, 'Supplier C'),
    (4, 4, 'Purchase', '2024-01-04', 80, 'Supplier D'),
    (5, 5, 'Purchase', '2024-01-05', 30, 'Supplier E'),
    (6, 6, 'Purchase', '2024-01-06', 40, 'Supplier F'),
    (7, 7, 'Purchase', '2024-01-07', 25, 'Supplier G'),
    (8, 8, 'Purchase', '2024-01-08', 20, 'Supplier H'),
    (9, 9, 'Purchase', '2024-01-09', 15, 'Supplier I'),
    (10, 10, 'Purchase', '2024-01-10', 10, 'Supplier J'),
    (11, 1, 'Sale', '2024-01-11', -50, 'Customer X'), -- Adding a movement representing an out-of-stock scenario
    (12, 1, 'Purchase', '2024-01-12', 100, 'Supplier K'), -- Restocking "Brake Pads"
    (13, 1, 'Sale', '2024-01-13', -100, 'Customer Y'), -- Selling additional "Brake Pads"
    (14, 1, 'Purchase', '2024-01-14', 30, 'Supplier L'); -- Restocking "Brake Pads" again

GO
