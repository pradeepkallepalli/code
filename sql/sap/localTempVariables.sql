DO

BEGIN 

 	 
DECLARE vCostCenterGroup NVARCHAR(16) = 'office';
DECLARE vCalMonth NVARCHAR(6) :=  '201801';
DECLARE vCurrentClosedMonth NVARCHAR(6);

DECLARE postingPeriodArray VARCHAR(100) ARRAY;
DECLARE postingPeriod VARCHAR(6);
DECLARE i INTEGER := 1;
DECLARE vFirstDaySelectedMonth DATE;

SELECT MAX("calendarMonth") INTO vCurrentClosedMonth
FROM "_SYS_BIC"."hd.bi.db.models.calendar.base/finClosedMonthsLOV"
WHERE "closedMonthIndicator"  = 'Y';

tab = 	
	SELECT DISTINCT "CALMONTH" 
	FROM  "_SYS_BI"."M_TIME_DIMENSION"
	WHERE "CALMONTH" BETWEEN :vCalMonth AND :vCurrentClosedMonth;


postingPeriodArray = ARRAY_AGG(:tab."CALMONTH");

DROP TABLE "#TEMP_TAB";
CREATE LOCAL TEMPORARY TABLE "#TEMP_TAB" (period VARCHAR(6)
										, date DATE
										, rollingMonthNo INTEGER);

FOR i IN 1..CARDINALITY(:postingPeriodArray) DO 
	postingPeriod = :postingPeriodArray[i];
	vFirstDaySelectedMonth = TO_DATE(:postingPeriod ||'01');


		INSERT INTO #TEMP_TAB
		SELECT :postingPeriod AS "period"
			, "DATE_SQL" AS "date"
			,CASE 
				WHEN "DATE_SQL" <= LAST_DAY(:vFirstDaySelectedMonth)
					THEN (
							CASE 
								WHEN "DAY" = '01'
									THEN MONTHS_BETWEEN("DATE_SQL", NEXT_DAY(LAST_DAY(:vFirstDaySelectedMonth))) - 1
								ELSE MONTHS_BETWEEN("DATE_SQL", NEXT_DAY(LAST_DAY(:vFirstDaySelectedMonth)))
								END
							)
				WHEN "DATE_SQL" >= NEXT_DAY(LAST_DAY(:vFirstDaySelectedMonth))
					THEN MONTHS_BETWEEN("DATE_SQL", ADD_MONTHS(NEXT_DAY(LAST_DAY(:vFirstDaySelectedMonth)), - 1))
				ELSE NULL
				END AS "rollingMonthNo"
		FROM  "_SYS_BI"."M_TIME_DIMENSION"
		;

END FOR;

SELECT DISTINCT A.period, A.rollingMonthNo
FROM "#TEMP_TAB" AS A
WHERE A.period = '201901'
ORDER BY period,A.rollingMonthNo DESC ;



		
END
;
