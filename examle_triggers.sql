USE bankmanagement;

-- Disable Safe Update Mode to allow DELETEs for testing (prevents Error 1175)
SET SQL_SAFE_UPDATES = 0;

-- 1. TEST THE TRIGGER (trg_UpdateAccountBalance)
SELECT '-- Testing Trigger --' AS Test;

-- Clean up any old test data
DELETE FROM transaction WHERE Transaction_ID = 999;
-- Restore account balance just in case
UPDATE account SET Balance = 31000.00 WHERE Account_No = 101;


SELECT 'Balance in Account 101 BEFORE deposit:' AS Step, Balance FROM account WHERE Account_No = 101;

-- Insert a new transaction. This will fire the trigger.
INSERT INTO transaction (Transaction_ID, Date, Type, Amount, Account_No)
VALUES (999, CURDATE(), 'Deposit', 1000.00, 101);

SELECT 'Balance in Account 101 AFTER deposit:' AS Step, Balance FROM account WHERE Account_No = 101;

-- Clean up the test
DELETE FROM transaction WHERE Transaction_ID = 999;
UPDATE account SET Balance = 31000.00 WHERE Account_No = 101; -- Restore


-- 2. TEST THE FUNCTION (fn_GetCustomerTotalBalance)
SELECT '-- Testing Function --' AS Test;

-- Test for Customer_ID 1 (Ravi Kumar), who has one account (101) with 31000
SELECT 'Total balance for Customer 1:' AS Customer, fn_GetCustomerTotalBalance(1) AS TotalBalance;

-- Test for Customer_ID 2 (Sneha Reddy), who has one account (102) with 50000
SELECT 'Total balance for Customer 2:' AS Customer, fn_GetCustomerTotalBalance(2) AS TotalBalance;

-- Test for a customer with no accounts
SELECT 'Total balance for Customer 99 (Non-existent):' AS Customer, fn_GetCustomerTotalBalance(99) AS TotalBalance;


-- 3. TEST THE PROCEDURE (sp_MakeLoanPayment)
SELECT '-- Testing Procedure --' AS Test;

-- Clean up old test data (payment_num 2 for loan 301)
DELETE FROM payment WHERE Loan_ID = 301 AND Payment_Num = 2;

SELECT 'Last balance on Loan 301 before payment:' AS Step, Balance
FROM payment WHERE Loan_ID = 301 ORDER BY Date DESC, Payment_ID DESC LIMIT 1;

-- Call the procedure to make a 10000 payment on loan 301
CALL sp_MakeLoanPayment(301, 10000.00, 'Test-Online');

SELECT 'Last balance on Loan 301 AFTER payment:' AS Step, Balance
FROM payment WHERE Loan_ID = 301 ORDER BY Date DESC, Payment_ID DESC LIMIT 1;

-- See the new record
-- FIX: Added table alias 'p' to use '*' with another column
SELECT 'Check Payment table for new record:' AS Step, p.* FROM payment p WHERE Payment_Mode = 'Test-Online';

-- Clean up the test
DELETE FROM payment WHERE Payment_Mode = 'Test-Online';


-- Re-enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;

