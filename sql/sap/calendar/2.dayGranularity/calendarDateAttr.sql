DO

BEGIN

	DECLARE vCurrentDate DATE;
	DECLARE vCurrentMonth NVARCHAR(6);
	DECLARE vCurrentQuarter NVARCHAR(5);
	DECLARE vCurrentCalWeek NVARCHAR(6);

	vCurrentDate := CURRENT_DATE;
	vCurrentMonth := TO_VARCHAR(:vCurrentDate,'YYYYMM');
	vCurrentQuarter := LEFT(QUARTER(:vCurrentDate,1),4)||RIGHT(QUARTER(:vCurrentDate,1),1);
	vCurrentCalWeek := YEAR(:vCurrentDate)||WEEK(:vCurrentDate);

	tab_date_attr =
	
		SELECT "DATE_SQL" AS "dateSQL"
			,"DATE_SAP" AS "dateSAP"
			,"YEAR" AS "year"
			,"YEAR_INT" AS "yearINT"
			,"CALQUARTER" AS "calQuarter"
			,"QUARTER" AS "quarter"
			,"QUARTER_INT" AS "quarterINT"
			,"CALMONTH" AS "calMonth"
			,"MONTH" AS "month"
			,"MONTH_INT" AS "monthINT"
			,"CALWEEK" AS "calWeek"
			,"WEEK" AS "week"
			,"WEEK_INT" AS "weekINT"
			,"WEEK_YEAR" AS "weekYear"
			,"WEEK_YEAR_INT" AS "weekYearINT"
			,"DAY_OF_WEEK" AS "dayOfWeek"
			,"DAY_OF_WEEK_INT" AS "dayOfWeekINT"
			,"DAY" AS "day"
			,"DAY_INT" AS "dayINT"
			,"DATETIMESTAMP" AS "dateTimeStampSQL"
			,"DATETIME_SAP" AS "dateTimeStampSAP"
			,"HOUR" AS "hour"
			,"HOUR_INT" AS "hourINT"
			,"MINUTE" AS "minute"
			,"MINUTE_INT" AS "minuteINT"
			,"SECOND" AS "second"
			,"SECOND_INT" AS "secondINT"
			,YEAR("DATE_SQL") - YEAR(:vCurrentDate) AS "rollingYearNo"
			,CASE 
				WHEN TO_INT(SUBSTRING(TO_VARCHAR(:vCurrentDate), 6, 2) || SUBSTRING(TO_VARCHAR(:vCurrentDate), 9, 2)) >= TO_INT(SUBSTRING(TO_VARCHAR("DATE_SQL"), 6, 2) || SUBSTRING(TO_VARCHAR("DATE_SQL"), 9, 2))
					THEN 'Y'
				ELSE 'N'
				END AS "ytd"
			,QUARTER("DATE_SQL") AS  "calendarQuarterDesc"
			,CASE 
				WHEN MOD("MONTH_INT", 3) != 0
					THEN MOD("MONTH_INT", 3)
				ELSE 3
				END AS "monthNoInQuarter"
			,SUM(1) OVER (
				PARTITION BY "CALQUARTER" ORDER BY "DATE_SAP"
				) AS "dayNoInQuarter"
			,CASE 
				WHEN (
						CASE 
							WHEN MOD(MONTH(:vCurrentDate), 3) != 0
								THEN MOD(MONTH(:vCurrentDate), 3)
							ELSE 3
							END || LPAD(DAYOFMONTH(:vCurrentDate), 2, '0')
						) >= (
						CASE 
							WHEN MOD("MONTH_INT", 3) != 0
								THEN MOD("MONTH_INT", 3)
							ELSE 3
							END || "DAY"
						)
					THEN 'Y'
				ELSE 'N'
				END AS "qtd"
			,LEFT("CALMONTH", 4) || '/' || RIGHT("CALMONTH", 2) AS "calendarMonth"
			,"YEAR" || '/' || LEFT(MONTHNAME("DATE_SQL"), 3) AS "calendarMonthDesc"
			,MONTHNAME("DATE_SQL") AS "monthName"
			,CASE 
				WHEN DAYOFMONTH(:vCurrentDate) >= "DAY"
					THEN 'Y'
				ELSE 'N'
				END AS "mtd"
			,1 AS "dayIndicInt"
			,CASE 
				WHEN "MONTH_LAST_DAY" = 1
					THEN 'Y'
				ELSE 'N'
				END AS "monthLastDayIndic"
			,rank() OVER (
				PARTITION BY "CALMONTH" ORDER BY "DAY" DESC
				) AS "reverseDayOfMonth"
			,CASE 
				WHEN "DAY_OF_WEEK_INT" <= WEEKDAY(:vCurrentDate)
					THEN 'Y'
				ELSE 'N'
				END AS "wtd"
			,DAYOFYEAR("DATE_SQL") AS "dayNoInYear"
			,DAYNAME("DATE_SQL") AS "dayName"
			,DAYS_BETWEEN(:vCurrentDate, "DATE_SQL") AS "rollingDayNo"
		--,"TZNTSTMPS"
		--,"TZNTSTMPL"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		ORDER BY "DATE_SQL";
	
	
	tab_rolling_month =
	
		SELECT DISTINCT "calMonth"
			,"rollingMonthNo"
		FROM (
			SELECT DISTINCT "CALMONTH" AS "calMonth"
				,((DENSE_RANK() OVER (ORDER BY "CALMONTH" DESC)) -1) * - 1 AS "rollingMonthNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_MONTH"
			WHERE  "CALMONTH" <= :vCurrentMonth
		
				UNION
		
			SELECT DISTINCT "CALMONTH" AS "calMonth"
					,(DENSE_RANK() OVER (ORDER BY "CALMONTH"))  AS "rollingMonthNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_MONTH"
			WHERE  "CALMONTH" > :vCurrentMonth
			)
		ORDER BY "calMonth" ;
		
	tab_rolling_qtr = 
			
		SELECT DISTINCT "calQuarter"
			,"rollingQuarterNo"
		FROM (
			SELECT DISTINCT "CALQUARTER" AS "calQuarter"
				,((DENSE_RANK() OVER (ORDER BY "CALQUARTER" DESC)) - 1) * - 1 AS "rollingQuarterNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_MONTH"
			WHERE "CALQUARTER" <= :vCurrentQuarter
			
			UNION
			
			SELECT DISTINCT "CALQUARTER" AS "calQuarter"
				,(DENSE_RANK() OVER (ORDER BY "CALQUARTER")) AS "rollingQuarterNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_MONTH"
			WHERE "CALQUARTER" > :vCurrentQuarter
			)
		ORDER BY "calQuarter";

	tab_rolling_week = 

		SELECT DISTINCT "calWeek"
			,"rollingWeekNo"
		FROM (
			SELECT DISTINCT "CALWEEK" AS "calWeek"
				,((DENSE_RANK() OVER (ORDER BY "CALWEEK" DESC)) - 1) * - 1 AS "rollingWeekNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_WEEK"
			WHERE "CALWEEK" <= :vCurrentCalWeek
			
			UNION
			
			SELECT DISTINCT "CALWEEK" AS "calWeek"
				,(DENSE_RANK() OVER (ORDER BY "CALWEEK")) AS "rollingWeekNo"
			FROM "_SYS_BI"."M_TIME_DIMENSION_WEEK"
			WHERE "CALWEEK" > :vCurrentCalWeek
			)
		ORDER BY "calWeek";

	var_out = 

		SELECT A."dateSQL" AS "dateSQL"
			,A."dateSAP" AS "dateSAP"
			,A."year" AS "year"
			,A."yearINT" AS "yearINT"
			,A."calQuarter" AS "calQuarter"
			,A."quarter" AS "quarter"
			,A."quarterINT" AS "quarterINT"
			,A."calMonth" AS "calMonth"
			,A."month" AS "month"
			,A."monthINT" AS "monthINT"
			,A."calWeek" AS "calWeek"
			,A."week" AS "week"
			,A."weekINT" AS "weekINT"
			,A."weekYear" AS "weekYear"
			,A."weekYearINT" AS "weekYearINT"
			,A."dayOfWeek" AS "dayOfWeek"
			,A."dayOfWeekINT" AS "dayOfWeekINT"
			,A."day" AS "day"
			,A."dayINT" AS "dayINT"
			,A."reverseDayOfMonth" AS "reverseDayOfMonth"
			,A."calendarQuarterDesc" AS "calendarQuarterDesc"
			,A."monthNoInQuarter" AS "monthNoInQuarter"
			,A."dayNoInQuarter" AS "dayNoInQuarter"
			,A."calendarMonth" AS "calendarMonth"
			,A."calendarMonthDesc" AS "calendarMonthDesc"
			,A."monthName" AS "monthName"
			,A."dayIndicInt" AS "dayIndicInt"
			,A."monthLastDayIndic" AS "monthLastDayIndic"
			,A."dayNoInYear"
			,A."dayName" AS "dayName"
			,A."rollingDayNo" AS "rollingDayNo"
			,D."rollingWeekNo" AS "rollingWeekNo"
			,A."wtd" AS "wtd"
			,B."rollingMonthNo" AS "rollingMonthNo"
			,A."mtd" AS "mtd"
			,C."rollingQuarterNo" AS "rollingQuarterNo"
			,A."qtd" AS "qtd"
			,A."rollingYearNo" AS "rollingYearNo"
			,A."ytd" AS "ytd"
		FROM :tab_date_attr A
			INNER JOIN :tab_rolling_month B 
				ON A."calMonth" = B."calMonth"
			INNER JOIN :tab_rolling_qtr C 
				ON A."calQuarter" = C."calQuarter"
			INNER JOIN :tab_rolling_week D
				ON A."calWeek" = D."calWeek"
		ORDER BY "dateSQL";
	

END;