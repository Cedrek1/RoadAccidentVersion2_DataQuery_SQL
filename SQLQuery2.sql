


--Checking Current Year Casualties and Previous Year Casualties

--First methode

select SUM(number_of_casualties) AS CY_Casualties
from RD_BI
where YEAR([Accident Date]) = '2022' 

select SUM(number_of_casualties) AS PY_Casualties
from RD_BI
where YEAR([Accident Date]) = '2021'  

-- Checking Total Casualties Just By Using What We Calculate With CY_Casualties and PY_Casualties In The Previous Queries

select  SUM(number_of_casualties)  +
(select SUM(number_of_casualties)  from RD_BI where YEAR([Accident Date]) = '2022') as Total_Accidents
from RD_BI
where YEAR([Accident Date]) = '2021'


--Second Methode Using Temp Table

DROP table if exists #temp_table_year
CREATE TABLE #temp_table_year (
  number_of_casualties NUMERIC,
  accident_year NUMERIC
);

INSERT INTO #temp_table_year (number_of_casualties, accident_year)
SELECT SUM(number_of_casualties), DATEPART(YEAR, [Accident Date]) AS accident_year
FROM RD_BI
Where Road_Surface_Conditions = 'Dry'
GROUP BY DATEPART(YEAR, [Accident Date]);


SELECT *
FROM #temp_table_year;






--Checking Current Year Casualties and Previous Year Casualties With Different Conditions And Filters

--First methode

select SUM(number_of_casualties) AS CY_Casualties
from RD_BI
where YEAR([Accident Date]) = '2022' AND Road_Surface_Conditions = 'Dry'

select SUM(number_of_casualties) AS PY_Casualties
from RD_BI
where YEAR([Accident Date]) = '2021'  AND Road_Surface_Conditions = 'Dry'


--Second Methode Using Temp Table

DROP table if exists #temp_table_year
CREATE TABLE #temp_table_year (
  number_of_casualties NUMERIC,
  accident_year NUMERIC
);

INSERT INTO #temp_table_year (number_of_casualties, accident_year)
SELECT SUM(number_of_casualties), DATEPART(YEAR, [Accident Date]) AS accident_year
FROM RD_BI
Where Road_Surface_Conditions = 'Dry'
GROUP BY DATEPART(YEAR, [Accident Date]);


SELECT *
FROM #temp_table_year;


--Checking Current Year Casualties and Previous Year Casualties 

select Count(distinct Accident_Index) as CY_Accidents
from RD_BI
where YEAR([Accident Date]) = '2022'

select Count(distinct Accident_Index) as PY_Accidents
from RD_BI
where YEAR([Accident Date]) = '2021'

--Checking Total Casualties Just By Using What We Calculate With CY_Accidents and PY_Accidents In The Previous Queries

select  Count(distinct Accident_Index)  +
(select Count(distinct Accident_Index)  from RD_BI where YEAR([Accident Date]) = '2022') as Total_Accidents
from RD_BI
where YEAR([Accident Date]) = '2021'

SELECT *
FROM RD_BI

--Checking Total Casualties BY Severity

--Fatal

select SUM(Number_of_Casualties) AS Total_Fatal_Casualties
from RD_BI
WHERE Accident_Severity = 'Fatal'

--Serious

select SUM(Number_of_Casualties) AS Total_Serious_Casualties
from RD_BI
WHERE Accident_Severity = 'Serious'

--Slight

select SUM(Number_of_Casualties) AS Total_Slight_Casualties
from RD_BI
WHERE Accident_Severity = 'Slight'


--Checking Casualties BY Severity IN CY_Casualties AND PY_Casualties :

--Fatal

select SUM(Number_of_Casualties) AS CY_Casualties
from RD_BI
WHERE Accident_Severity = 'Fatal' AND YEAR([Accident Date]) = '2022'

select SUM(Number_of_Casualties) AS PY_Casualties
from RD_BI
WHERE Accident_Severity = 'Fatal' AND YEAR([Accident Date]) = '2021'

--Serious

select SUM(Number_of_Casualties) AS CY_Casualties
from RD_BI
WHERE Accident_Severity = 'Serious' AND YEAR([Accident Date]) = '2022'

select SUM(Number_of_Casualties) AS PY_Casualties
from RD_BI
WHERE Accident_Severity = 'Serious' AND YEAR([Accident Date]) = '2021'

--Slight

select SUM(Number_of_Casualties) AS CY_Casualties
from RD_BI
WHERE Accident_Severity = 'Slight' AND YEAR([Accident Date]) = '2022'

