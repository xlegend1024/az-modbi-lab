CREATE PROCEDURE [wwi].[Configuration_PopulateLargeSaleTable] @EstimatedRowsPerDay [bigint],@Year [int] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    EXEC [wwi].[PopulateDateDimensionForYear] @Year;

    DECLARE @OrderCounter bigint = 0;
    DECLARE @NumberOfSalesPerDay bigint = @EstimatedRowsPerDay;
    DECLARE @DateCounter date; 
    DECLARE @StartingSaleKey bigint;
    DECLARE @MaximumSaleKey bigint = (SELECT MAX([Sale Key]) FROM wwi.seed_Sale);
    DECLARE @MaxDate date;
    SET @MaxDate = (SELECT MAX([Invoice Date Key]) FROM wwi.fact_Sale)
    IF ( @MaxDate < CAST(@YEAR AS CHAR(4)) + '1231') AND (@MaxDate > CAST(@YEAR AS CHAR(4)) + '0101')
        SET @DateCounter = @MaxDate
    ELSE
        SET @DateCounter= CAST(@Year as char(4)) + '0101';

    PRINT 'Targeting ' + CAST(@NumberOfSalesPerDay AS varchar(20)) + ' sales per day.';

    DECLARE @OutputCounter varchar(20);
    DECLARE @variance DECIMAL(18,10);
    DECLARE @VariantNumberOfSalesPerDay BIGINT;

    WHILE @DateCounter < CAST(@YEAR AS CHAR(4)) + '1231'
    BEGIN
        SET @OutputCounter = CONVERT(varchar(20), @DateCounter, 112);
        RAISERROR(@OutputCounter, 0, 1);
        SET @variance = (SELECT RAND() * 10)*.01 + .95
        SET @VariantNumberOfSalesPerDay = FLOOR(@NumberOfSalesPerDay * @variance)

        SET @StartingSaleKey = @MaximumSaleKey - @VariantNumberOfSalesPerDay - FLOOR(RAND() * 20000);
        SET @OrderCounter = 0;

        INSERT [wwi].[fact_Sale] (
            [City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key], [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], [Lineage Key]
        )
        SELECT TOP(@VariantNumberOfSalesPerDay)
            [City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], @DateCounter, DATEADD(day, 1, @DateCounter), [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], [Lineage Key]
        FROM [wwi].[seed_Sale]
        WHERE 
             --[Sale Key] > @StartingSaleKey and /* IDENTITY DOES NOT WORK THE SAME IN SQLDW AND CAN'T USE THIS METHOD FOR VARIANT */
            [Invoice Date Key] >=cast(@YEAR AS CHAR(4)) + '-01-01'
        ORDER BY [Sale Key];

        SET @DateCounter = DATEADD(day, 1, @DateCounter);
    END;

END;