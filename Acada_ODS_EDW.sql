--NOTE: we are using Excel data sheet as source system (OLTP) and use that data from OLTP to ODS, a snapshot



--ODS Phase----
-- where we are creating a tables just a  exact snap shot of OLTP source Systen and then doing denormaliztion from different table

create schema Acada_ODS



-----Address------

use [Acada ODS]

create table Acada_ODS.Address
(
	AddressID int,
	CityID nvarchar(255),
	AddressName nvarchar(255),
	Postalcode nvarchar(255),
	Constraint ODS_Address_pk primary key (AddressID)

)
alter table Acada_ODS.Address add  LoadDate datetime

select AddressID,AddressName as Address, c.CityName as City,Postalcode  from Acada_ODS.Address a
inner join Acada_ODS.City c on c.CityID = a.CityID


---Category

use [Acada ODS]

create table Acada_ODS.Category
(
	CategoryID int,
	CategoryName nvarchar(255),
	Constraint ODS_Category_pk primary key (CategoryID)
)
alter table Acada_ODS.Category add  LoadDate datetime


select CategoryID,CategoryName from Acada_ODS.Category

-----City 

use [Acada ODS]
 
 create table Acada_ODS.City
 (
 
	CityID int,
	StateProvinceID int,
	CityName nvarchar(255),
	Constraint ODS_city_pk primary key(CityID)
 )

 alter table Acada_ODS.City add  LoadDate datetime

 select CityID,StateProvinceID,CityName from Acada_ODS.City


use [Acada ODS]

create table Acada_ODS.Class

(	
	ClassID int,
	ClassName nvarchar(255),
	Constraint ODS_ClassID_pk primary key(ClassID)
)

 alter table Acada_ODS.Class add  LoadDate datetime

	select ClassID, ClassName from Acada_ODS.Class

---Color

use [Acada ODS]

Create table Acada_ODS.Color
(	
	ColorID int,
	ColorName nvarchar(255),
	Constraint ODS_Color_pk primary key (ColorID)
)
 alter table Acada_ODS.Color add  LoadDate datetime

Select ColorID, ColorName from Acada_ODS.Color

---JUNK

delete Acada_ODS.Junk 
Create table Acada_ODS.Junk

(	
	JunkID int identity (1,1),
	ColorID int, 
	Color nvarchar(255),
	ClassID int,
	Class nvarchar(255),
	Constraint ODS_JUNK_pk primary key (JunkID)
)
alter table Acada_ODS.Junk add  LoadDate datetime

select JunkID,  ColorID, Color, ClassID, Class from Acada_ODS.Junk

----Country

use [Acada ODS]

Create table Acada_ODS.Country
(	
	CountryID int,
	CountryName nvarchar(255),
	Constraint ODS_Country_pk primary key (CountryID)
)
 alter table Acada_ODS.Country add  LoadDate datetime

select CountryID, CountryName from Acada_ODS.Country


---Date

use [AcadaODS]

Create table Acada_ODS.Date
(
	DateKey int,
	FullDateAlternateKey int,
	DayNumberOfWeek int,
	EnglishDayNameOfWeek nvarchar(255),
	SpanishDayNameOfWeek nvarchar(255),
	FrenchDayNameOfWeek nvarchar(255),
	DayNumberOfMonth int,
	DayNumberOfYear int,
	WeekNumberOfYear int,
	EnglishMonthName nvarchar(255),
	SpanishMonthName nvarchar(255),
	FrenchMonthName nvarchar(255),
	MonthNumberOfYear int,
	CalendarQuarter int,
	CalendarYear int,
	CalendarSemester int,
	FiscalQuarter int,
	FiscalYear int,
	FiscalSemester int,
	Constraint ODS_Date_pk primary key (Datekey)
)

select * from [Acada_ODS].[Date]

select * from [Acada_ODS].[Employee]
 alter table Acada_ODS.Date add  LoadDate datetime

 alter table Acada_ODS.Date alter column [FullDateAlternateKey] int


select * from Acada_ODS.Date

----Employee

use [Acada ODS]

create table Acada_ODS.Employee
(	
	EmployeeID int,
	FirstName nvarchar(255),
	LastName nvarchar(255),
	Constraint ODS_Employee_pk primary key (EmployeeID)
)
 alter table Acada_ODS.Employee add  LoadDate datetime
select * from Acada_ODS.Employee

----Product

use [Acada ODS]

create table Acada_ODS.Product
(
	ProductID int,
	ProductName nvarchar(255),
	ProductNumber nvarchar(255)
	constraint ODS_Product_pk primary key (ProductID)
)
 alter table Acada_ODS.Product add  LoadDate datetime

select ProductID, ProductName, ProductNumber from Acada_ODS.Product


----ProductCategory
use [Acada ODS]

create table Acada_ODS.ProductCategory

(	
	ProductCategoryID int,
	CategoryID int,
	ProductID int,
	Constraint ODS_ProductCategory_pk primary key (ProductCategoryID) 
)
 alter table Acada_ODS.ProductCategory add  LoadDate datetime
select ProductCategoryID, CategoryID, ProductID from Acada_ODS.ProductCategory



---SpecialOffer

use [Acada ODS]

create table Acada_ODS.SpecialOffers

(
	SpecialOfferID int,
	SpecialOffer nvarchar(255),
	Constraint ODS_SpecialOffers_pk primary key (SpecialOfferID)
)
 alter table Acada_ODS.SpecialOffers add  LoadDate datetime
select SpecialOfferID, SpecialOffer from Acada_ODS.SpecialOffers



----StateProvince

use [Acada ODS]

create table Acada_ODS.StateProvince
(	
	StateProvinceID int,
	CountryID int,
	StateProvince nvarchar(255),
	Constraint ODS_StateProvince_pk primary key (StateProvinceID)
)
 alter table Acada_ODS.StateProvince add  LoadDate datetime


select StateProvinceID, CountryID, StateProvince from Acada_ODS.StateProvince




