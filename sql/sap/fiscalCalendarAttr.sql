DO

BEGIN

DECLARE vCurrentDate DATE;
DECLARE vCurrentFiscalDate NVARCHAR(8);
DECLARE vCurrentFiscalPeriod NVARCHAR(3);
DECLARE vCurrentFiscalYear NVARCHAR(4);

vCurrentDate := to_date('2019-08-21');


 SELECT "FISCAL_YEAR"||RIGHT("FISCAL_PERIOD",2)||RIGHT("DATE",2)
 INTO vCurrentFiscalDate
 FROM "_SYS_BI"."M_FISCAL_CALENDAR"
 WHERE "DATE_SQL" = :vCurrentDate;
 
 SELECT "FISCAL_PERIOD"
 INTO vCurrentFiscalPeriod
 FROM "_SYS_BI"."M_FISCAL_CALENDAR"
 WHERE "DATE_SQL" = :vCurrentDate;
 
 SELECT "FISCAL_YEAR"
 INTO vCurrentFiscalYear
 FROM "_SYS_BI"."M_FISCAL_CALENDAR"
 WHERE "DATE_SQL" = :vCurrentDate;
 
 
SELECT "CALENDAR_VARIANT"
		, "DATE"
		, "DATE_SQL"
		, "FISCAL_YEAR"||RIGHT("FISCAL_PERIOD",2)||RIGHT("DATE",2) AS "FISCAL_DATE"
		, "FISCAL_YEAR"	
		, RIGHT("FISCAL_PERIOD",2) AS "FISCAL_PERIOD"
		, "CURRENT_YEAR_ADJUSTMENT"
		, "FISCAL_YEAR" - :vCurrentFiscalYear  AS "rollingFiscalYear"
		, CASE
		WHEN TO_INT(RIGHT(:vCurrentFiscalDate, 4)) >= TO_INT("FISCAL_PERIOD"||RIGHT("DATE",2))
			THEN 'Y'
		ELSE 'N'
		END AS "fiscalYTD"
		, CASE 
		WHEN "FISCAL_PERIOD" <= '003' THEN "FISCAL_YEAR"||'01'
		WHEN "FISCAL_PERIOD" IN ('004','005','006') THEN "FISCAL_YEAR"||'02'
		WHEN "FISCAL_PERIOD" IN ('007','008','009') THEN "FISCAL_YEAR"||'03'
		ELSE "FISCAL_YEAR"||'04'
		END AS "fiscalQuarter"
		, CASE 
		WHEN "FISCAL_PERIOD" <= '003' THEN "FISCAL_YEAR"||'-Q1'
		WHEN "FISCAL_PERIOD" IN ('004','005','006') THEN "FISCAL_YEAR"||'-Q2'
		WHEN "FISCAL_PERIOD" IN ('007','008','009') THEN "FISCAL_YEAR"||'-Q3'
		ELSE "FISCAL_YEAR"||'-Q4'
		END AS "fiscalQuarter"
		FROM "_SYS_BI"."M_FISCAL_CALENDAR"
	
ORDER BY "DATE_SQL"

 ;
 
 
 
 END;
 