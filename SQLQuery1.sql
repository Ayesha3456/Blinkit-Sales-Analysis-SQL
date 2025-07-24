USE blinkitdb;
GO

SELECT * FROM blinkit_data

-- Count --
SELECT COUNT(*) FROM blinkit_data

-- Data Cleaning --
UPDATE blinkit_data 
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

-- Display Distinct Value --
SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data

-- Display Total Sales --
SELECT SUM(Total_Sales) AS Total_Sales
FROM blinkit_data

-- Display Total Sales In Particular Number Of Decimal Digits --
SELECT CAST(SUM(Total_Sales)/1000000 AS decimal(10,2)) AS Total_Sales_Million
FROM blinkit_data

-- Average Sales --
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit_data

-- Number Of Items --
SELECT COUNT(*) AS No_Of_Items FROM blinkit_data

-- Average Rating --
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data

-- Granular Requirements --
-- Total Sales By Fat Content --
SELECT Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales, 
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
      FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC

-- Total Sales By Item Type --
SELECT TOP 5 Item_Type, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales, 
       CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
      FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC

-- Fat Content By Outlet For Total Sales --
SELECT 
    Outlet_Location_Type,
    CAST(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- Total Sales By Outlet Establishment --
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year
 
-- Percentage Of Sales By Outlet Size --
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

-- Sales By Outlet Location --
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

-- All Metrics By Outlet Type --
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_dataGROUP BY Outlet_Type
ORDER BY Total_Sales DESC