-----Supplier------------------------------------------

use [Acada ODS]

create table Acada_ODS.Supplier

(
	SupplierID int,
	AccountNumber nvarchar(255),
	FirstName nvarchar(255),
	LastName nvarchar(255),
	AddressID int,
	Constraint ODS_Supplier_pk primary key (SupplierID)

)
 alter table Acada_ODS.Supplier add  LoadDate datetime

select SupplierID, AccountNumber, FirstName, LastName,AddressID from Acada_ODS.Supplier

------SupplierTransaction

use [Acada ODS]

create table Acada_ODS.SupplierTransaction
(	
	TransID int,
	OrderID int,
	AccountNumber nvarchar(255),
	Supplier nvarchar(255),
	Address nvarchar(255),
	City nvarchar(255),
	PostalCode nvarchar(255),
	StateProvince nvarchar(255),
	Country nvarchar(255),
	Employee nvarchar(255),
	DueDate date,
	ShipDate date,
	OrderDate date,
	CarrierTrackingNumber nvarchar(255),
	ProductID  int,
	OrderQty  int,
	Class nvarchar(255),
	Color nvarchar(255),
	ListPrice nvarchar(255),
	SpecialOfferID int,
	UnitPrice float,
	UnitPriceDiscount float,
	Constraint ODS_SupplierTransaction_pk primary key (TransID)
)

 alter table Acada_ODS.SupplierTransaction add  LoadDate datetime

select TransID, OrderID, AccountNumber,Supplier, Address, City, PostalCode, StateProvince, 
Country, Employee, DueDate, ShipDate, OrderDate,CarrierTrackingNumber, ProductID, OrderQty,
class, color, ListPrice, SpecialOfferID, UnitPrice, UnitPriceDiscount
from Acada_ODS.SupplierTransaction




-------------TransactionTable--------------
drop table Acada_ODS.TransactionTable
use [Acada ODS]

create table Acada_ODS.TransactionTable
(	
	TransID int,
	OrderID int,
	SupplierID int,
	EmployeeID int,
	ProductID  int,
	CarrierTrackingNumber nvarchar(255),
	Class nvarchar(255),
	Color nvarchar(255),
	JunkID int,
	SpecialOfferID int,
	OrderQty  int,
	PurchaseAmount float,
	DueDate datetime,
	ShipDate datetime,
	OrderDate datetime,
	LoadDate datetime

	Constraint ODS_Transaction_pk primary key (TransID)
)

select TransID, OrderID, SupplierID, EmployeeID,ProductID, CarrierTrackingNumber,class, color, SpecialOfferID,OrderQty,PurchaseAmount,
DueDate, ShipDate, OrderDate, LoadDate
from Acada_ODS.TransactionTable
------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*IN ODS we just created table a sanpshot of OLTP and then  using ODS we denormalized the tables using joins statements 
and name transformation is also done in ODS  */




-----------------------------------------------Supplier------------------------------------------------------------------------------------------

use [Acada ODS]

select SupplierID,Upper (s.LastName) + ',' +s.FirstName as SupplierName,AccountNumber as SupplierAccountNumber, 
a.AddressName as SupplierAddress, 
c.CityName as City, a.Postalcode, sp.StateProvince, co.CountryName as Country , GETDATE() as LoadDate  from Acada_ODS.Supplier s

inner join Acada_ODS.Address a on a.AddressID = s.AddressID
inner join Acada_ODS.City c on c.CityID = a.CityID
inner join Acada_ODS.StateProvince sp on sp.StateProvinceID = c.StateProvinceID
inner join Acada_ODS.Country co on co.CountryID = sp.CountryID


/* In staging we use the columns from ODS and created a table in staging */



create schema Acada_STAGGING

use [Acada Staging]

drop table Acada_STAGING.Supplier
create table Acada_STAGING.Supplier
(
	SupplierID int,
	SupplierName nvarchar(255),
	SupplierAccountNumber nvarchar (255),
	SupplierAddress nvarchar (255),
	City nvarchar(255),
	Postalcode nvarchar(255),
	StateProvince nvarchar(255),
	Country nvarchar(255),
	LoadDate datetime,
	Constraint Acada_STAGING_Supplier_PK primary key (SupplierID)
)
select SupplierID, SupplierName, SupplierAccountNumber, SupplierAddress, City, Postalcode,StateProvince,
Country,LoadDate from Acada_STAGING.Supplier 


/*In EDW we created dimension table using columns from staging and created auto incremental surrogate key */


create schema Acada_EDW


use [Acada EDW]
drop table Acada_EDW.DimSupplier
create table Acada_EDW.DimSupplier
(
	SupplierSK int identity(1,1),
	SupplierID int,
	SupplierName nvarchar(255),
	SupplierAccountNumber nvarchar (255),
	SupplierAddress nvarchar (255),
	City nvarchar(255),
	Postalcode nvarchar(255),
	StateProvince nvarchar(255),
	Country nvarchar(255),
	LoadDate datetime,
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	Constraint Acada_EDW_DimSupplier_PK primary key (SupplierSK)

)


-------------CHIOMA'S CODE for temp table-----


