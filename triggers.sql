
USE bankmanagement;

-- Set the delimiter for creating multi-line objects
DELIMITER $$

DROP TRIGGER IF EXISTS trg_UpdateAccountBalance;
DROP PROCEDURE IF EXISTS sp_MakeLoanPayment;
DROP FUNCTION IF EXISTS fn_GetCustomerTotalBalance;


CREATE TRIGGER trg_UpdateAccountBalance
AFTER INSERT ON transaction
FOR EACH ROW
BEGIN
    -- Check the type of transaction and update the account balance
    IF NEW.Type = 'Deposit' THEN
        UPDATE account
        SET Balance = Balance + NEW.Amount
        WHERE Account_No = NEW.Account_No;
    ELSEIF NEW.Type = 'Withdrawal' THEN
        UPDATE account
        SET Balance = Balance - NEW.Amount
        WHERE Account_No = NEW.Account_No;
    END IF;
END$$



CREATE FUNCTION fn_GetCustomerTotalBalance(
    p_Cust_ID INT
)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE total_balance DECIMAL(12, 2);

    -- Get total balance from all accounts linked to this Customer_ID
    SELECT SUM(Balance)
    INTO total_balance
    FROM account
    WHERE Customer_ID = p_Cust_ID;

    -- Return 0 if the customer has no accounts or balance
    RETURN IFNULL(total_balance, 0.00);
END$$



CREATE PROCEDURE sp_MakeLoanPayment(
    IN p_Loan_ID INT,
    IN p_payment_amount DECIMAL(12, 2),
    IN p_payment_mode VARCHAR(20)
)
BEGIN
    DECLARE next_payment_id INT;
    DECLARE last_balance DECIMAL(12, 2);
    DECLARE new_balance DECIMAL(12, 2);
    DECLARE next_payment_num INT;

    -- Start a transaction to ensure both operations succeed or fail together
    START TRANSACTION;

    -- 1. Get the next available Payment_ID
    SELECT IFNULL(MAX(Payment_ID), 0) + 1 INTO next_payment_id FROM payment;

    -- 2. Get the last recorded balance for this loan.
    --    If no payments exist, get the original Amount from the loans table.
    SELECT Balance INTO last_balance
    FROM payment
    WHERE Loan_ID = p_Loan_ID
    ORDER BY Date DESC, Payment_ID DESC
    LIMIT 1;

    IF last_balance IS NULL THEN
        SELECT Amount INTO last_balance FROM loans WHERE Loan_ID = p_Loan_ID;
    END IF;

    -- 3. Calculate the new remaining balance
    SET new_balance = last_balance - p_payment_amount;

    -- 4. Find the next payment installment number
    SELECT IFNULL(MAX(Payment_Num), 0) + 1 INTO next_payment_num
    FROM payment
    WHERE Loan_ID = p_Loan_ID;

    -- 5. Insert the new payment record
    INSERT INTO payment (Payment_ID, Date, Amount, Balance, Payment_Num, Status, Payment_Mode, Loan_ID)
    VALUES (next_payment_id, CURDATE(), p_payment_amount, new_balance, next_payment_num, 'Completed', p_payment_mode, p_Loan_ID);

    -- Commit the transaction
    COMMIT;

    -- Return a success message and the new balance
    SELECT 'Payment successful' AS message, new_balance AS new_loan_balance;

END$$

-- Reset the delimiter back to semicolon
-- FIX: Corrected typo from 'DELIMITTER'
DELIMITER ;
