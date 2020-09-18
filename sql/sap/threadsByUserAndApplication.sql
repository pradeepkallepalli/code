/*

connection_id = -1 : only internal hana threads  and not <> -1 is all external applications
application_name = ['sap.bc.ina.service.v2', 'HDBStudio','sap.hana.im.dp']

*/




SELECT DISTINCT
		CONNECTION_ID
	, COUNT(THREAD_ID)
FROM M_SERVICE_THREADS
WHERE (CONNECTION_ID != -1) AND (APPLICATION_NAME IN ('sap.bc.ina.service.v2', 'HDBStudio','sap.hana.im.dp')) AND (USER_NAME = 'PKALLEPALLI')
GROUP BY CONNECTION_ID