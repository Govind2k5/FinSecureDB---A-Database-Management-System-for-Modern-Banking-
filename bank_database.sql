-- ====================================================================
--            FinSecureDB Database Setup Script
-- ====================================================================
-- NOTE: This script has been completely updated to match the
-- user's 10 screenshots. It is the single source of truth
-- for the database schema and sample data.
-- ====================================================================

-- 1. CREATE AND USE THE DATABASE
CREATE DATABASE IF NOT EXISTS bankmanagement;
USE bankmanagement;

-- 2. DROP EXISTING TABLES (in reverse dependency order)
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS manager;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS atm;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS bank;


-- 3. CREATE TABLES (in dependency order)

-- Bank Table
CREATE TABLE bank (
    Bank_Code INT PRIMARY KEY,
    Name VARCHAR(100),
    Street VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Pincode VARCHAR(10)
);

-- Branch Table
CREATE TABLE branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Street VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Pincode VARCHAR(10),
    Bank_Code INT,
    FOREIGN KEY (Bank_Code) REFERENCES bank(Bank_Code) ON DELETE SET NULL
);

-- Customer Table
CREATE TABLE customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    DOB DATE,
    Gender VARCHAR(10),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Street VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Pincode VARCHAR(10),
    Balance DECIMAL(12, 2)
);

-- Account Table
CREATE TABLE account (
    Account_No INT PRIMARY KEY,
    ACC_Type VARCHAR(20),
    Balance DECIMAL(12, 2),
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID) ON DELETE SET NULL
);

-- ATM Table
CREATE TABLE atm (
    ATM_ID INT PRIMARY KEY,
    Status VARCHAR(20),
    Location VARCHAR(100),
    Branch_ID INT,
    FOREIGN KEY (Branch_ID) REFERENCES branch(Branch_ID) ON DELETE SET NULL
);

-- Loans Table
CREATE TABLE loans (
    Loan_ID INT PRIMARY KEY,
    Type VARCHAR(20),
    Amount DECIMAL(12, 2),
    Interest DECIMAL(4, 2),
    Time_Period INT,
    Date DATE,
    Date_of_repayment DATE,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID) ON DELETE SET NULL
);

-- Employee Table
CREATE TABLE employee (
    EID INT PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(10),
    DOB DATE,
    Hire_Date DATE,
    Salary DECIMAL(12, 2),
    Branch_ID INT,
    FOREIGN KEY (Branch_ID) REFERENCES branch(Branch_ID) ON DELETE SET NULL
);

-- Manager Table
CREATE TABLE manager (
    Man_ID INT PRIMARY KEY,
    Manager_Level VARCHAR(50),
    Start_Date DATE,
    Branch_ID INT,
    EID INT,
    FOREIGN KEY (Branch_ID) REFERENCES branch(Branch_ID) ON DELETE SET NULL,
    FOREIGN KEY (EID) REFERENCES employee(EID) ON DELETE SET NULL
);

-- Payment Table
CREATE TABLE payment (
    Payment_ID INT PRIMARY KEY,
    Date DATE,
    Amount DECIMAL(12, 2),
    Balance DECIMAL(12, 2),
    Payment_Num INT,
    Status VARCHAR(20),
    Payment_Mode VARCHAR(20),
    Loan_ID INT,
    FOREIGN KEY (Loan_ID) REFERENCES loans(Loan_ID) ON DELETE SET NULL
);

-- Transaction Table
CREATE TABLE transaction (
    Transaction_ID INT PRIMARY KEY,
    Date DATE,
    Type VARCHAR(20),
    Amount DECIMAL(12, 2),
    Account_No INT,
    FOREIGN KEY (Account_No) REFERENCES account(Account_No) ON DELETE SET NULL
);


-- 4. INSERT DATA 

-- Bank
INSERT INTO bank (Bank_Code, Name, Street, City, State, Pincode) VALUES
(501, 'State Bank of India', 'Main Road', 'Mumbai', 'Maharashtra', '400001'),
(502, 'HDFC Bank', 'Park Street', 'Kolkata', 'West Bengal', '700016'),
(503, 'ICICI Bank', 'Anna Salai', 'Chennai', 'Tamil Nadu', '600002'),
(504, 'Axis Bank', 'Kothrud', 'Pune', 'Maharashtra', '411038'),
(505, 'Canara Bank', 'Rajajinagar', 'Bangalore', 'Karnataka', '560010');

-- Branch
INSERT INTO branch (Branch_ID, Branch_Name, Street, City, State, Pincode, Bank_Code) VALUES
(601, 'Mumbai Central', 'Marine Drive', 'Mumbai', 'Maharashtra', '400002', 501),
(602, 'Park Circus', 'Sealdah Road', 'Kolkata', 'West Bengal', '700017', 502),
(603, 'T Nagar', 'Usman Road', 'Chennai', 'Tamil Nadu', '600017', 503),
(604, 'Shivajinagar', 'JM Road', 'Pune', 'Maharashtra', '411005', 504),
(605, 'Indiranagar', '100ft Road', 'Bangalore', 'Karnataka', '560038', 505);

