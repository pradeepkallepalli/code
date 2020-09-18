FUNCTION "dw.db.models.calendar.func::getRollingWeekdays" ()
RETURNS TABLE (
		"date" DATE
		,"dayName" NVARCHAR(10)
		,"calendarMonth" NVARCHAR(7)
		,"year" NVARCHAR(4)
		,"rollingMonday" INT
		,"rollingTuesday" INT
		,"rollingWednesday" INT
		,"rollingThursday" INT
		,"rollingFriday" INT
		,"rollingSaturday" INT
		,"rollingSunday" INT
		) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS

BEGIN
	/*****************************
        Write your function logic
    ****************************/
	VAR_ROLL_MONDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingMonday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'MONDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingMonday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'MONDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_TUESDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingTuesday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'TUESDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingTuesday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'TUESDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_WEDNESDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingWednesday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'WEDNESDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingWednesday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'WEDNESDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_THURSDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingThursday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'THURSDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingThursday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'THURSDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_FRIDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingFriday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'FRIDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingFriday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'FRIDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_SATURDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingSaturday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'SATURDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingSaturday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'SATURDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_ROLL_SUNDAY =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,(
			DENSE_RANK() OVER (
				ORDER BY "date" DESC
				) - 1
			) * - 1 AS "rollingSunday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'SUNDAY'
		AND "date" <= "dw.db.func::getCurrentDate" ().RESULT
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,DENSE_RANK() OVER (
			ORDER BY "date" ASC
			) AS "rollingSunday"
	FROM "dw.db.models.calendar.func::getTimeAttributes" ()
	WHERE "dayName" = 'SUNDAY'
		AND "date" > "dw.db.func::getCurrentDate" ().RESULT;

	VAR_OUT_UNION =

	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,"rollingMonday"
		,NULL AS "rollingTuesday"
		,NULL AS "rollingWednesday"
		,NULL AS "rollingThursday"
		,NULL AS "rollingFriday"
		,NULL AS "rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_MONDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,"rollingTuesday"
		,NULL AS "rollingWednesday"
		,NULL AS "rollingThursday"
		,NULL AS "rollingFriday"
		,NULL AS "rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_TUESDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,NULL AS "rollingTuesday"
		,"rollingWednesday"
		,NULL AS "rollingThursday"
		,NULL AS "rollingFriday"
		,NULL AS "rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_WEDNESDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,NULL AS "rollingTuesday"
		,NULL AS "rollingWednesday"
		,"rollingThursday"
		,NULL AS "rollingFriday"
		,NULL AS "rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_THURSDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,NULL AS "rollingTuesday"
		,NULL AS "rollingWednesday"
		,NULL AS "rollingThursday"
		,"rollingFriday"
		,NULL AS "rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_FRIDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,NULL AS "rollingTuesday"
		,NULL AS "rollingWednesday"
		,NULL AS "rollingThursday"
		,NULL AS "rollingFriday"
		,"rollingSaturday"
		,NULL AS "rollingSunday"
	FROM :VAR_ROLL_SATURDAY
	
	UNION ALL
	
	SELECT "date"
		,"dayName"
		,"calendarMonth"
		,"year"
		,NULL AS "rollingMonday"
		,NULL AS "rollingTuesday"
		,NULL AS "rollingWednesday"
		,NULL AS "rollingThursday"
		,NULL AS "rollingFriday"
		,NULL AS "rollingSaturday"
		,"rollingSunday"
	FROM :VAR_ROLL_SUNDAY;
	
	VAR_OUT =
	
	SELECT "date"		
		,"dayName"
		,"calendarMonth"
		,"year"
		,"rollingMonday"
		,"rollingTuesday"
		,"rollingWednesday"
		,"rollingThursday"
		,"rollingFriday"
		,"rollingSaturday"
		,"rollingSunday"
	FROM :VAR_OUT_UNION
	ORDER BY "date";

	RETURN :VAR_OUT;
END;