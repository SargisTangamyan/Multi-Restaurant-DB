-- CREATE SERVER LOGINS
CREATE LOGIN [DevUser_Login] WITH PASSWORD = 'DevPassword123!', CHECK_POLICY = OFF;
CREATE LOGIN [AdminUser_Login] WITH PASSWORD = 'AdminPassword123!', CHECK_POLICY = OFF;
CREATE LOGIN [ReaderUser_Login] WITH PASSWORD = 'ReaderPassword123!', CHECK_POLICY = OFF;
GO

-- SWITCH TO THE DATABASE
USE restaurant_project;
GO

-- CREATE DATABASE ROLES
CREATE ROLE [app_reader];
CREATE ROLE [app_developer];
CREATE ROLE [app_admin];
GO

-- GRANT PERMISSIONS TO ROLES
-- Reader: Can only view data
GRANT SELECT TO [app_reader];

-- Developer: Can CRUD data and modify schema (Tables, Procs, etc.)
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE TO [app_developer];
GRANT ALTER, CREATE TABLE, VIEW DEFINITION TO [app_developer];

-- Admin: Full control over this specific database
ALTER ROLE [db_owner] ADD MEMBER [app_admin];
GO

-- STEP 4: CREATE DATABASE USERS
CREATE USER [Meri_Zakaryan] FOR LOGIN [DevUser_Login];
CREATE USER [Sargis_Tangamyan] FOR LOGIN [AdminUser_Login];
CREATE USER [Narek_Srapionyan] FOR LOGIN [ReaderUser_Login];
GO

-- STEP 5: ASSIGN USERS TO ROLES
ALTER ROLE [app_developer] ADD MEMBER [Meri_Zakaryan];
ALTER ROLE [app_admin] ADD MEMBER [Sargis_Tangamyan];
ALTER ROLE [app_reader] ADD MEMBER [Narek_Srapionyan];
GO