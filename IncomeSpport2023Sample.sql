use [SK Income Support]
SELECT * FROM [dbo].[202009_v1]
SELECT * FROM [dbo].[202009_v2]
SELECT * FROM [dbo].[202108]
SELECT * FROM [dbo].[202109]

create view  vwSaskatoondata as 

WITH CTE AS
	(
	SELECT  v1.Casenum
			,v1.Month
			,Program
			,Casetype 
			,Town
			,Benefit
			,'Sep-2020' as Source
	FROM [dbo].[202009_v1] v1
	INNER JOIN [dbo].[202009_v2] v2 on v2.Casenum = v1.Casenum

	UNION

	SELECT  
			 Casenum
			,Month
			,Program
			,Casetype
			,Town
			,Benefit
			,'Aug-2021' as Source
	FROM [dbo].[202108]

	UNION

	SELECT  
			Casenum
			,Month
			,Program
			,Casetype
			,Town
			, [Benefit]
			,'Sep-2021' as Source
	FROM [dbo].[202109]
	)

	SELECT 
			Casenum
			,Month
			,Program
			,Casetype =  Case 
							WHEN Casetype =  1 THEN 'Singles'
							WHEN Casetype =  2 THEN 'Couples'
							ELSE 'Families'
							END
			,Town
			,Benefit
			,CASE 
				WHEN   Town = 'REGINA' OR Town = 'SASKATOON' THEN 'REGINA/SASKATOON'
				ELSE   'Rest of the province'
				END as 'Geographical Location'
			,Source

	FROM CTE 


/*•	the total benefit and average benefit amount by program for each of the three periods.  
•	the total benefit and average benefit amount by program and household composition for each of the three periods.  
•	the total benefit and average benefit amount by program and geographical location for each of the three periods. 
*/

SELECT *
FROM vwSaskatoondata



SELECT FORMAT(SUM(Benefit),'C') [Total Benefit], FORMAT(AVG(Benefit),'C') [Average Benefit], Program,Source
FROM vwSaskatoondata
GROUP BY Program, Source
ORDER BY Source


SELECT FORMAT(SUM(Benefit),'C') [Total Benefit], FORMAT(AVG(Benefit),'C') [Average Benefit], Program,Casetype,Source
FROM vwSaskatoondata
GROUP BY Program,Casetype,Source
ORDER BY Source


SELECT FORMAT(SUM(Benefit),'C') [Total Benefit], FORMAT(AVG(Benefit),'C') [Average Benefit], Program,[Geographical Location],Source
FROM vwSaskatoondata
GROUP BY Program,[Geographical Location],Source
--ORDER BY Source

--SELECT FORMAT(123.456, 'N2')
--SELECT CAST('2021-09-15' AS DATE)

