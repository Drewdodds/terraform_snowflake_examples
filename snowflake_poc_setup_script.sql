/*POC Setup Steps
1) Create the warehouse (XSMALL); add a comment about when it should be removed
2) Create the role (prospect_role for example)
3) Create a user, assign default role, warehouse and namespace
4) Create a database
5) Create schemas (Profiles, RUDDERSTACK and _RUDDERSTACK) in that database
6) Grant usage on warehouse to role
7) Grant usage on database to role
8) Grant create schema on database (created above) to role
9) Grant various permissions on tables, views, etc. on the different schemas
10) Grant new role privileges to DEMO_ROLE and ANALYTICS_ROLE so that everyone here can see it
11) Print out useful SQL commands
ENTER YOUR WORKSPACE NAME HERE  Everything else will be created automatically
 */


SET WORKSPACE_NAME = 'WYZE_DEMO_ALPHA';
--- LEAVE THESE AS IS ----
SET WAREHOUSE_NAME = $WORKSPACE_NAME || '_POC';
SET W_COMMENT = (Select 'For POC ' || ($WORKSPACE_NAME) || ' - Delete in ' || MONTHNAME( dateadd( month, 3, current_date ))::text || ' ' || YEAR( dateadd( month, 3, current_date ))::text);
SET ROLE_NAME = $WORKSPACE_NAME || '_ROLE';
SET DB_NAME = $WORKSPACE_NAME || '_DEMO';
SET SCHEMA_PROFILES = $DB_NAME || '.PROFILES';
SET SCHEMA_PUBLIC = $DB_NAME || '.PUBLIC';
SET SCHEMA_RUDDERSTACK = $DB_NAME || '.RUDDERSTACK';
SET SCHEMA_RETL = $DB_NAME || '._RUDDERSTACK';
-- Create the warehouse
CREATE OR REPLACE WAREHOUSE identifier($WAREHOUSE_NAME) WITH
    WAREHOUSE_SIZE = 'XSMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
COMMENT = $W_COMMENT;
-- Create the Role
create or replace role identifier($ROLE_NAME);
-- Create the user and assign to the role
CREATE USER IF NOT EXISTS identifier($WORKSPACE_NAME)
        email = 'ehwang@rudderstack.com'
        password= 'Rudder24!!!'
        default_role = $ROLE_NAME
        must_change_password = false
        default_warehouse = $WAREHOUSE_NAME
        default_namespace = $DB_NAME ;
GRANT ROLE IDENTIFIER($ROLE_NAME) TO USER IDENTIFIER($WORKSPACE_NAME) ;
-- Now grant the supporting permissions
GRANT USAGE ON WAREHOUSE identifier($WAREHOUSE_NAME) TO ROLE IDENTIFIER($ROLE_NAME);
--- Create the db and schemas
Create database IF NOT EXISTS  identifier($DB_NAME);
Create schema IF NOT EXISTS identifier($SCHEMA_PROFILES);
Create schema IF NOT EXISTS identifier($SCHEMA_RUDDERSTACK);
Create schema IF NOT EXISTS identifier($SCHEMA_RETL);
--- Grant permissions (THIS MAY NOT BE COMPLETE)
GRANT USAGE ON DATABASE identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT create schema ON DATABASE identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT ALL PRIVILEGES ON DATABASE identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT ALL PRIVILEGES ON SCHEMA identifier($SCHEMA_PROFILES) TO ROLE identifier($ROLE_NAME);
GRANT ALL PRIVILEGES ON SCHEMA identifier($SCHEMA_RUDDERSTACK) TO ROLE identifier($ROLE_NAME);
GRANT ALL PRIVILEGES ON SCHEMA identifier($SCHEMA_RETL) TO ROLE identifier($ROLE_NAME);
GRANT ALL PRIVILEGES ON SCHEMA identifier($SCHEMA_PUBLIC) TO ROLE identifier($ROLE_NAME);
GRANT select on all tables in database identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT select on all views in database identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT select on  future views in database identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT select on  future tables in database identifier($DB_NAME) TO ROLE identifier($ROLE_NAME);
GRANT ROLE identifier($ROLE_NAME) TO ROLE ANALYTICS_ROLE;
GRANT ROLE identifier($ROLE_NAME) TO ROLE DEMO_ROLE;
--  Generate Useful Statements at the end for adding to CLI Site Config or Terraform
Select
    (   '--- This will print out commands for copying into Site Config as well as TerraForm ' || CHR(10) ||
        'Account: ina31471.us-east-1' || CHR(10) ||
        'Password = ''Rudder24&@!!!''' || CHR(10) ||
        'Role = ' || $ROLE_NAME || CHR(10) ||
        'Warehouse = ' || $WAREHOUSE_NAME || CHR(10) ||
        'Namespace = ' || $DB_NAME || CHR(10) ||
        'Username = ' || $WORKSPACE_NAME || CHR(10) ||
        'Schema:  leave blank' || CHR(10) ||
         CHR(10) ||
         CHR(10) ||
        '--- This will print out commands for cleaninup up the POC environment ' || CHR(10) ||
        'DROP WAREHOUSE IF EXISTS ' || $WAREHOUSE_NAME || '; ' || CHR(10) ||
        'DROP ROLE IF EXISTS ' || $ROLE_NAME || '; '  || CHR(10) ||
        'DROP USER IF EXISTS ' || $WORKSPACE_NAME || '; '  || CHR(10) ||
        'DROP DATABSE IF EXISTS ' || $DB_NAME || '; ' ||
         CHR(10) ||
         CHR(10) ||
         '--- Verify Grants for new role ' || CHR(10) ||
         'SHOW GRANTS TO ROLE ' || $ROLE_NAME || '; '
    );

    --- This will print out commands for copying into Site Config as well as TerraForm
Account: ina31471.us-east-1
Password = 'Rudder24&@!!!'
Role = WYZE_DEMO_ALPHA_ROLE
Warehouse = WYZE_DEMO_ALPHA_POC
Namespace = WYZE_DEMO_ALPHA_DEMO
Username = WYZE_DEMO_ALPHA
Schema:  leave blank
--- This will print out commands for cleanup up the POC environment
DROP WAREHOUSE IF EXISTS WYZE_DEMO_ALPHA_POC;
DROP ROLE IF EXISTS WYZE_DEMO_ALPHA_ROLE;
DROP USER IF EXISTS WYZE_DEMO_ALPHA;
DROP DATABASE IF EXISTS WYZE_DEMO_ALPHA_DEMO;
--- Verify Grants for new role
SHOW GRANTS TO ROLE WYZE_DEMO_ALPHA_ROLE;