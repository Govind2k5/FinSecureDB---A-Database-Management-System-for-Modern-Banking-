
USE bankmanagement;

-- ====================================================================
-- 1. JOIN QUERY
--
-- Purpose: To list all employees, their branch name, and their
-- manager's level.
-- This query joins three tables: employee, branch, and manager.
-- ====================================================================
SELECT
    e.Name AS Employee_Name,
    e.Salary,
    b.Branch_Name,
    m.Manager_Level
FROM
    employee e
JOIN
    branch b ON e.Branch_ID = b.Branch_ID
JOIN
    manager m ON e.EID = m.EID;


-- ====================================================================
-- 2. AGGREGATE QUERY (with GROUP BY)
--
-- Purpose: To find the average salary of employees at each branch.
-- This query joins two tables and uses an aggregate (AVG)
-- and a GROUP BY clause.
-- ====================================================================
SELECT
    b.Branch_Name,
    AVG(e.Salary) AS Average_Salary,
    COUNT(e.EID) AS Number_of_Employees
FROM
    employee e
JOIN
    branch b ON e.Branch_ID = b.Branch_ID
GROUP BY
    b.Branch_Name;


-- ====================================================================
-- 3. NESTED QUERY (Subquery)
--
-- Purpose: To find all customers who have a loan amount greater
-- than the average of all loan amounts.
-- This uses a subquery in the WHERE clause.
-- ====================================================================
SELECT
    Customer_ID,
    Name,
    Email,
    Phone
FROM
    customer
WHERE
    Customer_ID IN (
        -- Subquery: Get all Customer_IDs from loans
        -- where the Amount is greater than the average
        SELECT Customer_ID
        FROM loans
        WHERE Amount > (
            -- Subquery: Get the average of all loan amounts
            SELECT AVG(Amount) FROM loans
        )
    );
