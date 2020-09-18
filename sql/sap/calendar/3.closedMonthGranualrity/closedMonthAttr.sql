DO

BEGIN

	DECLARE vCurrentMonth nVARCHAR(6);
	DECLARE vCurrentQuarter NVARCHAR(5);
	DECLARE vLastClosedMonth NVARCHAR(6);
	DECLARE vCurrentMonthNoInQTR NVARCHAR(1);
	DECLARE vFinCloseDay INTEGER;

	SELECT "value_To"
	INTO vFinCloseDay
	FROM "BI"."config"
	WHERE "group" = 'CALENDAR' AND "parameter" = 'DAY_PRIOR_MTH_CLOSES'
	;
	
	SELECT CASE 
			WHEN DAYOFMONTH(CURRENT_DATE) <= :vFinCloseDay
				THEN TO_VARCHAR(ADD_MONTHS(CURRENT_DATE, - 2), 'YYYYMM')
			WHEN DAYOFMONTH(CURRENT_DATE) > :vFinCloseDay
				THEN TO_VARCHAR(ADD_MONTHS(CURRENT_DATE, - 1), 'YYYYMM')
			END
	INTO vLastClosedMonth
	FROM DUMMY
	;
	
	vCurrentMonth := TO_VARCHAR(CURRENT_DATE, 'YYYYMM');
	vCurrentQuarter := LEFT(QUARTER(TO_DATE(:vLastClosedMonth || '01'),1),4)||RIGHT(QUARTER(TO_DATE(:vLastClosedMonth || '01'),1),1);
	
	IF MOD(TO_INT(LEFT('201908',2)),3) != 0 THEN 
		vCurrentMonthNoInQTR := MOD(TO_INT(LEFT('201908',2)),3); 
	ELSE vCurrentMonthNoInQTR := '3';
	END IF
	;
	
	tab_month_attr = 
	
		SELECT "CALMONTH" AS "calMonth"
			, "MONTH" AS "month"
			, "MONTH_INT" AS "monthINT"
			, "CALQUARTER" AS "calQuarter"
			, "QUARTER" AS "quarter"
			, "QUARTER_INT" AS "quarterINT"
			, "YEAR" AS "year"
			, "YEAR_INT" AS "yearINT"
			, "HALFYEAR" AS "halfYear"
			, "HALFYEAR_INT" AS "halfYearINT"
			, LEFT("CALMONTH", 4) || '/' || RIGHT("CALMONTH", 2) AS "calendarMonth"
			, "YEAR" || '/' || LEFT(MONTHNAME(TO_DATE("CALMONTH" || '01')), 3) AS "calendarMonthDesc"
			, MONTHNAME(TO_DATE("CALMONTH" || '01')) AS "monthName"
			, LAST_DAY(TO_DATE("CALMONTH" || '01')) AS "lastDayOfMonth"
			, CASE 
				WHEN "CALMONTH" <= :vLastClosedMonth
					THEN 'Y'
				ELSE 'N'
			END AS "closedMonthsIndicator"
			, CASE 
				WHEN MOD("MONTH_INT", 3) != 0
					THEN MOD("MONTH_INT", 3)
				ELSE 3
			END AS "monthNoInQuarter"
			, QUARTER(TO_DATE("CALMONTH" || '01')) AS "calendarQuarterDesc"
			, "YEAR" - LEFT(:vCurrentMonth, 4) AS "rollingYear"
			,CASE 
				WHEN "MONTH" <= RIGHT(:vLastClosedMonth, 2)
					THEN 'Y'
				ELSE 'N'
			END AS "ytd"
		FROM "_SYS_BI"."M_TIME_DIMENSION_MONTH"
		WHERE "CALMONTH" != '000000'
		;
	
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
		ORDER BY "calMonth" 
		;
		
	
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
		ORDER BY "calQuarter"
		;
		
		
	var_out = 
	
		SELECT A."calMonth" AS "calMonth"
			, A."month" AS "month"
			, A."monthINT" AS "monthINT"
			, A."calendarMonth" AS "calendarMonth"
			, A."calendarMonthDesc" AS "calendarMonthDesc"
			, A."monthName" AS "monthName"
			, A."lastDayOfMonth" AS "lastDayOfMonth"
			, A."closedMonthsIndicator" AS "closedMonthsIndicator"
			, B."rollingMonthNo" AS "rollingMonthNo"
			, A."calQuarter" AS "calQuarter"
			, A."quarter" AS "quarter"
			, A."quarterINT" AS "quarterINT"
			, A."calendarQuarterDesc" AS "calendarQuarterDesc"
			, A."monthNoInQuarter" AS "monthNoInQuarter"
			, C."rollingQuarterNo" AS "rollingQuarterNo"
			, CASE
				WHEN  A."monthNoInQuarter" <= :vCurrentMonthNoInQTR 
					THEN 'Y'
				ELSE 'N'
			END AS "qtd"
			, A."year" AS "year"
			, A."yearINT" AS "yearINT" 
			, A."halfYear" AS "halfYear"
			, A."halfYearINT" AS "halfYearINT"
			, A."rollingYear" AS "rollingYear"
			, A."ytd" AS "ytd"
		FROM :tab_month_attr AS A 
			INNER JOIN :tab_rolling_month AS B
			ON A."calMonth" = B."calMonth"
			INNER JOIN :tab_rolling_qtr AS C
				ON A."calQuarter" = C."calQuarter"
		ORDER BY "calMonth"
		;
					
END;