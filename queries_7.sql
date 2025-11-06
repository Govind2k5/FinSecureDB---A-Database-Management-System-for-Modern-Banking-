
USE bankmanagement;

-- ====================================================================
-- 7.1 SIMPLE QUERY WITH GROUP BY, AGGREGATE
--
-- Purpose: To find the average salary and number of employees
-- at each branch.
-- ====================================================================
SELECT '-- 7.1 SIMPLE QUERY WITH GROUP BY, AGGREGATE --' AS ' ';

SELECT
    b.Branch_Name,
    TRUNCATE(AVG(e.Salary), 2) AS Average_Salary,
    COUNT(e.EID) AS Number_of_Employees
FROM
    employee e
JOIN
    branch b ON e.Branch_ID = b.Branch_ID
GROUP BY
    b.Branch_Name;


-- ====================================================================
-- 7.2 UPDATE OPERATION
--
-- Purpose: To change the phone number for a specific customer.
-- We use a PRIMARY KEY (Customer_ID) in the WHERE clause for safety.
-- ====================================================================
SELECT '-- 7.2 UPDATE OPERATION --' AS ' ';

-- Step 1: See the customer's phone number BEFORE the update
SELECT Customer_ID, Name, Phone FROM customer WHERE Customer_ID = 1;

-- Step 2: Run the UPDATE command
UPDATE customer
SET Phone = '9999999999'
WHERE Customer_ID = 1;

-- Step 3: See the customer's phone number AFTER the update
SELECT Customer_ID, Name, Phone FROM customer WHERE Customer_ID = 1;

-- Step 4: Change it back to the original value
UPDATE customer
SET Phone = '9876543210'
WHERE Customer_ID = 1;


-- ====================================================================
-- 7.3 DELETE OPERATION
--
-- Purpose: To delete a specific transaction.
-- We use a PRIMARY KEY (Transaction_ID) in the WHERE clause.
-- ====================================================================
SELECT '-- 7.3 DELETE OPERATION --' AS ' ';

-- Step 1: Add a test transaction to delete
INSERT INTO transaction (Transaction_ID, Date, Type, Amount, Account_No)
VALUES (9999, CURDATE(), 'Test', 1.00, 101);

-- Step 2: Show that the transaction exists
SELECT * FROM transaction WHERE Transaction_ID = 9999;

-- Step 3: Run the DELETE command
DELETE FROM transaction
WHERE Transaction_ID = 9999;

-- Step 4: Show that the transaction is now gone
SELECT * FROM transaction WHERE Transaction_ID = 9999;


-- ====================================================================
-- 7.4 CORRELATED QUERY
--
-- Purpose: To find all employees who earn more than the
-- average salary OF THEIR OWN BRANCH.
--
-- How it works: The outer query (e1) scans each employee. For
-- each employee, the inner query (e2) runs and calculates
-- the average salary *only for that employee's branch*.
-- ====================================================================
SELECT '-- 7.4 CORRELATED QUERY --' AS ' ';

SELECT
    e1.Name AS Employee_Name,
    e1.Salary,
    b.Branch_Name
FROM
    employee e1
JOIN
    branch b ON e1.Branch_ID = b.Branch_ID
WHERE
    e1.Salary > (
        -- This is the correlated subquery
        SELECT AVG(e2.Salary)
        FROM employee e2
        WHERE e2.Branch_ID = e1.Branch_ID -- Correlates with the outer query
    );


-- ====================================================================
-- 7.5 NESTED QUERY
--
-- Purpose: To find all customers who have a loan amount greater
-- than the average of all loan amounts (a "large loan").
-- This query is "nested" but not "correlated" because the
-- inner queries can run on their own.
-- ====================================================================
SELECT '-- 7.5 NESTED QUERY --' AS ' ';

SELECT
    Customer_ID,
    Name,
    Email,
    Phone
FROM
    customer
WHERE
    Customer_ID IN (
        -- Subquery 1: Gets the list of customer IDs
        SELECT Customer_ID
        FROM loans
        WHERE Amount > (
            -- Subquery 2: Gets the single average loan amount
            SELECT AVG(Amount) FROM loans
        )
    );