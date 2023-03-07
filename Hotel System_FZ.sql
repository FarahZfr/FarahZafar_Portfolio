use [Hotel System]
select * from [dbo].[Menu]
select * from [dbo].[Requests]
select * from [dbo].[Bookings]
select * from [dbo].[Food_Orders]
select * from [dbo].[Rooms]
-----------------------------------
---Load DimRoom
INSERT into DimRoom
SELECT [id] as RoomID
	,[price_day] as PriceDay
	,[capacity] as Capacity
	,[type] as RoomType
	,prefix as Prefix
FROM [dbo].[Rooms]

--Create DimRoom

Create Table DimRoom
 
 (	
	RoomSK int identity(1,1),
	RoomID nvarchar(50),
	RoomPrice int,
	RoomCapacity nvarchar(50),
	RoomType nvarchar(50),
	RoomPrefix nvarchar(50)
	Constraint DimRoomPK  Primary key(RoomSK)
 )
 Select * from DimRoom
 --Load DimRequestType
 INSERT into DimRequestType
 Select [request_type] from [dbo].[Requests]

 -- Create DimRequestType
	Create Table DimRequestType
	(	
		RequestTypeSK int identity (1,1),
		RequestType nvarchar(50),
		Constraint DimRequestTypePK Primary key (RequestTypeSK)
	)

	ALTER Table DimRequestType
	ADD RequestTypeID as RequestTypeSK + 0

SELECT * From DimRequestType

---Load DimClient

INSERT into DimClient
SELECT [client_name] as ClientName FROM [dbo].[Requests]

---Create DimClient
Create Table DimClient
(
	ClientSK int identity(1,1),
	ClientID as ClientSK + 0,
	ClientName nvarchar(50)
	Constraint DimClientPK primary key (ClientSK)
)
Select * FROM DimClient


---Load DimMenu
INSERT INTO DimMenu
SELECT [id] as MenuID
	   ,[name] as MenuName
	   ,[price] as MenuPrice
	   ,[category] as MenuCategory
FROM  [dbo].[Menu]

---Create DimMenu

Create Table DimMenu
(	
	MenuSK int identity(1,1),
	MenuID nvarchar(50),
	MenuName nvarchar(50),
	MenuPrice nvarchar(50),
	MenuCategory nvarchar(50)
	Constraint DimMenuPK primary key(MenuSK)
)
SELECT * FROM DimMenu
---Load DimRoomNumber

INSERT INTO DimRoomNumber
SELECT RoomNumber FROM 
(
SELECT [room] as RoomNumber  FROM [dbo].[Bookings]
UNION
SELECT [dest_room] as RoomNumber FROM [dbo].[Food_Orders]
UNION  
SELECT [dest_room] as RoomNumber FROM [dbo].[Food_Orders])
r


--Create DimRoomNumber

Create Table DimRoomNumber
(
	RoomNumberSK int identity(1,1),
	RoomNumberID as RoomNumberSK + 0,
	RoomNumber nvarchar(50)
	Constraint DimRoomNumberPK primary key (RoomNumberSK)
)
SELECT * FROM DimRoomNumber



--populate DimTime table
set nocount on
declare @StartDate datetime, @EndDate datetime
set @StartDate='2020-01-01 00:00:00'
set @EndDate='2020-01-01 23:59:59'
while @StartDate<@EndDate --initiate loop
begin
	insert into DimOrderTime (OrderTime,OrderHour, OrderMinute, OrderSecond)
	values(
		CONVERT(time,@StartDate,108),--time
		DATEPART(hour,@StartDate), --hour
		DATEPART(minute,@StartDate), --minute
		DATEPART(second,@StartDate) --second
		)
set @StartDate=DATEADD(minute,1,@StartDate) --set counter
end;

--Create DimTime
Create table DimOrderTime
(
	OrderTimeSK int identity(1,1),
	OrderTime time,
	OrderHour int,
	OrderMinute int,
	OrderSecond int,
	constraint DimTimePK primary key (OrderTimeSK)
);

SELECT * FROM DimOrderTime

---Load Dimdate
set nocount on
declare @StartDate date = '2014-01-01'
declare @EndDate date = '2017-12-31'

