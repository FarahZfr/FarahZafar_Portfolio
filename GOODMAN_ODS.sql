/*Good Man Inc. Case Study
Task 1.
As a SQL Developer with Good Man Incorporation, you are tasked by the management to produce the
following summary reports for Year/ and Month from the operational Data Store:
a. Total Purchased Amount and quantity of produced supplied by supplier from each country
b. Total Count of transaction, Quantity, purchase amount by city, country
c. Average delivery time for each product, supplier and City
d. Total purchase amount and quantity supplies made by each employ*/

select * from ods.SupplierTrans
select * from ods.Supplier
Select * from ods.Product
select * from ods.Country
select * from ods.Category
select * from ods.CategoryProduct

/*Use of Concatination function to concat first and last name */

--select s.SupplierID, s.AddressID, s.AccountNumber, CONCAT(s.FirstName , '', s.LastName) Name, s.LoadDate from ods.Supplier s


select 
s.SupplierID,CONCAT(s.FirstName , ' ', s.LastName) as [Supplier Name], ct.CountryName as [Country],
sum(st.PurchaseAmount)TotalPurchaseAmount, Sum(st.OrderQty)TotalQuantity, st.ShipDate
from ods.SupplierTrans st

Inner Join ods.Supplier s on s.SupplierID= st.SupplierID
Inner Join ods.SupplierAddress sa on sa.AddressID = s.AddressID
Inner join ods.City c on c.cityID= sa.cityID
Inner join ods.StateProvince sp on sp.ProvinceID = c.ProvinceID
Inner join ods.Country ct on ct.CountryID = sp.CountryID
--Inner join ods.Product p on p.ProductID = st.productID
group by s.SupplierID,CONCAT(s.FirstName , ' ', s.LastName),
ct.CountryName,st.ShipDate
order by Country,[Supplier Name],st.ShipDate


/******Create a Function of Year and Month**************/

/**We drop the Function SummarybyYearMonth and created under schema ods.SummarybyYearMonth**/
--a. Total Purchased Amount and quantity of produced supplied by supplier from each country

--drop  Function ods.SummarybyYearMonth
--Create Function ods.SummarybyYearMonth (@Year int, @Month nvarchar (10))
--RETURNS Table
--As 
--RETURN
select 
	ct.CountryName as [Country],s.SupplierID,CONCAT(s.FirstName , ' ', s.LastName) as [Supplier Name], 
	sum(st.PurchaseAmount)TotalPurchaseAmount, Sum(st.OrderQty)TotalQuantity,Year(st.ShipDate) as [Year], 
	DATENAME(mm, st.ShipDate) as [Month]
from ods.SupplierTrans st

Inner Join ods.Supplier s on s.SupplierID= st.SupplierID
Inner Join ods.SupplierAddress sa on sa.AddressID = s.AddressID
Inner join ods.City c on c.cityID= sa.cityID
Inner join ods.StateProvince sp on sp.ProvinceID = c.ProvinceID
Inner join ods.Country ct on ct.CountryID = sp.CountryID
--Inner join ods.Product p on p.ProductID = st.productID

--where @Year = Year(ShipDate)and @Month = DATENAME(MM, ShipDate) 
group by s.SupplierID,CONCAT(s.FirstName , ' ', s.LastName),
ct.CountryName
Order by Year,Month, Country,[Supplier Name]
select * from ods.SummarybyYearMonth(2005, 'June')

select * from ods.SummarybyYearMonth(2006, 'May')
select * from ods.SummarybyYearMonth(2007, 'January')
select * from ods.SummarybyYearMonth(2008, 'March')




--b. Total Count of transaction, Quantity, purchase amount by city, country
/*drop  Function ods.SummarybyTransaction
Create Function ods.SummarybyTransaction (@Year int, @Month nvarchar (10))
RETURNS Table
As 
RETURN*/
select 
	CONCAT(s.FirstName , ' ', s.LastName) as [Supplier Name], ct.CountryName as [Country], c.CityName as [City],
	format(sum(st.PurchaseAmount), 'c') as [TotalPurchaseAmount] ,Year(st.ShipDate) as [Year], Datename(mm, st.ShipDate) as [Month],
	Sum(st.OrderQty)as [Total Quantity],Count(st.TransID)as [Total Transaction],p.ProductName as [Product]
from ods.SupplierTrans st

Inner Join ods.Supplier s on s.SupplierID= st.SupplierID
Inner Join ods.SupplierAddress sa on sa.AddressID = s.AddressID
Inner join ods.City c on c.cityID= sa.cityID
Inner join ods.StateProvince sp on sp.ProvinceID = c.ProvinceID
Inner join ods.Country ct on ct.CountryID = sp.CountryID
Inner join ods.Product p on p.ProductID = st.productID

--where @Year = Year(ShipDate)and @Month = DATENAME(MM, ShipDate) 
group by CONCAT(s.FirstName , ' ', s.LastName), p.ProductName, c.CityName,st.ShipDate,
ct.CountryName
Order by Year,Month

--select * from ods.SummarybyTransaction(2005, 'June')

--c. Average delivery time for each product, supplier and City

/*Create Function ods.SummarybyAvgDelivery (@Year int, @Month nvarchar (10))
RETURNS Table
As 
RETURN*/

select 
	Year(st.ShipDate) as [Year], DATENAME(mm, ShipDate) as [Month],
	CONCAT(s.FirstName , ' ', s.LastName) as [Supplier Name], ct.CountryName as [Country], c.CityName as [City],
	format(sum(st.PurchaseAmount), 'c') as [TotalPurchaseAmount] ,
	Sum(st.OrderQty)as [Total Quantity],Count(st.TransID)as [Total Transaction],p.ProductName as [Product],
	AVG(DateDiff(d, st.OrderDate,st.ShipDate)) as [AvgDelivery]

