-- Week 7 Assignment: Database Design and Normalization
-- Database Systems
-- Run this script in MySQL Workbench or another MySQL environment.

-- =========================================================
-- QUESTION 1: ACHIEVING FIRST NORMAL FORM (1NF)
-- =========================================================
-- The original Products column contains comma-separated values.
-- To achieve 1NF, each row below stores exactly one product per order.
-- The composite primary key prevents the same product being repeated
-- for the same order.

DROP TABLE IF EXISTS ProductDetail_1NF;

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Check the 1NF result: every row contains one product only.
SELECT * FROM ProductDetail_1NF
ORDER BY OrderID, Product;


-- =========================================================
-- QUESTION 2: ACHIEVING SECOND NORMAL FORM (2NF)
-- =========================================================
-- Partial dependency:
-- CustomerName depends only on OrderID, not on the full composite
-- key (OrderID, Product). Therefore, CustomerName is moved to Orders.
--
-- Orders stores each order once.
-- OrderItems stores each product and its quantity for an order.
-- OrderItems uses (OrderID, Product) as its composite primary key,
-- and OrderID is a foreign key referencing Orders.

DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID)
);

CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID),
    CONSTRAINT chk_orderitems_quantity
        CHECK (Quantity > 0)
);

-- Insert each order once into Orders.
INSERT INTO Orders (OrderID, CustomerName)
VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

-- Insert the products and quantities associated with each order.
INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);

-- Check the normalized tables and their relationship.
SELECT
    Orders.OrderID,
    Orders.CustomerName,
    OrderItems.Product,
    OrderItems.Quantity
FROM Orders
INNER JOIN OrderItems
    ON Orders.OrderID = OrderItems.OrderID
ORDER BY Orders.OrderID, OrderItems.Product;