/*use [Acada ODS]
select s.AccountNumber, s.FirstName, s.LastName, AddressID
From Acada_ODS.Supplier  s
group by s.AccountNumber, s.FirstName, s.LastName, AddressID
--Having count(*) > 1

drop table  Acada_ODS.SupplierTemp 

select s.SupplierID, s.AccountNumber, s.FirstName, s.LastName, a.AddressName, c.CityName, sp.StateProvince, ct.CountryName,
a.Postalcode
into Acada_ODS.SupplierTemp

From Acada_ODS.Supplier  s
inner join Acada_ODS.[Address] a on s.AddressID = a.AddressID
inner join Acada_ODS.[City] c on c.CityID = a.cityID
inner join Acada_ODS.[StateProvince] sp on sp.StateProvinceID = c.StateProvinceID
inner join Acada_ODS.[Country] ct on ct.CountryID = sp.CountryID
group by s.supplierID, s.AccountNumber, s.FirstName, s.LastName, a.AddressName, c.CityName, sp.StateProvince,
ct.CountryName, a.Postalcode

select * from Acada_ODS.SupplierTemp
order by 1

select	
	st.TransID,
	s.SupplierID,
	st.ProductID,
	st.SpecialOfferID,
	--e.EmployeeID,
	st.DueDate,
	st.ShipDate,
	st.OrderDate,
	st.CarrierTrackingNumber,
	st.OrderQty,
	(st.OrderQty*st.ListPrice) as PurchaseAmount,
	(st.OrderQty*st.ListPrice*(1 - st.UnitPriceDiscount)) as NetAmount,
	datediff(dd,st.OrderDate, st.ShipDate) as DeliveryPeriod,
	datediff(dd, st.Orderdate, st.DueDate) as DuePeriod,
	getdate() as LoadDate	
from Acada_ODS.SupplierTransaction st
left join Acada_ODS.SupplierTemp s on concat(s.AccountNumber, s.FirstName, ' ', s.LastName, s.AddressName, s.CityName, 
s.StateProvince, s.CountryName, s.Postalcode) 
		= concat(st.AccountNumber, st.Supplier, st.Address, st.City, st.StateProvince, st.Country, st.PostalCode)
--group by s.supplierID, s.AccountNumber, s.FirstName, s.LastName, a.AddressName, c.CityName, sp.StateProvince, ct.CountryName, a.Postalcode
--where SupplierID is null*/



select * from Acada_ODS.Supplier


select * from Acada_ODS.SupplierTemp
--select * from [dbo].[SupplierTransaction]




------------------------------------------Color--------------------------------------------------------------

use [Acada ODS]

select ColorID,ColorName, GETDATE() as LoadDate from Acada_ODS.Color


----Load Color from ODS to Staging

use [Acada Staging]

create table Acada_STAGING.Color
(	
	ColorID int,
	ColorName nvarchar(255),
	LoadDate datetime
	Constraint Acada_STAGING_Color_PK primary key (ColorID)
)

-----------------------------------------Class---------------------------------------
use [Acada ODS]

select ClassID,ClassName, GETDATE() as LoadDate from Acada_ODS.Class

----Load Class from ODS to Staging

use [Acada Staging]

create table Acada_STAGING.Class
(	
	ClassID int,
	ClassName nvarchar(255),
	LoadDate datetime
	Constraint Acada_STAGING_Class_PK primary key (ClassID)
)

-------------------------------------------Employee---------------------------------------------------------------------
use [Acada ODS]

select EmployeeID, upper(LastName)+ ','   + FirstName as EmployeeName, GETDATE() as LoadDate from Acada_ODS.Employee

---Load Employee EDW---

use [Acada Staging]

Drop table Acada_STAGING.Employee
create table Acada_STAGING.Employee
(
	EmployeeID int, 
	EmployeeName nvarchar (255),
	LoadDate datetime,
	Constraint Acada_STAGING_Employee_PK primary key (EmployeeID)

)
select EmployeeID, EmployeeName,LoadDate from Acada_STAGING.Employee

use [Acada EDW]

drop table Acada_EDW.DimEmployee
create table Acada_EDW.DimEmployee

(
	EmployeeSK int identity(1,1),
	EmployeeID int,
	EmployeeName nvarchar (255),
	LoadDate datetime,
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	Constraint Acada_EDW_DimEmployee_PK primary key (EmployeeSK)
)
--------------------------------------------------Product----------------------------------

use [Acada ODS]

select p.ProductID, p.ProductName, p.ProductNumber, c.CategoryName as ProductCategory, GETDATE() as LoadDate  
from Acada_ODS.Product p
inner join Acada_ODS.ProductCategory pc on pc.ProductID = p.ProductID
Inner join Acada_ODS.Category c on c.CategoryID = pc.CategoryID


use [Acada Staging]
drop table Acada_STAGING.Product
create table Acada_STAGING.Product

(
	ProductID int,
	ProductName nvarchar(255),
	ProductNumber nvarchar(255),
	ProductCategory nvarchar(255),
	LoadDate date,
	constraint Acada_STAGING_Product_PK primary key (ProductID)
)

select ProductID, ProductName, ProductNumber,ProductCategory,LoadDate from Acada_STAGING.Product

use [Acada EDW]
drop table Acada_EDW.DimProduct

create table Acada_EDW.DimProduct
(
	ProductSK int identity(1,1),
	ProductID int,
	ProductName nvarchar(255),
	ProductNumber nvarchar(255),
	ProductCategory nvarchar(255),
	LoadDate date,
	EffectiveStartDate datetime,
	EffectiveEndDate datetime
	Constraint Acada_EDW_DimProduct_PK primary key (ProductSK)
)

-------------------------------------------------SpecialOffers----------------------------------

use [Acada ODS]

select SpecialOfferID, SpecialOffer, GETDATE() as LoadDate from Acada_ODS.SpecialOffers

--script to load SpecialOffer from ODS to Staging

use [Acada Staging]
drop table Acada_STAGING.SpecialOffers
create table Acada_STAGING.SpecialOffers

(	
	SpecialOfferID int,
	SpecialOffer nvarchar(255),
	LoadDate date,
	Constraint Acada_STAGING_SpecialOffers_PK primary key (SpecialOfferID)
)

select SpecialOfferID, SpecialOffer, LoadDate from Acada_STAGING.SpecialOffers

--script to load SpecialOffer from Staging to EDW

use [Acada EDW]

drop table Acada_EDW.DimSpecialOffers
Create table Acada_EDW.DimSpecialOffers

(
	SpecialOfferSK int identity(1,1),
	SpecialOfferID int,
	SpecialOffer nvarchar(255),
	LoadDate date,
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	Constraint Acada_EDW_DimSpecialOffers_PK primary key(SpecialOfferSK)
)
---------------------------------------------------------------JUNK----------------------------------

