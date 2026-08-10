CREATE OR ALTER PROCEDURE gold.usp_Load_Customer_Gold
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Full reload: Gold Customer dimension is rebuilt each run
        -- from the current state of Silver (SCD Type 1 pattern)
        TRUNCATE TABLE gold.DimCustomer;

        INSERT INTO gold.DimCustomer (
            SourceCustomerKey,
            CustomerID,
            CustomerName,
            Age,
            Gender,
            Region,
            City,
            CustomerSatisfaction,
            LoadDate
        )
        SELECT
            s.CustomerKey                       AS SourceCustomerKey,
            s.CustomerID,
            s.CustomerName,
            s.Age,
            -- Standardize Gender casing/abbreviations to a consistent
            -- domain so Power BI slicers don't split 'Male'/'M'/'m'
            -- into separate categories
            CASE
                WHEN UPPER(LTRIM(RTRIM(s.Gender))) IN ('M', 'MALE')   THEN 'Male'
                WHEN UPPER(LTRIM(RTRIM(s.Gender))) IN ('F', 'FEMALE') THEN 'Female'
                WHEN s.Gender IS NULL OR LTRIM(RTRIM(s.Gender)) = ''  THEN NULL
                ELSE 'Other'
            END                                  AS Gender,
            s.Region,
            s.City,
            s.CustomerSatisfaction,
            SYSDATETIME()                        AS LoadDate
        FROM silver.Customer_Silver s;

        -- Capture rowcount immediately after INSERT; COMMIT itself
        -- would otherwise overwrite @@ROWCOUNT with 0
        DECLARE @RowsLoaded INT = @@ROWCOUNT;

        COMMIT TRANSACTION;

        PRINT 'gold.usp_Load_Customer_Gold completed successfully. Rows loaded: '
            + CAST(@RowsLoaded AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrState INT = ERROR_STATE();

        RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO