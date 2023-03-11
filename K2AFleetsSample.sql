create database K2A_Fleets


alter authorization on database::[K2A_Fleets]to farah





/*select CustomerID,CustomerName
into farah 
from Customer
cross join Equipment

select * from farah	*/

/*---use K2A_Fleets

create schema Sales

create table Sales.FloatCategory
(
	FloatCategoryID int,
	FloatRate float,
	FloatExceedQty float,
	FloatExceedRate float,
	Constraint Sales_FloatCategory_Pk primary key (FloatCategoryID)

)

create table Sales.Equipment
(
	EquipmentID int,
	EqupimentName nvarchar(255),
	UnitPrice decimal (12,2),
	DiscountPercent float,
	FloatCategoryID int,
	Constraint Sales_Equipment_Pk primary key (EquipmentID)

)

create table Sales.Customer
(
	CustomerID int,
	CustomerName varchar(255),
	Category varchar(255),
	PrimaryContact varchar(255),
	ReferenceNo varchar(255),
	PaymentDays int,
	PostalCode int
	Constraint Sales_Customer_PK primary key (CustomerID)

)
*/



drop table EquipmentTransaction

create table Sales.EquipmentTransaction
(
	TransID int identity(1,1),
	TransDate datetime,
	CustomerID int,
	EquipmentID int,
	Quantity float,
	GrossAmount decimal(12,2),
	DiscountAmount decimal(12,2),
	FloatRateAmount decimal(12,2),
	FloatExceededAmount decimal(12,2),
	PostalVariationAmount decimal(12,2),
	Constraint EquipmentTransaction_Pk primary key(TransID),
	Constraint EquipmentTransaction_Customer_fk foreign key(CustomerID) References Sales.Customer(CustomerID),
	Constraint EquipmentTransaction_Equipment_fk foreign key(EquipmentID) References Sales.Equipment(EquipmentID)

	)


create table Sales.Equipment
(
	EquipmentID int,
	EqupimentName nvarchar(255),
	UnitPrice decimal (12,2),
	DiscountPercent float,
	FloatCategoryID int,
	Constraint Equipment_Pk primary key (EquipmentID)

)

select * from [Sales].[Equipment]
select * from [Sales].[FloatCategory]
select * from [Sales].[EquipmentTransaction]
select * from [Sales].[Customer]

--Daclaring of variables---
---To insert the data into existing table 

	declare @randDay int = 0;
declare @StartDate date = '2015-01-01';
declare @EndDate date = '2019-05-31';
declare @days int = datediff(day,@StartDate, @EndDate);
declare @maxQty int = 500;
declare @counter int = 0;
declare @maxTrans int = 1000000;
--declare @Year int = 2019;
--declare @TopNCustomer int = 10;

while @counter< @maxTrans
begin

with transdata as
(

---insert into EquipmentTransaction(CustomerID, EquipmentID, Quantity)

select top 500 CustomerID, EquipmentID, ceiling(rand(checksum(newid()))*@maxQty) as Quantity
from Sales.Customer c
cross join Sales.Equipment eq
order by newid()
)
insert into Sales.EquipmentTransaction(TransDate, CustomerID,EquipmentID,Quantity,GrossAmount,
DiscountAmount,FloatRateAmount,
FloatExceededAmount,PostalVariationAmount)

select transdate = DATEADD(DAY, FLOOR(rand(checksum(NEWID()))*@days),@StartDate), 
td.CustomerID,td.EquipmentID,td.Quantity,  GrossAmount = td.Quantity* eq.UnitPrice, 
DiscountAmount=eq.DiscountPercent* eq.UnitPrice*td.Quantity,
FloatRateAmount =
				case 
					when td.Quantity  between 100 and 150  then f.FloatRate*td.Quantity*eq.UnitPrice
					else 0
				end,
FloatExceedRateAmount =
				case 
					when td.Quantity  > 150  then f.FloatExceedRate*td.Quantity*eq.UnitPrice
					else 0
				end,

PostalVariationCode = 
					case 
					when PostalCode  between 7000 and 50000  then 0.002*td.Quantity*eq.UnitPrice
					when PostalCode  between 50001 and 70000  then 0.050*td.Quantity*eq.UnitPrice
					when PostalCode  between 70001 and 90000  then 0.062*td.Quantity*eq.UnitPrice
					else 0.0078*td.Quantity*eq.UnitPrice

 
				end

