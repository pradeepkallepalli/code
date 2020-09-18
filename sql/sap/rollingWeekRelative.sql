 
 /********* Begin Procedure Script ************/ 
 BEGIN 
 
 DECLARE vCurrentCalWeek NVARCHAR(6);
 
SELECT DISTINCT "CALWEEK" 
	INTO  vCurrentCalWeek
 FROM "_SYS_BI"."M_TIME_DIMENSION"
 WHERE "DATE_SQL" = :ip_TodaysDate;
 
 	 var_out = 
 	 
 	SELECT DISTINCT "calWeek"
		,"rollingWeekNo"
	FROM (
		SELECT DISTINCT "CALWEEK" AS "calWeek"
			,((DENSE_RANK() OVER (ORDER BY "CALWEEK" DESC)) -1) * - 1 AS "rollingWeekNo"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE  "CALWEEK" <= :vCurrentCalWeek
	
			UNION
	
		SELECT DISTINCT "CALWEEK" AS "calWeek"
				,(DENSE_RANK() OVER (ORDER BY "CALWEEK"))  AS "rollingWeekNo"
		FROM "_SYS_BI"."M_TIME_DIMENSION"
		WHERE  "CALWEEK" > :vCurrentCalWeek
	)
	ORDER BY "calWeek" ASC;

END /********* End Procedure Script ************/