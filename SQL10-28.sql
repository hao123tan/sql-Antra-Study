--1. In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
	-- I will choose join because usually join will have better performance compared to subqueries.
--2. What is CTE and when to use it?
	-- A Common Table Expression (CTE) is the result set of a query which exists temporarily and for use only within the context of a larger query.
--3. What are Table Variables? What is their scope and where are they created in SQL Server?
	-- variable type is table. The scope is within the batch.
--4. What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
	-- Truncate command is faster than Delete command. It will remove all row once and it does not reset it to seed value.
--5. What is Identity column? How does DELETE and TRUNCATE affect it?
	-- Delete command will retain identity. A SQL Server IDENTITY column is a special type of column that is used to automatically generate key values based on a provided seed.
--6. What is difference between “delete from table_name” and “truncate table table_name”?
	-- Truncate command remove all rows. Delete command can remove a subset of rows.
use Northwind
GO
-- 1. List all cities that have both Employees and Customers.
	SELECT DISTINCT e.City FROM Employees e join Orders o ON e.EmployeeID = o.EmployeeID join Customers c ON c.CustomerID = o.CustomerID
-- 2. List all cities that have Customers but no Employee.
	SELECT City FROM Customers WHERE City NOT IN (SELECT City FROM Employees)
-- 3. List all products and their total order quantities throughout all orders.
	SELECT p.ProductName, SUM(od.Quantity) FROM Products p LEFT JOIN [Order Details] od ON P.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID GROUP BY p.ProductName
-- 4. List all Customer Cities and total products ordered by that city.
	SELECT c.City, p.ProductName, SUM(od.Quantity), RANK() OVER(ORDER BY SUM(od.Quantity)) RNK FROM Customers c left join Orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID join Products p on p.ProductID = od.ProductID GROUP BY c.City, p.ProductName
-- 5. List all Customer Cities that have at least two customers.
	SELECT City FROM Customers GROUP BY City HAVING COUNT(CustomerID) >= 2
-- 6. List all Customer Cities that have ordered at least two different kinds of products.
	SELECT c.City, COUNT(p.ProductID) FROM Customers c left join Orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID join Products p on p.ProductID = od.ProductID GROUP BY c.City HAVING COUNT(p.ProductID) >= 2
-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
	
-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
	SELECT dt.City, dt.ProductName, dt.UnitPrice, dt.RNK FROM (SELECT c.City, p.ProductName, p.UnitPrice, RANK() OVER(PARTITION BY c.City ORDER BY p.UnitPrice desc) RNK FROM Customers c left join Orders o on c.CustomerID = o.CustomerID join [Order Details] od on o.OrderID = od.OrderID join Products p on p.ProductID = od.ProductID GROUP BY c.City, p.ProductName, p.UnitPrice) dt WHERE dt.RNK <= 5
-- 9. List all cities that have never ordered something but we have employees there.
	
-- 10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
	
-- 11.How do you remove the duplicates record of a table?
	-- I will use DISTINCT command to remove the duplicates record of a table.
-- 12.Sample table to be used for solutions below- Employee (empid integer, mgrid integer, deptid integer, salary money) Dept (deptid integer, deptname varchar(20))
	--Find employees who do not manage anybody.
-- 13.Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.
	WITH MaxEmp
	AS
	(
	SELECT e1.Title FROM Employees e1 join Employees e2 ON e1.Title = e2.Title GROUP BY e1.Title HAVING count(e1.Title) < count(e2.Title)
	)
	SELECT * FROM MaxEmp
-- 14.Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
	