FUNCTION "dw.db.models.calendar.func::getTimeAttributes"( )
       RETURNS TABLE (
       	 "date" Date
       	 ,"sapDate" NVARCHAR(8)
       	 ,"dayOfMonth" NVARCHAR(2)
       	 ,"dayOfMonthInt" TINYINT
       	 ,"reverseDayOfMonth" NVARCHAR(2)
		 ,"dayName" NVARCHAR(10)
		 ,"dayOfWeek" NVARCHAR(1)
		 ,"dayOfWeekInt" TINYINT
		 ,"dayOfYear" SMALLINT
		 ,"lastDayOfMonthIndic" NVARCHAR(1)
		 ,"rollingDayNo" INTEGER
		 ,"dayIndicInt" INTEGER
		 ,"week" NVARCHAR(2)
		 ,"weekInt" TINYINT
		 ,"calWeek" NVARCHAR(6)
		 ,"yearOfWeek" NVARCHAR(4)
		 ,"yearOfWeekInt" INTEGER
		 ,"month" NVARCHAR(2)
		 ,"monthInt" TINYINT
		 ,"calMonth" NVARCHAR(6)
		 ,"calendarMonth" NVARCHAR(7)
		 ,"calendarMonthDesc" NVARCHAR(10)
		 ,"monthName" NVARCHAR(10)
		 ,"rollingMonthNo" INTEGER
		 ,"mtd" NVARCHAR(1)
		 ,"quarter" NVARCHAR(2)
		 ,"quarterInt" TINYINT
		 ,"calQuarter" NVARCHAR(5)
		 ,"yearQuarter" NVARCHAR(7)
		 ,"monthNoInQuarter" TINYINT
		 ,"dayNoInQuarter" TINYINT
		 ,"qtd" NVARCHAR(1)
		 ,"year" NVARCHAR(4)
		 ,"yearInt" INTEGER
		 ,"rollingYearNo" INTEGER
		 ,"ytd" NVARCHAR(1)
       )
       LANGUAGE SQLSCRIPT 
       SQL SECURITY INVOKER AS 
BEGIN 
    /*****************************
        Write your function logic
    ****************************/
   VAR_OUT = 
			    SELECT "DATE_SQL" AS "date"
			    	, "DATE_SAP" AS "sapDate"
			    	, "DAY" AS "dayOfMonth"
			    	, "DAY_INT" AS "dayOfMonthInt"
			    	, rank() OVER (partition by "CALMONTH" order by "DAY" DESC) AS "reverseDayOfMonth"
			    	, DAYNAME("DATE_SQL") AS "dayName"
			    	,"DAY_OF_WEEK" AS "dayOfWeek"
			    	,"DAY_OF_WEEK_INT" AS "dayOfWeekInt"
			    	, DAYOFYEAR("DATE_SQL") AS "dayOfYear"
			    	, CASE
		    			WHEN "MONTH_LAST_DAY" = 0
		        			THEN 'Y'
		    			ELSE 'N'
					END AS "lastDayOfMonthIndic"
					, DAYS_BETWEEN ("dw.db.func::getCurrentDate"().RESULT,"DATE_SQL") AS "rollingDayNo"
					, 1 AS "dayIndicInt"
					, "WEEK" AS "week"
					, "WEEK_INT" AS "weekInt"
					, "CALWEEK" AS "calWeek"
					, "WEEK_YEAR" AS "yearOfWeek"
					, "WEEK_YEAR_INT" AS "yearOfWeekInt"
        			, "MONTH" AS "month"
					, "MONTH_INT" AS "monthInt"
					, "CALMONTH" AS "calMonth"
					, LEFT("CALMONTH", 4) || '/' || RIGHT("CALMONTH", 2) AS "calendarMonth"
					, "YEAR" || '/' || LEFT(MONTHNAME("DATE_SQL"), 3) AS "calendarMonthDesc"
					, MONTHNAME("DATE_SQL") AS "monthName"
					,CASE
						WHEN "DATE_SQL" <= LAST_DAY("dw.db.func::getCurrentDate"().RESULT)
						THEN (
							CASE
							WHEN "DAY" = '01'
								THEN MONTHS_BETWEEN(NEXT_DAY(LAST_DAY("dw.db.func::getCurrentDate"().RESULT)), "DATE_SQL") + 1
							ELSE MONTHS_BETWEEN(NEXT_DAY(LAST_DAY("dw.db.func::getCurrentDate"().RESULT)), "DATE_SQL")
							END
						)
						WHEN "DATE_SQL" >= NEXT_DAY(LAST_DAY("dw.db.func::getCurrentDate"().RESULT))
						THEN MONTHS_BETWEEN(ADD_MONTHS(NEXT_DAY(LAST_DAY("dw.db.func::getCurrentDate"().RESULT)), - 1), "DATE_SQL")
						ELSE NULL
					END AS "rollingMonthNo"
					,CASE
						WHEN DAYOFMONTH("dw.db.func::getCurrentDate"().RESULT) >= "DAY"
						THEN 'Y'
						ELSE 'N'
						END AS "mtd"
					,"QUARTER" AS "quarter" 
					,"QUARTER_INT" AS "quarterInt" 
					,"CALQUARTER" AS "calQuarter"
					,QUARTER("DATE_SQL") AS "yearQuarter"
					,CASE
						WHEN MOD("MONTH_INT",3)!= 0 THEN MOD("MONTH_INT",3)
						ELSE 3
					END  AS "monthNoInQuarter"
					,SUM(1) OVER (PARTITION BY "CALQUARTER" ORDER BY "DATE_SAP") AS "dayNoInQuarter"
					,CASE
						WHEN ( CASE WHEN MOD(MONTH("dw.db.func::getCurrentDate"().RESULT),3)!= 0 THEN MOD(MONTH("dw.db.func::getCurrentDate"().RESULT),3) ELSE 3 END || LPAD(DAYOFMONTH("dw.db.func::getCurrentDate"().RESULT),2,'0')  ) >= (CASE WHEN MOD("MONTH_INT",3)!= 0 THEN MOD("MONTH_INT",3) ELSE 3 END ||  "DAY" ) 
						THEN 'Y'
						ELSE 'N'
					END AS "qtd"
					,"YEAR" AS "year"
					,"YEAR_INT" AS "yearInt"
					,YEAR("DATE_SQL") - YEAR(CURRENT_DATE) AS "rollingYearNo"
					,CASE
						WHEN TO_INT(SUBSTRING(TO_VARCHAR("dw.db.func::getCurrentDate"().RESULT), 6, 2) || SUBSTRING(TO_VARCHAR("dw.db.func::getCurrentDate"().RESULT), 9, 2)) >= TO_INT(SUBSTRING(TO_VARCHAR("DATE_SQL"), 6, 2) || SUBSTRING(TO_VARCHAR("DATE_SQL"), 9, 2))
						THEN 'Y'
						ELSE 'N'
					END AS "ytd"
			    FROM "dw.db.time_tables::M_TIME_DIMENSION"
			    ;



	RETURN :VAR_OUT;
END;