while @StartDate<@EndDate
BEGIN 
INSERT into DimDate(datekey,CalendarDate,CalendarYear,CalendarQuarter,CalendarMonth,CalendarDay,CalendarWeek)
SELECT Datekey = convert(char(8),@StartDate, 112),
       CalendarDate= convert(char(10), @StartDate, 110),
       CalendarYear= DATEPART(YEAR,@StartDate),
       CalendarQuarter= DATEPART(QQ, @StartDate),
       CalendarMonth = DATENAME(MONTH,@StartDate),
       CalendarDay= DATEPART(DD,@StartDate),
       CalendarWeek= DATEPART(WW,@StartDate)

    set @StartDate = DATEADD(dd,1,@StartDate)
    end;

	---Create DimDate

Create table DimDate
(
 datekey int,
 CalendarDate date,
 CalendarYear int,
 CalendarQuarter nvarchar (2),
 CalendarMonth nvarchar(50),
 CalendarDay int,
 CalendarWeek int,
 constraint DimDatePK primary key(datekey)
)

	select * from DimDate

 
----DimTime breakdown into 3 further dimensions in --1. DimHour --2. DimMinutes --3.DimSeconds
/**We extracted hour, minutes, seconds and mili second */

select * from [dbo].[Food_Orders]

--Load DimHour
Drop table DimOrderHour
INSERT  into DimOrderHour
 SELECT DATEPART(HOUR, time) as Hour FROM [dbo].[Food_Orders]

 Create Table DimOrderHour
 (
	OrderHourSK int identity(1,1),
	OrderHourID as OrderHourSK + 0,
	OrderHour int
	Constraint DimDimOrderHourPK primary key (OrderHourSK)	
 )
 Select * from DimOrderHour

 --Load DimMinute
 Drop table DimOrderMinute
 INSERT into DimOrderMinute
 SELECT DATEPART(MINUTE, time) as Minute FROM [dbo].[Food_Orders]

 --Create DimMinute
 drop  table DimOrderMinute
 Create Table DimOrderMinute
 (
	OrderMinuteSK int identity(1,1),
	OrderMinuteID as OrderMinuteSK + 0,
	OrderMinute int
	Constraint DimOrderMinutePK primary key (OrderMinuteSK)	
 )

 --Load DimSecond
 INSERT into DimOrderSecond
 SELECT  DATEPART(SECOND, time) as Second FROM [dbo].[Food_Orders]
 --Create DimSecond
 Drop table DimSecond
 Create Table DimOrderSecond
 (
	OrderSecondSK int identity(1,1),
	OrderSecondID as OrderSecondSK + 0,
	OrderSecond int,
	Constraint DimOrderSecondPK primary key (OrderSecondSK)
 )
 SELECT * FROM DimOrderSecond



 --Load MilliSecond
/* INSERT into DimMilliSecond
 SELECT  DATEPART(MILLISECOND, time) as MilliSecond FROM [dbo].[Food_Orders]

 --Create MilliSecond

  Create Table DimMilliSecond
 (
	MilliSecondSK int identity(1,1),
	MilliSecondID as MilliSecondSK + 0,
	MilliSecond int
	Constraint DimMilliSecondPK primary key (MilliSecondSK)
 
 )
 SELECT * FROM DimMilliSecond*/



 SELECT * FROM [dbo].[Food_Orders]
 SELECT * FROM DimOrderHour
 SELECT * FROM DimOrderMinute
 SELECT * FROM DimOrderSecond
 --SELECT * FROM DimMilliSecond

 

 SELECT * FROM Bookings 
 SELECT *FROM Requests
 SELECT *FROM Food_Orders
 SELECT *FROM [DimRoomNumber]
 SELECT * FROM DimClient


-- Create Fact_BookingRequest
INSERT INTO Fact_BookingRequest
SELECT r.request_id
      ,c.ClientSK
      ,rm.RoomSK
     -- ,rt.RequestTypeSK
	  ,rn.RoomNumberSK
      ,d.datekey StartDateSK
      ,dd.datekey as EndDateSK
      ,adults as TotalAdults
      ,children as TotalChildren
