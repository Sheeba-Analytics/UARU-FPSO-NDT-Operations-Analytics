/*
UARU FPSO NDT Operations Analytics
Script 05: Data Quality and Warehouse Validation
*/

USE Uaru_NDT_DW;
GO

-- 1. Table row counts
SELECT 'fact_ndt_inspection' AS TableName, COUNT(*) AS RowCount
FROM dbo.fact_ndt_inspection
UNION ALL
SELECT 'dim_method', COUNT(*) FROM dbo.dim_method
UNION ALL
SELECT 'dim_discipline', COUNT(*) FROM dbo.dim_discipline
UNION ALL
SELECT 'dim_module', COUNT(*) FROM dbo.dim_module
UNION ALL
SELECT 'dim_calendar', COUNT(*) FROM dbo.dim_calendar;
GO

-- 2. Duplicate InspectionID check
SELECT
    InspectionID,
    COUNT(*) AS DuplicateCount
FROM dbo.fact_ndt_inspection
GROUP BY InspectionID
HAVING COUNT(*) > 1;
GO

-- 3. NULL foreign-key checks
SELECT
    SUM(CASE WHEN MethodKey IS NULL THEN 1 ELSE 0 END) AS NullMethodKey,
    SUM(CASE WHEN DisciplineKey IS NULL THEN 1 ELSE 0 END) AS NullDisciplineKey,
    SUM(CASE WHEN ModuleKey IS NULL THEN 1 ELSE 0 END) AS NullModuleKey,
    SUM(CASE WHEN RequestDateKey IS NULL THEN 1 ELSE 0 END) AS NullRequestDateKey,
    SUM(CASE WHEN JDRDateKey IS NULL THEN 1 ELSE 0 END) AS NullJDRDateKey
FROM dbo.fact_ndt_inspection;
GO

-- 4. Records with a missing reporting date
SELECT
    InspectionID,
    RequestNo,
    RequestDateKey,
    JDRDateKey,
    RequestedQty,
    CompletedQty,
    JDRQty
FROM dbo.fact_ndt_inspection
WHERE RequestDateKey IS NULL
ORDER BY InspectionID;
GO

-- 5. Date range validation
SELECT
    MIN(RequestDateKey) AS FirstRequestDateKey,
    MAX(RequestDateKey) AS LastRequestDateKey,
    MIN(JDRDateKey) AS FirstJDRDateKey,
    MAX(JDRDateKey) AS LastJDRDateKey
FROM dbo.fact_ndt_inspection;
GO

SELECT
    InspectionID,
    RequestDateKey,
    JDRDateKey
FROM dbo.fact_ndt_inspection
WHERE RequestDateKey < 20230101
   OR RequestDateKey > 20261231
   OR JDRDateKey < 20230101
   OR JDRDateKey > 20261231;
GO

-- 6. Foreign-key integrity checks
SELECT COUNT(*) AS InvalidMethodKeys
FROM dbo.fact_ndt_inspection AS f
LEFT JOIN dbo.dim_method AS d
    ON f.MethodKey = d.MethodKey
WHERE d.MethodKey IS NULL;
GO

SELECT COUNT(*) AS InvalidDisciplineKeys
FROM dbo.fact_ndt_inspection AS f
LEFT JOIN dbo.dim_discipline AS d
    ON f.DisciplineKey = d.DisciplineKey
WHERE d.DisciplineKey IS NULL;
GO

SELECT COUNT(*) AS InvalidModuleKeys
FROM dbo.fact_ndt_inspection AS f
LEFT JOIN dbo.dim_module AS d
    ON f.ModuleKey = d.ModuleKey
WHERE d.ModuleKey IS NULL;
GO

SELECT COUNT(*) AS InvalidRequestDateKeys
FROM dbo.fact_ndt_inspection AS f
LEFT JOIN dbo.dim_calendar AS d
    ON f.RequestDateKey = d.DateKey
WHERE f.RequestDateKey IS NOT NULL
  AND d.DateKey IS NULL;
GO

SELECT COUNT(*) AS InvalidJDRDateKeys
FROM dbo.fact_ndt_inspection AS f
LEFT JOIN dbo.dim_calendar AS d
    ON f.JDRDateKey = d.DateKey
WHERE f.JDRDateKey IS NOT NULL
  AND d.DateKey IS NULL;
GO

-- 7. Quantity checks
SELECT
    SUM(CASE WHEN RequestedQty < 0 THEN 1 ELSE 0 END) AS NegativeRequestedQty,
    SUM(CASE WHEN CompletedQty < 0 THEN 1 ELSE 0 END) AS NegativeCompletedQty,
    SUM(CASE WHEN JDRQty < 0 THEN 1 ELSE 0 END) AS NegativeJDRQty,
    SUM(CASE WHEN RequestedQty IS NULL THEN 1 ELSE 0 END) AS NullRequestedQty,
    SUM(CASE WHEN CompletedQty IS NULL THEN 1 ELSE 0 END) AS NullCompletedQty,
    SUM(CASE WHEN JDRQty IS NULL THEN 1 ELSE 0 END) AS NullJDRQty
FROM dbo.fact_ndt_inspection;
GO

-- 8. Requested-versus-completed variance
SELECT
    InspectionID,
    RequestNo,
    RequestedQty,
    CompletedQty,
    CompletedQty - RequestedQty AS VarianceQty
FROM dbo.fact_ndt_inspection
WHERE CompletedQty <> RequestedQty
ORDER BY ABS(CompletedQty - RequestedQty) DESC;
GO

-- 9. Dimension attribute validation
SELECT
    Method,
    JDRUnit,
    JDRDescription
FROM dbo.dim_method
WHERE JDRUnit IS NULL
   OR JDRDescription IS NULL;
GO
