-- https://preppindata.blogspot.com/2023/01/2023-week-2-international-bank-account.html

-- "For week 2 of our beginner month, Data Source Bank has a requirement to construct International Bank Account Numbers (IBANs), even for Transactions taking place in the UK.
-- We have all the information in separate fields, we just need to put it altogether in the following order:
-- [Country Code, Check Digits, Bank Code, Sort Code, Account Number]]

-- Inputs:
-- 1. A list of the transactions, with information about the receiving bank account 
-- 2. A lookup table for the SWIFT Bank Codes 

-- Requirements:
 
-- 1) In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string
-- 2) Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account
-- 3) Add a field for the Country Code. Hint: all these transactions take place in the UK so the Country Code should be GB
-- 4) Create the IBAN as above. Hint: watch out for trying to combine sting fields with numeric fields - check data types
-- 5) Remove unnecessary fields
-- (Output the data (2 fields: Transaction ID, IBAN; 100 rows (101 including headers)))



-- Outputs 1, 2

SELECT S.[Check Digits]
	 , S.[SWIFT code]
	 , REPLACE([Sort Code], '-', '') AS Sort_Code_Abbr
	 , [Account Number]
  FROM [General].[Preppin Data | 2023, Week 2].[Transactions] T
  JOIN [General].[Preppin Data | 2023, Week 2].[Swift Codes] S
  ON T.[Bank] = S.[Bank]
  ;


-- Output 3

SELECT 'GB' AS Country_Code
	 , S.[Check Digits]
	 , S.[SWIFT code]
	 , REPLACE([Sort Code], '-', '') AS Sort_Code_Abbr
	 , [Account Number]
  FROM [General].[Preppin Data | 2023, Week 2].[Transactions] T
  JOIN [General].[Preppin Data | 2023, Week 2].[Swift Codes] S
  ON T.[Bank] = S.[Bank]
  ;


-- Output 4, 5

WITH ConcatenatedData AS(

SELECT 'GB' AS Country_Code
	 , S.[Check Digits]
	 , S.[SWIFT code]
	 , REPLACE([Sort Code], '-', '') AS Sort_Code_Abbr
	 , [Account Number]
	 , [Transaction ID]
  FROM [General].[Preppin Data | 2023, Week 2].[Transactions] T
  JOIN [General].[Preppin Data | 2023, Week 2].[Swift Codes] S
  ON T.[Bank] = S.[Bank]
  )

  SELECT [Transaction ID]
	, CONCAT([Country_Code], [Check Digits], [SWIFT code], [Sort_Code_Abbr], [Account Number])
		AS IBAN
  FROM ConcatenatedData;
