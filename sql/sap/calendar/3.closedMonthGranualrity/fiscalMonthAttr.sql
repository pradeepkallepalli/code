-- fiscal variant is v9 - (oct to sep)
-- rolling month, rolling quarter, mtd, qtd - these attributes get it form calendar attr, by joining on "dateSQL"

DO

BEGIN
	DECLARE vCurrentMonth NVARCHAR(6);
	DECLARE vLastClosedMonth NVARCHAR(6);
	DECLARE vLastClosedFiscalYear NVARCHAR(4);
	DECLARE vLastClosedFiscalPeriod NVARCHAR(3);
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

	SELECT DISTINCT "FISCAL_YEAR"
	INTO vLastClosedFiscalYear
	FROM "_SYS_BI"."M_FISCAL_CALENDAR"
	WHERE TO_VARCHAR("DATE_SQL", 'YYYYMM') = :vLastClosedMonth;
	
	SELECT DISTINCT "FISCAL_PERIOD"
	INTO vLastClosedFiscalPeriod
	FROM "_SYS_BI"."M_FISCAL_CALENDAR"
	WHERE TO_VARCHAR("DATE_SQL", 'YYYYMM') = :vLastClosedMonth;
	


   -- var_out = 

        SELECT DISTINCT "CALENDAR_VARIANT" AS"fiscalVariant"
        , TO_VARCHAR("DATE_SQL", 'YYYYMM') AS "calMonth"
		,"FISCAL_YEAR" AS "fiscalYear"
		,RIGHT("FISCAL_PERIOD", 2) AS "fiscalPeriod"
		,"FISCAL_YEAR"||RIGHT("FISCAL_PERIOD", 2) AS "fiscalMonth"
		,"CURRENT_YEAR_ADJUSTMENT" AS "fiscalYearAdjustment"
		,"FISCAL_YEAR" - :vLastClosedFiscalYear AS "rollingFiscalYear"
		,CASE 
			WHEN TO_INT(:vLastClosedFiscalPeriod) >= TO_INT("FISCAL_PERIOD")
				THEN 'Y'
			ELSE 'N'
			END AS "fiscalYTD"
		,CASE 
			WHEN "FISCAL_PERIOD" <= '003'
				THEN "FISCAL_YEAR" || '01'
			WHEN "FISCAL_PERIOD" IN (
					'004'
					,'005'
					,'006'
					)
				THEN "FISCAL_YEAR" || '02'
			WHEN "FISCAL_PERIOD" IN (
					'007'
					,'008'
					,'009'
					)
				THEN "FISCAL_YEAR" || '03'
			ELSE "FISCAL_YEAR" || '04'
			END AS "fiscalQuarter"
		,CASE 
			WHEN "FISCAL_PERIOD" <= '003'
				THEN "FISCAL_YEAR" || '-Q1'
			WHEN "FISCAL_PERIOD" IN (
					'004'
					,'005'
					,'006'
					)
				THEN "FISCAL_YEAR" || '-Q2'
			WHEN "FISCAL_PERIOD" IN (
					'007'
					,'008'
					,'009'
					)
				THEN "FISCAL_YEAR" || '-Q3'
			ELSE "FISCAL_YEAR" || '-Q4'
			END AS "fiscalQuarterDesc"
	FROM "_SYS_BI"."M_FISCAL_CALENDAR"
	ORDER BY "fiscalMonth";


END;