--Script to load Junk from ODS to Staging 
use  [Acada ODS]

select JunkID, ColorID,Color,ClassID,Class,getdate() as LoadDate from Acada_ODS.Junk

use [Acada Staging]
create table Acada_STAGING.Junk

( 
	JunkID int,
	ColorID int,
	Color nvarchar(255),
	ClassID int,
	Class nvarchar(255),
	LoadDate date,
	Constraint Acada_STAGING_Junk_pk primary key(JunkID)
)
--Script to load Junk from Staging to EDW

select JunkID, ColorID,Color,ClassID,Class,LoadDate from Acada_STAGING.Junk

---Query to load class and color from staging to DimJunk

select ColorID,ColorName from Acada_STAGING.Color
union
Select ClassID,ClassName from Acada_STAGING.Class

drop table Acada_EDW.DimJunk

use [Acada EDW]
create table Acada_EDW.DimJunk
(
	JunkSK int ,
	JunkID int identity(1,1),
	JunkDescr nvarchar(255),
	Constraint Acada_EDW_DimJunk_PK primary key(JunkSK)
)
/*insert into Acada_EDW.DimJunk(ColorID, ColorName, ClassID, ClassName)*/

select * from [Acada ODS].[Acada_ODS].Color																																								
cross join [Acada ODS].[Acada_ODS].Class

---------------------------------------------------------------------Date-------------------

use [Acada ODS]
	select DateKey, FullDateAlternateKey ,DayNumberOfWeek,EnglishDayNameOfWeek,SpanishDayNameOfWeek,FrenchDayNameOfWeek,
	DayNumberOfMonth,DayNumberOfYear,WeekNumberOfYear,EnglishMonthName,SpanishMonthName,FrenchMonthName,MonthNumberOfYear,
	CalendarQuarter,CalendarYear,CalendarSemester,FiscalQuarter,FiscalYear,FiscalSemester
	from Acada_ODS.Date

--script to load Date data from ODS to EDW
drop table Acada_EDW.DimDate
use [Acada EDW]

create table Acada_EDW.DimDate
(	
	
	Datekey int,
	FullDateAlternateKey date,
	DayNumberOfWeek int,
	EnglishDayNameOfWeek int, 
	SpanishDayNameOfWeek int, 
	FrenchDayNameOfWeek int,
	DayNumberOfMonth int,
	DayNumberOfYear int,
	WeekNumberOfYear int, 
	EnglishMonthName int,
	SpanishMonthName int,
	FrenchMonthName int,
	MonthNumberOfYear int,
	CalendarQuarter int, 
	CalendarYear int,
	CalendarSemester int, 
	FiscalQuarter int, 
	FiscalYear int,
	FiscalSemester int,
	Constraint Acada_EDW_DimDate_PK primary key (Datekey)                 
)

/*use [Acada EDW]
drop table Acada_EDW.DimJunk
create table Acada_EDW.DimJunk
(

	JunkSK int identity(1,1),
	ColorID int, 
	Color nvarchar(255),
	ClassID int,
	Class nvarchar(255),
	Constraint Acada_EDW_DimJunk_PK primary key (JunkSK)
)

insert into Acada_EDW.DimJunk(ColorID, Color, ClassID, Class)

select * from [Acada ODS].[Acada_ODS].Color							--if we are bringing data from otehr database we use database name name->Schema name ->	table name																																		
cross join [Acada ODS].[Acada_ODS].Class*/



--------------------------------------SupplierTransaction--------------------------------


/*FACT_SUPPLIERTRANSACTION*/

/* Script to Load SupplierTransaction from ODS to Staging*/


use [Acada ODS]
select st.TransID,e.EmployeeID,s.SupplierID, st.ProductID, st.OrderID,st.SpecialOfferID,st.CarrierTrackingNumber,
st.OrderDate,st.DueDate,st.ShipDate,st.OrderQty, (st.OrderQty* st.ListPrice)as PurchaseAmount, 
(st.OrderQty * st.ListPrice *(1- st.UnitPriceDiscount)) as NetAmount, 
DATEDIFF(day,st.OrderDate,st.DueDate) as DuePeriod, 
DATEDIFF(DAY, st.OrderDate,st.ShipDate) as DeliveryPeriod,
GETDATE() as LoadDate

from Acada_ODS.SupplierTransaction st
inner join Acada_ODS.Employee e on st.Employee = e.LastName+','+ e.FirstName
inner join Acada_ODS.Supplier s on st.Supplier = s.LastName+','+ s.FirstName


/* create SupplierTransaction table in Staging*/

use [Acada Staging]

drop table Acada_STAGING.SupplierTransaction
create table Acada_STAGING.SupplierTransaction
(
	
	TransID int,
	EmployeeID int, 
	SupplierID int,
	ProductID int,
	SpecialOfferID int,
	CarrierTrackingNumber int,
	OrderDate date,
	DueDate date,
	ShipDate date,
	OrderQty int,
	PurchaseAmount float,
	NetAmount float,
	DuePeriod int,
	DeliveryPeriod int,
	LoadDate date,
	Constraint Acada_STAGING_SupplierTransaction_PK primary key(TransID)
)

