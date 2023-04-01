Create Database Highcloud_Airline;
Use Highcloud_Airline;

SELECT * FROM highcloud_airline.project;

SET SQL_SAFE_UPDATES = 0;

/* Q1. Date Fields */

-- Date --
Update Project
SET Date = STR_TO_DATE(CONCAT(Year, '-', Month, '-', Day), '%Y-%m-%d');

Select Date from Project;

--------------------------------------------------------------------------------------------------------------------------------------------------

-- MonthNo --
Alter Table Project
Add Column MonthNo INT;

Update Project
SET MonthNo = MONTH(Date);

Select MonthNo from Project;

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- MonthName -- 
Alter Table Project
Add Column Month_Name Char(20);

Update Project
SET Month_Name = MONTHName(Date);

Select Month_Name from Project;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Quarter -- 
Alter Table Project
Add Column Quarters VARCHAR(9);

Update Project
SET Quarters =
CASE
    WHEN Quarter(Date) = 1 then 'Q1'
    WHEN Quarter(Date) = 2 then 'Q2'
    WHEN Quarter(Date) = 3 then 'Q3'
    ELSE 'Q4'
    END;
    
Select Quarters from Project;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Year-Month --  
Alter Table Project
Add Column YearMonth VARCHAR(25);

Update Project
SET YearMonth = date_format(date,'%Y-%m');

SELECT YearMonth from Project;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WeekDayNo --
Alter Table Project
Add Column WeekDayNo INT;

Update Project
SET WeekDayNo = weekday(date);

SELECT WeekDayNo from Project;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WeekDayName --
Alter Table Project
Add Column WeekDayName VARCHAR(25);

Update Project
SET WeekDayName = dayname(date);

SELECT WeekDayName from Project;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Financial Month Date -- 
Alter Table Project
Add Column Financial_Month_Date VARCHAR(25);

Update Project
Set Financial_Month_Date = Adddate((date),interval '-3' Month);

SELECT Financial_Month_Date from Project;

--------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Financial Month --
Alter Table Project
Add Column Financial_Month VARCHAR(25);

Update Project
Set Financial_Month =  MONTH(Financial_Month_Date);

SELECT Financial_Month from Project;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Financial Quarter -- 
Alter Table Project
Add Column Financial_Quarter VARCHAR(25);
    
Update Project
SET Financial_Quarter =
CASE
    WHEN Month(Date) < 4 then 'Q4'
    WHEN Month(Date) < 7 then 'Q1'
    WHEN Month(Date) < 10 then'Q2'
    ELSE 'Q3'
END;

SELECT Financial_Quarter from Project;

--------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Weekday VS Weekend --
Alter Table Project
Add Column WeekDay_VS_Weekend VARCHAR(25);

Update Project
SET WeekDay_VS_Weekend = 
  CASE
  WHEN DAYNAME(date) IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
    END;
    
SELECT WeekDay_VS_Weekend from Project;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DATE VIEW --
CREATE VIEW DATE_FIELD AS
SELECT `Date`,`MonthNo`,`Month_Name`,`Quarters`,`YearMonth`,`WeekDayNo`,`WeekDayName`,`Financial_Month`,`Financial_Quarter`
FROM Project;

Select * from DATE_FIELD;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis --

-- Load Factor--
Alter Table Project
Add Column Load_Factor FLOAT DEFAULT NULL;

Update Project 
SET Load_Factor = ifnull(round(`Transported Passengers`/`Available Seats`*100,2),0);

SELECT Load_Factor from Project;

--------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW LoadFactor AS
SELECT `Year`,`Quarters`,`Month`, ROUND(avg(Load_Factor*100),2) AS AVG_LoadFactor
FROM Project 
GROUP BY `Year`,`Quarters`,`Month`;

SELECT * from LoadFactor;

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3. Find the load Factor percentage on a Carrier Name basis  -- 

CREATE VIEW Carrier_Name AS
SELECT `Carrier Name`, ROUND(avg(Load_Factor*100),2) AS AVG_LoadFactor
FROM Project
GROUP BY `Carrier Name`;

SELECT * FROM Carrier_Name;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q4. Identify Top 10 Carrier Names based passengers preference --

CREATE VIEW Top10_Carrier_Name AS
SELECT `Carrier Name`, SUM(`Transported Passengers`) AS No_of_passengers
FROM Project
GROUP BY `Carrier Name`
order by No_of_passengers DESC
LIMIT 10;

Select * from Top10_Carrier_Name;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q5. Display top Routes ( from-to City) based on Number of Flights --

CREATE VIEW Top_Route AS
SELECT `From - To City`, Count(`Departures Performed`) as No_of_Flights
FROM Project
group by `From - To City`
order by No_of_Flights DESC
LIMIT 20;

SELECT * FROM Top_Route;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6. Identify the how much load factor is occupied on Weekend vs Weekdays --

CREATE VIEW Weekend_VS_Weekday AS
SELECT `WeekDay_VS_Weekend`, ROUND(avg(Load_Factor*100),2) AS AVG_Loadfactor
FROM Project
Group By `WeekDay_VS_Weekend`;

SELECT * from Weekend_VS_Weekday;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*-- Q7.Use the filter to provide a search capability to find the flights between 
Source Country, Source State, Source City to Destination Country , Destination State, Destination City --*/

Create View Search_Capability_To_Find_The_Flights AS
SELECT `Airline ID`,`Datasource ID`,`Region Code`,`Carrier Name`,`Origin Country`,`Destination Country`,`Origin State`,`Destination State`,`Origin City`,`Destination City`
FROM Project;

SELECT * FROM Search_Capability_To_Find_The_Flights;

---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8. Identify number of flights based on Distance groups --

CREATE VIEW DistanceGroup_IDs AS
SELECT `Distance Group ID`, Count(`Departures Performed`) AS No_of_flights
FROM Project
GROUP BY `Distance Group ID`
Order BY No_of_flights DESC;

SELECT * FROM DistanceGroup_IDs;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

