DO

BEGIN

	tab_workday_indic =

		SELECT "DATE_SQL"
			,"CALMONTH"
			,"YEAR"
			,LEAD("A") OVER (
				ORDER BY "DATE_SQL"
				) AS "workdayIndicator"
		FROM (
			SELECT "DATE_SQL"
				,"CALMONTH"
				,"YEAR"
				,WORKDAYS_BETWEEN('ZI', "DATE_SQL", LAG("DATE_SQL") OVER (
						ORDER BY "DATE_SQL"
						), 'ECC') * - 1 AS "A"
			FROM "_SYS_BI"."M_TIME_DIMENSION"
			);

	
	var_out =

		SELECT DISTINCT
			"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,SUM("workdayIndicator") OVER (
				PARTITION BY "CALMONTH" ORDER BY "CALMONTH"
				) AS "workdayNoInMonth"
			,SUM("workdayIndicator") OVER (
				PARTITION BY "YEAR" ORDER BY "CALMONTH"
				) AS "workdayNoInYear"
		FROM :tab_workday_indic
		;
		
END;