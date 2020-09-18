select "date"
	, WORKDAYS_BETWEEN('ZI','2019-04-01',"date",'ECC')+1
from "SYSTEM"."home.calendar.func::calendarUsingCurrentDate" ( ) 
WHERE "year" = '2019' AND "month" = '04'
ORDER BY "date"
;

"SYSTEM"."home.calendar.func::getWorkDayNoInMonth" ("date") 


select * from "SYSTEM"."home.calendar.func::calendarUsingLastDayOfPriorClosedMonth" ( ) 
WHERE "year" IN ('2018','2019');

-------------------------------------------------------------------------------------------------
SELECT "date"
,dayname("date")
,"workdayBase"
,LEAD("workdayBase") OVER ( ORDER BY "date")

FROM(

select "date"
	, "SYSTEM"."home.calendar.func::getWorkDayNoInMonth" ("date")  AS "workdayBase"

from "SYSTEM"."home.calendar.func::calendarUsingCurrentDate" ( ) 
WHERE "year" = '2019'
ORDER BY "date")
;


