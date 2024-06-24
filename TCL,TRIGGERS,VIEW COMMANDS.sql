CREATE DATABASE ola;

-- Using the database
USE ola;

-- Creating the Drivers table
CREATE TABLE drivers (
    did INT PRIMARY KEY,
    dname VARCHAR(50) NOT NULL,
    age INT,
    phone_no BIGINT NOT NULL
);

-- Creating the Customers table
CREATE TABLE customers (
    cid INT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    age INT,
    addr VARCHAR(100)
);

-- Creating the Rides table
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    cid INT,
    did INT,
    fare INT NOT NULL,
    FOREIGN KEY (cid) REFERENCES customers(cid),
    FOREIGN KEY (did) REFERENCES drivers(did)
);

-- Creating the Payment table
CREATE TABLE payment (
    pay_id INT PRIMARY KEY,
    ride_id INT,
    amount INT NOT NULL,
    mode VARCHAR(30) CHECK (mode IN ('upi', 'credit', 'debit')),
    status VARCHAR(30),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
);

-- Creating the Employee table
CREATE TABLE employee (
    eid INT PRIMARY KEY,
    ename VARCHAR(50) NOT NULL,
    phone_no BIGINT NOT NULL,
    department VARCHAR(50) NOT NULL,
    manager_id INT
);

-- Inserting values into Drivers table
INSERT INTO drivers VALUES (1, 'Amit', 30, 9876543210);
INSERT INTO drivers VALUES (2, 'Arpita', 25, 8765432109);
INSERT INTO drivers VALUES (3, 'Ravi', 35, 7654321098);
INSERT INTO drivers VALUES (4, 'Rohan', 28, 6543210987);
INSERT INTO drivers VALUES (5, 'Manish', 22, 5432109876);

-- Inserting values into Customers table
INSERT INTO customers VALUES (101, 'Ravi', 30, 'Mumbai');
INSERT INTO customers VALUES (102, 'Rahul', 25, 'Delhi');
INSERT INTO customers VALUES (103, 'Simran', 32, 'Bangalore');
INSERT INTO customers VALUES (104, 'Aayush', 28, 'Mumbai');
INSERT INTO customers VALUES (105, 'Tarun', 22, 'Delhi');

-- Inserting values into Rides table
INSERT INTO rides VALUES (1001, 101, 1, 500);
INSERT INTO rides VALUES (1002, 102, 2, 300);
INSERT INTO rides VALUES (1003, 103, 3, 200);
INSERT INTO rides VALUES (1004, 104, 4, 400);
INSERT INTO rides VALUES (1005, 105, 5, 150);

-- Inserting values into Payment table
INSERT INTO payment VALUES (1, 1001, 500, 'upi', 'completed');
INSERT INTO payment VALUES (2, 1002, 300, 'credit', 'completed');
INSERT INTO payment VALUES (3, 1003, 200, 'debit', 'in process');

-- Inserting values into Employee table
INSERT INTO employee VALUES (201, 'Aryan', 9876543210, 'Sales', 205);
INSERT INTO employee VALUES (202, 'Japjot', 8765432109, 'Delivery', 206);
INSERT INTO employee VALUES (203, 'Vansh', 7654321098, 'Delivery', 202);
INSERT INTO employee VALUES (204, 'Rishika', 6543210987, 'Sales', 202);
INSERT INTO employee VALUES (205, 'Sanjana', 5432109876, 'HR', 204);
INSERT INTO employee VALUES (206, 'Sanjay', 4321098765, 'Tech', NULL);

