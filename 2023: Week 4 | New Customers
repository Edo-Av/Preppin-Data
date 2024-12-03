-- https://preppindata.blogspot.com/2023/01/2023-week-4-new-customers.html

-- "Data Source Bank acquires new customers every month. They are stored in separate tabs of an Excel workbook so it's "easy" to see which customers joined in which month.
-- However, it's not so easy to do any comparisons between months. Therefore, we'd like to consolidate all the months into one dataset. 
-- There's an extra twist as well. The customer demographics are stored as rows rather than columns, which doesn't make for very easy reading. So we'd also like to restructure the data."


-- Inputs: We have one excel file, with 12 different tabs, one for each month.

-- Requirements:
-- 1) Input the data
-- 2) We want to stack the tables on top of one another, since they have the same fields in each sheet
-- 3) Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
-- 4) Make a Joining Date field based on the Joining Day, Table Names and the year 2023
-- 5) Now we want to reshape our data so we have a field for each demographic, for each new customer
-- 6) Make sure all the data types are correct for each field
-- 7) Remove duplicates:
--   - If a customer appears multiple times take their earliest joining date
-- 8) Output the data (5 fields):
--    ID
--    Joining Date
--    Account Type
--    Date of Birth
--    Ethnicity
-- 989 rows (990 including headers)


-- 2)

SELECT *
INTO [General].[Preppin Data | 2023, Week 4].[New Customers Full Year]
FROM 
	(
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - January]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - February]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - March]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - April]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - May]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - June]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - July]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - August]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - September]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - October]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - November]
	 UNION
	 SELECT *
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - December]
	) U


-- 3.1)

EXEC sp_rename '[General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - October].[Demagraphic]', 'Demographic', 'COLUMN';


-- 3.2 / 6)

ALTER TABLE [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - January]
ALTER COLUMN Joining_Day integer;


-- 3.3) 

DROP TABLE [General].[Preppin Data | 2023, Week 4].[New Customers Full Year]

-- and then re-run the same query as point 2 above


-- 4)

WITH "Table with Months" AS

(SELECT *
	 , 1 AS Month
	 , 2023 AS Year
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - January]
	 UNION
	 SELECT *
	 , 2
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - February]
	 UNION
	 SELECT *
	 , 3
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - March]
	 UNION
	 SELECT *
	 , 4
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - April]
	 UNION
	 SELECT *
	 , 5
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - May]
	 UNION
	 SELECT *
	 , 6
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - June]
	 UNION
	 SELECT *
	 , 7
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - July]
	 UNION
	 SELECT *
	 , 8
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - August]
	 UNION
	 SELECT *
	 , 9
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - September]
	 UNION
	 SELECT *
	 , 10
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - October]
	 UNION
	 SELECT *
	 , 11
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - November]
	 UNION
	 SELECT *
	 , 12
	 , 2023
	 FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - December])

SELECT 	   ID
,	   CONCAT_WS('/', RIGHT(REPLICATE('0', 1) + TRIM(STR(Joining_Day)), 2), RIGHT(REPLICATE('0', 1) + TRIM(STR(Month)), 2), TRIM(STR(Year))) AS "Joining Date"
,	   Demographic
,	   Value

INTO [Preppin Data | 2023, Week 4].[New Customers.xlsx - .Pre-Pivot]
FROM "Table with Months"
ORDER BY Month
	;



-- 5, 6, 7, 8)

SELECT [ID]
,	   [Joining Date]
,	   "Account Type"
,	   "Date of Birth"
,	   "Ethnicity"

INTO [Preppin Data | 2023, Week 4].[New Customers.xlsx - .PivotTable]

  FROM [General].[Preppin Data | 2023, Week 4].[New Customers.xlsx - .Pre-Pivot]
		
		PIVOT
				(MAX([Value])
				FOR [Demographic] IN
				("Account Type", "Date of Birth", "Ethnicity"))
				AS PivotTable
;