/*Load  SupplierTransaction Columns from Staging to EDW for Fact_SupplierTransaction*/
use [Acada Staging]
 
 select  TransID, EmployeeID,SupplierID,ProductID,SpecialOfferID,CarrierTrackingNumber,OrderDate,DueDate,ShipDate,OrderQty,
 PurchaseAmount,NetAmount,DuePeriod,DeliveryPeriod,LoadDate
 from Acada_STAGING.SupplierTransaction

 /*Create table in EDW for Fact_SupplierTransaction*/

 use [Acada EDW]

 drop table Acada_EDW.Fact_SupplierTransaction
 create table Acada_EDW.Fact_SupplierTransaction
 (
		Supplier_Transaction_sk int identity(1,1),
		EmployeeSK int,
		SupplierSK int,
		ProductSK int,
		SpecialOfferSK int,
		CarrierTrackingNumber nvarchar(255),
		OrderDateSK int,
		DueDateSK int,
		ShipDateSK int,
		JunkSK int,
		OrderQty int,
		PurchaseAmount float,
		NetAmount float,
		DuePeriod int,
		DeliveryPeriod int,
		LoadDate datetime,
		Constraint Acada_EDW_Fact_SupplierTransaction_PK  primary key (Supplier_Transaction_sk ),
		Constraint Acada_EDW_Fact_Employee_SK foreign key(EmployeeSK) references Acada_EDW.DimEmployee(EmployeeSK),
		Constraint Acada_EDW_Fact_Supplier_SK foreign key(SupplierSK) references Acada_EDW.DimSupplier(SupplierSK),
		Constraint Acada_EDW_Fact_Product_SK foreign key(ProductSK) references Acada_EDW.DimProduct(ProductSK),
		Constraint Acada_EDW_Fact_SpecialOffer_SK foreign key(SpecialOfferSK) references Acada_EDW.DimSpecialOffers(SpecialOfferSK),
		Constraint Acada_EDW_Fact_DueDate_SK foreign key(DueDateSK) references Acada_EDW.DimDate(Datekey),
		Constraint Acada_EDW_Fact_ShipDate_SK foreign key(ShipDateSK) references Acada_EDW.DimDate(Datekey),
		Constraint Acada_EDW_Fact_Junk_SK foreign key(JunkSK) references Acada_EDW.DimJunk(JunkSK)
	
 )


 --------------------------------------TransactionTable--------------------------------


/*FACT_TRANSACTIONTable*/

/* Script to Load Transactiontbale from ODS to Staging*/
use [Acada ODS]

select TransID,EmployeeID,SupplierID,JunkID, ProductID, OrderID,SpecialOfferID,CarrierTrackingNumber,
OrderDate,DueDate,ShipDate,OrderQty, PurchaseAmount, 
DATEDIFF(day,OrderDate,DueDate) as DuePeriod, 
DATEDIFF(DAY, OrderDate,ShipDate) as DeliveryPeriod,
GETDATE() as LoadDate
from Acada_ODS.TransactionTable

/* create SupplierTransaction table in Staging*/
drop table Acada_STAGING.TransactionTable
use [Acada Staging]
create table Acada_STAGING.TransactionTable
(
	
	TransID int,
	EmployeeID int, 
	SupplierID int,
	ProductID int,
	OrderID int,
	ColorID int,
	ClassID int,
	SpecialOfferID int,
	CarrierTrackingNumber int,
	OrderDate datetime,
	DueDate datetime,
	ShipDate datetime,
	OrderQty int,
	PurchaseAmount float,
	DuePeriod int,
	DeliveryPeriod int,
	LoadDate datetime,
	Constraint Acada_STAGING_Transaction_PK primary key(TransID)
)

/*Script to Load  TransactionTable Columns from Staging to EDW for Fact_TransactionTable*/
use [Acada Staging]
 
 select  TransID, EmployeeID,SupplierID,ProductID,OrderID,ColorID,ClassID,SpecialOfferID,CarrierTrackingNumber,OrderDate,
 DueDate,ShipDate,OrderQty,PurchaseAmount,DuePeriod,DeliveryPeriod,LoadDate
 from Acada_STAGING.TransactionTable

/*Create table in EDW for Fact_TransactionTable*/
drop table Acada_EDW.Fact_TransactionTable
 use [AcadaEDW]

 /*alter table Acada_EDW.Fact_TransactionTable 
 add ColorSK int, ClassSK int
 Constraint Acada_EDW_Color_SK foreign key(ColorSK) references Acada_EDW.DimJunk(JunkSK),
 Constraint Acada_EDW_Class_SK foreign key(ClassSK) references Acada_EDW.DimJunk(JunkSK)*/

 create table Acada_EDW.Fact_TransactionTable
 (
		TransactionTable_sk int identity(1,1),
		EmployeeSK int,
		SupplierSK int,
		ProductSK int,
		SpecialOfferSK int,
		CarrierTrackingNumber nvarchar(255),
		OrderDateSK int,
		DueDateSK int,
		ShipDateSK int,
		ColorSK int, 
		ClassSK int,
		OrderQty int,
		PurchaseAmount float,
		DuePeriod int,
		DeliveryPeriod int,
		LoadDate datetime,
		Constraint Acada_EDW_Fact_Transaction_PK  primary key (TransactionTable_sk ),
		Constraint Acada_EDW_Fact_Employee_SK foreign key(EmployeeSK) references Acada_EDW.DimEmployee(EmployeeSK),
		Constraint Acada_EDW_Fact_Supplier_SK foreign key(SupplierSK) references Acada_EDW.DimSupplier(SupplierSK),
		Constraint Acada_EDW_Fact_Product_SK foreign key(ProductSK) references Acada_EDW.DimProduct(ProductSK),
		Constraint Acada_EDW_Fact_SpecialOffer_SK foreign key(SpecialOfferSK) references Acada_EDW.DimSpecialOffers(SpecialOfferSK),
		Constraint Acada_EDW_Fact_OrderDate_SK foreign key(OrderDateSK) references Acada_EDW.DimDate(Datekey),
		Constraint Acada_EDW_Fact_DueDate_SK foreign key(DueDateSK) references Acada_EDW.DimDate(Datekey),
		Constraint Acada_EDW_Fact_ShipDate_SK foreign key(ShipDateSK) references Acada_EDW.DimDate(Datekey),
		Constraint Acada_EDW_Color_SK foreign key(ColorSK) references Acada_EDW.DimJunk(JunkSK),
		Constraint Acada_EDW_Class_SK foreign key(ClassSK) references Acada_EDW.DimJunk(JunkSK),
 )
 alter table [Acada_EDW].[Fact_TransactionTable]
 drop Constraint Acada_EDW_Fact_Junk_SK 

	 select * from  Acada_EDW.Fact_TransactionTable

