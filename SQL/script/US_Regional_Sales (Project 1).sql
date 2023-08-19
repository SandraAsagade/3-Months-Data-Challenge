/* US REGIONAL SALES (FICTIONAL SALES DATA) FOR SQL PROJECT */

--1. Checking for duplicates
USE usregionalsales;
SELECT
	OrderNumber,
    COUNT(OrderNumber)
FROM sales_order
GROUP BY OrderNumber
HAVING COUNT(OrderNumber) > 1;

--2. Adding a Revenue and Profit column
ALTER TABLE sales_order ADD Revenue DOUBLE;
UPDATE sales_order
SET Revenue = ROUND((UnitPrice * OrderQuantity),2);

ALTER TABLE sales_order ADD Profit DOUBLE;
UPDATE sales_order
SET Profit = ROUND(((UnitPrice - UnitCost)*OrderQuantity),2);
SELECT * FROM sales_order;

--3. converting and changing the date format from text(dd/mm/yyyy) to date(yyyy-mm-dd) 
UPDATE usregionalsales.sales_order
SET ProcuredDate = str_to_date(ProcuredDate, "%d/%m/%Y");
UPDATE usregionalsales.sales_order
SET OrderDate = str_to_date(OrderDate, "%d/%m/%Y");
UPDATE usregionalsales.sales_order
SET ShipDate = str_to_date(ShipDate, "%d/%m/%Y");
UPDATE usregionalsales.sales_order
SET DeliveryDate = str_to_date(DeliveryDate, "%d/%m/%Y");
SELECT
	ProcuredDate,
    OrderDate,
    ShipDate,
    DeliveryDate 
FROM sales_order;

--4. Total transactions made
SELECT
	COUNT(*) AS Total_orders_made,
    SUM(OrderQuantity) AS Total_Quantity,
    ROUND(SUM(Revenue),2) AS Total_Revenue,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_order;

--5. Number of transactions/products/total revenue/profit ordered per order date(year)
SELECT
	DATE_FORMAT(OrderDate, '%Y') AS Year,
    COUNT(*) AS Total_Transaction,
    SUM(OrderQuantity) AS Total_Quantity,
     ROUND(SUM(Revenue),2) AS Total_Revenue,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_order
GROUP BY Year
ORDER BY Revenue DESC;

--6. Transaction per Sales channel
SELECT
	SalesChannel,
    COUNT(*) AS Total_Transaction
FROM sales_order
GROUP BY SalesChannel;

--7. How many customers ordered
SELECT
    COUNT(DISTINCT _CustomerID) AS Total_Customers,
    COUNT(DISTINCT _SalesTeamID) AS Total_Sales_Team
FROM sales_order s1;

--8. Distinct Products ordered
SELECT
    COUNT(DISTINCT s1._ProductID) AS Total_Products
FROM sales_order s1
JOIN product p
	USING(_ProductID);

--9. Total number of Orders each customer made
SELECT
	c._CustomerID,
    CustomerNames,
    COUNT(*) AS Total_Transaction
FROM sales_order s1
JOIN customer c
	USING(_CustomerID)
GROUP BY _CustomerID
ORDER BY Total_Transaction DESC;

--10. Total number of stores in each region
SELECT
	Region,
    COUNT(_StoreID) AS Stores_Count
FROM location
JOIN region
	USING(StateCode)
GROUP BY Region
ORDER BY Stores_Count DESC;

--11. Total state in each region
SELECT
	Region,
	COUNT(State) AS Total_States
FROM region
GROUP BY Region
ORDER BY Total_States DESC;

--12. Total quantity sold and transaction per store
SELECT
	_StoreID,
    COUNT(*) AS Transaction_Count,
    SUM(OrderQuantity) AS Total_Quantity_Sold
FROM sales_order
GROUP BY _StoreID
ORDER BY Total_Quantity_Sold DESC;

--13. Total revenue and profit from each city
SELECT
	CityName,
     ROUND(SUM(Revenue),2) AS Total_Revenue,
     ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_order s1
JOIN location l
 USING(_StoreID)
GROUP BY l.CityName
ORDER BY Revenue DESC;

--14. Most expensive and least expensive products
SELECT
	p.ProductName,
    s1.UnitPrice AS Price,
    FIRST_VALUE(p.ProductName) OVER (ORDER BY UnitPrice Desc) AS Most_Expensive_Product,
   LAST_VALUE(p.ProductName) OVER (ORDER BY UnitPrice Desc 
		RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Least_Expensive_Product
FROM sales_order s1
JOIN product p
	USING(_ProductID)
GROUP BY p.ProductName;

--15. Total Revenue/Profit in each region by year
WITH cte AS (
	SELECT
		Region,
		DATE_FORMAT(OrderDate, '%Y') AS Year,
		ROUND(SUM(Revenue),2) AS Total_Revenue,
		ROUND(SUM(Profit),2) AS Total_Profit
	FROM sales_order
	JOIN location
		USING(_StoreID)
	JOIN region
		USING(StateCode)
	GROUP BY Region, Year
	ORDER BY Region, Year, Revenue)
SELECT
    Region,
    Year,
    Total_Revenue,
    Total_Profit,
    ROUND(SUM(Total_Revenue) OVER(PARTITION BY Region),2) AS Total_Revenue_Per_Region,
    ROUND(((Total_Revenue/18255731.2)*100),2)AS Percent_Of_Total_Revenue
FROM cte
GROUP BY Region, Year
ORDER BY Region;
    
--16. Total Transaction per location type
SELECT
	Type,
    COUNT(*) AS Total_Transaction
FROM sales_order
JOIN location
	USING(_StoreID)
GROUP BY Type
ORDER BY COUNT(*) DESC;

--17. Sales team Performance Statistics
SELECT
    s2._SalesTeamID,
    SalesTeam,
    COUNT(*) AS Total_Transaction,
    SUM(OrderQuantity) AS Total_Quantity_Sold,
    ROUND(SUM(Revenue),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM sales_order s1
JOIN sales_team s2
	USING(_SalesTeamID)
GROUP BY SalesTeam
ORDER BY Total_Transaction DESC;

--18. Procedure to view the stats of sales team: This shows all orders made under a particular sales team
USE usregionalsales;
DROP procedure IF EXISTS sales_team_stats;
DELIMITER $$
USE usregionalsales $$
CREATE PROCEDURE sales_team_stats (IN TeamName VARCHAR(30))
BEGIN
SELECT
	OrderNumber, SalesChannel, WarehouseCode, ProcuredDate, OrderDate,ShipDate, DeliveryDate,
	CurrencyCode, _CustomerID, _StoreID, ProductName, OrderQuantity, DiscountApplied, UnitPrice, UnitCost, Revenue, Profit
FROM sales_order s1
JOIN sales_team s2
	USING(_SalesTeamID)
JOIN product p
	USING(_ProductID)
WHERE SalesTeam = TeamName;
END $$
DELIMITER ;
CALL sales_team_stats("Joshua Ryan");


--19. Date difference between Order date and delivery date
WITH cte AS(
	SELECT
		DATEDIFF(DeliveryDate,OrderDate) AS Delivery_Duration
	FROM sales_order
	GROUP BY Delivery_Duration)
SELECT
	Delivery_Duration,
    FIRST_VALUE(Delivery_Duration) OVER (ORDER BY Delivery_Duration DESC) AS Maximum_Duration,
    LAST_VALUE(Delivery_Duration) OVER (ORDER BY Delivery_Duration DESC
				RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Minimum_Duration
FROM cte;




