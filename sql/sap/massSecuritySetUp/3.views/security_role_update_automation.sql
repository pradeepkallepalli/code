

DO

BEGIN

	DECLARE userNameArray NVARCHAR(256) ARRAY;
	DECLARE newUserGroupArray NVARCHAR(20) ARRAY;
	DECLARE priorUserGroupArray NVARCHAR(20) ARRAY;
	DECLARE grantRoleArray NVARCHAR(256) ARRAY;
	DECLARE revokeRoleArray NVARCHAR(256) ARRAY;
	
	DECLARE userName NVARCHAR(256);
	DECLARE newUserGroup NVARCHAR(20);
	DECLARE priorUserGroup NVARCHAR(20);
	DECLARE grantRoleName NVARCHAR(256);
	DECLARE revokeRoleName NVARCHAR(256);
	
	DECLARE i INTEGER = 1;
	DECLARE x INTEGER = 1;
	DECLARE n INTEGER = 1;

	-- LISTS ALL USERS WHOSE USER GROUP HAS BEEN UPDATED

	updateUsersTab =

		SELECT A."user_name" AS userName
			,A."user_group" AS newUserGroup
			,B."user_group" AS priorUserGroup
		FROM "bi"."hd.bi.db.ddl::securityAssignmentTables.create_user_list" A
		INNER JOIN "bi"."hd.bi.db.ddl::securityAssignmentTables.user_log" B ON A."user_name" = B."user_name"
		WHERE A."user_group" != B."user_group";

	userNameArray = ARRAY_AGG(:updateUsersTab.userName);
	priorUserGroupArray = ARRAY_AGG(:updateUsersTab.priorUserGroup);
	newUserGroupArray = ARRAY_AGG(:updateUsersTab.newUserGroup);
	
	-- LOOP FOR EACH USER IN UPDATED USERS TAB

	FOR i IN 1..CARDINALITY(:userNameArray) DO 
	
		userName = :userNameArray [i];
		newUserGroup = :newUserGroupArray [i];
		priorUserGroup = :priorUserGroupArray [i];

		-- GRANTS NEW ROLES - BASED ON THE NEW USER GROUP

		grantRolesTab =

			SELECT "role" AS ROLE
			FROM "bi"."hd.bi.db.ddl::securityAssignmentTables.user_group_role_mapping"
			WHERE "user_group" = :newUserGroup;

		grantRoleArray = ARRAY_AGG(:grantRolesTab.ROLE);
	
		FOR x IN 1..CARDINALITY(:grantRoleArray) DO 
			
			grantRoleName = :grantRoleArray [x];

			CALL GRANT_ACTIVATED_ROLE(:grantRoleName, :userName);
			
		END FOR;

		-- REVOKES OLD ROLES - REVOKES OLD ROLES BASED ON OLD USER GROUP

		revokeRolesTab =

			SELECT "role" AS ROLE
			FROM "bi"."hd.bi.db.ddl::securityAssignmentTables.user_group_role_mapping"
			WHERE "user_group" = :priorUserGroup;

		revokeRoleArray = ARRAY_AGG(:revokeRolesTab.ROLE);

		FOR n IN 1..CARDINALITY(:revokeRoleArray) DO 
			
			revokeRoleName = :revokeRoleArray [n];

			CALL GRANT_ACTIVATED_ROLE(:grantRoleName, :userName);
			
		END FOR;

		-- UPDATES THE LOG TABLE WITH NEW USER GROUP AND MODIFIED DATE

		UPSERT "bi"."hd.bi.db.ddl::securityAssignmentTables.user_log" (
				"user_name"
				,"user_group"
				,"changed_on"
				)
		VALUES (
			:userName
			,:newUserGroup
			,CURRENT_TIMESTAMP
			)
		WHERE "user_name" = :userName;

	COMMIT;

	END FOR;
	
END;