select SUM(Number_of_Casualties) AS PY_Casualties
from RD_BI
WHERE Accident_Severity = 'Slight' AND YEAR([Accident Date]) = '2021'




--Checking Percentage Of Total Casualties BY Severity :


select round((SUM(Number_of_Casualties)/(select SUM(Number_of_Casualties) from RD_BI))*100,2)

from RD_BI
Where Accident_Severity = 'Fatal'

select round((SUM(Number_of_Casualties)/(select SUM(Number_of_Casualties) from RD_BI))*100,2)

from RD_BI
Where Accident_Severity = 'Serious'


select round((SUM(Number_of_Casualties)/(select SUM(Number_of_Casualties) from RD_BI))*100,2)

from RD_BI
Where Accident_Severity = 'Slight'


--Checking Cy_Casualties VS PY_Casualties Monthly Trend :


select  datename(MONTH,[Accident Date]), SUM(Number_of_Casualties) AS CY_Casualties
from RD_BI
where datename(YEAR,[Accident Date]) = '2022'
group by  datename(MONTH,[Accident Date])


select  datename(MONTH,[Accident Date]), SUM(Number_of_Casualties) AS PY_Casualties
from RD_BI
where datename(YEAR,[Accident Date]) = '2021'
group by  datename(MONTH,[Accident Date])


--Checking Casualties By Road Type In CY_Casualties AND PY_Casualties

select distinct Road_Type,SUM(Number_of_Casualties) OVER(PARTITION BY Road_Type) As CY_Casualties
from RD_BI
where datename(YEAR,[Accident Date]) = '2022'


select distinct Road_Type,SUM(Number_of_Casualties) OVER(PARTITION BY Road_Type) As PY_Casualties
from RD_BI
where datename(YEAR,[Accident Date]) = '2021'


--Checking Percentage Casualties By Urban/Rural In CY_Casualties AND PY_Casualties

--Urban

select distinct Urban_or_Rural_Area,round((SUM(Number_of_Casualties) OVER(PARTITION BY Urban_or_Rural_Area ) /
(select SUM(Number_of_Casualties) from RD_BI Where DATENAME(Year,[Accident Date])= '2022')*100),2) as Percentage_CY_Casualties
from RD_BI
Where DATENAME(Year,[Accident Date])= '2022' AND Urban_or_Rural_Area = 'Urban'




select distinct Urban_or_Rural_Area,round((SUM(Number_of_Casualties) OVER(PARTITION BY Urban_or_Rural_Area ) /
(select SUM(Number_of_Casualties) from RD_BI Where DATENAME(Year,[Accident Date])= '2021')*100),2) as Percentage_PY_Casualties
from RD_BI
Where DATENAME(Year,[Accident Date])= '2021' AND Urban_or_Rural_Area = 'Urban'



--Rural

select distinct Urban_or_Rural_Area,round((SUM(Number_of_Casualties) OVER(PARTITION BY Urban_or_Rural_Area ) /
(select SUM(Number_of_Casualties) from RD_BI Where DATENAME(Year,[Accident Date])= '2022')*100),2) as Percentage_CY_Casualties
from RD_BI
Where DATENAME(Year,[Accident Date])= '2022' AND Urban_or_Rural_Area = 'Rural'




select distinct Urban_or_Rural_Area,round((SUM(Number_of_Casualties) OVER(PARTITION BY Urban_or_Rural_Area ) /
(select SUM(Number_of_Casualties) from RD_BI Where DATENAME(Year,[Accident Date])= '2021')*100),2) as Percentage_PY_Casualties
from RD_BI
Where DATENAME(Year,[Accident Date])= '2021' AND Urban_or_Rural_Area = 'Rural'





--Checking Casualties BY Light_Conditions

SELECT 
    CASE 
        WHEN Light_Conditions IN ('Daylight') THEN 'Day'
        WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
    END AS Light_Group_Conditions,
    ROUND(
        (SUM(Number_of_Casualties) / 
        (SELECT SUM(Number_of_Casualties) 
         FROM RD_BI 
         WHERE DATENAME(YEAR, [Accident Date]) = '2022')
        ) * 100,
        2
    )
	AS CY_Casualties_PCT
FROM RD_BI
WHERE DATENAME(YEAR, [Accident Date]) = '2022'
GROUP BY 
    CASE 
        WHEN Light_Conditions IN ('Daylight') THEN 'Day'
        WHEN Light_Conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
    END
    


