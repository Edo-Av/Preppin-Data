/*
At Preppin' Data we use a number of (mock) companies to look at the challenges they have with their data.
For January, we're going to focus on our own airline, Prep Air. The airline has introduced a new loyalty card called the Flow Card.
We need to clean up a number of data sets to determine how well the card is doing. 
The first task is setting some context for later weeks by understanding how popular the Flow Card is.
Our stakeholder would like two data sets about our passengers. One data set for card users and one data set for those who don't use the card.
/*

Requirements:

1) Split the Flight Details field to form:
  Date 
  Flight Number
  From
  To
  Class
  Price

2) Convert the following data fields to the correct data types:
  Date to a date format
  Price to a decimal value

3) Change the Flow Card field to Yes / No values instead of 1 / 0

4) Create two tables, one for Flow Card holders and one for non-Flow Card holders

-----



1.1) In order to split the Flight Details field, I first need to add a unique ID to the table:

ALTER TABLE [Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ADD ID INT IDENTITY(1,1);


1.2) Then add the columns that will receive the split values:

ALTER TABLE [General].[Preppin Data | 2024, Week 1].[PD 2024 Wk 1 Input]
ADD Date NVARCHAR(50), 
    FlightNumber NVARCHAR(50),
    CombinedCity NVARCHAR(100),
    Class NVARCHAR(50),
    Price NVARCHAR(50);




