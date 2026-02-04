
USE ROLE SYSADMIN;

-- Separate database for git repository
-- Create a database for the metadata
CREATE OR ALTER DATABASE DATAOPS_DB;

-- Git repository object is similar to external stage (this is a trick to get access to the files)
CREATE OR REPLACE GIT REPOSITORY DATAOPS_DB.PUBLIC.DATAOPS_REPO
API_INTEGRATION = GIT_INTEGRATION_REEVES
ORIGIN = 'https://github.com/reeves-ah/snowflake-devops';

-- Create a database for the data
CREATE OR ALTER DATABASE REEVES_DB;

-- Database level objects
CREATE OR ALTER SCHEMA REEVES_DB.BRONZE;
CREATE OR ALTER SCHEMA REEVES_DB.SILVER;
CREATE OR ALTER SCHEMA REEVES_DB.GOLD;


-- Schema level objects
CREATE OR REPLACE FILE FORMAT BRONZE.JSON_FORMAT TYPE = 'json';
CREATE OR ALTER STAGE BRONZE.RAW; -- Internal Stage


-- Copy file from GitHub to internal stage
COPY FILES INTO @REEVES_DB.BRONZE.RAW 
FROM @DATAOPS_DB.PUBLIC.DATAOPS_REPO/branches/main/data/airport_list.json;



