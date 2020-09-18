PROCEDURE "bi"."hd.bi.db.proc::spGetOfficeAuthInfo" ( OUT OUT_OFFICES "DEMO".home.heartland::globalTTs.ttOfficeAuth )
   LANGUAGE SQLSCRIPT
   SQL SECURITY DEFINER
   --DEFAULT SCHEMA <default_schema_name>
   READS SQL DATA AS
   
	DECLARE vCountSessionUser INTEGER := 0;
   
   
BEGIN
   /*************************************
       Write your procedure logic 
   *************************************/
   
   -- check if the session user exists inthe mapping table --
   
    SELECT COUNT(DISTINCT "userID") 
    	INTO vCountSessionUser 
    FROM  "DEMO"."userOfficeMapping"
    WHERE "userID" = SESSION_USER;
	
	
    
    -- if session user exists pick all authorized offices, else pick all offices--
    
    IF(:vCountSessionUser > 0) THEN tempOut = 
    	SELECT DISTINCT "officeID" 
    	FROM "bi"."userOfficeMapping" 
    	WHERE "userID" = SESSION_USER;
    END IF;
    
    IF(:vCountSessionUser = 0) THEN tempOut = 
    	SELECT DISTINCT "officeID" 
    	FROM "bi"."userOfficeMapping";
    END IF;
   
   
   -- output the result --
   
   OUT_OFFICES = SELECT DISTINCT "officeID" 
   				  FROM :tempOut
   				  ORDER BY "officeID";
   
END;



call "bi"."hd.bi.db.proc::spGetOfficeAuthInfo" (null);