-- Customer
INSERT INTO customer (Customer_ID, Name, DOB, Gender, Email, Phone, Street, City, State, Pincode, Balance) VALUES
(1, 'Ravi Kumar', '1990-04-15', 'Male', 'ravi.kumar@email.com', '9876543210', 'MG Road', 'Bangalore', 'Karnataka', '560001', 75000.00),
(2, 'Sneha Reddy', '1995-08-21', 'Female', 'sneha.reddy@email.com', '9876543211', 'Banjara Hills', 'Hyderabad', 'Telangana', '500034', 50000.00),
(3, 'Arjun Mehta', '1988-11-12', 'Male', 'arjun.mehta@email.com', '9876543212', 'Hill Road', 'Delhi', 'Delhi', '110001', 30000.00),
(4, 'Priya Sharma', '1992-02-05', 'Female', 'priya.sharma@email.com', '9876543213', 'FC Road', 'Pune', 'Maharashtra', '411004', 90000.00),
(5, 'Karthik N', '1985-12-25', 'Male', 'karthik.n@email.com', '9876543214', 'Adyar', 'Chennai', 'Tamil Nadu', '600020', 45000.00);

-- Account
INSERT INTO account (Account_No, ACC_Type, Balance, Customer_ID) VALUES
(101, 'Savings', 31000.00, 1),
(102, 'Current', 50000.00, 2),
(103, 'Savings', 15000.00, 3),
(104, 'Savings', 70000.00, 4),
(105, 'Current', 25000.00, 5);

-- ATM
INSERT INTO atm (ATM_ID, Status, Location, Branch_ID) VALUES
(701, 'Active', 'Churchgate, Mumbai', 601),
(702, 'Inactive', 'Howrah Bridge, Kolkata', 602),
(703, 'Active', 'T Nagar, Chennai', 603),
(704, 'Active', 'FC Road, Pune', 604),
(705, 'Inactive', 'CMH Road, Bangalore', 605);

-- Loans
INSERT INTO loans (Loan_ID, Type, Amount, Interest, Time_Period, Date, Date_of_repayment, Customer_ID) VALUES
(301, 'Home Loan', 2000000.00, 7.50, 240, '2023-01-01', '2043-01-01', 1),
(302, 'Car Loan', 800000.00, 8.20, 60, '2023-06-15', '2028-06-15', 2),
(303, 'Personal Loan', 300000.00, 10.50, 36, '2024-03-20', '2027-03-20', 3),
(304, 'Education Loan', 1500000.00, 6.80, 120, '2024-07-10', '2034-07-10', 4),
(305, 'Business Loan', 5000000.00, 9.00, 180, '2025-01-05', '2040-01-05', 5);

-- Employee
INSERT INTO employee (EID, Name, Gender, DOB, Hire_Date, Salary, Branch_ID) VALUES
(801, 'Anil Deshmukh', 'Male', '1980-05-20', '2010-01-15', 80000.00, 601),
(802, 'Meena Sharma', 'Female', '1985-09-10', '2012-03-25', 75000.00, 602),
(803, 'Rohit Verma', 'Male', '1990-12-01', '2015-07-30', 60000.00, 603),
(804, 'Divya Nair', 'Female', '1992-11-18', '2018-10-05', 55000.00, 604),
(805, 'Suresh Kumar', 'Male', '1988-07-14', '2016-04-20', 65000.00, 605);

-- Manager
INSERT INTO manager (Man_ID, Manager_Level, Start_Date, Branch_ID, EID) VALUES
(901, 'Senior Manager', '2015-02-01', 601, 801),
(902, 'Branch Manager', '2016-05-01', 602, 802),
(903, 'Assistant Manager', '2018-08-01', 603, 803),
(904, 'Branch Manager', '2019-09-01', 604, 804),
(905, 'Senior Manager', '2020-11-01', 605, 805);

-- Payment
INSERT INTO payment (Payment_ID, Date, Amount, Balance, Payment_Num, Status, Payment_Mode, Loan_ID) VALUES
(401, '2025-02-01', 15000.00, 1985000.00, 1, 'Completed', 'NEFT', 301),
(402, '2025-03-01', 12000.00, 788000.00, 1, 'Completed', 'UPI', 302),
(403, '2025-04-01', 10000.00, 290000.00, 1, 'Pending', 'Cheque', 303),
(404, '2025-05-01', 20000.00, 1480000.00, 2, 'Completed', 'Cash', 304),
(405, '2025-06-01', 50000.00, 4950000.00, 1, 'Completed', 'NEFT', 305);

-- Transaction
INSERT INTO transaction (Transaction_ID, Date, Type, Amount, Account_No) VALUES
(201, '2025-09-01', 'Deposit', 10000.00, 101),
(202, '2025-09-02', 'Withdrawal', 5000.00, 102),
(203, '2025-09-03', 'Deposit', 2000.00, 103),
(204, '2025-09-04', 'Withdrawal', 10000.00, 104),
(205, '2025-09-05', 'Deposit', 15000.00, 105);


-- 5. VERIFY DATA INSERTION
SELECT '-- Verifying Data (10 tables) --' AS Status;
SELECT * FROM account;
SELECT * FROM atm;
SELECT * FROM bank;
SELECT * FROM branch;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM loans;
SELECT * FROM manager;
SELECT * FROM payment;
SELECT * FROM transaction;

