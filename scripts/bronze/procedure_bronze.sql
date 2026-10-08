/*
===============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================
Purpose:
    Loads raw data from the CRM and ERP CSV files into the 'bronze'
    schema. Each table is truncated, then reloaded with BULK INSERT.
    Load times are printed per table and for the whole batch.

Prerequisite (SQL Server in Docker on macOS):
    Copy the CSV files into the container first:
      docker cp datasets <container_name>:/var/opt/mssql/datasets
    File paths below are container paths, not Mac paths.

Usage:
    EXEC bronze.load_bronze;
===============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
    DECLARE @starttime DATETIME ,@endtime DATETIME , @batchstarttime DATETIME ,@batchendtime DATETIME;
    BEGIN TRY 
        set @batchstarttime = GETDATE();
        PRINT('===============================');
        PRINT 'Loading data into bronze layer';
        PRINT('===============================');


        PRINT('-------------------------------');
        PRINT 'Loading CRM Tables';
        PRINT('-------------------------------');
        set @starttime = GETDATE();
        PRINT('>> Truncating : bronze.crm_cust_info');
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT('>> Inserting date into :  bronze.crm_cust_info');
        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.crm_cust_info : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------');
        set @starttime = GETDATE();
        PRINT('>> Truncating : bronze.crm_prd_info');
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT('>> Inserting date into :  bronze.crm_prd_info');
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'

        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.crm_prd_info : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------');
        set @starttime = GETDATE();
        PRINT('>> Truncating : bronze.crm_sales_details');
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT('>> Inserting date into :  bronze.crm_sales_details');
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'

        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.crm_sales_details : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------');
        set @starttime = GETDATE();
        PRINT('-------------------------------');
        PRINT 'Loading ERP Tables';
        PRINT('-------------------------------');
        PRINT('>> Truncating : bronze.erp_cust_az12');
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT('>> Inserting date into :  bronze.erp_cust_az12');
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/datasets/source_erp/CUST_AZ12.csv'

        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.erp_cust_az12 : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------');
        set @starttime = GETDATE();
        PRINT('>> Truncating : bronze.erp_loc_a101');
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT('>> Inserting date into :  bronze.erp_loc_a101');
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/datasets/source_erp/LOC_A101.csv'

        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.erp_loc_a101 : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------');
        set @starttime = GETDATE();     
        PRINT('>> Truncating : bronze.erp_px_cat_g1v2');        
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT('>> Inserting date into :  bronze.erp_px_cat_g1v2');
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/datasets/source_erp/PX_CAT_G1V2.csv'

        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK
        );
        set @endtime = GETDATE();
        PRINT('>> Time taken to load bronze.erp_px_cat_g1v2 : ' + CAST(DATEDIFF(SECOND, @starttime, @endtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('>>-------------------------------'); 
        set @batchendtime = GETDATE();
        PRINT('>> Total time taken to load bronze layer : ' + CAST(DATEDIFF(SECOND, @batchstarttime, @batchendtime) AS NVARCHAR(10)) + ' seconds');
        PRINT('===============================');
    END TRY
    BEGIN CATCH
        PRINT('================================');
        PRINT('Error occurred while loading data into bronze layer');
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)));
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('================================');
        THROW;
    END CATCH;

END;
