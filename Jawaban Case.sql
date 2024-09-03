--Answer of 10 Case 

--1. Display CustomerID, First Name (obtained from the first word of CustomerName), CustomerGender, 
--and Total Item Purchased (obtained from the total of Quantity) 
--for each CustomerGender equals to Male and Total Item Purchased is greater than 1.
SELECT mc.CustomerID,
		[First Name] = LEFT(CustomerName, CHARINDEX(' ',CustomerName)-1),
		CustomerGender,
		[Total Item Purchased] = SUM(Quantity)
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
WHERE CustomerGender LIKE 'Male'
GROUP BY mc.CustomerID, mc.CustomerGender, mc.CustomerName
HAVING SUM(Quantity) > 1

--2. Display Shoes Id (obtained by replacing 'SH' with 'Shoes ' from ShoesID), StaffID, 
--Transaction Day (obtained from the day of SalesDate), ShoesName, 
--and Total Sold (obtained from the total of Quantity) 
--for each ShoesPrice greater than 120000 and Total Sold must be even number.

SELECT [ShoesID] = REPLACE(ms.ShoeID, 'SH', 'Shoes '),
		mf.StaffID,
		[Transaction Day] = DAY(TransactionDate),
		ShoeName,
		[Total Sold] = SUM(Quantity)
FROM MsShoe ms
JOIN TransactionDetail td ON ms.ShoeID = td.ShoeID
JOIN TransactionHeader th ON td.TransactionID = th.TransactionID
JOIN MsStaff mf ON th.StaffID = mf.StaffID
WHERE ShoePrice > 120000
GROUP BY ms.ShoeID , mf.StaffID , th.TransactionDate , ms.ShoeName, td.Quantity 
HAVING SUM(Quantity) % 2 = 0

--3. Display Staff Number (obtained from displaying StaffID as integer), 
--Staff Name (obtained from StaffName in uppercase format), StaffSalary, 
--Total Purchase Made (obtained from total purchase made by vendor), 
--and Max Shoes Purchased (obtained from maximum of Quantity) 
--for each StaffSalary greater than 150000 and Total Purchase Made greater than 2.


SELECT  [Staff Number] = CAST(SUBSTRING(ms.StaffID, 3, LEN(ms.StaffID) - 2) AS INT),
		[Staff Name] = UPPER(StaffName),
		StaffSalary,
		[Total Purchase Made] = SUM(pd.Quantity),
		[Max Shoes Purchased] = MAX(pd.Quantity)
FROM MsStaff ms
JOIN PurchaseHeader ph ON ms.StaffID = ph.StaffID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
WHERE StaffSalary > 150000 
GROUP BY ms.StaffID, ms.StaffName, ms.StaffSalary
HAVING SUM(Quantity) > 2

--4.	Display VendorID, Vendor Name (obtained from VendorName ends with ' Vendor'), 
--Vendor Mail (obtained by replacing ‘@gmail.com’ with ‘@mail.co.id’ from VendorEmail in uppercase format), 
--Total Shoes Sold (obtained from total of Quantity), and Minimum Shoes Sold (obtained from minimum of Quantity) 
--for each Total Shoes Sold greater than 13 and Minimum Shoes Sold greater than 10.

SELECT mv.VendorID,
		[Vendor Name] = CONCAT(VendorName, ' Vendor'),
		[Vendor Mail]= UPPER(REPLACE(VendorEmail,'@gmail.com','@mail.co.id')),
		[Total Shoes Sold]= SUM(Quantity),
		[Minimum Shoes Sold]= MIN(Quantity)
FROM MsVendor mv
JOIN PurchaseHeader ph ON mv.VendorID = ph.VendorID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
GROUP BY mv.VendorID, mv.VendorName, mv.VendorEmail
HAVING SUM(pd.Quantity)>13 AND MIN(pd.Quantity) > 10

--5 Display VendorID, Vendor Name (obtained from VendorName ends with ' Company'), VendorPhone, 
--Purchase Month (obtained from the name of the month of PurchaseDate), and Quantity 
--for each transaction that occurs in April and Quantity is greater than the average of all purchasing quantity.
--(ALIAS SUBQUERY)

SELECT mv.VendorID,
		[Vendor Name] = CONCAT(VendorName, ' Company'),
		VendorNumber,
		[Purchase Month] = DATENAME(MONTH,PurchaseDate),
		Quantity
FROM MsVendor mv
JOIN PurchaseHeader ph ON mv.VendorID = ph.VendorID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID,
(SELECT AVG(Quantity) AS AVG1
 FROM PurchaseDetail pd
 JOIN PurchaseHeader ph ON pd.PurchaseID = ph.PurchaseID
) AS ALIAS
WHERE DATENAME(MONTH, PurchaseDate) = 'April'
	  AND Quantity > ALIAS.AVG1

--6. Display Invoice Number (obtained from replacing 'SA' with 'Invoice 'from SalesID),  
--Sales Year (obtained from the year of the SalesDate) ShoesName, ShoesPrice, 
--Total Item (obtained from Quantity ends with ' piece(s)') for each ShoesName that contains 'c' 
--and ShoesPrice is greater than average of all ShoesPrice.

SELECT [Invoice Number] = REPLACE(th.TransactionID,'TR', 'Invoice '),
		[Sales Year] = YEAR(TransactionDate),
		ShoeName,
		ShoePrice,
		[Total Item] = CONCAT(Quantity,' piece(s)')