FROM Requests r
 JOIN [dbo].[DimClient] c on c.ClientName = r.client_name
 JOIN [dbo].[DimRoom] rm on rm.RoomType = r.room_type
 --JOIN [dbo].[DimRequestType] rt on rt.RequestType = r.request_type
 JOIN [dbo].[DimDate] d on d.CalendarDate = r.start_date
 JOIN [dbo].[DimDate] dd on dd.CalendarDate = r.end_date
 JOIN [dbo].[Bookings] b on b.request_id = r.request_id
 JOIN [dbo].[DimRoomNumber] rn on rn.RoomNumber = b.room

Create table Fact_BookingRequest
(
	BookingRequestSK int identity(1,1),
	RequestID int,
	ClientSK int,
	RequestTypeSK int,
	RoomNumberSK int,
	RoomSK int,
	StartDateSK int,
	EndDateSK int,
	TotalAdults int,
	TotalChildren int
	Constraint Fact_BookinRequestPK primary key (BookingRequestSK),
	Constraint Fact_BookingRequest_ClientSK foreign key(ClientSK) references DimClient(ClientSK),
	--Constraint Fact_BookingRequest_RequestTypeSK foreign key(RequestTypeSK) references DimRequestType(RequestTypeSK),
	Constraint Fact_BookingRequest_RoomNumberSK foreign key(RoomNumberSK) references  DimRoomNumber(RoomNumberSK),
	Constraint Fact_BookingRequest_RoomSK foreign key(RoomSK) references  DimRoom(RoomSK),
	COnstraint Fact_BookingRequest_StartDateSK foreign key(StartDateSK) references DimDate(datekey), 
	Constraint Fact_BookingRequest_EndDateSK foreign key(EndDateSK) references  DimDate(datekey)
)
SELECT * FROM Fact_BookingRequest



--Load Fact_FoodOrders
SELECT  
	   rn.RoomNumberSK as Dest_RoomSK 
      ,rb.RoomNumberSK as Bill_RoomSK
      ,[date] as OrderDateSK
      ,[time] as OrderTimeSK
      ,orders
      ,m.MenuSK
FROM Food_Orders f
LEFT JOIN DimMenu m on m.MenuID = f.menu_id
LEFT JOIN DimRoomNumber rn on rn.RoomNumberSK = f.dest_room
LEFT JOIN DimRoomNumber rb on rb.RoomNumberSK = f.bill_room
LEFT JOIN DimDate d on d.CalendarDate =f.date
/*LEFT JOIN DimOrderTime t on t.OrderTime
LEFT JOIN DimOrderHour h on h.OrderHourSK =  
--LEFT JOIN DimOrderMinute dm on dm.OrderMinuteSK = f.time
--LEFT JOIN DimOrderSecond s on s.OrderSecondSK =f.time*/

SELECT *FROM [dbo].[Food_Orders]
--Create Fact_FoodOrders
Create Table Fact_FoodOrders
(
		FoodOrderSK int identity(1,1),
		Dest_RoomSK int,
		Bill_RoomSK int,
		OrderDateSK int,
		OrderTimeSK int,
		OrderHourSK int,
		OrderMinuteSK int,
		OrderSecondSK int,
		OrderSK int,
		MenuSK int
		Constraint Fact_FoodOrdersPK primary key (FoodOrderSK)
		Constraint Fact_FoodOrders_Dest_RoomSK foreign key (Dest_RoomSK) references DimRoomNumber(RoomNumberSK),
		Constraint Fact_FoodOrders_Bill_RoomSK foreign key (Bill_RoomSK) references DimRoomNumber(RoomNumberSK),
		Constraint Fact_FoodOrders_OrderDateSK foreign key (OrderDateSK) references [dbo].[DimDate]([datekey]),
		--Constraint Fact_FoodOrders_OrderHourSK foreign key (OrderHourSK) references 
		--Constraint Fact_FoodOrders_OrderMinuteSK foreign key (OrderMinuteSK) references 
		--Constraint Fact_FoodOrders_OrderSecondSK foreign key (OrderSecondSK) references 
		 Constraint Fact_FoodOrders_MenuSK foreign key (MenuSK) references  [dbo].[DimMenu](MenuSK)





)