from transdata td

inner join Sales.Equipment eq on  eq.EquipmentID = td.EquipmentID 
inner join Sales.Customer c on c.CustomerID = td.CustomerID
inner join Sales.FloatCategory f on f.FloatCategoryID = eq.FloatCategoryID

set @counter = (select count(*)from Sales.EquipmentTransaction)
End

select* from Sales.EquipmentTransaction

/*4. Create a dynamic function that produce top N customer purchased Amount by year 
E.g. Top 10 customers with highest purchased in 2019 Select * from TopCustomer (2019, 10)*/

create function fn_TopNCustomers(@Year int, @TopCustomer int)
Returns table

As
Return (
	select top(@TopCustomer)e.CustomerID,c.CustomerName,Year(TransDate) as Year, GrossAmount as PurchaseAmount 
	from Sales.EquipmentTransaction e
	inner join customer c on c.customerID = e.customerID

	where YEAR(TransDate) = @Year order by GrossAmount desc 
)
select * from fn_TopNCustomers(2019,10)
truncate table Sales.EquipmentTransaction

select * from Sales.EquipmentTransaction
select * from Sales.Equipment



drop Table Sales.[Equipment]

---------------------------------------------------------------------------
/*5. Dataset and summary data are needed for testing S&M Software*/

With PivotEquipment_Tbl as (

select EquipmentName as [Equipment], [2015],[2016], [2017],[2018], [2019] 
from 
(
	select  e.EquipmentName, year(TransDate) Year, GrossAmount  from  Sales.EquipmentTransaction et
	inner join Sales.Equipment e  on e.EquipmentID = et.EquipmentID
)	 as Source

PIVOT
	(
		sum(GrossAmount) 
		for Year
		IN ([2015], [2016], [2017],[2018], [2019]) 
	)
As PivotTable
)

select [Equipment], format([2015] , 'c') [2015] ,format([2016] , 'c') [2016], format([2017] , 'c') [2017],format([2018] , 'c') [2018], format([2019] , 'c')  [2019] 
from 
PivotEquipment_Tbl 

UNION All
select 'Total', format(Sum([2015]) , 'c') [2015] ,format(Sum([2016]) , 'c')[2016], format(Sum([2017]) , 'c')[2017],
format(Sum([2018]) , 'c')[2018], format(Sum([2019]) , 'c')[2019] 
from  PivotEquipment_Tbl 
--order by  1

/*******---------- Chimoa Code using Coalesce-------------

	with ctePivot as
(
	select
		equipmentName as [Equipment], [2015], [2016], [2017], [2018], [2019]
	from
	(
		select eq.equipmentName, year(TransDate) as [Year], GrossAmount
		from Sales.EquipmentTransaction et
		join Sales.Equipment eq on eq.equipmentID = et.equipmentID
	) as sourceTable
	pivot
	(
		sum(GrossAmount)
		for [Year]
		in ([2015], [2016], [2017], [2018], [2019])
	) as pivotTable
)
select 
	coalesce([Equipment], 'Total') as [Equipment], 
	format(sum([2015]),'c') as [2015], 
	format(sum([2016]),'c') as [2016], 
	format(sum([2017]),'c') as [2017], 
	format(sum([2018]),'c') as [2018], 
	format(sum([2019]),'c') as [2019] 
from ctePivot
group by rollup ([Equipment])

-----------------------*/
With PivotEquipment_Tbl as (

select EquipmentName as [Equipment], [2015],[2016], [2017],[2018], [2019] 
from 
(
	select  e.EquipmentName, year(TransDate) Year, GrossAmount  from  Sales.EquipmentTransaction et
	inner join Sales.Equipment e  on e.EquipmentID = et.EquipmentID
)	 as Source

PIVOT
	(
		sum(GrossAmount) 
		for Year
		IN ([2015], [2016], [2017],[2018], [2019]) 
	)
As Table1
)

select 
	coalesce([Equipment], 'Total') as [Equipment], 
	format(sum([2015]),'c') as [2015], 
	format(sum([2016]),'c') as [2016], 
	format(sum([2017]),'c') as [2017], 
	format(sum([2018]),'c') as [2018], 
	format(sum([2019]),'c') as [2019] 
from PivotEquipment_Tbl
group by rollup ([Equipment])



select * from [Sales].[EquipmentTransaction]

