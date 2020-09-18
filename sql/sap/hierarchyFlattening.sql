-- Pre-Req - Creating Parent Child Hierarchy Model
-- Go To _SYS_BIC schema and see if the Hierarchy is properly generated, as this will be the source for this code.


/******************************************************************************************

** File: "pk.sapOrgHierarchy.func::profitCenterFlatenedHiearachy" 
** Type: Table Function
** Name: Profit Center Level Hierarchy
** Desc: Converts Profit Center's Parent/Child Hierarchy to a Leveled Hierarchy
** Auth: Pradeep V Kallepalli
** Date: 2018-04-24


******************************************************************************************
								** Change History **
******************************************************************************************
** PR   	Date        	Author  				Description 
** --   	--------    	-------   				------------------------------------
** 1    	2018-04-24  	Pradeep V Kallepalli    Base Version
*********************************************************************************************/




FUNCTION "SYSTEM"."pk.sapOrgHiearachy.func::profitCenterFlatHierarchy" ( ) 
	RETURNS TABLE (
		"pcLevel00" NVARCHAR(25)
		,"pcLevel00Desc" NVARCHAR(45)
		,"pcLevel01" NVARCHAR(25)
		,"pcLevel01Desc" NVARCHAR(45)
		,"pcLevel02" NVARCHAR(25)
		,"pcLevel02Desc" NVARCHAR(45)
		,"pcLevel03" NVARCHAR(25)
		,"pcLevel03Desc" NVARCHAR(45)
		,"pcLevel04" NVARCHAR(25)
		,"pcLevel04Desc" NVARCHAR(45)
		,"pcLevel05" NVARCHAR(25)
		,"pcLevel05Desc" NVARCHAR(45)
		,"pcLevel06" NVARCHAR(25)
		,"pcLevel06Desc" NVARCHAR(45)
		,"pcLevel07" NVARCHAR(25)
		,"pcLevel07Desc" NVARCHAR(45)
		,"profitCenter" NVARCHAR(25)
		,"profitCenterDesc" NVARCHAR(45)
	)
	LANGUAGE SQLSCRIPT
	SQL SECURITY INVOKER AS
BEGIN
/***************************** 
	Write your function logic
 *****************************/
 
 L00 =
	SELECT "RESULT_NODE" AS "level00"
		,"childText" AS "level00Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 0
	;
	
 L01 =
 	SELECT "PRED_NODE" AS "level00"
		,"RESULT_NODE" AS "level01"
		,"childText" AS "level01Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 1
	;
 
 L02 = 
 	SELECT "PRED_NODE" AS "level01"
		,"RESULT_NODE" AS "level02"
		,"childText" AS "level02Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 2
	;
	
 L03 = 
 	SELECT "PRED_NODE" AS "level02"
		,"RESULT_NODE" AS "level03"
		,"childText" AS "level03Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 3
	;
	
 L04 = 
 	SELECT "PRED_NODE" AS "level03"
		,"RESULT_NODE" AS "level04"
		,"childText" AS "level04Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 4
	;
	
 L05 = 
 	SELECT "PRED_NODE" AS "level04"
		,"RESULT_NODE" AS "level05"
		,"childText" AS "level05Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 5
	;
	
 L06 =
 	SELECT "PRED_NODE" AS "level05"
		,"RESULT_NODE" AS "level06"
		,"childText" AS "level06Desc"
	FROM "EDW_1"."dw.db.models.md.org.reuse::profitCenterHierarchy/hier/h_profitCenter"
	WHERE "LEVEL" = 6
	;
	
	VAR_OUT = 

	SELECT 	L00."level00" AS "pcLevel00"
		,L00."level00Desc" AS "pcLevel00Desc"
		,L01."level01" AS "pcLevel01"
		,L01."level01Desc" AS "pcLevel01Desc"
		,L02."level02" AS "pcLevel02"
		,L02."level02Desc" AS "pcLevel02Desc"
		,L03."level03" AS "pcLevel03"
		,L03."level03Desc" AS "pcLevel03Desc"
		,L04."level04" AS "pcLevel04"
		,L04."level04Desc" AS "pcLevel04Desc"
		,L05."level05" AS "pcLevel05"
		,L05."level05Desc" AS "pcLevel05Desc"
		,L06."level06" AS "pcLevel06"
		,L06."level06Desc" AS "pcLevel06Desc"
		,COALESCE (L06."level06", L05."level05", L04."level04", L03."level03", L02."level02", L01."level01", L00."level00") AS "profitCenter"
		,COALESCE (L06."level06Desc", L05."level05Desc", L04."level04Desc", L03."level03Desc", L02."level02Desc", L01."level01Desc", L00."level00Desc") AS "profitCenterDesc"
	FROM :L00 AS L00 
		LEFT OUTER JOIN :L01 AS L01 
			ON L00."level00" = L01."level00"
		LEFT OUTER JOIN :L02 AS L02 
			ON L01."level01" = L02."level01"
		LEFT OUTER JOIN :L03 AS L03 
			ON L02."level02" = L03."level02"
		LEFT OUTER JOIN :L04 AS L04 
			ON L03."level03" = L04."level03"
		LEFT OUTER JOIN :L05 AS L05
			ON L04."level04" = L05."level04"
		 LEFT OUTER JOIN :L06 AS L06
			ON L05."level05" = L06."level05"
	;

 	RETURN :VAR_OUT;
END;