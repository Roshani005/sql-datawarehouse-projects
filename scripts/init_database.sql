/*
=======================================================================
Create Database and Schemas
=======================================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after
    checking if it already exists.

    If the database exists, it is dropped and recreated.

    The script also creates three schemas within the database:
        - bronze
        - silver
        - gold

WARNING:
    Running this script will DROP the entire 'DataWarehouse' database
    if it already exists.

    All data in the database will be permanently deleted.

    Proceed with caution and make sure you have proper backups before
    running this script.

=======================================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Switch to the 'DataWarehouse' database
USE DataWarehouse;
GO

-- Create Bronze schema
CREATE SCHEMA bronze;
GO

-- Create Silver schema
CREATE SCHEMA silver;
GO

-- Create Gold schema
CREATE SCHEMA gold;
GO
