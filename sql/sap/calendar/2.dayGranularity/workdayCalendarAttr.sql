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

	SELECT "dateSQL"
		,"workdayNoInMonth"
		,MAX("workdayNoInMonth") OVER (PARTITION BY "calMonth") AS "totalWorkingDaysInMonth"
		,"workdayNoInYear"
		,MAX("workdayNoInYear") OVER (PARTITION BY "year") AS "totalWorkingDaysInYear"
	FROM (
		SELECT "DATE_SQL" AS "dateSQL"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,"workdayIndicator"
			,SUM("workdayIndicator") OVER (
				PARTITION BY "CALMONTH" ORDER BY "DATE_SQL"
				) AS "workdayNoInMonth"
			,SUM("workdayIndicator") OVER (
				PARTITION BY "YEAR" ORDER BY "DATE_SQL"
				) AS "workdayNoInYear"
		FROM :tab_workday_indic

		);
END;