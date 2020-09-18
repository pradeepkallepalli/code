


-- sql METHOD

CREATE SCHEMA DEMO OWNED BY SYSTEM ;

GRANT SELECT ON SCHEMA DEMO
TO "_SYS_REPO"
WITH GRANT OPTION;



-- .hdbschema METHOD

/* 

If you created the schema using .hdbschema file, you may not see the schema name in the catalog.

After activation in the repository, the schema object is only visible in the catalog to the _SYS_REPO user. 
To enable other users, for example the schema owner, to view the newly created schema, you must grant the user the required SELECT privilege.


*/

call _SYS_REPO.GRANT_SCHEMA_PRIVILEGE_ON_ACTIVATED_CONTENT ('SELECT, ALTER, CREATE ANY, INSERT, UPDATE, DELETE, EXECUTE, DROP, INDEX, REFERENCES, DEBUG, TRIGGER, CREATE TEMPORARY TABLE, CREATE VIRTUAL FUNCTION PACKAGE, SELECT CDS METADATA, SELECT METADATA'
																,'SCHEMA_NAME'
																, 'ROLE_USER_NAME')
																
																
-- NOTE: If you are unable to call this procedure, the following privilege needs to be assigned to you role/user.

	GRANT_SCHEMA_PRIVILEGE_ON_ACTIVATED_CONTENT(_SYS_REPO) : EXECUTE


