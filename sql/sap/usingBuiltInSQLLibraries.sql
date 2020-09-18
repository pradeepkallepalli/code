DO

BEGIN

	-- check out the following SQL built in libraries in HANA 2.0 SPS2 -- SQLSCRIPT_PRINT, SQLSCRIPT_SYNC, SQLSCRIPT_STRING, SQL SCRIPT_LOGGING


	 USING SQLSCRIPT_PRINT AS libPrint;
	 USING SQLSCRIPT_SYNC AS libSync;
	 
	 DECLARE X NVARCHAR(50);
	 
		libPrint:PRINT_LINE('Hello World !!!');
	
		CALL libSync:SLEEP_SECONDS(10);
	
		libPrint:PRINT_LINE('Hello World 2 !!!');


END;