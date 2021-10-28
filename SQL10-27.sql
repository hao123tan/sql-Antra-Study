-- Answer following questions

-- 1. What is a result set.
	-- A result set is an object that represents a set of data returned from a data source.

-- 2. What is the difference between Union and Union All?
	-- 1. UNION removes duplicate records, Union ALL not.
	-- 2. UNION: the records from the first column will be sorted ascending.
	-- 3. UNION cannot be used in recursive cte, but UNION ALL can.

-- 3. What are the Other Set Operators SQL Server has?
	-- UNION, EXCEPT AND INTERSECT

-- 4. What is the different between INNER JOIN and FULL JOIN?
	-- INNER JOIN returns only the matching rows between both the tables.
	-- FULL Join returns all rows from both the tables.

-- 5. What is the difference between left join and outer join
	-- left join will return all the rows from the left table and matching records between both the tables.
	-- Full outer join combines the result of the left outer join and right outer join.

-- 6. What is the difference between Union and Join?
	-- join is used to combine columns from different tables
	-- union is used to combine rows.

-- 7. What is cross join?
	-- a type of join that returns the cartesian product of rows from the tables in the join.

-- 8. What is the difference between WHERE clause and HAVING clause?
	-- HAVING applies only to groups as a whole, as only filter aggretated fileds, but WHERE appleis to individual rows
	-- HERE goes before aggregations, but HAVING filters after the aggregtions
	-- WHERE can be used with SELECT, UPDATE and DELETE statment, but HAVING can only be used in SELECT statement.

-- 9. Can there be multiple group by columns?
	-- A GROUP BY clause can contain two or more columns.

use AdventureWorks2019
GO

-- 1. How many products can you find in the Production.Product table?
	SELECT COUNT(*) AS NUMBER FROM Production.Product
-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
	SELECT Count(*) AS NUMBER FROM Production.Product WHERE ProductSubcategoryID IS NOT NULL
-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
	SELECT ProductSubcategoryID, COUNT(*) FROM Production.Product GROUP BY ProductSubcategoryID HAVING ProductSubcategoryID IS NOT NULL
-- 4. How many products that do not have a product subcategory.
	SELECT COUNT(*) as Number FROM Production.Product WHERE ProductSubcategoryID IS NULL
-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
	SELECT SUM(Quantity) AS Quantity FROM Production.ProductInventory
-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
	SELECT p.ProductID, SUM(p.Quantity) AS TheSum FROM Production.ProductInventory p Group BY ProductID, LocationID HAVING p.LocationID = 40 AND SUM(p.Quantity) < 100
-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
	SELECT p.Shelf ,p.ProductID, SUM(p.Quantity) AS TheSum FROM Production.ProductInventory p Group BY ProductID, LocationID, Shelf HAVING p.LocationID = 40 AND SUM(p.Quantity) < 100
-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
	SELECT AVG(Quantity) AS average FROM Production.ProductInventory WHERE LocationID = 10
-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
	SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg FROM Production.ProductInventory GROUP BY ProductID, Shelf
-- 10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
	SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg FROM Production.ProductInventory GROUP BY ProductID, Shelf HAVING Shelf IS NOT NULL
-- 11.List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
	SELECT Color, Class, COUNT(*) TheCount, AVG(ListPrice) AvgPrice FROM Production.Product GROUP BY Color, Class HAVING Color IS NOT NULL AND Class IS NOT NULL
-- 12.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 
	SELECT c.Name Country, s.Name Province FROM Person.CountryRegion c join Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
-- 13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
	SELECT c.Name Country, s.Name Province FROM Person.CountryRegion c join Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode WHERE c.Name != 'Germany' AND c.Name != 'Canada'
use Northwind
GO
-- 14.List all Products that has been sold at least once in last 25 years.
	SELECT DISTINCT p.ProductName FROM Products p join [Order Details] od ON p.ProductID = od.ProductID join Orders o ON od.OrderID = o.OrderID WHERE YEAR(o.OrderDate) > 1996
-- 15.List top 5 locations (Zip Code) where the products sold most.
	SELECT TOP 5 o.ShipPostalCode, od.ProductID, SUM(od.Quantity) FROM Orders o join [Order Details] od ON o.OrderID = od.OrderID GROUP BY o.ShipPostalCode, od.ProductID ORDER BY 3 DESC
-- 16.List top 5 locations (Zip Code) where the products sold most in last 25 years.
	SELECT TOP 5 o.ShipPostalCode, od.ProductID, SUM(od.Quantity) FROM Orders o join [Order Details] od ON o.OrderID = od.OrderID GROUP BY o.ShipPostalCode, od.ProductID, o.OrderDate HAVING YEAR(o.OrderDate) > 1996 ORDER BY 3 DESC
-- 17.List all city names and number of customers in that city.
	SELECT City, COUNT(*) AS Number FROM Customers GROUP BY City
-- 18.List city names which have more than 2 customers, and number of customers in that city
	SELECT City, COUNT(*) AS Number FROM Customers GROUP BY City HAVING COUNT(*) > 2
-- 19.List the names of customers who placed orders after 1/1/98 with order date.
	SELECT DISTINCT c.ContactName FROM Customers c join Orders o ON c.CustomerID = o.CustomerID WHERE YEAR(O.OrderDate) > 1997
-- 20.List the names of all customers with most recent order dates
	SELECT DISTINCT ContactName FROM Customers  WHERE CustomerID = (SELECT o1.CustomerID FROM Orders o1 join Orders o2 ON o1.OrderID = o2.OrderID WHERE o1.OrderDate < o2.OrderDate)
-- 21.Display the names of all customers  along with the  count of products they bought
	SELECT DISTINCT c.ContactName, Sum(od.Quantity) AS Number FROM Customers c join Orders o ON c.CustomerID = o.CustomerID join [Order Details] od ON o.OrderID = od.OrderID GROUP BY c.ContactName
-- 22.Display the customer ids who bought more than 100 Products with count of products.
	SELECT DISTINCT c.CustomerID FROM Customers c join Orders o ON c.CustomerID = o.CustomerID join [Order Details] od ON o.OrderID = od.OrderID GROUP BY c.CustomerID HAVING Count(od.ProductID) > 100
-- 23.List all of the possible ways that suppliers can ship their products. Display the results as below
-- 24.Display the products order each day. Show Order date and Product Name.
-- 25.Displays pairs of employees who have the same job title.
	SELECT e1.LastName + ' ' + e1.FirstName, e2.LastName + ' ' + e2.FirstName FROM Employees e1 join Employees e2 ON e1.Title = e2.Title
-- 26.Display all the Managers who have more than 2 employees reporting to them.
	SELECT e1.LastName + ' ' + e1.FirstName FROM Employees e1 GROUP BY ReportsTo, LastName, FirstName HAVING COUNT(EmployeeID) > 2
-- 27.Display the customers and suppliers by city. The results should have the following columns
