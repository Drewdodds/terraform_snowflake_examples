/* POC Setup Steps
1) Create the warehouse (XSMALL); add a comment about when it should be removed
2) Create the role (prospect_role for example)
3) Create a user, assign default role, warehouse and namespace
4) Create a database
5) Create schemas (Profiles, RUDDERSTACK and _RUDDERSTACK) in that database
6) Grant usage on warehouse to role
7) Grant usage on databae to role
8) Grant create schema on database (created above) to role
9) Grant various permissions on tables, views, etc. on the different schemas
10) Grant new role privileges to DEMO_ROLE and ANALYTICS_ROLE so that everyone here can see it
*/
-- Create the warehouse
CREATE WAREHOUSE TRAVELEX_POC WITH
    WAREHOUSE_SIZE = 'XSMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
COMMENT = 'For TRAVELEX POC - Delete in Feb 2024';
-- Create the Role
create role travelex_role;
-- Create the user and assign to the role
CREATE USER IF NOT EXISTS travelex
        #email = 'enter email'
        #password= 'enter password'
        default_role = travelex_role
        must_change_password = false
        default_warehouse = TRAVELEX_POC
        default_namespace = TRAVELEX;
-- Now grant the supporting permissions
GRANT USAGE ON WAREHOUSE TRAVELEX_POC TO ROLE TRAVELEX_ROLE;
Create database WYZE_DEMO;
Create schema WYZE_DEMO.PROFILES;
Create schema WYZE_DEMO._RUDDERSTACK;
Create schema WYZE_DEMO.RUDDERSTACK;
GRANT USAGE ON DATABASE WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT create schema ON DATABASE WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT USAGE ON DATABASE WYZE_DEMO TO ROLE DEMO_ROLE; WYZE_DEMO.PROFILES TO ROLE DEMO_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA WYZE_DEMO.RUDDERSTACK TO ROLE DEMO_ROLE;
GRANT select on all tables in database WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT select on all views in database WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT select on  future views in database WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT select on  future tables in database WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA WYZE_DEMO._RUDDERSTACK TO ROLE DEMO_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA WYZE_DEMO.Public TO ROLE DEMO_ROLE;
GRANT select on all tables in schema WYZE_DEMO.public TO ROLE DEMO_ROLE;
GRANT select on all views in schema WYZE_DEMO.public TO ROLE DEMO_ROLE;
GRANT select on  future views in schema WYZE_DEMO.public TO ROLE DEMO_ROLE;
GRANT select on  future tables in schema WYZE_DEMO.public TO ROLE DEMO_ROLE;
Show users
GRANT ROLE DEMO_ROLE TO ROLE ANALYTICS_ROLE;
GRANT ROLE DEMO_ROLE TO USER TRAVELEX;
GRANT ROLE DEMO_ROLE TO USER BENJI;
GRANT ROLE DEMO_ROLE TO USER MCHOI;
GRANT ROLE DEMO_ROLE TO USER KHINTIKKA;
GRANT ROLE DEMO_ROLE TO USER EHWANG;
GRANT ROLE DEMO_ROLE TO USER SHAMIL;
GRANT ROLE DEMO_ROLE TO USER profiles_demo;
GRANT ROLE DEMO_ROLE TO USER DAVID;
GRANT ROLE DEMO_ROLE TO USER DAVIDT;
GRANT ROLE DEMO_ROLE TO USER EMIL;
GRANT ROLE DEMO_ROLE TO USER SHAMIL;
GRANT ROLE DEMO_ROLE TO USER SHREYA;

GRANT USAGE ON WAREHOUSE
GRANT USAGE ON DATABASE
GRANT USAGE ON DATABASE WYZE_DEMO TO ROLE DEMO_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA
GRANT select on all tables in databas
