DO 

BEGIN

DECLARE postingPeriodArray NVARCHAR(100) ARRAY;
DECLARE postingPeriod VARCHAR(6);
DECLARE i INTEGER DEFAULT 1;

tab = SELECT DISTINCT "calMonth" 
		FROM "_SYS_BIC"."hd.bi.db.models.calendar.base/calendarBaseAttributes"
		WHERE "calMonth"  BETWEEN '201801' AND '201912'
		;

postingPeriodArray = ARRAY_AGG(:tab."calMonth");

FOR i IN 1..CARDINALITY(:postingPeriodArray) DO 
	postingPeriod = :postingPeriodArray[i];
	
	call "bi"."hd.bi.db.proc::officeCostCenterCountsByPeriod" (:postingPeriod) ;
	commit;



END FOR;

END;