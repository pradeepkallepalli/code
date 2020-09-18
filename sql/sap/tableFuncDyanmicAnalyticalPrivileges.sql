-- Using Table Function Allows You to Join Table Function to KPI/Reporting View which has OfficeID



FUNCTION "dw.db.models.calendar.func::tableFuncForDyanmicAnalyticalPrivileges" ()
RETURNS TABLE (
		"officeID" INTEGER
		,"userID" NVARCHAR(10)
		,"countOfficeID" INTEGER
		) LANGUAGE SQLSCRIPT SQL SECURITY INVOKER AS


/********* Begin Procedure Script ************/ 

BEGIN 

    DECLARE vCountSessionUser INTEGER;


   SELECT COUNT(DISTINCT "userID") 
    	INTO vCountSessionUser 
    FROM  "DEMO"."userOfficeMapping" 
    WHERE "userID" = SESSION_USER;

    
    IF(:vCountSessionUser > 0) THEN tempOut = 

									SELECT DISTINCT "officeID"
										,"userID"
									FROM  "DEMO"."userOfficeMapping"
									WHERE "userID" = SESSION_USER
									;

    END IF;
    
    IF(:vCountSessionUser = 0) THEN tempOut = 
							
									SELECT DISTINCT "officeID"
										,SESSION_USER AS "userID"
									FROM  "DEMO"."userOfficeMapping"
									;
    END IF;

   
   var_out = SELECT "officeID"
					,"userID" 
					,count( "officeID") AS "countOffice"
				FROM :tempOut
				GROUP BY "officeID"
					,"userID"
					;

END /********* End Procedure Script ************/

