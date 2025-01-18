-- At Preppin' Data we use a number of (mock) companies to look at the challenges they have with their data.
-- For January, we're going to focus on our own airline, Prep Air. The airline has introduced a new loyalty card called the Flow Card.
-- We need to clean up a number of data sets to determine how well the card is doing. 
-- The first task is setting some context for later weeks by understanding how popular the Flow Card is.
-- Our stakeholder would like two data sets about our passengers. One data set for card users and one data set for those who don't use the card.


-- Requirements:

-- 1) Split the Flight Details field to form:
--  Date 
--  Flight Number
--  From
--  To
--  Class
--  Price

-- 2) Convert the following data fields to the correct data types:
--  Date to a date format
--  Price to a decimal value

-- 3) Change the Flow Card field to Yes / No values instead of 1 / 0

-- 4) Create two tables, one for Flow Card holders and one for non-Flow Card holders



-----



-- 1.1) In order to split the Flight Details field, I first need to add a unique ID to the table:

ALTER TABLE [Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ADD ID INT IDENTITY(1,1);



-- 1.2) Then add the columns that will receive the split values (keeping the cities as one field):

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ADD Date NVARCHAR(50), 
    FlightNumber NVARCHAR(50),
    CombinedCity NVARCHAR(100),
    Class NVARCHAR(50),
    Price NVARCHAR(50);



-- 1.3) Split the Flight_Details field for every '//' delimiter:

WITH 

SplitData AS (
    SELECT
        t1.[ID],
        s.value,
        ROW_NUMBER() OVER (PARTITION BY t1.[ID] ORDER BY (SELECT NULL)) AS PartNumber
    FROM [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input] t1
    CROSS APPLY STRING_SPLIT(REPLACE(t1.Flight_Details, '//', '|'), '|') s
),

MappedData AS (
    SELECT
        ID,
        MAX(CASE WHEN PartNumber = 1 THEN value END) AS Date,
        MAX(CASE WHEN PartNumber = 2 THEN value END) AS FlightNumber,
        MAX(CASE WHEN PartNumber = 3 THEN value END) AS CombinedCity,
        MAX(CASE WHEN PartNumber = 4 THEN value END) AS Class,
        MAX(CASE WHEN PartNumber = 5 THEN value END) AS Price
    FROM SplitData
    GROUP BY ID
)

UPDATE t1
SET
    t1.Date = m.Date,
    t1.FlightNumber = m.FlightNumber,
    t1.CombinedCity = m.CombinedCity,
    t1.Class = m.Class,
    t1.Price = m.Price

FROM [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input] t1
JOIN MappedData m 
ON t1.ID = m.ID;



-- 1.4) Add two fields to split the CombinedCity field:

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ADD FromCity NVARCHAR(50), 
    ToCity NVARCHAR(50);


-- 1.5) Split CombinedCity and the data to the new columns:

UPDATE t1
SET
    t1.FromCity = LEFT(t1.CombinedCity, CHARINDEX('-', t1.CombinedCity) - 1),
    t1.ToCity = SUBSTRING(t1.CombinedCity, CHARINDEX('-', t1.CombinedCity) + 1, LEN(t1.CombinedCity))
FROM [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input] t1
WHERE CHARINDEX('-', t1.CombinedCity) > 0; -- Ensure valid format



-- 1.6) Drop the fields that aren't needed:

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
DROP   COLUMN [Flight_Details]
      ,[CombinedCity];


-- 2)

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ALTER COLUMN [Date] DATE;

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ALTER COLUMN [Price] DECIMAL(10, 1);



