 		-- Join the following SQL with "yearQuarter"
		
		-- Variable (vFirstQuarterStartMonth) - Is the first quarter start month (integer)

SELECT DISTINCT "yearQuarter"
		,"rollingQuarterNo"
	FROM (
		SELECT DISTINCT "yearQuarter" AS "yearQuarter"
			,(
				(
					DENSE_RANK() OVER (
						ORDER BY "yearQuarter" DESC
						)
					) -1
				) * - 1 AS "rollingQuarterNo"
		FROM "SYSTEM"."home.calendar.func::calendarUsingCurrentDate" ( ) 
		WHERE quarter("date",1) <= quarter(CURRENT_DATE,1)  -- vFirstQuarterStartMonth
	
		UNION
	
	SELECT DISTINCT "yearQuarter" AS "yearQuarter"
			,(
				DENSE_RANK() OVER (
					ORDER BY "yearQuarter"
					)
				)  AS "rollingQuarterNo"
		FROM "SYSTEM"."home.calendar.func::calendarUsingCurrentDate" ( ) 
		WHERE quarter("date",1) > quarter(CURRENT_DATE,1)-- vFirstQuarterStartMonth
	)
	ORDER BY "rollingQuarterNo" ASC;