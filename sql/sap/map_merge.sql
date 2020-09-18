DO
BEGIN

DECLARE vMonth NVARCHAR(6) = '202001';


DECLARE itab_ccg "bi"."hd.bi.db.ddl::globalTTs.ttcostCenterGroupMonth";


DECLARE id INTEGER ARRAY = ARRAY(1,2,3);
DECLARE ccg NVARCHAR(20) ARRAY = ARRAY('office','reg','corp');

ccg_tab = UNNEST(:id, :ccg) as (id, costCenterGroup);

-- for each month, need to run  it for 3 costcenter groups: office, corp, reg
-- so created a constant array ccg above with office, corp and reg
-- doing outer join with time table
itab_ccg = SELECT DISTINCT A.id  AS "id", A.costCenterGroup AS "costCenterGroup" , B."CALMONTH" AS "calmonth"   
			FROM :ccg_tab A,  "_SYS_BI"."M_TIME_DIMENSION" B 
			WHERE B."CALMONTH" = :vMonth
			ORDER BY "calmonth" DESC ;

-- iterator is the row on which a table_function is repeated
iterator = select "costCenterGroup" as costCenterGroup, "calmonth" as calmonth from :itab_ccg;

-- MAP_MERGE currently only take tabel functionsas the function
tab_gl_bal = MAP_MERGE(:iterator,"PKALLEPALLI"."Demo.Calendar::glbalance_tf"(:iterator.costCenterGroup, :iterator.calmonth));

-- inserting the snapshot into the table
DELETE FROM "SCHMA"."TABLE_NAME" WHERE "postingPeriod" = :vMonth;
INSERT INTO "SCHMA"."TABLE_NAME" SELECT * FROM :tab_gl_bal;



END;
