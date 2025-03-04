-- It's the second week of our introductory challenges. This week the challenge will involve unions, aggregation and reshaping data.

-- Requirements:

-- 1) Input the two csv files [and u]nion the files together

-- 2) Convert the Date field to a Quarter Number instead [and n]ame this field Quarter

-- 3) Aggregate the data in the following ways:
--     Median price per Quarter, Flow Card? and Class
--     Minimum price per Quarter, Flow Card? and Class
--     Maximum price per Quarter, Flow Card? and Class

-- 4) Create three separate flows where you have only one of the aggregated measures in each. 
--     One for the minimum price
--     One for the median price
--     One for the maximum price

-- 5) Now pivot the data to have a column per class for each quarter and whether the passenger had a flow card or not

-- 6) Union these flows back together

-- What's this you see??? Economy is the most expensive seats and first class is the cheapest? When you go and check with your manager you realise the original data has been
-- incorrectly classified so you need to the names of these columns.

-- 7) Change the name of the following columns:
--     Economy to First
--     First Class to Economy
--     Business Class to Premium
--     Premium Economy to Business



1)
CREATE TABLE [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
		(
		Flow_Card NVARCHAR(3),
		Bags_Checked TINYINT,
		Meal_Type NVARCHAR(50),
		ID INT,
		Date DATE,
		FlightNumber NVARCHAR(50),
		Class NVARCHAR(50),
		Price DECIMAL(10,1),
		FromCity NVARCHAR(50),
		ToCity NVARCHAR(50)
		)
;




1.1)

INSERT INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined] ([Flow_Card], [Bags_Checked], [Meal_Type], [Date], [FlightNumber], [Class], [Price], [FromCity], [ToCity])

SELECT [Flow_Card], [Bags_Checked], [Meal_Type], CAST([Date] AS DATE), [Flight_Number], [Class], [Price], [From], [To]
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Output Flow Card]
UNION 
SELECT [Flow_Card], [Bags_Checked], [Meal_Type], CAST([Date] AS DATE), [Flight_Number], [Class], [Price], [From], [To]
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Output Non-Flow Card]
;



2)
SELECT *
,	DATEPART(QUARTER, "Date") AS Quarter
  FROM [Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
;



2.1) ALTER TABLE [Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
ADD Quarter Int
;


2.2) UPDATE [Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
SET [Quarter] = DATEPART(QUARTER, "Date")
;


3) 
SELECT DISTINCT 
  	[Quarter],
	[Flow_Card],
	[Class],
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price)  
        OVER (PARTITION BY Quarter, Flow_Card, Class) AS Median_Price,
	MIN([Price]) OVER (PARTITION BY Quarter, Flow_Card, Class) AS Minimum_Price,
	MAX([Price]) OVER (PARTITION BY Quarter, Flow_Card, Class) AS Maximum_Price
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
WHERE Price IS NOT NULL
;



4)
CREATE TABLE [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Median_Price]
	(
	[Quarter] TINYINT,
	[Flow_Card] NVARCHAR(3),
	[Class] NVARCHAR(50),
	[Median_Price] DECIMAL(10,1)
	)
;


4.1)
INSERT INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Median_Price]
([Quarter], [Flow_Card], [Class], [Median_Price])

SELECT DISTINCT
  	[Quarter],
	[Flow_Card],
	[Class],
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price)  
        OVER (PARTITION BY Quarter, Flow_Card, Class) AS Median_Price
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
WHERE Price IS NOT NULL
;


4.2)
CREATE TABLE [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Max_Price]
	(
	[Quarter] TINYINT,
	[Flow_Card] NVARCHAR(3),
	[Class] NVARCHAR(50),
	[Max_Price] INT
	)
;


4.3)
INSERT INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Max_Price]
([Quarter], [Flow_Card], [Class], [Max_Price])

SELECT DISTINCT
  	[Quarter],
	[Flow_Card],
	[Class],
    MAX([Price]) OVER (PARTITION BY Quarter, Flow_Card, Class) AS Max_Price
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
WHERE Price IS NOT NULL
;


4.4)
CREATE TABLE [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Min_Price]
	(
	[Quarter] TINYINT,
	[Flow_Card] NVARCHAR(3),
	[Class] NVARCHAR(50),
	[Min_Price] INT
	)
;


