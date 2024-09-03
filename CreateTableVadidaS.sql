--CREATE DATABASE AND TABLE FOR VADIDAS

CREATE DATABASE VadidaS
GO
USE VadidaS
GO

CREATE TABLE MsStaff (
StaffID CHAR (5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]') NOT NULL,
StaffName VARCHAR (100) NOT NULL,
StaffGender VARCHAR (10) NOT NULL,
StaffEmail VARCHAR (100) NOT NULL,
StaffAddress VARCHAR (100) NOT NULL,
StaffSalary INT NOT NULL,
)

CREATE TABLE MsCustomer(
CustomerID CHAR (5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
CustomerName VARCHAR (100) NOT NULL,
CustomerGender VARCHAR (10) NOT NULL,
CustomerDOB DATE NOT NULL,
CustomerAddress VARCHAR (100) NOT NULL,
CustomerEmail VARCHAR (100) NOT NULL
)

CREATE TABLE MsVendor (
VendorID CHAR (5) PRIMARY KEY CHECK (VendorID LIKE 'VE[0-9][0-9][0-9]'),
VendorName VARCHAR (100) NOT NULL,
VendorAddress VARCHAR (100) NOT NULL,
VendorEmail VARCHAR (100) NOT NULL,
VendorNumber VARCHAR (20) NOT NULL
)

CREATE TABLE MsShoe (
ShoeID CHAR (5) PRIMARY KEY CHECK (ShoeID LIKE 'SH[0-9][0-9][0-9]'),
ShoeName VARCHAR (25) NOT NULL,
ShoePrice INT NOT NULL,
ShoeDescription VARCHAR (255) 
)

CREATE TABLE PurchaseHeader (
PurchaseID CHAR (5) PRIMARY KEY CHECK (PurchaseID LIKE 'PU[0-9][0-9][0-9]'),
VendorID CHAR (5) FOREIGN KEY REFERENCES MsVendor(VendorID) NOT NULL,
StaffID CHAR (5) FOREIGN KEY REFERENCES MsStaff(StaffID) NOT NULL,
PurchaseDate DATE NOT NULL
)

CREATE TABLE PurchaseDetail(
PurchaseID CHAR (5) FOREIGN KEY REFERENCES PurchaseHeader (PurchaseID) NOT NULL,
ShoeID CHAR (5) FOREIGN KEY REFERENCES MsShoe(ShoeID) NOT NULL,
Quantity INT NOT NULL
)

CREATE TABLE TransactionHeader (
TransactionID CHAR (5) PRIMARY KEY CHECK (TransactionID LIKE 'TR[0-9][0-9][0-9]'),
StaffID CHAR (5) FOREIGN KEY REFERENCES MsStaff(StaffID) NOT NULL,
CustomerID CHAR (5) FOREIGN KEY REFERENCES MsCustomer (CustomerID) NOT NULL,
TransactionDate DATE NOT NULL
)

CREATE TABLE TransactionDetail (
TransactionID CHAR (5) FOREIGN KEY REFERENCES TransactionHeader (TransactionID) NOT NULL,
ShoeID CHAR (5) FOREIGN KEY REFERENCES MsShoe (ShoeID) NOT NULL,
Quantity INT NOT NULL
)

--ADD CONSTRAINT REQUIREMENT

ALTER TABLE MsVendor
ADD CONSTRAINT chk_veemail CHECK (VendorEmail LIKE '%@gmail.com')

ALTER TABLE MsStaff
ADD CONSTRAINT chk_stname CHECK (LEN(StaffName)>10)

ALTER TABLE MsStaff
ADD CONSTRAINT chk_stgender CHECK (StaffGender LIKE 'Male' OR StaffGender LIKE 'Female')

ALTER TABLE MsStaff
ADD CONSTRAINT chk_stemail CHECK (StaffEmail LIKE '%gmail.com')

ALTER TABLE MsStaff
ADD CONSTRAINT chk_stsalary CHECK (StaffSalary BETWEEN 120000 AND 500000)

ALTER TABLE MsCustomer
ADD CONSTRAINT chk_cuname CHECK (LEN(CustomerName) > 10)

ALTER TABLE MsCustomer
ADD CONSTRAINT chk_cugender CHECK (CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female')

ALTER TABLE MsCustomer
ADD CONSTRAINT chk_cuemail CHECK (CustomerEmail LIKE '%gmail.com')

ALTER TABLE MsCustomer
ADD CONSTRAINT chk_customer_age CHECK (DATEDIFF(YEAR, CustomerDOB, GETDATE()) >= 17)



