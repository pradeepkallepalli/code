-- Mass User creation


-- creating Users Store Procedure

PROCEDURE "ACME"."Demo.SAP_BOC_SPATIAL::test" () --OUT output NVARCHAR(50)
	LANGUAGE SQLSCRIPT
	SQL SECURITY DEFINER
	--DEFAULT SCHEMA "bi"
	--READS SQL DATA 
	AS
BEGIN
/***************************** 
	Write your procedure logic 
 *****************************/
DECLARE userNameArray NVARCHAR(100) ARRAY;
DECLARE userTypeArray NVARCHAR(20) ARRAY;
DECLARE userGroupArray NVARCHAR(20) ARRAY;
DECLARE samlIdProvArray NVARCHAR(100) ARRAY;
DECLARE extIdArray NVARCHAR(100) ARRAY;
DECLARE password NVARCHAR(20) := 'Password123';

DECLARE userName NVARCHAR(100);
DECLARE userType NVARCHAR(20);
DECLARE userGroup NVARCHAR(20);
DECLARE samlIdProv NVARCHAR(100);
DECLARE extId NVARCHAR(100);



DECLARE i INTEGER DEFAULT 1;

tab = select "user_name" AS userID
			  ,"user_type" AS userType
			  ,"user_group" AS userGroup
			  ,"saml_identity_provider" AS samlIdProv
			  ,"external_identity" AS extId
		   from "bi"."hd.bi.db.ddl::securityAssignmentTables.create_user_list";


userNameArray = ARRAY_AGG(:tab.userID);
userTypeArray = ARRAY_AGG(:tab.userType);
userGroupArray = ARRAY_AGG(:tab.userGroup);
samlIdProvArray = ARRAY_AGG(:tab.samlIdProv);
extIdArray = ARRAY_AGG(:tab.extId);




FOR i IN 1..CARDINALITY(:userNameArray) DO 
	userName = :userNameArray[i];
	userType = :userTypeArray[i];
	userGroup = :userGroupArray[i];
	samlIdProv = :samlIdProvArray[i];
	extId = :extIdArray[i];

	
	EXEC 'CREATE ' || :userType ||' USER ' || :userName || ' PASSWORD ' || :password || ' WITH IDENTITY ''' || :extId || ''' FOR SAML PROVIDER ' || :samlIdProv ;
	CALL GRANT_ACTIVATED_ROLE ('hd.sec.common::basicRole', :userName);	
	COMMIT;
END FOR;

END;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Role Assignment

-- Assigning roles from a table to a user

DO
BEGIN

	DECLARE roleArray VARCHAR(1000) ARRAY;
	DECLARE i INTEGER = 1;
	DECLARE roleName VARCHAR(1000);
	
	tab = select "roleName" A from "ACME"."roleList";  -- select the list of all roles to be assigned
	roleArray = ARRAY_AGG(:tab.A ORDER BY A DESC);  -- converting the select into an array
	
	FOR i IN 1..CARDINALITY(:roleArray) DO 		-- for loop - CARDINALITY functiongives the length of the array or gives the max position in array
		roleName = :roleArray[:i];

		-- NOTE : Try to use Autonomous Transaction here.
		CALL GRANT_ACTIVATED_ROLE (:roleName,'TEST_SCRIPT');	

	END FOR;

END;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE USER ROLES--
----------------------
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




updateUsersTab = select A."user_name" AS userName
					, A."user_group" AS newUserGroup
					, B."user_group" AS priorUserGroup
 				from "bi"."hd.bi.db.ddl::securityAssignmentTables.create_user_list" A INNER JOIN "bi"."hd.bi.db.ddl::securityAssignmentTables.user_log" B
 							ON A."user_name" = B."user_name"
 				where A."user_group" !=  B."user_group"
 				;


userNameArray = ARRAY_AGG(:updateUsersTab.userName);
priorUserGroupArray = ARRAY_AGG(:updateUsersTab.priorUserGroup);
newUserGroupArray = ARRAY_AGG(:updateUsersTab.newUserGroup);


FOR i IN 1..CARDINALITY(:userNameArray) DO 
		userName = :userNameArray[i];
		newUserGroup = :newUserGroupArray [i];
		priorUserGroup = :priorUserGroupArray[i];

		grantRolesTab = select "role" AS role
 			from "bi"."hd.bi.db.ddl::securityAssignmentTables.user_group_role_mapping"
 			WHERE "user_group" = :newUserGroup
 			;
		
		grantRoleArray = ARRAY_AGG(:grantRolesTab.role);

		FOR x IN 1..CARDINALITY(:grantRoleArray) DO
			grantRoleName = :grantRoleArray[x];
		
			CALL GRANT_ACTIVATED_ROLE (:grantRoleName, :userName);	

		END FOR;
			

		revokeRolesTab = select "role" AS role
 			from "bi"."hd.bi.db.ddl::securityAssignmentTables.user_group_role_mapping"
 			WHERE "user_group" = :priorUserGroup
 			;
		
		revokeRoleArray = ARRAY_AGG(:revokeRolesTab.role);

		FOR n IN 1..CARDINALITY(:revokeRoleArray) DO
			revokeRoleName = :revokeRoleArray[n];
		
			CALL GRANT_ACTIVATED_ROLE (:grantRoleName, :userName);	
			
		END FOR;

	UPSERT "bi"."hd.bi.db.ddl::securityAssignmentTables.user_log" ("user_name", "user_group", "changed_on") 
 		VALUES (:userName, :newUserGroup, CURRENT_DATE) WHERE "user_name" = :userName
 	;

	COMMIT;
	
END FOR;

END;