4.5)
INSERT INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Min_Price]
([Quarter], [Flow_Card], [Class], [Min_Price])

SELECT DISTINCT
  	[Quarter],
	[Flow_Card],
	[Class],
    MIN([Price]) OVER (PARTITION BY Quarter, Flow_Card, Class) AS Min_Price
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined]
WHERE Price IS NOT NULL
;




5)
SELECT [Flow_Card],
	   [Quarter],
	   [Business Class],
	   [Economy],
	   [First Class],
	   [Premium Economy],
	   'Median' AS [Aggregation]

INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Median_Pivot]
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Median_Price]

	   PIVOT
			(MAX([Median_Price])
			FOR [Class] IN
				([Business Class], [Economy], [First Class], [Premium Economy])
				) AS PivotTable
;



5.1)
SELECT [Flow_Card],
	   [Quarter],
	   [Business Class],
	   [Economy],
	   [First Class],
	   [Premium Economy],
	   'Min' AS [Aggregation]

INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Min_Pivot]
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Min_Price]

	   PIVOT
			(MAX([Min_Price])
			FOR [Class] IN
				([Business Class], [Economy], [First Class], [Premium Economy])
				) AS PivotTable
;



5.2)
SELECT [Flow_Card],
	   [Quarter],
	   [Business Class],
	   [Economy],
	   [First Class],
	   [Premium Economy],
	   'Max' AS [Aggregation]

INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Max_Pivot]
FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Max_Price]

	   PIVOT
			(MAX([Max_Price])
			FOR [Class] IN
				([Business Class], [Economy], [First Class], [Premium Economy])
				) AS PivotTable
;



6)
SELECT *  
INTO [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Pivots]  
FROM  
(  
    SELECT * FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Median_Pivot]  
    UNION  
    SELECT * FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Max_Pivot]  
    UNION  
    SELECT * FROM [General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Min_Pivot]  
) AS CombinedPivots
;



7)
EXEC sp_rename '[General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Pivots].[Economy]', 'First', 'COLUMN';
EXEC sp_rename '[General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Pivots].[First Class]', 'Economy', 'COLUMN';
EXEC sp_rename '[General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Pivots].[Business Class]', 'Premium', 'COLUMN';
EXEC sp_rename '[General].[Preppin Data | 2024, Week 2].[PD 2024 Wk 1 Combined_Pivots].[Premium Economy]', 'Business', 'COLUMN';


-- Output:

Flow_Card	Quarter	Premium	First		  Economy	  Business	Aggregation
No		    1		    241.0		1030.0		204.0		  515.0		  Min
No	    	1		    574.8		2340.0		438.0		  1075.0		Median
No	    	1		    834.0		3455.0		699.0		  1702.0		Max
No		    2		    240.0		1000.0		202.0		  507.0		  Min
No		    2	    	553.8		2325.0		445.0		  1205.0		Median
No		    2		    828.0		3480.0		694.0		  1745.0		Max
No		    3		    240.0		1000.0		201.0		  517.0		  Min
No		    3		    490.8		2285.0		487.0		  1125.0		Median
No		    3		    838.0		3475.0		691.0		  1747.0		Max
No		    4		    240.0		1015.0		200.0		  510.0		  Min
No		    4		    555.6		2202.5		428.0		  1062.5		Median
No		    4		    835.0		3465.0		698.0		  1730.0		Max
Yes		    1		    249.0		1020.0		201.0		  502.0		  Min
Yes		    1		    523.2		2325.0		447.5		  1160.0		Median
Yes		    1		    840.0		3500.0		698.0		  1737.0		Max
Yes		    2		    240.0		1020.0		200.0		  500.0		  Min
Yes		    2		    517.8		2290.0		459.0		  1071.3		Median
Yes		    2		    840.0		3490.0		696.0		  1737.0		Max
Yes	    	3		    241.0		1005.0		206.0		  502.0		  Min
Yes	    	3		    553.8		2347.5		457.0		  1090.0		Median
Yes	    	3		    840.0		3495.0		697.0		  1750.0		Max
Yes		    4		    249.0		1030.0		205.0		  505.0		  Min
Yes	    	4		    522.6		2212.5		424.0		  1108.8		Median
Yes		    4		    834.0		3460.0		697.0		  1722.0		Max
