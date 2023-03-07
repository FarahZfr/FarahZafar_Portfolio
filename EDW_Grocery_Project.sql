q2015-04-07  23

10*365*(


Select * from Employee

10*365

0 - 23   1


20:00:00

0 - 23


----- Staging Load Store ------

Use [Grocery OLTP]
Select s.StoreID, s.StoreName, s.StreetAddress, c.CityName, st.State from Store s 
inner join City c on c.CityID = s.CityID
inner join  State st on	st.StateID = c.StateID
	

Use [Grocery Staging]

Create schema Grocery_OLTP

Create Schema Human_Resources

----Staging Store----

Create Table Grocery_OLTP.Store
(
	StoreID int ,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	CityName nvarchar(50),
	[State] nvarchar(50),
    Constraint Grocery_OLTP_Store_Pk primary key (StoreID)		

)

alter table Grocery_OLTP.Store add LoadDate datetime
select * from  Grocery_OLTP.Store


---Script to Load from Staging to EDW---
 Truncate Table Grocery_OLTP.Store
 Select StoreID, StoreName, StreetAddress, CityName, [State] from Grocery_OLTP.Store



Use [Grocery EDW]
Create schema Grocery_EDW

Create Table Grocery_EDW.DimStore
(
	StoreSK int identity(1,1),
	StoreID int ,
	StoreName nvarchar(50),
	StreetAddress nvarchar(50),
	CityName nvarchar(50),
	[State] nvarchar(50),
	EffectiveStartDate datetime,
	Constraint Grocery_EDW_Store_SK primary key (StoreSk)		

)
Select * from [Grocery OLTP].dbo.PurchaseTransaction
use [Grocery EDW]

select s.State, p.ProductName, sum(f.LineAmount) as  "Amount" from Grocery_EDW.Fact_Sales_Analysis f
inner join Grocery_EDW.DimStore s on s.StoreSK = f.StoreSK
inner join Grocery_EDW.DimProduct p on p.ProductSK = f.ProductSk
group by s.State, p.ProductName


Select *   from [Grocery EDW].Grocery_EDW.DimStore s



---Product Staging Load---

Use [Grocery OLTP]

select p.ProductID, p.Product, p.ProductNumber, p.UnitPrice, d.Department from Product p
inner join Department d on d.DepartmentID = p.DepartmentID


select count(*) as OltpCount from Product p
inner join Department d on d.DepartmentID = p.DepartmentID

use [Grocery Staging]

create table Grocery_OLTP.Product
(

	ProductID int,
	ProductName nvarchar(50),
	ProductNumber int,
	UnitPrice float,
	Department nvarchar(50)
	Constraint Grocery_OLTP_Product_Pk Primary Key (ProductID)

)

Truncate Table Grocery_OLTP.Product

Select ProductID, ProductName, ProductNumber, UnitPrice, Department from Grocery_OLTP.Product


---EDW---

----UPDATED DIM_PRODUCT_TABLE  to DimProduct1

Use [Grocery EDW]
create table Grocery_EDW.DimProduct1
(
	ProductSK int identity(1,1),
	ProductID int,
	ProductName nvarchar(50),
	ProductNumber nvarchar(50),
	--ProductNumber int,
	UnitPrice float,
	Department nvarchar(50),
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	Constraint Grocery_EDW_Product1_Sk Primary Key (ProductSK)

)



---Load Promotion Staging---

Use [Grocery OLTP]

Select p.PromotionID,pt.Promotion, p.StartDate, p. EndDate,p.DiscountPercent from Promotion p
inner join PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID


Use [Grocery Staging]

Truncate table Grocery_OLTP.Promotion

create table Grocery_OLTP.Promotion
(
	PromotionID int,
	Promotion nvarchar(50), 
	StartDate date, 
	EndDate date,
	DiscountPercent float,
	constraint Grocery_OLTP_Promotion1_pk primary key(PromotionID)
)

use [Grocery EDW]

create table Grocery_EDW.DimPromotion
(	PromotionSK int identity(1,1),
	PromotionID int,
	Promotion nvarchar(50), 
	StartDate date, 
	EndDate date,
	DiscountPercent float,
	EffectiveStartDate datetime,
	constraint Grocery_EDW_DimPromotion_sk primary key(PromotionSK)
)




----Load Staging Customer

Use [Grocery OLTP]
----

--Extract and Transform
Select ct.CustomerID,  UPPER(ct.LastName) +',  '+ ct.FirstName as Customer, CustomerAddress, CityName, State from  Customer ct
 inner join	city c on c.CityID = ct.CityID
 inner join State s on s.StateID = c.StateID

 use [Grocery Staging]

 Truncate Table Grocery_OLTP.Customer 

 create table Grocery_OLTP.Customer

 (
	CustomerID int, 
	Customer nvarchar(255),
	CustomerAddress nvarchar(50),
	CityName nvarchar(50),
	State nvarchar(50),
	constraint Grocery_OLTP_Customer_Pk primary key (CustomerID)
 )


  use [Grocery EDW]

  create table Grocery_EDW.DimCustomer

 (
	CustomerSK int identity (1,1),
	CustomerID int, 
	Customer nvarchar(255),
	CustomerAddress nvarchar(50),
	CityName nvarchar(50),
	State nvarchar(50),
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	constraint Grocery_EDW_DimCustomer_sk primary key (CustomerSK)
 )




 -----Load Staging  POSChannel----

 use [Grocery OLTP]
 select   p.ChannelID, p.ChannelNo, p.DeviceModel, p.SerialNo, p.InstallationDate from POSChannel p 



 use [Grocery Staging]
 truncate table  Grocery_OLTP.POSChannel


 create table Grocery_OLTP.POSChannel
 (
	ChannelID int,
	ChannelNo nvarchar(50),
	DeviceModel nvarchar(50),
	SerialNo nvarchar(50),
	InstallationDate date,
	constraint Grocery_OLTP_POSChannel_pk primary key (ChannelID)

 )


 --- EDW ---
 
 use [Grocery EDW]


/** create table Grocery_EDW.POSChannel
 (
	

 )*/



 create table Grocery_EDW.POSChannel1
 (
	ChannelSK int identity (1,1),
	ChannelID int,
	ChannelNo nvarchar(50),
	DeviceModel nvarchar(50),
	SerialNo nvarchar(50),
	InstallationDate date,
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	constraint Grocery_EDW_POSChannel1_Sk primary key (ChannelSK)
)


---Load Employee---
use [Grocery OLTP]
select * from Employee
select * from MaritalStatus

select e.EmployeeID, e.EmployeeNo, e.FirstName, e.LastName, e.DoB, m.MaritalStatus from Employee e
inner join MaritalStatus m on e.MaritalStatus = m.MaritalStatusID


----
use [Grocery Staging]


Truncate table Grocery_OLTP.Employee

create table  Grocery_OLTP.Employee
(
EmployeeID int,
EmployeeNo nvarchar(50), 
FirstName nvarchar(50),
LastName nvarchar(50),
DoB date,
MaritalStatus nvarchar(50),	
constraint Grocery_OLTP_Employee_pk primary key (EmployeeID)

)

---Load Employee EDW---
use [Grocery Staging]

Select	e.EmployeeID, e.EmployeeNo, upper(e.LastName)+ ', ' +e.FirstName as Employee, DOB as DateofBirth, 
	e.MaritalStatus from  Grocery_OLTP.Employee e	



use [Grocery EDW]
create table  Grocery_EDW.DimEmployee
(
	EmployeeSK int identity(1,1),
	EmployeeID int,
	EmployeeNo nvarchar(50), 
	Employee nvarchar(255),
	DateofBirth date,
	MaritalStatus nvarchar(50),	
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	constraint Grocery_EDW_DimEmployee_sk primary key (EmployeeSK)

) 


-----Vendor Staging Load---

use [Grocery OLTP]

select v.VendorID, v.VendorNo,v.FirstName, v.LastName, v.RegistrationNo, .VendorAddress, c.CityName, s.State  from Vendor v 
inner join City c on c.CityID = v.CityID
inner join State s on c.StateID = s.StateID	


use [Grocery Staging]
Truncate  table Grocery_OLTP.Vendor
create table Grocery_OLTP.Vendor
(
	VendorID int,
	VendorNo nvarchar(50),
	FirstName nvarchar(50),
	LastName nvarchar(50),
	RegistrationNo nvarchar(50), 
	VendorAddress nvarchar(50),
	CityName  nvarchar(50),
	State  nvarchar(50),
	Constraint Grocery_OLTP_Vendor_Pk primary key(VendorID)
)

use [Grocery Staging]
select VendorID, VendorNo, Upper(LastName)+ ' , '+FirstName as Vendor , RegistrationNo, .VendorAddress, CityName, State  from Grocery_OLTP.Vendor 	


use [Grocery EDW]
		create table Grocery_EDW.DimVendor
	(
		VendorSK int identity (1,1),
		VendorID int,
		VendorNo nvarchar(50),
		Vendor nvarchar(50),
		RegistrationNo nvarchar(50), 
		VendorAddress nvarchar(50),
		CityName  nvarchar(50),
		State  nvarchar(50),
		EffectiveStartDate datetime,
		EffectiveEndDate datetime,
		Constraint Grocery_EDW_Vendor_Sk primary key(VendorSK)
	)

use [Grocery OLTP]

select top 100 * from SalesTransaction
select top 100 * from PurchaseTransaction


use [Grocery EDW]

Create Table Grocery_EDW.DimHour
(
	HourKey int,   --0
	[Hour] int,    ---0---23		
	PeriodofDay nvarchar (20),  ---0-5   = Early Bird,  6- 11 Morning, 12 = Noon, 13-17 - afternoon, 18-23- Evening
	BusinessHour nvarchar(20),---- - 8-- Closed, 9 to 17 Open, 18 - 23- Closed
	---StartDate nvarchar(20),
	Constraint Grocery_EDW_DimHour_sk primary key(HourKey)
)



insert into Grocery_EDW.DimHour(HourKey,Hour,PeriodofDay,BusinessHour)
 Values(0,1, 'Early Bird', 'Close')

 





Declare @hourkey int = 0
if OBJECT_ID('Grocery_EDW.DimHour') IS NOT NULL
	BEGIN
	 TRUNCATE TABLE Grocery_EDW.DimHour
	 END
while @hourkey <= 23
BEGIN

	insert into Grocery_EDW.DimHour(HourKey,Hour,PeriodofDay,BusinessHour)
	
	Select HourKey=@hourkey, [Hour]=@hourkey,
	PeriodofDay = 
	case  
		when @hourkey>= 0 and @hourkey <= 5 then 'Early Bird'
		when @hourkey>=6 and @hourkey<= 11 then 'Morning'
		when @hourkey = 12 then 'Noon' 
		when @hourkey>=13 and @hourkey<= 17 then 'Afternoon'
		when @hourkey>=18 and @hourkey<= 20 then 'Evening'
		ELSE 'Night'
		End,
		
		BusinessHour =	
			case 
				when (@hourkey>= 0 and @hourkey<= 8) OR (@hourkey>=18 and @hourkey<=23) then 'closed'
				else 'Open'
				end	

	Select @hourkey = @hourkey + 1
			
END



select * from INFORMATION_SCHEMA.TABLES
select * from sys.objects order by create_date


select OBJECT_ID('Grocery_EDW.DimHour')
-----Using IF Statement
	
declare @hourkey int = 0
declare @PeriodofDay nvarchar(20) = 'Night'
while @hourkey <= 23
 Begin

 IF @hourkey>= 0 and @hourkey <= 5
	select @PeriodofDay ='Early Bird'
 IF @hourkey>=6 and @hourkey<= 11 
	select @PeriodofDay = 'Morning'
IF  @hourkey = 12 
	select @PeriodofDay ='Noon'
IF @hourkey>=13 and @hourkey<= 17 
 select @PeriodofDay = 'Afternoon'

IF  @hourkey>=18 and @hourkey<= 20 
  Select @PeriodofDay = 'Evening'
 
 Select HourKey=@hourkey, [Hour]=@hourkey, PeriodofDay = @PeriodofDay
	select @hourkey = @hourkey +1 
	end
 
		
T-SQL


select case hour when 1  then 'sss' end from Grocery_EDW.DimHour

---Variable---
---Conditional Statement Case , IF
---Iteration  while,   Cursor  is an Evil

declare @kemi int = 12
select @kemi = 1 
while @kemi < 100					--2<100
BEGIN
	print (@kemi)                   --2
	select  @kemi = @kemi+1    ---2+1
END
print('End of Discussion')

---select cast (@kemi as nvarchar)+'SA'
/*
loop year
	reset month =1
	loop month
		day =1 to day(eom)
		Loop Day
			day = day+1
	month= month+1
Year = year+1
*/

---mm-yy--dd
select GETDATE()


alter procedure Grocery_EDW.spGenerateDimDate(@StartYear int, @EndYear int)
AS

BEGIN 
set nocount on
declare @StartMonth int 
declare @EndMonth int = 12
declare @startDay int
declare @CurrentDate date 
declare @EndDay int
declare @EngMonthName nvarchar(20)
declare @YouMonthName nvarchar(20)
declare @EngDayName nvarchar(20)
declare @HinduDayName nvarchar(20)
declare @YouDayName nvarchar(20)
declare @SpaDayName nvarchar(20)
declare @Datekey int 
declare @DayofWeek int
declare @Calweek int
declare @CalJulian int
declare	@CalQuarter nvarchar(2)

BEGIN

IF OBJECT_ID('Grocery_EDW.DimDate') is not Null

	TRUNCATE TABLE   Grocery_EDW.DimDate

WHILE @StartYear<=@EndYear      ----2020<=2022   for the first iteration
BEGIN

	Select @StartMonth = 1
	While @StartMonth <= @EndMonth          ----1<=12
		BEGIN
			select @startDay= 1
			select @EndDay= day(EOMONTH(DATEFROMPARTS( @StartYear,@StartMonth,1))) 
			While @startDay<= @EndDay
			BEGIN
			---Select @StartYear as CurrentYear, @StartMonth as CurrentMonth , @startDay as currentday
			select @CurrentDate = DATEFROMPARTS(@StartYear,@StartMonth,@StartDay)
			select @EngMonthName = DATENAME(MONTH,@CurrentDate)
			select @EngDayName = DATENAME(WEEKDAY, @CurrentDate)
			select @Datekey = cast(concat(@StartYear, RIGHT('0'+ CAST(@StartMonth as varchar),2),
			Right('0'+ CAST(@startDay as varchar), 2))as int)

	/*1. Ravivar: Sunday(day of Sun)
2. Somvar: Monday (day of Moon) 
3. Mangalvar: Tuesday (day of Mars)
4. Budhvar: Wednesday (day of Mercury)
5. Vrihaspativar or Guruvar
6. Shukravar: Friday (day of Venus)
7. Shanivar : Saturday (day of Saturn)*/



/*Monday = Lunes
Tuesday = Martes
Wednesday = Miercoles	
Thursday = Jueves
Friday = Vierves
Saturday = Sabado
Sunday = Domingo*/



/*
Sunday - aiku
Monday - aje
Tuesday - ishegun
Wednesday - ojoru
Thursday - ojobo
Friday - eti 
Saturday - aba-meta
*/
/*Sere/ January
Erele/ February
Erena/ March
Igbe/ April 
Ebibi/ May
Okudu/ June
Agemo/ July
Ogun/ August
Owewe/ September
Qwara/ October
Belu/ November
Ope/ December
*/

			
			select @YouMonthName = case MONTH(@CurrentDate)
				When 1 then 'Sere'
				When 2 then 'Erele'
				When 3 then 'Erena'
				When 4 then 'Igbe'
				When 5 then 'Ebibi'
				When 6 then 'Okudu'
				When 7 then 'Agemo'
				When 8 then 'Ogun'
				When 9 then 'Owewe'
				When 10 then 'Qwara'
				When 11 then 'Belu'
				When 12 then 'Ope'
				END
				select @DayofWeek = DATEPART(WEEKDAY, @CurrentDate)
				select @HinduDayName = case @DayofWeek
						when 1 then 'Ravivar'
						when 2 then 'Somvar'
						when 3 then 'Mangalvar'
						when 4 then 'Budhvar'
						when 5 then 'Vrihaspativar'
						when 6 then 'Shukravar'
						when 7 then 'Shanivar'
						END

				select @YouDayName = case @DayofWeek
						when 1 then 'aiku'
						when 2 then 'aje'
						when 3 then 'ishegun'
						when 4 then 'ojoru'
						when 5 then 'ojobo'
						when 6 then 'eti'
						when 7 then 'aba-met'
						END

					Select @SpaDayName = case @DayofWeek

					when 1 then 'Domingo'
						when 2 then 'Lunes'
						when 3 then 'Martes'
						when 4 then 'Miercoles'
						when 5 then 'Jueves'
						when 6 then 'Vierves'
						when 7 then 'Sabado '
						END

				Select @Calweek = DATEPART(WEEK, @CurrentDate)
				select @CalQuarter = 'Q' + cast( DATEPART(QUARTER, @CurrentDate) as nvarchar)
				Select @CalJulian = DATEPART(DAYOFYEAR, @CurrentDate)   ---Calendar Julian Day

				Insert into Grocery_EDW.DimDate(Datekey, CalenderDate, CalenderYear, CalenderMonth, CalenderMonthEnglish, CalenderMonthYoruba, CalenderDay, 
												CalenderDayofWeek, CalenderDayofWeekEnglish, CalenderDayofWeekHindu, CalenderDayofWeekYoruba,
												CalenderdayofWeekSpanish, CalenderWeek, CalenderQuarter,CalenderJulianDay)
												Select @Datekey, @CurrentDate,@StartYear, @StartMonth, @EngMonthName, @YouMonthName, @startDay,
												@DayofWeek, @EngDayName, @HinduDayName, @YouDayName,@SpaDayName, @Calweek,@CalQuarter, @CalJulian

			
			


			Select @startDay = @startDay+1
			END

	Select @StartMonth=@StartMonth+1
	END		
	Select @StartYear = @StartYear+1
 END
END
END


Select * from Grocery_EDW.DimDate

Exec Grocery_EDW.spGenerateDimDate   1968,2099 
 






select GETDATE()
select Day(EOMONTH(GETDATE()))

select DATEPART(WEEKDAY, GETDATE())

select DATEPART(WEEK, GETDATE())   ---Calendar Week

select 'Q'+ cast(DATEPART(Quarter, GETDATE()) as nvarchar)   ---Calendar Quarter


select DATEPART(DAYOFYEAR,GETDATE())   ---Calendar Julian Day

select DATEFROMPARTS(2001,8,1)

select EOMONTH(DATEFROMPARTS(2001,8,1))

select day(EOMONTH(DATEFROMPARTS(2004,3,1)))



select RIGHT('0'+ '1', 2)
select RIGHT('0'+ '12', 2)

select RIGHT('343453412',3)
select Left('343453412',3)







drop table Grocery_EDW.DimDate 

Create Table Grocery_EDW.DimDate
(
Datekey int,  ---20110709
CalenderDate date, ---2011-07-09
CalenderYear int, ---2011
CalenderMonth int, ---07
CalenderMonthEnglish nvarchar(20), ---January, February, March
CalenderMonthYoruba nvarchar(20),
CalenderDay int, ---09 
CalenderDayofWeek int, ---7
CalenderDayofWeekEnglish nvarchar(20), ---Sunday, Monday.....Saturday 
CalenderDayofWeekHindu nvarchar(20),
CalenderDayofWeekYoruba nvarchar(20),
CalenderdayofWeekSpanish nvarchar(20),
CalenderWeek int,  ---1...52
CalenderQuarter nvarchar(2), ---Q1, Q2, Q3
CalenderJulianDay int, 
Constraint Grocery_EDW_DimDate_sk primary key(Datekey)
)





select GETDATE()
select DATENAME(Weekday, getdate())
select DATEPART(QUARTER, GETDATE())

select 'Q'+ cast(DATEPART(QUARTER, GETDATE()) as nvarchar)
select EOMONTH(GETDATE())


select DATEFROMPARTS(2000, 02, 01)

select Year(GetDate())



---Leap Year from 1960 to Current Year---
declare @StartYear int = 1960
declare @EndYear int = 3000                  ---Year (GetDate())---
while @StartYear <= @EndYear
	BEGIN
		IF DAY(EOMONTH(DATEFROMPARTS(@StartYear, 02, 01))) = 29
		Print('Leap Year - '+ cast(@StartYear as nvarchar))
		Else
		Print('Non Leap Year - '+ cast(@StartYear as nvarchar))

select @StartYear= @StartYear+1
END


	
---Store Procedure for creating leap year
create procedure Grocery_EDW.getLeapYear(@StartYear int = 1960,  @EndYear int= 2019)
AS 
BEGIN
	--declare @StartYear int = 1960
	--declare @EndYear int = 3000                  ---Year (GetDate())---
	while @StartYear <= @EndYear
	BEGIN
		IF DAY(EOMONTH(DATEFROMPARTS(@StartYear, 02, 01))) = 29
			Print('Leap Year - '+ cast(@StartYear as nvarchar))
		Else
			Print('Non Leap Year - '+ cast(@StartYear as nvarchar))

	select @StartYear= @StartYear+1
 END

END


exec Grocery_EDW.getLeapYear
exec Grocery_EDW.getLeapYear 1900, 2500

select getdate()

---1.select  addclass(12,13)            ---scalar Function---1

create function Grocery_EDW.addclass(@value1 int, @value2 int)

returns int
AS
BEGIN

	RETURN

	(
		@value1+@value2
	)

END
select Grocery_EDW.addclass(301,10)

select Lyear, Indicator from fngetleapYearStatus(1900,2500)      ---2

  dimdate ----3

----2 table Function----

	alter function Grocery_EDW.fngetleapYearStatus(@startYear int,	@EndYear int)
	returns 
			@leapyear table	(Lyear int, Indicator nvarchar(255))
		AS 
		BEGIN
			while @StartYear <= @EndYear
				BEGIN
				IF DAY(EOMONTH(DATEFROMPARTS(@StartYear, 02, 01))) = 29
				BEGIN
					insert into @leapyear(Lyear,Indicator) Select  @StartYear, 'Leap Year'
				END
			ELSE
				BEGIN
					insert into @leapyear(Lyear,Indicator) Select  @StartYear, 'Non Leap Year'
				END

	select @StartYear= @StartYear+1
	END
	
	Return
   END
		
Select f.Lyear, f.Indicator from Grocery_EDW.fngetleapYearStatus(1900, 4000) f 
where f.Lyear>2000 and f.Indicator= 'Leap Year'




----3 DimDate




----Fact Sales TRANSACTIONS---


use [Grocery OLTP]
select  top 100 *, LineAmount* LineDiscountAmount from SalesTransaction

select	* from SalesTransaction
	 

select s.TransactionID, s.TransactionNO, CONVERT(date, s.TransDate) TransDate, DATEPART(HOUR, s.TransDate) TransHour,
CONVERT(date, s.OrderDate) OrderDate, DATEPART(HOUR, s.OrderDate) OrderHour,
CONVERT(date, s.DeliveryDate) DeliveryDate, s.ChannelID, s.CustomerID, s.EmployeeID, s.ProductID, s.StoreID, s.PromotionID, 
s.Quantity, s.TaxAmount, s.LineAmount, s.LineDiscountAmount

from SalesTransaction s

use [Grocery Staging]

create table Grocery_OLTP.SalesTRansaction1
(

	TransactionID int,
	TransactionNo nvarchar(50),
	TransDate date,
	TransHour int,
	OrderDate date,
	OrderHour int,
	DeliveryDate date,
	ChannelID int,
	CustomerID int,
	EmployeeID int,
	ProductID int,
	StoreID int,
	PromotionID int,
	Quantity float,
	TaxAmount float,
	LineAmount float,
	LineDiscountAmount float,
	loaddate datetime,
constraint Grocery_SalesTransaction1_pk primary key(TransactionID)


)

select * from Grocery_EDW.DimDate

use [Grocery EDW]

drop table Grocery_EDW.Fact_Sales_Analysis
Create Table Grocery_EDW.Fact_Sales_Analysis

( 
	Sales_Analysis_sk int identity (1,1),
	StoreSK int,
	TransDateSk int,
	TransHourSK int,
	OrderDateSk int, 
	OrderHourSK int,
	DeliveryDateSk int,
	ChannelSk int,
	CustomerSk int,
	EmployeeSk int,
	ProductSk int,
	PromotionSk int,
	TransactionNo nvarchar(50),
	Quantity float,
	TaxAmount float,
	LineAmount float,
	LineDiscountAmount float,
	LoadDate datetime default getdate(),
	Constraint EDW_Fact_Salaes_Analysis_pk primary key(Sales_Analysis_sk),
	constraint EDW_Fact_Sales_DimStore_sk foreign key(StoreSk) references Grocery_EDW.Dimstore(StoreSk),
	constraint EDW_Fact_Sales_TransDate_sk foreign key(TransDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Sales_TransHour_sk foreign key(TransHourSk) references Grocery_EDW.DimHour(Hourkey),
	constraint EDW_Fact_Sales_OrderDate_sk foreign key(OrderDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Sales_OrderHour_sk foreign key(OrderHourSk) references Grocery_EDW.DimHour(Hourkey),
	constraint EDW_Fact_Sales_DeliveryDate_sk foreign key(DeliveryDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Sales_POSChannel_sk foreign key(ChannelSk) references Grocery_EDW.POSChannel(ChannelSk),
	constraint EDW_Fact_Sales_DimCustomer_sk foreign key(CustomerSk) references Grocery_EDW.DimCustomer(CustomerSk),
	constraint EDW_Fact_Sales_DimEmployee_sk foreign key(EmployeeSk) references Grocery_EDW.DimEmployee(EmployeeSK),
	constraint EDW_Fact_Sales_DimProduct_sk foreign key(ProductSk) references Grocery_EDW.DimProduct(ProductSk),
	constraint EDW_Fact_Sales_DimPromotion_sk foreign key(PromotionSk) references Grocery_EDW.DimPromotion(PromotionSk)

	 )

select DATEPART(hour, cast('2021-12-08 20:23:18' as datetime))

08 20:23:18 => 2021-12-08 20:23:18

2021-12-08 20:23:18
2022-11-08 20:23:18
2023-10-08 20:23:18
2024-09-08 20:23:18


select cast(CONCAT('2021-12-', '08 20:23:18') as datetime)

----Fact Purchase Transaction----


use [Grocery OLTP]

select p.TransactionID, p.TransactionNO, CONVERT(date, p.TransDate) TransDate, CONVERT(date, p.OrderDate) OrderDate,
CONVERT(date, p.DeliveryDate) DeliveryDate, CONVERT(date, p.ShipDate) ShipDate, p.EmployeeID,p.VendorID,
p.StoreID, p.ProductID, p.Quantity, p.TaxAmount, p.LineAmount, DATEDIFF(d, p.OrderDate, p.DeliveryDate) DeliveryEfficiency
from PurchaseTransaction p


use  [Grocery Staging]
create table Grocery_OLTP.PurchaseTRansaction
(

	TransactionID int,
	TransactionNo nvarchar(50),
	TransDate date,
	OrderDate date,
	ShipDate date,
	DeliveryDate date,
	VendorID int,
	EmployeeID int,
	ProductID int,
	StoreID int,
	Quantity float,
	TaxAmount float,
	LineAmount float,
	DeliveryEfficiency int,
	loaddate datetime,
constraint Grocery_PurchaseTransaction_pk primary key(TransactionID)

)


use [Grocery EDW]

drop table Grocery_EDW.Fact_Purchase_Analysis 

Create table Grocery_EDW.Fact_Purchase_Analysis
(
 Purchase_Analysis_sk int identity (1,1),
	StoreSK int,
	TransDateSk int,
	OrderDateSk int, 
	ShipDateSk int,	
	DeliveryDateSk int,
	VendorSk int,
 	EmployeeSk int,
	ProductSk int,
	TransactionNo nvarchar(50),
	Quantity float,
	TaxAmount float,
	LineAmount float,
	DeliveryEfficiency int,	
	LoadDate datetime default getdate(),
	Constraint EDW_Fact_Purcahse_Analysis_pk primary key(Purchase_Analysis_sk),
	constraint EDW_Fact_Purchase_DimStore_sk foreign key(StoreSk) references Grocery_EDW.DimStore(StoreSK),
	constraint EDW_Fact_Purcahse_TransDate_sk foreign key(TransDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Purchase_OrderDate_sk foreign key(OrderDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Purchase_ShipDate_sk foreign key(ShipDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Purchase_DeliveryDate_sk foreign key(DeliveryDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Purchase_DimVendor_sk foreign key(VendorSk) references Grocery_EDW.DimVendor(VendorSK),
	constraint EDW_Fact_Purchase_DimEmployee_sk foreign key(EmployeeSk) references Grocery_EDW.DimEmployee(EmployeeSK),
	constraint EDW_Fact_Purchase_DimProduct_sk foreign key(ProductSk) references Grocery_EDW.DimProduct(ProductSk)


)


------HR Fact_HR_Analysis-------


---OvertimeID,EmployeeNo,FirstName,LastName,StartOvertime,EndOvertime

use [GroceryStaging]

Create Table Human_Resources.OverTimeTrans

(	OvertimeID int,

	EmployeeNo nvarchar(50),

	FirstName nvarchar(50),
	LastName nvarchar(50),
	StartOvertime datetime,
	EndOvertime datetime,
	Constraint Human_Resources_OverTimeTrans_pk primary key (OvertimeID)
)

select h.OvertimeID, h.EmployeeNo, CONVERT(date, StartOvertime) StartOverTimeDate,
DATEPART(HOUR,StartOvertime) StartOvertimeHour, CONVERT(date, EndOvertime) EndOverTimeDate, 
DATEPART(HOUR,EndOvertime) EndOvertimeHour, DATEDIFF(hour, StartOvertime, EndOvertime) OvertimeHour
from  Human_Resources.OverTimeTrans h 

select * from Human_Resources.OverTimeTrans

use [GroceryEDW]

Create Table Grocery_EDW.Fact_Hr_Analysis

( 
	Hr_Analysis_sk int identity (1,1),
	EmployeeSK int,
	OverTimeStartDateSk int,
	OverTimeStartHourSK int,
	OverTimeSEndDateSk int,
	OverTimeEndHourSK int,
	OverTimeHourSK int,	
	LoadDate datetime default getdate(),
	Constraint EDW_Fact_Hr_Analysis_pk primary key(Hr_Analysis_sk),
	constraint EDW_Fact_Hr_DimEmployee_sk foreign key(EmployeeSk) references Grocery_EDW.DimEmployee(EmployeeSK),
	constraint EDW_Fact_Hr_OStartDate_sk foreign key(OverTimeStartDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Hr_OStartHour_sk foreign key(OverTimeStartHourSK) references Grocery_EDW.DimHour(Hourkey),
	constraint EDW_Fact_Hr_OEndDate_sk foreign key(OverTimeStartDateSk) references Grocery_EDW.DimDate(Datekey),
	constraint EDW_Fact_Hr_OEndHour_sk foreign key(OverTimeEndHourSK) references Grocery_EDW.DimHour(Hourkey), 

	 )	


Declare @count int
select @count = 1
while @count <20
BEGIN
	print @Count
	Select @count  = @count+1


END

------------------------------------------------------Control Framework----------------------------
----Control Framework---
----Sequence of How ETL process 
---PackageTable
---Metric Table

use [GroceryControl]
create schema [control]

create Table Control.DataAnomalies

(
DataAnoID int identity(1,1),
PackageID int,
TableName nvarchar (255),
ColumnName nvarchar(255),
TransactionID int,
LoadDate datetime,
constraint DataAnomalies_pk primary key (DataAnoID),
constraint Data_Package_fk foreign key(PackageID) references Control.Package(PackageID)
)

create Table Control.ProjectPackage						-----1.-----

(
ProjectID int,
ProjectName nvarchar(50) ----Staging, Edw
constraint ProjectPackage_pk primary key (ProjectID)
)

insert into  control.ProjectPackage(ProjectID,ProjectName)
values (1, 'Staging'),
	   (2, 'EDW')


create Table Control.PackageCategory					------2-----

(
CategoryID int,
CategoryName nvarchar(50)----Dimension, Fact
constraint ProjectCategory_pk primary key (CategoryID)
)

insert into  control.PackageCategory(CategoryID, CategoryName)
values (1, 'Dimension'),
	   (2, 'Fact')

drop table control.package
create table control.package					---3----
(
PackageID int identity(1,1), ----1
PackageName nvarchar(255), ----stgstore.dtsx
ProjectID int, 
CategoryID int, ----Dimaension, Fact
SequenceID int,
StartDate date,
EndDate date,
LastRun	datetime,	

constraint control_package_pk primary key (PackageID),
constraint package_project_fk foreign key (ProjectID) references Control.ProjectPackage(ProjectID),
constraint package_category_fk foreign key (CategoryID) references Control.PackageCategory(CategoryID)
)




insert into control.package(PackageName, ProjectID,CategoryID,SequenceID,StartDate)
values('stgStore.dtsx',1,1,100, GETDATE()),
('stgProduct.dtsx',1,1,200, GETDATE()),
('stgPromotion.dtsx',1,1,300, GETDATE()),
('stgCustomer.dtsx',1,1,400, GETDATE()),
('stgPOSChannel.dtsx',1,1,500, GETDATE()),
('stgEmployee.dtsx',1,1,600, GETDATE()),
('stgVendor.dtsx',1,1,700, GETDATE()),
('stgInitSalesTrans.dtsx',1,2,1000, GETDATE()),
('stgSalesTrans.dtsx',1,2,1001, DATEADD(day,1, getdate())),
	('stgIntPurchaseTrans.dtsx',1,2,2000, GETDATE()),
('stgPurchaseTrans.dtsx',1,2,2001, GETDATE()),
('stgOvertime.dtsx',1,2,3000, GETDATE()),
('stgOvertime.dtsx',1,2,3001,DATEADD(day,1, getdate()))


insert into control.package(PackageName, ProjectID,CategoryID,SequenceID,StartDate)
values('dimStore. dtsx',2,1,100, GETDATE()),
('dimProduct.dtsx',2,1,200, GETDATE()),
('dimPromotion.dtsx',2,1,300, GETDATE()),
('dimCustomer.dtsx',2,1,400, GETDATE()),
('dimPOSChannel.dtsx',2,1,500, GETDATE()),
('dimEmployee.dtsx',2,1,600, GETDATE()),
('dimVendor.dtsx',2,1,700, GETDATE()),
('factSalesTrans.dtsx',2,2,1000, GETDATE()),
('factPurchaseTrans.dtsx',2,2,2000, GETDATE()),
('factOvertime.dtsx',2,2,3000, GETDATE())

/*-----------
select Min(TransDate), MAX(TransDate) from SalesTransaction
select * from  SalesTransaction where TransDate <= DATEADD(d, -1, GETDATE())	E= 1...n-1   once start and end   14 Aug and 14 Aug initsales

select * from  SalesTransaction where TransDate = DATEADD(d, -1, GETDATE())	    n- 1 start = 15 Aug  sales

select DATEADD(d, -1, getdate())

-----Precount -> CurrentCount ->PostCount, Type1count, Type2count-- precount+currentCount+ Type2Count = Postcount  ---Edw load metrics
---SourceCount = StageCount  --Staging Load metrics
*/



drop table control.metric
create table control.metric															-----4-----
(
MetricID int identity (1,1),
PackageID int,
OltpCount int,
StageCount int,
PreCount int,
CurrentCount int,
Type1Count int,
Type2Count int,
PostCount int,
Rundate datetime

constraint control_metric_pk primary key(metricID),
constraint package_metric_fk foreign key (PackageID) references Control.Package(PackageID)
)
	
	use [Grocery Control]

	select * from control.package

	select * from control.metric
	select * from control.ProjectPackage
	select * from control.PackageCategory

select * from control.package

select PackageID,SequenceID, PackageName from control.package p
where p.ProjectID= 1 and StartDate<= cast (GETDATE()as date) and (EndDate is null or EndDate>= cast(GETDATE() as date))
order by p.SequenceID

truncate table control.metric

use [Grocery OLTP]
Select count(*) as  OltpCount from Store s 
inner join City c on c.CityID = s.CityID
inner join  State st on	st.StateID = c.StateID

Select Count(*) as OltpCount from Promotion p
inner join PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID

Select p.PromotionID,pt.Promotion, p.StartDate, p. EndDate,p.DiscountPercent from Promotion p
inner join PromotionType pt on p.PromotionTypeID = pt.PromotionTypeID



---EDW Loading---	

-----Control Metrics----

declare @PackageID int =?   
declare @OltpCount int = ?   
declare @StageCount int =?     
update control.package set LastRun= GETDATE() where PackageID =@PackageID

insert into control.metric(PackageId,OltpCount, StageCount,Rundate)
Select @PackageID,@OltpCount,@StageCount,GETDATE()


declare @PackageID int =?        
update control.package set LastRun= GETDATE() where PackageID =@PackageID



use [Grocery OLTP]



/*Full load */

select	count(*) as OltpCount from SalesTransaction s
Where cast (TransDate as date) <= cast(DATEADD(day, -1, GETDATE()) as date)


select s.TransactionID, s.TransactionNO, CONVERT(date, s.TransDate) TransDate, DATEPART(HOUR, s.TransDate) TransHour,
CONVERT(date, s.OrderDate) OrderDate, DATEPART(HOUR, s.OrderDate) OrderHour,
CONVERT(date, s.DeliveryDate) DeliveryDate, s.ChannelID, s.CustomerID, s.EmployeeID, s.ProductID, s.StoreID, s.PromotionID, 
s.Quantity, s.TaxAmount, s.LineAmount, s.LineDiscountAmount
from SalesTransaction s
Where cast(TransDate as date)<= cast(DATEADD(day, -1, GETDATE()) as date)



	select * from SalesTransaction

/*Incremental Load*/

select Count(*) as OltpCount  from SalesTransaction s
Where cast(s.TransDate as date)  = cast(DATEADD(day, -1, GETDATE()) as date)



select s.TransactionID, s.TransactionNO, CONVERT(date, s.TransDate) TransDate, DATEPART(HOUR, s.TransDate) TransHour,
CONVERT(date, s.OrderDate) OrderDate, DATEPART(HOUR, s.OrderDate) OrderHour,
CONVERT(date, s.DeliveryDate) DeliveryDate, s.ChannelID, s.CustomerID, s.EmployeeID, s.ProductID, s.StoreID, s.PromotionID, 
s.Quantity, s.TaxAmount, s.LineAmount, s.LineDiscountAmount
from SalesTransaction s
Where cast(TransDate as date)= cast(DATEADD(day, -1, GETDATE()) as date)



select * from control.package
n = current day
n-1= yesterday


2011, 2021
2013, 2021
2012, 2022

use [Grocery OLTP]




----Shifting the data by 2 years forward---
--==========================================

select * from [dbo].[OvertimeData]

select MIN(startOverTime), MAX(startOverTime) from [dbo].[OvertimeData]

update OvertimeData
set StartOverTime= DATEADD(year, 2, StartOverTime),
EndOverTime= DATEADD(year, 2, EndOverTime)




/*Purchase Shifted Data*/

select * from PurchaseTransaction

update PurchaseTransaction
set TransDate= DATEADD(YEAR, 2 , TransDate),
OrderDate= DATEADD(year, 2, OrderDate),
DeliveryDate= DATEADD(year, 2, DeliveryDate),
ShipDate= DATEADD(year, 2, ShipDate)





/*Sales Shifted Data*/
select min(t2), max(t2) 
from 
	(
	select *, DATEADD(YEAR, 2 , TransDate) t2, DATEADD(year, 2, OrderDate) o2, DATEADD(year, 2, DeliveryDate) d2  
	from SalesTransaction
	)a




update SalesTransaction
set TransDate= DATEADD(YEAR, 2 , TransDate),
OrderDate= DATEADD(year, 2, OrderDate),
DeliveryDate= DATEADD(year, 2, DeliveryDate)


select min(TransDate), max(TransDate) from SalesTransaction

select Count(*), Month(TransDate) from SalesTransaction where YEAR(TransDate)= 2019
group by MONTH(TransDate)



---Purchase Trans---
---Init	Extract data load
use [Grocery OLTP]

select count(*) as OltpCount
from PurchaseTransaction p
where cast(TransDate as date)<=cast(DATEADD(day, -1, GETDATE()) as date)

select p.TransactionID, p.TransactionNO, CONVERT(date, p.TransDate) TransDate, CONVERT(date, p.OrderDate) OrderDate,
CONVERT(date, p.DeliveryDate) DeliveryDate, CONVERT(date, p.ShipDate) ShipDate, p.EmployeeID,p.VendorID,
p.StoreID, p.ProductID, p.Quantity, p.TaxAmount, p.LineAmount, DATEDIFF(d, p.OrderDate, p.DeliveryDate) DeliveryEfficiency,
GetDate() as LoadDate
from PurchaseTransaction p
where cast(TransDate as date) <= cast(DATEADD(day, -1, GETDATE()) as date)


----Incremental Extract
select count(*) as OltpCount
from PurchaseTransaction p
where cast(TransDate as date) = cast(DATEADD(day, -1, GETDATE()) as date)

select p.TransactionID, p.TransactionNO, CONVERT(date, p.TransDate) TransDate, CONVERT(date, p.OrderDate) OrderDate,
CONVERT(date, p.DeliveryDate) DeliveryDate, CONVERT(date, p.ShipDate) ShipDate, p.EmployeeID,p.VendorID,
p.StoreID, p.ProductID, p.Quantity, p.TaxAmount, p.LineAmount, DATEDIFF(d, p.OrderDate, p.DeliveryDate) DeliveryEfficiency, 
GetDate() as LoadDate
from PurchaseTransaction p
where cast(TransDate as date) = cast(DATEADD(day, -1, GETDATE()) as date)



------HR OverTime Data---

use [Grocery OLTP]

select * from Employee

---393201,EMP-43967,Cade,Bender,2020-11-02 13:00:00,2020-11-02 17:00:00---

use [Grocery Staging]
alter table [Human_Resources].[OverTimeTrans] add LoadDate DateTime

select h.OvertimeID, h.EmployeeNo, CONVERT(date, StartOvertime) StartOverTimeDate, 
DATEPART(HOUR,StartOvertime) StartOvertimeHour, CONVERT(date, EndOvertime) EndOverTimeDate, 
DATEPART(HOUR,EndOvertime) EndOvertimeHour, DATEDIFF(hour, StartOvertime, EndOvertime) OvertimeHour
from  Human_Resources.OverTimeTrans h






---EDW Loading---	

-----Control Metrics----

declare @PackageID int =?   
declare @PreCount int = ?   
declare @CurrentCount int =?
declare @Type1Count int =?
declare @Type2Count int =?
declare @PostCount int =?


UPDATE control.package set LastRun= GETDATE() where PackageID =@PackageID

insert into control.metric(PackageId,PreCount, CurrentCount, Type1Count, Type2Count, PostCount, Rundate)
Select @PackageID,@PreCount,@CurrentCount, @Type1Count, @Type2Count, @PostCount, GETDATE()

 

use [Grocery Control]

select * from control.package

select * from control.metric
select * from control.ProjectPackage
select * from control.PackageCategory

select * from control.package

select PackageID,SequenceID, PackageName from control.package p
where p.ProjectID= 1 and StartDate<= cast (GETDATE()as date) and (EndDate is null or EndDate>= cast(GETDATE() as date))
order by p.SequenceID

---Loading from Staging to EDW---
---Dim Store Load---


use [Grocery Staging]
Select count(*) as CurrentCount from Grocery_OLTP.Store s
Select s.StoreID, s.StoreName, s.StreetAddress,s.CityName, s.State from Grocery_OLTP.Store s


use [Grocery EDW]
select count(*) as PreCount  from Grocery_EDW.Dimstore s


select count(*) as PostCount  from Grocery_EDW.Dimstore s

select s.storeID, s.StoreName, s.StreetAddress, s,CityName, s.State from Grocery_EDW.Dimstore s


-----Dim Product---


use [Grocery Staging]

Select p.ProductID,p.ProductName, p.ProductNumber, p.Department, p.UnitPrice  from Grocery_OLTP.Product p

use [Grocery EDW]

truncate table Grocery_EDW.DimPromotion

select * from Grocery_EDW.DimPromotion

select count(*) as PreCount from Grocery_EDW.DimProduct p	

select count(*) as PostCount from Grocery_EDW.DimProduct p

select * from Grocery_EDW.DimProduct p	
Truncate table  Grocery_EDW.DimProduct 

-----------Loading Promotion-----

use [Grocery Staging]

select p.PromotionID, p.Promotion, p.DiscountPercent, p.StartDate, p.EndDate from Grocery_OLTP.Promotion p

use [Grocery EDW]
select count(*) as PreCount from [Grocery_EDW].[DimPromotion] p

select count(*) as PostCount from [Grocery_EDW].[DimPromotion] p 





-----Loading Customer Grocery_OLTP.Customer----
use [Grocery Staging]
select  c.CustomerID,c.Customer, c.CustomerAddress, c.CityName, c.State	 from Grocery_OLTP.Customer c


use [Grocery EDW]
select * from Grocery_EDW.DimCustomer

select count(*) as PreCount from Grocery_EDW.DimCustomer

select count(*) as PostCount from Grocery_EDW.DimCustomer


-------Loading POSChannel-----

use [Grocery Staging]
select p.ChannelID,p.ChannelNo, p.DeviceModel, p.SerialNo, p.InstallationDate from Grocery_OLTP.POSChannel p

use [Grocery EDW]
select * from Grocery_EDW.POSChannel1
select count (*) as PreCount from Grocery_EDW.POSChannel1

select count (*) as PostCount from Grocery_EDW.POSChannel1

----Loading Employee----

use [Grocery Staging]
select * from Grocery_OLTP.Employee

Select	e.EmployeeID, e.EmployeeNo, upper(e.LastName)+ ', ' +e.FirstName as Employee, e.DOB as DateofBirth, e.MaritalStatus from  Grocery_OLTP.Employee e	


use [Grocery EDW]
select * from Grocery_EDW.DimEmployee
 
select Count(*) as PreCount from Grocery_EDW.DimEmployee
 
select Count(*) as PostCount from Grocery_EDW.DimEmployee

-------Loading Vendor-----
use [Grocery Staging]

select * from Grocery_OLTP.Vendor
select VendorID, VendorNo, Upper(LastName)+ ' , '+FirstName as Vendor , RegistrationNo, VendorAddress, CityName, State  from Grocery_OLTP.Vendor 


use [Grocery EDW]
select * Grocery_EDW.DimVendor

select COUNT(*) as Precount from Grocery_EDW.DimVendor

select COUNT(*) as Postcount from Grocery_EDW.DimVendor



----Loading Sales Fact Information-----

use [Grocery OLTP]
select * from SalesTransaction where cast(TransDate as date) <=cast(dateadd(d, -1, getdate())as date) 
order by TransDate	



use [Grocery EDW]

sp_help 'Grocery_EDW.Fact_Hr_Analysis'

	sp_help 'Grocery_EDW.Fact_Sales_Analysis'

select distinct type_desc from sys.all_objects where type_desc= 'USER_TABLE'


select * from sys.all_objects where type_desc= 'USER_TABLE'

select * from sys.all_columns order by user_type_id desc

select * from INFORMATION_SCHEMA.TABLES

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Fact_Hr_Analysis'

---Initial Sales trans Load----

 
use [Grocery Staging]

If (select count(*)from [Grocery EDW].Grocery_EDW.Fact_Sales_Analysis) < 1 
		BEGIN
		
		select s.TransactionID, s.TransactionNo, s.TransDate, s.TransHour,s.OrderDate, s.OrderHour,s.DeliveryDate, 
		s.ChannelID, s.CustomerID, EmployeeID,s.ProductID, s.StoreID, s.PromotionID, s.Quantity,s.TaxAmount, s.LineAmount,s.LineDiscountAmount, GETDATE() as LoadDate
		from [Grocery Staging].Grocery_OLTP.SalesTRansaction1 s
		where cast(TransDate as date) <=cast(dateadd(d, -1, getdate())as date)
END
	else 
		BEGIN
		select s.TransactionID, s.TransactionNo, s.TransDate, s.TransHour,s.OrderDate, s.OrderHour,s.DeliveryDate, 
		s.ChannelID, s.CustomerID, EmployeeID,s.ProductID, s.StoreID, s.PromotionID, s.Quantity,s.TaxAmount, s.LineAmount,s.LineDiscountAmount, GETDATE() as LoadDate
		from [Grocery Staging].Grocery_OLTP.SalesTRansaction1 s
	where cast(TransDate as date) =cast(dateadd(d, -1, getdate())as date)
	END



use [Grocery EDW]

select COUNT(*) as PreCount from Grocery_EDW.Fact_Sales_Analysis

select COUNT(*) as PostCount from Grocery_EDW.Fact_Sales_Analysis

use [Grocery Staging]
select * from Grocery_OLTP.SalesTRansaction1

---Purcahse Fact Analysis-----
use [Grocery EDW]
Select count(*) as PreCount from Grocery_EDW.Fact_Purchase_Analysis
Select count(*) as PostCount from Grocery_EDW.Fact_Purchase_Analysis



use [Grocery Staging]

if (select count(*) from [Grocery EDW]. Grocery_EDW.Fact_Purchase_Analysis) <1

	BEGIN
		select p.TransactionID, p.TransactionNo, p.TransDate, p.OrderDate, p.ShipDate, p.DeliveryDate, p.VendorID, p.EmployeeID,
		p.ProductID, p.StoreID, p.Quantity, p.TaxAmount, p.LineAmount, p.DeliveryEfficiency, GETDATE() as LoadDate
		from [Grocery Staging]. Grocery_OLTP.PurchaseTRansaction p
		where	CAST(p.TransDate as date) <=cast (DATEADD(d, -1, GETDATE())  as date)
   END
ELSE
 BEGIN
	select p.TransactionID, p.TransactionNo, p.TransDate, p.OrderDate, p.ShipDate, p.DeliveryDate, p.VendorID, p.EmployeeID,
	p.ProductID, p.StoreID, p.Quantity, p.TaxAmount, p.LineAmount, p.DeliveryEfficiency, GETDATE() as LoadDate
	from [Grocery Staging]. Grocery_OLTP.PurchaseTRansaction p
	where	CAST(p.TransDate as date) =cast (DATEADD(d, -1, GETDATE())  as date)
END


-----Load OverTime----

use [Grocery Staging]

select cast(DATEADD(d, -1, GetDate()) as date)

select * from Human_Resources.OverTimeTrans order by StartOvertime desc

 select count(*) as PreCount from Grocery_EDW.Fact_Hr_Analysis

  select count(*) as PostCount from Grocery_EDW.Fact_Hr_Analysis


IF (select count(*) from [Grocery EDW].Grocery_EDW.Fact_Hr_Analysis) < 1
  BEGIN  ----Full Load, stgOvertimeInt
	select h.OvertimeID, h.EmployeeNo, Convert(date, StartOvertime) StartOverTimeDate, 
	DATEPART(HOUR,StartOvertime) StartOvertimeHour, CONVERT(date, EndOvertime) EndOverTimeDate, 
	DATEPART(HOUR,EndOvertime) EndOvertimeHour, DATEDIFF(hour, StartOvertime, EndOvertime) OvertimeHour, GetDate() as LoadDate
	from [Grocery Staging].Human_Resources.OverTimeTrans h
	where cast(h.StartOvertime as date)<= cast (DATEADD(d, -1, GetDate()) as date)
  END
ELSE
  BEGIN   ---Incremental Load,stgOverTime
	select h.OvertimeID, h.EmployeeNo, Convert(date, StartOvertime) StartOverTimeDate, 
	DATEPART(HOUR,StartOvertime) StartOvertimeHour, CONVERT(date, EndOvertime) EndOverTimeDate, 
	DATEPART(HOUR,EndOvertime) EndOvertimeHour, DATEDIFF(hour, StartOvertime, EndOvertime) OvertimeHour, GetDate() as LoadDate
	from [Grocery Staging].Human_Resources.OverTimeTrans h
	where cast(h.StartOvertime as date)= cast (DATEADD(d, -1, GetDate()) as date)

END

select t.OvertimeID, t.EmployeeNo from Human_Resources.OverTimeTrans t




-----Dimension Lookup----
use [Grocery EDW]
select StoreSK,StoreID  from Grocery_EDW.DimStore
select Datekey,CalenderDate from Grocery_EDW.DimDate
select HourKey,hour from Grocery_EDW.DimHour
select ChannelSK, ChannelID from Grocery_EDW.POSChannel1 where EffectiveEndDate is null
select CustomerID,CustomerSK from Grocery_EDW.DimCustomer where EffectiveEndDate is null
Select EmployeeSK, EmployeeID from Grocery_EDW.DimEmployee where EffectiveEndDate is null
Select EmployeeSK, EmployeeNo from Grocery_EDW.DimEmployee where EffectiveEndDate is null
Select  ProductID, ProductSK from Grocery_EDW.DimProduct1 where EffectiveEndDate is null
select PromotionSK, PromotionID from Grocery_EDW.DimPromotion
Select VendorSK, VendorID from Grocery_EDW.DimVendor where EffectiveEndDate is null

 select * from Grocery_EDW.Fact_Sales_Analysis

select * from Grocery_EDW.Fact_Sales_Analysis


-full load data => start to n-1 day   -one time load
- incremental load => start to n-1     -every load, n-1 day 

	
-----Control Metrics Facts----

declare @PackageID int = ?
declare @PreCount int =?
declare @CurrentCount int =?
declare @PostCount int = ?


	

UPDATE control.package set LastRun= GETDATE() where PackageID =@PackageID

insert into control.metric(PackageID,PreCount, CurrentCount,PostCount, Rundate)
Select @PackageID, @PreCount, @CurrentCount,@PostCount, GETDATE()

use [Grocery Control]


select p.SequenceID, p.PackageID, p.PackageName, p.StartDate, p.EndDate, p.LastRun,m.* from control.metric m 
inner join control.package p on m.PackageID = p.PackageID
where CAST(p.LastRun as date) = cast (GETDATE() as date) and p.PackageID = 1
order by LastRun desc 
select from control.package p

select * from control.package
select * from control.metric
select * from control.ProjectPackage
select * from control.PackageCategory


select * from control.package

select PackageID,SequenceID, PackageName from control.package p
where p.ProjectID= 1 and StartDate<= cast (GETDATE()as date) and (EndDate is null or EndDate>= cast(GETDATE() as date))
order by p.SequenceID



select * from control.package order by LastRun desc
select PackageID,SequenceID, PackageName from control.package p
where p.ProjectID= 2 and StartDate<= cast (GETDATE()as date) and (EndDate is null or EndDate>= cast(GETDATE() as date))
order by p.SequenceID

-----Load OverTime----