FROM MsShoe ms
JOIN TransactionDetail td ON ms.ShoeID = td.ShoeID
JOIN TransactionHeader th ON td.TransactionID = th.TransactionID,
(SELECT AVG(ShoePrice) AS avgPrice
FROM MsShoe ms
) AS ALIAS1
WHERE ShoeName LIKE '%c%'
	  AND ShoePrice > ALIAS1.avgPrice

--7. Display PurchaseID, StaffID, Staff Name (obtained from StaffName in uppercase format), 
--Purchase Date (obtained from PurchaseDate in 'dd/mm/yyyy' format), 
--and Total Expenses (obtained from calculating the total of multiplication between ShoesPrice and Quantity and starts with 'Rp. ') 
--for each Total Expenses greater than the average of multiplication between ShoesPrice and Quantity 
--and last three digit of StaffID must be an odd number.

SELECT ph.PurchaseID,
	   ms.StaffID,
	   [Staff Name] = UPPER(StaffName),
	   [Purchase Date] = CONVERT(VARCHAR, PurchaseDate, 103),
	   [Total Expenses]= CONCAT ('Rp. ',SUM(ShoePrice*Quantity))
FROM MsStaff ms
JOIN PurchaseHeader ph ON ms.StaffID = ph.StaffID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
JOIN MsShoe sh ON pd.ShoeID = sh.ShoeID,
(SELECT AVG(ShoePrice * Quantity) AS AVG1
     FROM MsShoe sh
     JOIN TransactionDetail td ON sh.ShoeID = td.ShoeID
     JOIN TransactionHeader th ON td.TransactionID = th.TransactionID
     JOIN MsStaff ms ON th.StaffID = ms.StaffID
     ) AS ALIAS1
WHERE RIGHT(ms.StaffID, 3) % 2 = 1
GROUP BY
	ALIAS1.AVG1,ph.PurchaseID,ms.StaffID,ms.StaffName,ph.PurchaseDate
HAVING
    SUM(ShoePrice * Quantity) > ALIAS1.AVG1;

--8.Display SalesID, StaffID, First Name (obtained from the first word of StaffName), 
--Last Name (obtained from the last word of StaffName), 
--and Total Revenue (obtained from the total of multiplication between Quantity and ShoesPrice) 
--for each StaffGender that equals 'Female' and ShoesPrice is greater than the average of all shoes price.
--(ALIAS SUBQUERY)

SELECT [SalesID] = th.TransactionID,
	   ms.StaffID,
	   [First Name] = LEFT(StaffName, CHARINDEX(' ', StaffName)),
	   [Last Name] = RIGHT(StaffName,CHARINDEX(' ',REVERSE(StaffName))),
	   [Total Revenue] = SUM(Quantity*ShoePrice)
FROM MsStaff ms
JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsShoe sh ON td.ShoeID = sh.ShoeID,
(SELECT AVG(ShoePrice) AS AVG1
FROM MsShoe ms
JOIN TransactionDetail td ON ms.ShoeID = td.ShoeID
JOIN TransactionHeader th ON td.TransactionID = th.TransactionID
JOIN MsStaff st ON th.StaffID = st.StaffID
) AS ALIAS
WHERE ShoePrice > ALIAS.AVG1
	  AND  StaffGender LIKE 'Female' 
GROUP BY 
	  th.TransactionID, ms.StaffID, ms.StaffName


--9. Create a view named 'Vendor Max Transaction View' to display Vendor Number (obtained by replacing 'VE' with 'Vendor ' from VendorID), 
--Vendor Name (obtained from VendorName in lower case format), Total Transaction Made (obtained from the total transaction made), 
--Maximum Quantity (obtained from maximum of Quantity) for each VendorName that contains 'a' and Maximum Quantity greater than 20.

CREATE VIEW [Vendor Max Transaction View] AS
SELECT [Vendor Number]= REPLACE(mv.VendorID,'VE','Vendor '),
	   [Vendor Name]= LOWER(VendorName),
	   [Total Transaction Made]= COUNT(Quantity),
	   [Maximum Quantity] = MAX(Quantity)
FROM MsVendor mv
JOIN PurchaseHeader ph ON ph.VendorID = mv.VendorID
JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
WHERE VendorName LIKE '%a%'
GROUP BY mv.VendorID, mv.VendorName
HAVING MAX(Quantity) > 20

--10.	Create view named 'Shoes Minimum Transaction View' to display SalesID, SalesDate, StaffName, 
--Staff Email (obtained from StaffEmail in uppercase format), Minimum Shoes Sold (obtained from minimum of Quantity),
--and Total Shoes Sold (obtained from total of Quantity) for SalesDate that occurs after 2020 and ShoesPrice greater than 10000.

CREATE VIEW [Shoes Minimum Transaction View] AS
SELECT [SalesID] = th.TransactionID,
	   [SalesDate] = th.TransactionDate,
	   StaffName,
	   [Staff Email] = UPPER(StaffEmail),
	   [Minimum Shoes Sold] = MIN(td.Quantity),
	   [Total Shoes Sold] = SUM(td.Quantity)
FROM MsStaff ms
JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsShoe sh ON td.ShoeID = sh.ShoeID
WHERE YEAR(TransactionDate) > 2020
AND ShoePrice > 10000
GROUP BY th.TransactionID, th.TransactionDate, ms.StaffName, ms.StaffEmail



