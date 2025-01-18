-- https://preppindata.blogspot.com/2023/01/2023-week-3-targets-for-dsb.html

-- "For the third week of beginner month, we're going to be building on the skills that we've already learnt, as well as exploring new concepts.
-- This week may feel a little more challenging, but I promise you're ready for it!
-- Data Source Bank has some quarterly targets for the value of transactions that are being performed in-person and online. It's our job to compare the transactions to these target figures."


-- Inputs:
-- 1) The same transactions file as the first week's
-- 2) Quarterly Targets dataset


-- Requirements:

-- For the transactions file:
--   1) Filter the transactions to just look at DSB (These will be transactions that contain DSB in the Transaction Code field)
--   2) Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
--   3) Change the date to be the quarter
--   4) Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person)
-- For the targets file:
--   5) Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter
--   6) Rename the fields
--   7) Remove the 'Q' from the quarter field and make the data type numeric
--   8) Join the two datasets together (You may need more than one join clause!)
--   9) Remove unnecessary fields
--   10) Calculate the Variance to Target for each row
--   11) Output the data (5 fields:
--       - Online or In-Person
--       - Quarter
--       - Value
--       - Quarterly Targets
--       - Variance to Target)
--       8 rows (9 including headers)



-- Task 1:

SELECT *

FROM [General].[Preppin Data | 2023, Week 3].[PD 2023 Wk 1 Input]

WHERE [Transaction Code] LIKE '%DSB%'
;


-- Task 2:

SELECT [Transaction Code]
      ,[Value]
      ,[Customer Code]
      , CASE
			WHEN [Online or In-Person] = '1' THEN 'Online'
			WHEN [Online or In-Person] = '2' THEN 'In-Person'
			ELSE [Online or In-Person]
			END AS "Online or In Person"
      ,[Transaction Date]

FROM [General].[Preppin Data | 2023, Week 3].[PD 2023 Wk 1 Input]

WHERE [Transaction Code] LIKE '%DSB%'
;


-- Task 3:

SELECT [Transaction Code]
      ,[Value]
      ,[Customer Code]
      , CASE
		WHEN [Online or In-Person] = '1' THEN 'Online'
		WHEN [Online or In-Person] = '2' THEN 'In-Person'
		ELSE [Online or In-Person]
		END AS "Online or In Person"
	  , DATEPART(quarter, CONVERT(DATETIME, [Transaction Date], 105)) AS Quarter

FROM [General].[Preppin Data | 2023, Week 3].[PD 2023 Wk 1 Input]

WHERE [Transaction Code] LIKE '%DSB%'
;


-- Task 4:

SELECT CASE
		WHEN [Online or In-Person] = '1' THEN 'Online'
		WHEN [Online or In-Person] = '2' THEN 'In-Person'
		ELSE [Online or In-Person]
		END AS "Online or In-Person"
	  , DATEPART(quarter, CONVERT(DATETIME, [Transaction Date] , 105)) AS Quarter
	  , SUM(CAST([Value] AS integer)) AS Value

FROM [General].[Preppin Data | 2023, Week 3].[PD 2023 Wk 1 Input]

WHERE [Transaction Code] LIKE '%DSB%'

GROUP BY DATEPART(quarter, CONVERT(DATETIME, [Transaction Date] , 105)), [Online or In-Person]
;


-- Task 5 & 6:

SELECT [Online_or_In_Person]
	, "Quarter"
	, "Quarterly Targets"
  FROM 
		(SELECT  *
		FROM [General].[Preppin Data | 2023, Week 3].[Targets]) p
  UNPIVOT
		-- Value ↓	    Column Name ↓
		("Quarterly Targets" FOR "Quarter" IN
			([Q1], [Q2], [Q3], [Q4])
		) AS unpvt
;


-- Task 7:

SELECT [Online_or_In_Person]
	, CONVERT(INTEGER, RIGHT("Quarter", 1)) AS Quarter
	, "Quarterly Targets"
  FROM 
		(SELECT  *
		FROM [General].[Preppin Data | 2023, Week 3].[Targets]) p
  UNPIVOT
		-- Value ↓	    Column Name ↓
		("Quarterly Targets" FOR "Quarter" IN
			([Q1], [Q2], [Q3], [Q4])
		) AS unpvt
;


-- Task 8 & 9:

SELECT 
    q1.[Online or In-Person],
    q1.Quarter,
    q1.Value,
    q2.[Quarterly Targets],

-- Task 10:

    q1.Value - q2.[Quarterly Targets] AS "Variance to Target"
FROM
    (
        -- Query 1
        SELECT 
            CASE
                WHEN [Online or In-Person] = '1' THEN 'Online'
                WHEN [Online or In-Person] = '2' THEN 'In-Person'
                ELSE [Online or In-Person]
            END AS "Online or In-Person",
            DATEPART(quarter, CONVERT(DATETIME, [Transaction Date], 105)) AS Quarter,
            SUM(CAST([Value] AS integer)) AS Value
        FROM 
            [General].[Preppin Data | 2023, Week 3].[PD 2023 Wk 1 Input]
        WHERE 
            [Transaction Code] LIKE '%DSB%'
        GROUP BY 
            DATEPART(quarter, CONVERT(DATETIME, [Transaction Date], 105)), 
            [Online or In-Person]
    ) AS q1

JOIN

    (
        -- Query 2
        SELECT 
            [Online_or_In_Person],
            CONVERT(INTEGER, RIGHT("Quarter", 1)) AS Quarter,
            "Quarterly Targets"
        FROM 
            (
                SELECT  *
                FROM [General].[Preppin Data | 2023, Week 3].[Targets]
            ) p
        UNPIVOT
            ("Quarterly Targets" FOR "Quarter" IN ([Q1], [Q2], [Q3], [Q4])) AS unpvt
    ) AS q2

ON 
    q1.[Online or In-Person] = q2.[Online_or_In_Person]
    AND q1.Quarter = q2.Quarter
;





-- 11) Output:

Online or In-Person	Quarter 	Value   	Quarterly Targets	Variance to Target
Online			1		74562		72500			2062
Online			2		69325		70000			-675
Online			3		59072		60000			-928
Online			4		61908		60000			1908
In-Person		1		77576		75000			2576
In-Person		2		70634		70000			634
In-Person		3		74189		70000			4189
In-Person		4		43223		60000			-16777
