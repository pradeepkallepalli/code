DO

BEGIN

	DECLARE vCurrentDATE DATE;
	vCurrentDate := CURRENT_DATE;

	tab_roll_monday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingMonday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'MONDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingMonday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'MONDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_tuesday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingTuesday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'TUESDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingTuesday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'TUESDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_wednesday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingWednesday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'WEDNESDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingWednesday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'WEDNESDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_thursday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingThursday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'THURSDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingThursday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'THURSDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_friday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingFriday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'FRIDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingFriday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'FRIDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_saturday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingSaturday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'SATURDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingSaturday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'SATURDAY'
			AND "DATE_SQL" > :vCurrentDate;

	tab_roll_sunday =

		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,(
				DENSE_RANK() OVER (
					ORDER BY "DATE_SQL" DESC
					) - 1
				) * - 1 AS "rollingSunday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'SUNDAY'
			AND "DATE_SQL" <= :vCurrentDate
		
		UNION ALL
		
		SELECT "DATE_SQL" AS "dateSQL"
			,DAYNAME("DATE_SQL") AS "dayName"
			,"CALMONTH" AS "calMonth"
			,"YEAR" AS "year"
			,DENSE_RANK() OVER (
				ORDER BY "DATE_SQL" ASC
				) AS "rollingSunday"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE DAYNAME("DATE_SQL") = 'SUNDAY'
			AND "DATE_SQL" > :vCurrentDate;

	var_out_union =

		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,"rollingMonday"
			,NULL AS "rollingTuesday"
			,NULL AS "rollingWednesday"
			,NULL AS "rollingThursday"
			,NULL AS "rollingFriday"
			,NULL AS "rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_monday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,"rollingTuesday"
			,NULL AS "rollingWednesday"
			,NULL AS "rollingThursday"
			,NULL AS "rollingFriday"
			,NULL AS "rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_tuesday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,NULL AS "rollingTuesday"
			,"rollingWednesday"
			,NULL AS "rollingThursday"
			,NULL AS "rollingFriday"
			,NULL AS "rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_wednesday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,NULL AS "rollingTuesday"
			,NULL AS "rollingWednesday"
			,"rollingThursday"
			,NULL AS "rollingFriday"
			,NULL AS "rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_thursday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,NULL AS "rollingTuesday"
			,NULL AS "rollingWednesday"
			,NULL AS "rollingThursday"
			,"rollingFriday"
			,NULL AS "rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_friday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,NULL AS "rollingTuesday"
			,NULL AS "rollingWednesday"
			,NULL AS "rollingThursday"
			,NULL AS "rollingFriday"
			,"rollingSaturday"
			,NULL AS "rollingSunday"
		FROM :tab_roll_saturday
		
		UNION ALL
		
		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,NULL AS "rollingMonday"
			,NULL AS "rollingTuesday"
			,NULL AS "rollingWednesday"
			,NULL AS "rollingThursday"
			,NULL AS "rollingFriday"
			,NULL AS "rollingSaturday"
			,"rollingSunday"
		FROM :tab_roll_sunday;

	var_out =

		SELECT "dateSQL"
			,"dayName"
			,"calMonth"
			,"year"
			,"rollingMonday"
			,"rollingTuesday"
			,"rollingWednesday"
			,"rollingThursday"
			,"rollingFriday"
			,"rollingSaturday"
			,"rollingSunday"
		FROM :var_out_union
		ORDER BY "dateSQL";
		
		
END;