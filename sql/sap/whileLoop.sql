-- To get Consolidated office ID - Loop Office Merged into Field util u find Office Meged into is null


FUNCTION "bi"."hd.bi.db.func::getConsolidatedOfficeID" (IN vOfficeID INTEGER ) 
	RETURNS result INTEGER
	LANGUAGE SQLSCRIPT
	SQL SECURITY INVOKER AS
	
	DECLARE vMergedInto INTEGER;
    DECLARE vConsolidatedOfficeID INTEGER;
	
BEGIN
/***************************** 
	Write your function logic
 *****************************/
    
	-- check the value of office merged into field

    SELECT DISTINCT "officeIDMergedInto" 
    INTO vMergedInto
	FROM "DEMO"."officeInfo"
	WHERE "officeID" = :vOfficeID;
	
	-- if merged into is null
				
    IF (:vMergedInto IS NULL) THEN 
        vConsolidatedOfficeID = :vOfficeID;
    END IF;
    
	-- if merged into is not null
	
    IF (:vMergedInto IS NOT NULL) THEN 
	
	-- find the office id until merged into field is null, by taking the office id every time merged into field is not null

        WHILE vMergedInto IS NOT NULL DO
   
            SELECT DISTINCT "officeID" 
            INTO vConsolidatedOfficeID 
            FROM "DEMO"."officeInfo"
            WHERE "officeID" = :vMergedInto;
   
            SELECT DISTINCT "officeIDMergedInto" 
            INTO vMergedInto 
            FROM "DEMO"."officeInfo"
            WHERE "officeID" = :vConsolidatedOfficeID;
   
        END WHILE;
   
    END IF;


	-- output result
	
	result = :vConsolidatedOfficeID;
 
END;



SELECT DISTINCT "officeID" AS "officeID",
		"bi"."hd.bi.db.func::getConsolidatedOfficeID" ("officeID") AS"consolidateofficeID"
FROM "_SYS_BIC"."hd.bi.db.models.dentrix.master/officeInfo"