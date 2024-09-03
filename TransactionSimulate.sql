--Simulate the Transactions Processes VadidaS


-- Customer with staff
INSERT INTO MsCustomer VALUES
('CU016','Lionel Victory', 'Male' ,'2002-11-08', '19 Rawab BC','vicganzz@gmail.com')

INSERT INTO TransactionHeader VALUES
('TR021', 'ST013', 'CU016', '2023-06-12')

INSERT INTO TransactionDetail VALUES
('TR021', 'SH013' , 2)

--Staff with Vendor

INSERT INTO PurchaseHeader VALUES
('PU021', 'VE010', 'ST001', '2023-01-23')

INSERT INTO PurchaseDetail VALUES 
('PU021', 'SH015', 2)
