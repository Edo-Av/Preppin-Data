-- [This query was created in data.world]

-- https://preppindata.blogspot.com/2023/01/2023-week-1-data-source-bank.html

-- "The subject for January will be our new (fake) bank - The Data Source Bank (DSB).
-- This week we have had a report with a number of transactions that have not just our transactions but other banks' too.
-- Can you help clean up the data?"

-- 1) Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction
--    Rename the new field with the Bank code 'Bank'. 
-- 2) Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
-- 3) Change the date to be the day of the week
-- 4) Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
--      - Total Values of Transactions by each bank
--      - Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
--      - Total Values by Bank and Customer Code


-- Output 1
SELECT 
  REGEXP_EXTRACT(transaction_code, '[A-Z]+') AS Bank
, SUM(value) AS Value
FROM pd_2023_wk_1_input
GROUP BY Bank
ORDER BY Value DESC
;


-- Output 2
SELECT 
  REGEXP_EXTRACT(transaction_code, '[A-Z]+') AS Bank
, CASE
    WHEN online_or_in_person = 1 THEN 'Online'
    WHEN online_or_in_person = 2 THEN 'In-Person'
    END AS Online_or_In_Person
, DATE_FORMAT(transaction_date, 'EEEE') AS Transaction_Date
, SUM(value) AS Value
FROM pd_2023_wk_1_input
GROUP BY Bank, Online_or_In_Person, DATE_FORMAT(transaction_date, 'EEEE')
;


-- Output 3
SELECT 
  REGEXP_EXTRACT(transaction_code, '[A-Z]+') AS Bank
, customer_code AS Customer_Code
, SUM(value) AS Value
FROM pd_2023_wk_1_input
GROUP BY Bank, customer_code