from ods.SupplierTrans st

Inner Join ods.Supplier s on s.SupplierID= st.SupplierID
Inner Join ods.SupplierAddress sa on sa.AddressID = s.AddressID
Inner join ods.City c on c.cityID= sa.cityID
Inner join ods.StateProvince sp on sp.ProvinceID = c.ProvinceID
Inner join ods.Country ct on ct.CountryID = sp.CountryID
Inner join ods.Product p on p.ProductID = st.productID
group by  Year(st.ShipDate),DATENAME(mm, ShipDate),CONCAT(s.FirstName , ' ', s.LastName), p.ProductName, c.CityName,
ct.CountryName
Order by [Year],[Month],[Supplier Name],[Country],[City], [Product]


--d. Total purchase amount and quantity supplies made by each employee*/
select
	Year(st.ShipDate) as [Year], 
	Datename(mm, st.ShipDate) as [Month],
	ct.CountryName as [Country], c.CityName as [City],
	CONCAT(e.FirstName, ' ', e.LastName) as [Employee Name], 
	format(sum(st.PurchaseAmount), 'c') as [TotalPurchaseAmount],Sum(st.OrderQty)as [Total Quantity]
	
from ods.SupplierTrans st

Inner Join ods.Supplier s on s.SupplierID= st.SupplierID
Inner Join ods.SupplierAddress sa on sa.AddressID = s.AddressID
Inner join ods.City c on c.cityID= sa.cityID
Inner join ods.StateProvince sp on sp.ProvinceID = c.ProvinceID
Inner join ods.Country ct on ct.CountryID = sp.CountryID
Inner join ods.Product p on p.ProductID = st.productID
Inner Join ods.Employee e on e.EmployeeID = st.EmployeeID
group by CONCAT(e.FirstName , ' ', e.LastName), c.CityName, YEAR(st.ShipDate),Datename(mm, st.ShipDate),
ct.CountryName
Order by Year,Month




/*****************************************************************************************************************
Task 2.
	You are requested to generate a new dataset for the evaluation of a new software product.
	One of your main goal is to generate 10,000 rows of 6 columns with range of transaction date from
	January 1, 2016 To Date with the following information:
Schema Name : Eval
Table Name: Product_Dataset
Column Names:
TransID surrogate key
Transaction Date
OrderID range 1 to 500
ProductID range 1 to 100
Category range 1 to 12
Promotion range 1 to 10
****************************************************************************/
Drop table Eval.ProductDataset
create Schema Eval

Create table Eval.ProductDataset
(
	TransID int identity(1,1),
	TransactionDate date,
	OrderID nvarchar(255),
	ProductID nvarchar(255),
	Category int,
	Promotion int, 
	Constraint ProductDataset_pk Primary key (TransID)
)
----Declaring  variables  name and their ranges from min to max 
truncate table Eval.ProductDataset
declare @randDay int = 0;
declare @StartDate date = '01-01-2016';
declare @EndDate date= getdate();
declare @days int= datediff(d, @StartDate, @EndDate);
--declare @counter int = 0;
declare @counter int = 0;

declare @Category int;
declare @Promotion int;
declare @Product int;
declare @Order int;
declare @Trans int;
declare @maxTrans int =  10000;
declare @maxCategory int = 12;
declare @maxPromotion int = 10;
declare @maxProduct int = 100;
declare @maxOrder int = 500;
declare @minTrans int = 1;
declare @minCategory int = 1;
declare @minPromotion int = 1;
declare @minProduct int = 1;
declare @minOrder int = 1;

while @counter< @maxTrans       -------creating couner loop for generating 10,000 rows dataset
begin
insert into Eval.ProductDataset (TransactionDate,OrderID, ProductID, Category, Promotion)
	select
	DATEADD(day, Ceiling(rand(checksum(NEWID())) * @days), @StartDate )as TransactionDate, 
	CEILING(RAND(CHECKSUM(NEWID()))*@maxOrder)  OrderID, CEILING(RAND(CHECKSUM(NEWID()))* @maxProduct) ProductID,
	CEILING(RAND(CHECKSUM(NEWID()))*@maxCategory) Category, CEILING(RAND(CHECKSUM(NEWID()))*@maxPromotion) Promotion

	--set @counter = (select COUNT(*) from Eval.ProductDataset )
		set @counter = @counter+1
END

select * from Eval.ProductDataset


select transid, TransactionDate, OrderID, ProductID,Category,Promotion from Eval.ProductDataset




--------------------------------MUSHAFFA CODE-------------------

declare 
    @StartDate date = '2016-01-01', 
    @EndDate date = cast(getdate() as date); 
declare
    @days int = datediff(day, @StartDate, @EndDate),
    @counter int;

set @counter=1
while @counter<=10000
begin
with cteProductDataset as
    (
    select 
        dateadd(day,round(RAND(checksum(newid()))*@days,0), @StartDate)  as TransDate,
        ceiling(RAND(checksum(newid()))*500) as OrderID,
        ceiling(RAND(checksum(newid()))*100) as ProductID,
        ceiling(RAND(checksum(newid()))*12) as ProductCategory,
        ceiling(RAND(checksum(newid()))*10) as Promotion
    )
insert into Eval.ProductDataset 
select TransDate, OrderID, ProductID, ProductCategory, Promotion
from cteProductDataset
set @counter= @counter+1
end 