------------------------------------------SSIS  Creating Packages ---------------------------------------------
if cast(getdate() as Date) = EOMONTH(getdate())						--creating load date for every package of source system
begin
    delete from Acada_ODS.Address
    where LoadDate < DATEADD(month,-6,getdate())
end




if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Category
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.City
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Class
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Color
    where LoadDate < DATEADD(month,-6,getdate())
end




if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Date
    where LoadDate < DATEADD(month,-6,getdate())
end




if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Employee
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Product
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.ProductCategory
    where LoadDate < DATEADD(month,-6,getdate())
end




if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.SpecialOffers
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.StateProvince
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.Supplier
    where LoadDate < DATEADD(month,-6,getdate())
end



if cast(getdate() as Date) = EOMONTH(getdate())
begin
    delete from Acada_ODS.SupplierTransaction
    where LoadDate < DATEADD(month,-6,getdate())
end


if CAST(getdate() as Date)  = EOMONTH(GETDATE())
begin 
	delete from Acada_ODS.TransactionTable
	where loadDate< DATEADD(MONTH, -6,GETDATE())
end



if cast(getdate() as Date) = EOMONTH(getdate())						
begin
    delete from Acada_ODS.Junk
    where LoadDate < DATEADD(month,-6,getdate())
end


----------------------Address Package-------------
Select count (*) as ExcelFileCount from [Address$]
Select count (*) as ODSPreCount from Acada_ODS.Address
Select count (*) as ODSPostCount from Acada_ODS.Address

------------------------Category Package-----------------
Select count(*) as ExcelFileCount from [Category$]
Select count (*) as ODSPreCount from Acada_ODS.Category
Select count (*) as ODSPostCount from Acada_ODS.Category

------------------City Package-----------------------
Select count(*) as ExcelFileCount from [City$]
Select count (*) as ODSPreCount from Acada_ODS.City
Select count (*) as ODSPostCount from Acada_ODS.City

-------------------Class Package-------------
Select count(*) as ExcelFileCount from [Class$]
Select count (*) as ODSPreCount from Acada_ODS.Class
Select count (*) as ODSPostCount from Acada_ODS.Class

-------------------Color Package-------------
Select count(*) as ExcelFileCount from [Color$]
Select count (*) as ODSPreCount from Acada_ODS.Color
Select count (*) as ODSPostCount from Acada_ODS.Color

------------------Junk Package---------------------
Select count(*) as ODSCount from Acada_ODS.Junk
Select count (*) as ODSPreCount from Acada_ODS.Junk
Select count (*) as ODSPostCount from Acada_ODS.Junk

-------------------Country Package-------------
Select count(*) as ExcelCount from [Country$]
Select count (*) as ODSPreCount from Acada_ODS.Country
Select count (*) as ODSPostCount from Acada_ODS.Country


-------------------Date Package-------------
Select count(*) as ExcelFileCount from [Date$]
Select count (*) as ODSPreCount from Acada_ODS.Date
Select count (*) as ODSPostCount from Acada_ODS.Date


-------------------Employee Package-------------
Select count(*) as ExcelFileCount from [Employee$]
Select count (*) as ODSPreCount from Acada_ODS.Employee
Select count (*) as ODSPostCount from Acada_ODS.Employee



-------------------Product Package-------------
Select count(*) as ExcelFileCount from [Product$]
Select count (*) as ODSPreCount from Acada_ODS.Product
Select count (*) as ODSPostCount from Acada_ODS.Product

-------------------ProductCategory Package-------------
Select count(*) as ExcelFileCount from [ProductCategory$]
Select count (*) as ODSPreCount from Acada_ODS.ProductCategory
Select count (*) as ODSPostCount from Acada_ODS.ProductCategory

-------------------SpecialOffers Package-------------
Select count(*) as ExcelFileCount from [SpecialOffers$]
Select count (*) as ODSPreCount from Acada_ODS.SpecialOffers
Select count (*) as ODSPostCount from Acada_ODS.SpecialOffers



-------------------StateProvince Package-------------
Select count(*) as ExcelCount from [StateProvince$]
Select count (*) as ODSPreCount from Acada_ODS.StateProvince
Select count (*) as ODSPostCount from Acada_ODS.StateProvince


-------------------Supplier Package-------------
Select count(*) as ExcelFileCount from [Supplier$]
Select count (*) as ODSPreCount from Acada_ODS.Supplier
Select count (*) as ODSPostCount from Acada_ODS.Supplier


-------------------SupplierTransaction Package-------------
Select count(*) as ExcelFileCount from [SupplierTransaction$]
Select count (*) as ODSPreCount from Acada_ODS.SupplierTransaction
Select count (*) as ODSPostCount from Acada_ODS.SupplierTransaction

------------------TransactionTable Package--------------------

select count(*) as ExcelFileCount from [TransactionTable$]
select count(*) as ODSPreCount from Acada_ODS.TransactionTable
select count(*) as ODSPostCount from Acada_ODS.TransactionTable


--------------------------------------------------------------------Control Framework--------------------------------------------------------
----Control Framework---
----Sequence of How ETL process 
---PackageTable
---Metric Table



use [Acada Control]

create schema Acada_control

drop Table Acada_control.DataAnomalies

create Table Acada_control.DataAnomalies
(
DataAnoID int identity(1,1),
PackageID int,
TableName nvarchar (255),
ColumnName nvarchar(255),
TransactionID int,
LoadDate datetime,
constraint DataAnomalies_pk primary key (DataAnoID),
--constraint Data_Package_fk foreign key(PackageID) references Acada_control.Package(PackageID)
)


drop table Acada_control.Project						--droping previous tablename and created new one
create Table Acada_control.Project
                                                         --creating projects for SSIS during ETL--
(
	ProjectID int,
	ProjectName nvarchar(50)								--ODS, Staging, EDW--
	constraint Project_pk primary key (ProjectID)
)


