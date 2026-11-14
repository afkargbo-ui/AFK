/*****************************************************************************************************************
NAME:    W3.4 Adventure Works-Craft Answers
PURPOSE: The purpose is to build my SQL translation skills using SQL

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     14/11/2026   AFKARGBO       1. Built this script for EC IT143


RUNTIME: 
 Xs

NOTES: 
Designed for W3.4	- Adventure Works: Craft Answer 

This script is design for the use of SQL to generated to the queations from my section and other resources by demostrating to 
student on how to give solution to an actual developed complexity question using 
-- Adventure Works Meta data -> https://dataedo.com/samples/html/AdventureWorks/index.html
-- SQL
-- SSMS

 
******************************************************************************************************************/

-- Q1:What is the number of employees that are currently working at AdventureWorks?
-- A1: Active number of employees are 290

SELECT COUNT(*) AS ActiveEmployees
FROM HumanResources.Employee
WHERE CurrentFlag = 1;

-- Q2: List the product that has the highest list price?
-- A:   product with highest list price is Road-150 Red.62        
SELECT TOP 1 WITH TIES 
    ProductID, 
    Name, 
    ProductNumber, 
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Q3: Can you create a list of all tables in the AdventureWorks database that contain a column named 'ProductID'?
-- A: 

SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID'
  AND TABLE_NAME IN (
      SELECT TABLE_NAME 
      FROM INFORMATION_SCHEMA.TABLES 
      WHERE TABLE_TYPE = 'BASE TABLE'
  )
ORDER BY TABLE_SCHEMA, TABLE_NAME;


-- Q4: We need to evaluate our sales performance. Can you list the names of the stores and their total sales amounts for the year 2013?
-- A:
SELECT 
    s.Name AS StoreName,
    SUM(soh.TotalDue) AS TotalSales2013
FROM Sales.Store AS s
JOIN Sales.Customer AS c 
    ON s.BusinessEntityID = c.StoreID
JOIN Sales.SalesOrderHeader AS soh 
    ON c.CustomerID = soh.CustomerID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY s.Name
ORDER BY TotalSales2013 DESC;


-- Q5: I would like to see a break down of order per country and what products the order contains?
-- A:
SELECT 
    cr.Name AS Country,
    soh.SalesOrderID,
    p.Name AS ProductName,
    sod.OrderQty
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesTerritory AS st 
    ON soh.TerritoryID = st.TerritoryID
JOIN Person.CountryRegion AS cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
JOIN Sales.SalesOrderDetail AS sod 
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product AS p 
    ON sod.ProductID = p.ProductID
ORDER BY Country, soh.SalesOrderID;


-- Q6: Create view of our Employees on who gets paid weekly or biweekly from the HumanResources.EmployeePayHistory?
-- A: 
CREATE VIEW

HumanResources.vw_EmployeePayFrequency
AS
SELECT
    E.BusinessEntityID,
    P.FirstName,
    P.LastName,
    E.JobTitle,
    EPH.Rate,
    EPH.PayFrequency,
    CASE
        WHEN EPH.PayFrequency = 1 THEN 'Weekly'
        WHEN EPH.PayFrequency = 2 THEN 'Biweekly'
    END AS PaymentFrequency,
    EPH.RateChangeDate
FROM HumanResources.Employee E
INNER JOIN HumanResources.EmployeePayHistory EPH
    ON E.BusinessEntityID = EPH.BusinessEntityID
INNER JOIN Person.Person P
    ON E.BusinessEntityID = P.BusinessEntityID
WHERE EPH.PayFrequency IN (1, 2);


-- Q7: list components that were ordered in 2012 but never used in production, with component name, supplier, cost, and order date?
-- A:   
     SELECT 
    p.Name AS ComponentName,
    v.Name AS SupplierName,
    pod.UnitPrice AS Cost,
    poh.OrderDate
FROM Purchasing.PurchaseOrderDetail AS pod
INNER JOIN Purchasing.PurchaseOrderHeader AS poh
    ON pod.PurchaseOrderID = poh.PurchaseOrderID
INNER JOIN Production.Product AS p
    ON pod.ProductID = p.ProductID
INNER JOIN Purchasing.ProductVendor AS pv
    ON p.ProductID = pv.ProductID
INNER JOIN Purchasing.Vendor AS v
    ON pv.BusinessEntityID = v.BusinessEntityID
WHERE YEAR(poh.OrderDate) = 2012
  AND NOT EXISTS (
      SELECT 1
      FROM Production.BillOfMaterials AS bom
      WHERE bom.ComponentID = p.ProductID
  )
ORDER BY poh.OrderDate, p.Name;
    

-- Q8:Number of bike sales performed during 2013. Show monthly sales revenue, quantity sold, and average selling price for each mountain bike product?
-- A: 
SELECT 
    MONTH(soh.OrderDate) AS SalesMonth,
    DATENAME(MONTH, soh.OrderDate) AS MonthName,
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS MonthlySalesRevenue,
    SUM(sod.OrderQty) AS QuantitySold,
    SUM(sod.LineTotal) / SUM(sod.OrderQty) AS AverageSellingPrice
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod 
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS p 
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc 
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE 
    YEAR(soh.OrderDate) = 2013
    AND psc.Name = 'Mountain Bikes'
GROUP BY 
    MONTH(soh.OrderDate),
    DATENAME(MONTH, soh.OrderDate),
    p.Name
ORDER BY 
    SalesMonth ASC,
    MonthlySalesRevenue DESC;







SELECT GETDATE() AS my_date; 