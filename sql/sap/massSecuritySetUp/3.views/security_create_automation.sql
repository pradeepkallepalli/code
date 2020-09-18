

DO

BEGIN

	DECLARE userNameArray NVARCHAR(256) ARRAY;
	DECLARE userTypeArray NVARCHAR(20) ARRAY;
	DECLARE userGroupArray NVARCHAR(20) ARRAY;
	DECLARE extIdArray NVARCHAR(100) ARRAY;
	DECLARE roleArray NVARCHAR(256) ARRAY;
	
	DECLARE password NVARCHAR(20) := 'Password123';
	DECLARE samlIdProv1 NVARCHAR(256) := 'HTTPS___US3_HANA_ONDEMAND_COM_H6C407DDC';-- PROVIDE THE APPROPRIATE SAML IDENTITY PROVIDER
	DECLARE samlIdProv2 NVARCHAR(256) := 'TEST_HEARTLAND_DENTAL_Q_US2_SAPANALYTICS_CLOUD_';-- PROVIDE THE APPROPRIATE SAML IDENTITY PROVIDER

	DECLARE userName NVARCHAR(256);
	DECLARE userType NVARCHAR(20);
	DECLARE userGroup NVARCHAR(20);
	DECLARE extId NVARCHAR(100);
	DECLARE roleName NVARCHAR(256);
	
	DECLARE i INTEGER DEFAULT 1;
	DECLARE x INTEGER DEFAULT 1;

	-- CREATE USERS--
	-----------------
	-- SELECTS ALL THE USERS FROM A TABLE, WHICH DO NOT EXISTS IN HANA

	usersTab =

		SELECT "user_name" AS userID
			,"user_type" AS userType
			,"user_group" AS userGroup
			,"external_identity" AS extId
		FROM "bi"."hd.bi.db.ddl::securityAssignmentTables.create_user_list"
		WHERE "user_name" NOT IN (
				SELECT "USER_NAME"
				FROM "USERS"
				);

	-- TURNS THE COLUMNS IN VIEW CREATED ABOVE INTO ARRAYS

	userNameArray = ARRAY_AGG(:usersTab.userID);
	userTypeArray = ARRAY_AGG(:usersTab.userType);
	userGroupArray = ARRAY_AGG(:usersTab.userGroup);
	extIdArray = ARRAY_AGG(:usersTab.extId);
	
	-- LOOPS THROUGH EACH POSITION IN USER NAME ARRAY
	
	FOR i IN 1..CARDINALITY(:userNameArray) DO 
		
		userName = :userNameArray [i];
		userType = :userTypeArray [i];
		userGroup = :userGroupArray [i];
		extId = :extIdArray [i];

		-- EXCUTES CREATE STATMENT (USED DYNAMIC SQL), EXECUTES ALTER STATMENT FOR 2nd SAML PTROVIDER AND ASSIGNS BASIC ROLE

		EXEC 'CREATE ' || :userType || ' USER ' || :userName || ' PASSWORD ' || :password || ' WITH IDENTITY ''' || :extId || ''' FOR SAML PROVIDER ' || :samlIdProv1;
		EXEC 'ALTER USER ' || :userName || ' ADD IDENTITY ''' || :extId || ''' FOR SAML PROVIDER ' || :samlIdProv2;
		CALL GRANT_ACTIVATED_ROLE('hd.sec.common::basicRole', :userName);

		-- SELECT ALL THE ROLES THAT NEED TO BE ASSIGNED FOR THE USER BASED ON HIS USER GROUP

		rolesTab =
	
			SELECT "role" AS ROLE
			FROM "bi"."hd.bi.db.ddl::securityAssignmentTables.user_group_role_mapping"
			WHERE "user_group" = :userGroup;

		-- TURNS THE ROLE COLUMN INTO ARRAY

		roleArray = ARRAY_AGG(:rolesTab.ROLE);
	
			-- LOOPS THROUGH EACH POSITION OF ROLE ARRAY AND EXECUTES THE  GRANT ACTIVATED ROLE PROCEDURE, TO ASSIGN THE EACH ROLE IN THE ARRAY
	
			FOR x IN 1..CARDINALITY(:roleArray) DO 
			
				roleName = :roleArray [x];
		
				CALL GRANT_ACTIVATED_ROLE(:roleName, :userName);
			
			END FOR;

	-- ADDING ENTRY IN THE LOG FILE

	UPSERT "bi"."hd.bi.db.ddl::securityAssignmentTables.user_log" (
			"user_name"
			,"user_group"
			,"created_on"
			,"changed_on"
			)
	VALUES (
		:userName
		,:userGroup
		,CURRENT_TIMESTAMP
		,''
		)
	WHERE "user_name" = :userName;

	COMMIT;-- FOR EACH USER SUCCEFULLY CREATED, COMMITS THE TRANSACTION

	END FOR;
	
	END;