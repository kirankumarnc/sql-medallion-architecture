/*
   
    Stored Procedure : bronze.load_bronze
    =========================================================
    Purpose:
        Loads raw data into the 'bronze' schema tables by performing a full truncate-and-reload from CSV source files.
        Covers CRM and ERP source systems.

    Actions Performed:
        - Truncates existing data in each bronze table
        - Bulk inserts raw data from CSV files into bronze tables
        - Logs row counts and load duration per table
        - Logs total batch duration on completion

    Source Systems:
        - CRM : cust_info, prd_info, sales_details
        - ERP : loc_a101, cust_az12, px_cat_g1v2

    Notes:
        - This procedure performs a full reload on every execution.
        - CSV file paths are hardcoded for local development use.
        - Not intended for production use.

	Usage:
        EXEC bronze.load_bronze;

*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '---------------------------------------------------------';
		PRINT 'Loading the Bronze layer data';
		PRINT '---------------------------------------------------------';

		PRINT '*********************************************************';
		PRINT 'Loading the data into CRM Tables';
		PRINT '*********************************************************';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '-- Inserting the data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.crm_cust_info: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '-- Inserting the data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.crm_prd_info: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '-- Inserting the data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.crm_sales_details: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		PRINT '*********************************************************';
		PRINT 'Loading the data into ERP Tables';
		PRINT '*********************************************************';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '-- Inserting the data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.erp_loc_a101: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '-- Inserting the data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.erp_cust_az12: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		SET @start_time = GETDATE();
		PRINT '-- Truncating the Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '-- Inserting the data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Learning_Materials\SQL_Projects\SQL_Data_Warehouse_project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		PRINT '-- Rows Inserted into bronze.erp_px_cat_g1v2: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		SET @end_time = GETDATE();
		PRINT '>> Load the duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------------- <<';

		SET @batch_end_time = GETDATE();
		PRINT '---------------------------------------------------------';
		PRINT 'Bronze Layer Load Completed';
		PRINT 'The total load duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT '*********************************************************';
		PRINT 'Error occurred during the Bronze Layer data loading';
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '*********************************************************';
	END CATCH
END


