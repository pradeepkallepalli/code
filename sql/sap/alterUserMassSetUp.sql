DO
BEGIN

	DECLARE userNameArray NVARCHAR(256) ARRAY;
	DECLARE extIdArray NVARCHAR(100) ARRAY;
	DECLARE samlIdProv2 NVARCHAR(256) := 'HEARTLAND_DENTAL_Q_US2_SAPANALYTICS_CLOUD';
	DECLARE userName NVARCHAR(256);
	DECLARE extId NVARCHAR(100);
	DECLARE i INTEGER DEFAULT 1;
	DECLARE x INTEGER DEFAULT 1;

	usersTab = SELECT DISTINCT "USER_NAME" AS userID
			,"EXTERNAL_IDENTITY" AS extId
		FROM "SYS"."SAML_USER_MAPPINGS" 
		WHERE "USER_NAME" IN ('TFISHER', 'GOUTHAMKATARAPU');

	userNameArray = ARRAY_AGG(:usersTab.userID);
	extIdArray = ARRAY_AGG(:usersTab.extId);
	
	FOR i IN 1..CARDINALITY(:userNameArray) DO 
		userName = :userNameArray [i];
		extId = :extIdArray [i];
		EXEC 'ALTER USER ' || :userName || ' ADD IDENTITY ''' || :extId || ''' FOR SAML PROVIDER ' || :samlIdProv2;

	END FOR;

	
	
END;