/* Triggers
Triggers are special types of stored procedures that are automatically executed or fired when certain events occur. They can be used to enforce business rules, maintain data integrity, and automatically update or validate data.

1. Trigger to Update Payment Status after a Ride is Completed
Purpose: This trigger automatically updates the payment status to 'completed' once the corresponding ride is marked as completed.

Explanation:

AFTER UPDATE: This specifies that the trigger will be executed after an update operation on the rides table.
FOR EACH ROW: This means the trigger will execute once for each row that is updated.
IF NEW.status = 'completed': Checks if the new status of the ride is 'completed'.
UPDATE payment: Updates the status field in the payment table to 'completed' for the corresponding ride.

DELIMITER //
CREATE TRIGGER update_payment_status_after_ride
AFTER UPDATE ON rides
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' THEN
        UPDATE payment
        SET status = 'completed'
        WHERE ride_id = NEW.ride_id;
    END IF;
END //
DELIMITER ;

2. Trigger to Check Driver Availability before Inserting a Ride
Purpose: This trigger checks if a driver is available before assigning them to a new ride.

Explanation:

BEFORE INSERT: This specifies that the trigger will be executed before an insert operation on the rides table.
DECLARE available_rides INT: Declares a variable to store the count of rides the driver is currently assigned to.
SELECT COUNT(*) INTO available_rides FROM rides WHERE did = NEW.did: Counts the number of rides currently assigned to the driver.
IF available_rides >= 1 THEN: Checks if the driver is already assigned to at least one ride.
SIGNAL SQLSTATE '45000': Raises an error if the driver is unavailable.

DELIMITER //
CREATE TRIGGER check_driver_availability_before_ride
BEFORE INSERT ON rides
FOR EACH ROW
BEGIN
    DECLARE available_rides INT;
    SELECT COUNT(*) INTO available_rides FROM rides WHERE did = NEW.did;
    IF available_rides >= 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Driver is currently unavailable';
    END IF;
END //
DELIMITER ;

3. Trigger to Update Customer's Address after an Order is Placed
Purpose: This trigger updates the customer's address after an order (ride) is placed.

Explanation:

AFTER INSERT: This specifies that the trigger will be executed after an insert operation on the rides table.
UPDATE customers SET addr = NEW.addr WHERE cid = NEW.cid: Updates the customer's address to the new address provided in the order.

DELIMITER //
CREATE TRIGGER update_customer_address_after_order
AFTER INSERT ON rides
FOR EACH ROW
BEGIN
    UPDATE customers
    SET addr = NEW.addr
    WHERE cid = NEW.cid;
END //
DELIMITER ;

TCL Commands
Transaction Control Language (TCL) commands manage transactions in a database to ensure data integrity. Transactions are sequences of operations performed as a single logical unit of work.

1. Save Command Permanently (Commit)
Purpose: This sequence of commands ensures that the changes made to the database are saved permanently.

Explanation:

START TRANSACTION: Begins a new transaction.
INSERT INTO ...: Inserts new records into the rides and payment tables.
COMMIT: Saves all changes made during the transaction permanently.

START TRANSACTION;
INSERT INTO rides (ride_id, cid, did, fare) VALUES (1006, 106, 1, 250);
INSERT INTO payment (pay_id, ride_id, amount, mode, status) VALUES (4, 1006, 250, 'upi', 'completed');
COMMIT;


2. Rollback to Previous Command
Purpose: This sequence of commands demonstrates how to discard changes made during a transaction.

Explanation:

START TRANSACTION: Begins a new transaction.
INSERT INTO ...: Inserts a new record into the rides table.
ROLLBACK: Discards all changes made during the transaction.

START TRANSACTION;
INSERT INTO rides (ride_id, cid, did, fare) VALUES (1007, 107, 2, 300);
ROLLBACK;

3. Create Savepoint and Rollback to Savepoint
Purpose: This sequence of commands shows how to create a savepoint within a transaction and roll back to that savepoint if needed.

Explanation:

START TRANSACTION: Begins a new transaction.
INSERT INTO ...: Inserts new records into the rides and payment tables.
SAVEPOINT ride_insert: Creates a savepoint named ride_insert.
ROLLBACK TO ride_insert: Rolls back the transaction to the ride_insert savepoint, discarding subsequent changes.

START TRANSACTION;
INSERT INTO rides (ride_id, cid, did, fare) VALUES (1008, 108, 3, 350);
SAVEPOINT ride_insert;
INSERT INTO payment (pay_id, ride_id, amount, mode, status) VALUES (5, 1008, 350, 'credit', 'in process');
ROLLBACK TO ride_insert;


Views
Views are virtual tables created by querying data from one or more tables. They simplify complex queries and enhance data security by restricting access to specific data.

1. View that Displays Customers with Their Corresponding Rides
Purpose: This view shows customer information along with their ride details.

Explanation:

SELECT c.cid, c.cname, r.ride_id, r.fare: Selects customer ID, customer name, ride ID, and fare.
FROM customers c JOIN rides r ON c.cid = r.cid: Joins the customers and rides tables based on the customer ID.
sql
Copy code
CREATE VIEW CustomerRides AS
SELECT c.cid, c.cname, r.ride_id, r.fare
FROM customers c
JOIN rides r ON c.cid = r.cid;

2. Create or Replace View to Show Payment Details with Ride and Customer Information
Purpose: This view combines payment details with related ride and customer information.

Explanation:

SELECT p.pay_id, p.ride_id, r.cid, c.cname, c.age, c.addr, p.amount, p.mode, p.status: Selects payment ID, ride ID, customer ID, customer name, age, address, payment amount, mode, and status.
FROM payment p JOIN rides r ON p.ride_id = r.ride_id JOIN customers c ON r.cid = c.cid: Joins the payment, rides, and customers tables based on their respective relationships.
sql
Copy code
CREATE OR REPLACE VIEW PaymentRideCustomerDetails AS
SELECT p.pay_id, p.ride_id, r.cid, c.cname, c.age, c.addr, p.amount, p.mode, p.status
FROM payment p
JOIN rides r ON p.ride_id = r.ride_id
JOIN customers c ON r.cid = c.cid;

3. Drop View if It Exists
Purpose: This command removes a view if it exists in the database.

Explanation:

DROP VIEW IF EXISTS PaymentRideCustomerDetails: Drops the PaymentRideCustomerDetails view if it exists.
sql
Copy code
DROP VIEW IF EXISTS PaymentRideCustomerDetails;

By implementing these triggers, TCL commands, and views, you can enhance the functionality and data integrity of your OLA database. 
Triggers automate critical updates and checks, TCL commands manage transactions to ensure data consistency, and views simplify complex queries and restrict access to sensitive information.
*/