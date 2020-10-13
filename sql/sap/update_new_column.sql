DO

BEGIN

DECLARE postingPeriodArray NVARCHAR(100) ARRAY;
DECLARE postingPeriod VARCHAR(6);
DECLARE i INTEGER DEFAULT 1;

tab = SELECT DISTINCT "calMonth"
		FROM "_SYS_BIC"."hd.bi.db.models.calendar.base/calendarBaseAttributes"
		WHERE "calMonth"  BETWEEN '201801' AND '202009'
		;

postingPeriodArray = ARRAY_AGG(:tab."calMonth");

FOR i IN 1..CARDINALITY(:postingPeriodArray) DO

	postingPeriod = :postingPeriodArray[i];

	cost_center_view_attr =

		SELECT :postingPeriod AS "postingPeriod", *
	 	FROM "_SYS_BIC"."hd.bi.db.models.epicor.master/costCenter"(PLACEHOLDER."$$ipSelectedClosedMonth$$" => :postingPeriod)
	 	WHERE "costCenterGroup" = 'office' AND ("costCenter" != '0') AND ("costCenter" IS NOT NULL);

 -- Update the new column in the table from the view,
 -- only if it is  NULL for the selected posting period

 	UPDATE "bi"."hd.bi.db.ddl::tables.officeCostCenterCountsByPostingPeriod" A
	SET A."denovoCode" = B."denovoCode"
	FROM "bi"."hd.bi.db.ddl::tables.officeCostCenterCountsByPostingPeriod" A  INNER JOIN :cost_center_view_attr B
	ON  A."costCenter" = B."costCenter"
	WHERE A."postingPeriod" = :postingPeriod AND A."denovoCode" IS NULL
	;



END FOR;


END;