insert into  Acada_control.Project(ProjectID,ProjectName)
values (1, 'ODS'),
	   (2, 'Staging'),
	   (3, 'EDW')

drop table Acada_control.PackageType

create Table Acada_control.PackageType				--PackageType define dimension or fact in SSIS-----

(
	PackageTypeID int,
	PackageName nvarchar(50)----Dimension, Fact
	constraint ProjectType_pk primary key (PackageTypeID)
)

insert into  Acada_control.PackageType(PackageTypeID, PackageName)  
values (1, 'NormTable'),
	   (2, 'Dimension'),
	   (3, 'Fact')

drop table Acada_control.Frequency
create table Acada_control.Frequency
(	
	FrequencyID int,
	Frequency nvarchar(50)
	constraint Acada_control_Frequency_PK primary key (FrequencyID)
)
insert into Acada_control.Frequency(FrequencyID, Frequency)
values(1, 'Daily'),
	  (2,'Weekly'),
	  (3, 'Monthly')

drop table Acada_control.Package
create table Acada_control.Package
(
	PackageID int identity(1,1),          --packages that are created in SSIS auto incrmeent
	PackageName nvarchar (255),                             
	ProjectID int,				--ODS, staging, edw--
	PackageTypeID int,			--Dimaension, Fact
	SequenceNo int,								---which one needs to go first. eg Dimension or Fact. Dimension needs to go first always, if not it will crash because there is no referential integrity----100, 200, 300, 400, 500
	FrequencyID int,										----ETL might run daily, weekly, monthly etc
	StartDate datetime,								--For ETL to run a particular date, not frequently eg to run tomorrow, 02-27-2022
	EndDate datetime,						--the date to stop on a particular date, 02-28-2022, after 28-02-2022, the lifespan of the package will expire or skip (the sequence of the run. if you dont want end date, then you dont specify any date
	LastRun datetime,

	constraint Acada_control_Package_PK primary key (PackageID), 
	constraint Project_fk foreign key (ProjectID) references Acada_control.Project (ProjectID),
	constraint PackageType_fk foreign key (PackageTypeID) references Acada_control.PackageType(PackageTypeID),
	constraint PackageFrequency_fk foreign key (FrequencyID) references Acada_control.Frequency (FrequencyID)
) 

insert into Acada_control.Package(PackageName, ProjectID,PackageTypeID,SequenceNo,FrequencyID,StartDate)
values('odsAddress.dtsx', 1, 1, 100, 1, getdate()),
	  ('odsCategory.dtsx', 1, 1, 200, 1, getdate()),
	  ('odsCity.dtsx', 1, 1, 300, 1, getdate()),
	  ('odsClass.dtsx', 1, 1, 400, 1, getdate()),
	  ('odsColor.dtsx', 1, 1, 500, 1, getdate()),
	  ('odsCountry.dtsx', 1, 1, 600, 1, getdate()),
	  ('odsDate.dtsx', 1, 1, 700, 1, getdate()),
	  ('odsEmployee.dtsx', 1, 1, 800, 1, getdate()),
	  ('odsProduct.dtsx', 1, 1, 900, 1, getdate()),
	  ('odsProductCategory.dtsx', 1, 1, 1000, 1, getdate()),
	  ('odsSpecialOffers.dtsx', 1, 1, 1100, 1, getdate()),
	  ('odsStateProvince.dtsx', 1, 1, 1200, 1, getdate()),
	  ('odsSuppliers.dtsx', 1, 1, 1300, 1, getdate()),
	  ('odsTransactionTable.dtsx',1,1,1400,1,getdate())

insert into Acada_control.Package(PackageName, ProjectID,PackageTypeID,SequenceNo,FrequencyID,StartDate)
	 values('stgEmployee.dtsx', 2, 2, 100, 1, getdate()),
	  ('stgProduct.dtsx', 2, 2, 200, 1, getdate()),
	  ('stgSpecialOffer.dtsx', 2, 2, 300, 1, getdate()),
	  ('stgSupplier.dtsx', 2, 2, 400, 1, getdate()),
	  ('stgTransactionTable.dtsx',2,3,500,1,GETDATE()),
	  ('stgColor.dtsx', 2,2,420,1,GETDATE()),
	  ('stgClass.dtsx', 2,2,440,1,GETDATE())

insert into Acada_control.Package(PackageName, ProjectID,PackageTypeID,SequenceNo,FrequencyID,StartDate)
	  values('dimEmployee.dtsx', 3, 2, 100, 1, getdate()),
	  ('dimProduct.dtsx', 3, 2, 200, 1, getdate()),
	  ('dimSpecialOffers.dtsx', 3, 2, 300, 1, getdate()),
	  ('dimSupplier.dtsx', 3, 2, 400, 1, getdate()),
	  ('dimJunk.dtsx', 3, 2, 500, 1, getdate()),
	  ('dimDate.dtsx', 3, 2, 600, 1, getdate()),
	  ('factTransactionTable.dtsx', 3,3,700,1,getdate())

Delete from Acada_control.Package where PackageID = 29
Delete from Acada_control.Package where PackageID = 47 
Delete from Acada_control.Package where PackageID = 41

select * from Acada_control.Package

----Precount -> CurrentCount ->PostCount, Type1count, Type2count-- precount+currentCount+ Type2Count = Postcount  ---Edw load metrics--
---SourceCount = StageCount  --Staging Load metrics--

drop table Acada_control.Metric
create table Acada_control.Metric
(
	MetricID int identity (1,1),
	PackageID int,
	ExcelFileCount int,
	ODSPreCount int,      --ODS Environment
	ODSPostCount int,	   --ODS Environment
	ODSCount int,			--staging env
	StageCount int,			--staging env
	PreCount int,			--EDW metric
	CurrentCount int,		--EDW metric
	Type1Count int,			--EDW metric
	Type2Count int,			--EDW metric
	PostCount int,			--EDW metric
	RunDate datetime		---EDW metric
	constraint Acada_control_Metric_PK primary key (MetricID),
	constraint PackageMetric_fk foreign key (PackageID) references Acada_control.Package(PackageID)
)

alter table Acada_control.Metric add PreCount int
--alter table Acada_control.Metric alter column ExcelFilCount int 



//--Update Metrics in ODS Packages -----------------
	declare @PackageID int =?
	declare @ExcelFileCount int = ?
	declare @ODSPreCount  int =?
	declare @ODSPostCount  int =?
	update Acada_control.Package set LastRun = GETDATE() where PackageID = @PackageID

	insert into Acada_control.Metric(PackageID,ExcelFileCount,ODSPreCount,ODSPostCount,RunDate)
	select @PackageID,@ExcelFileCount,@ODSPreCount,@ODSPostCount, GETDATE()
----------------------------------------------------------------------------------

declare @PackageData int  = ?
declare @PackageID int = ?
declare @PackageName int = ?
declare @SequenceNo int = ?

select p.PackageID,p.PackageName,p.SequenceNo from Acada_control.Package p
where p.ProjectID = 1 and StartDate <= CAST(getdate() as date) and 
(EndDate is null or EndDate>= cast(getdate()as date)) and FrequencyID = 1 -----daily run/load
order by p.SequenceNo ---this will determine how the data is run

declare @PackageID int =?        
update Acada_control.package set LastRun= GETDATE() where PackageID =@PackageID

select * from Acada_control.Project
select * from Acada_control.PackageType
select * from Acada_control.Package
select * from Acada_control.Frequency
select * from Acada_control.Metric





----------------------------------------------------------------------SSIS Staging----------------------------------

------Truncate and load data into Staging SSIS

//-----Loading Metrics In Staging packages  in SSIS 
declare @PackageID int =? 
declare @ODSCount int = ?
declare @StageCount int =?

update Acada_control.package set LastRun= GETDATE() where PackageID =@PackageID
insert into Acada_control.Metric(PackageID,ODSCount,StageCount,RunDate)
select @PackageID,@ODSCount,@StageCount, GETDATE()
---------------------------------------------------------------------------


Truncate Table [Acada_STAGING].[Employee]

Select count(*) as ODSCount from Acada_ODS.Employee

Truncate Table [Acada_STAGING].[Product]

Select count(*) as ODSCount from Acada_ODS.Product


Truncate Table [Acada_STAGING].[Junk]

Select count(*) as ODSCount from Acada_ODS.Junk

Truncate Table [Acada_STAGING].[Color]

Select count(*) as ODSCount from Acada_ODS.Color

Truncate Table [Acada_STAGING].[Class]

Select count(*) as ODSCount from Acada_ODS.Class


Truncate Table [Acada_STAGING].[SpecialOffers]

Select count(*) as ODSCount from Acada_ODS.SpecialOffers

Truncate Table [Acada_STAGING].[Supplier]

Select count(*) as ODSCount from Acada_ODS.Supplier

Truncate Table [Acada_STAGING].[SupplierTransaction]

Select count(*) as ODSCount from Acada_ODS.SupplierTransaction

select * from [Acada_STAGING].[SupplierTransaction]

select count(*) as ODSCount from Acada_ODS.TransactionTable

 Truncate Table [Acada_STAGING].[TransactionTable]

 select * from Acada_ODS.TransactionTable

select * from Acada_control.Package 


------------------------------------------------------------------SSIS EDW Metrics-------------------------------------------------------------

---EDW Loading---	

-----Control Metrics----

declare @PackageID int =?   
declare @PreCount int = ?   
declare @CurrentCount int =?
declare @Type1Count int =?
declare @Type2Count int =?
declare @PostCount int =?

update Acada_control.package set LastRun= GETDATE() where PackageID =@PackageID
insert into Acada_control.Metric(PackageId,PreCount, CurrentCount, Type1Count, Type2Count, PostCount, Rundate)
Select @PackageID,@PreCount,@CurrentCount, @Type1Count, @Type2Count, @PostCount, GETDATE()



select Count(*) as PreCount from Acada_EDW.DimEmployee
select Count(*) as PostCount from Acada_EDW.DimEmployee

select Count(*) as PreCount from Acada_EDW.DimDate
select Count(*) as PostCount from Acada_EDW.DimDate


select Count(*) as PreCount from Acada_EDW.DimProduct
select Count(*) as PostCount from Acada_EDW.DimProduct

select Count(*) as PreCount from Acada_EDW.DimSpecialOffers
select Count(*) as PostCount from Acada_EDW.DimSpecialOffers

select Count(*) as PreCount from Acada_EDW.DimSupplier
select Count(*) as PostCount from Acada_EDW.DimSupplier


select Count(*) as PreCount from Acada_EDW.DimJunk
select Count(*) as PostCount from Acada_EDW.DimJunk


select Count(*) as PreCount from Acada_EDW.Fact_TransactionTable
select Count(*) as PostCount from Acada_EDW.Fact_TransactionTable


select * from Acada_ODS.Date
select * from Acada_EDW.DimDate
select  *from Acada_EDW.DimSpecialOffers

select * from Acada_ODS.SpecialOffers
select * from [Acada_STAGING].[SpecialOffers]
select * from [Acada_STAGING].TransactionTable


-----Dimension Lookup----
select SupplierSK, SupplierID from Acada_EDW.DimSupplier where EffectiveEndDate is null
select EmployeeSK, EmployeeID from Acada_EDW.DimEmployee where EffectiveEndDate is null
select ProductSK, ProductID from   Acada_EDW.DimProduct where  EffectiveEndDate is null
Select SpecialOfferSK, SpecialOfferID from Acada_EDW.DimSpecialOffers
Select Datekey,FullDateAlternateKey from Acada_EDW.DimDate
Select JunkSK,JunkID from Acada_EDW.DimJunk where  EffectiveEndDate is null 

select * from Acada_ODS.Junk