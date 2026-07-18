/*
UARU FPSO NDT Operations Analytics
Script 06: Analytical SQL Queries

RequestDateKey is used as the primary reporting date throughout the portfolio version.
*/

USE Uaru_NDT_DW;
GO

--Query 1 – Overall Summary
SELECT
    COUNT(InspectionID) AS TotalInspectionRecords,
    SUM(RequestedQty) AS TotalRequestedQty,
    SUM(CompletedQty) AS TotalCompletedQty,
    round(SUM(JDRQty),0) AS TotalJDRQty
FROM fact_ndt_inspection;

-- Query 2 – Discipline Analysis
SELECT
    d.Discipline,
    COUNT(*) AS TotalInspections,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
GROUP BY d.Discipline
ORDER BY TotalRequestedQty DESC;

-- Query 3 – Method Analysis
SELECT
    m.Method,
    COUNT(f.InspectionID) AS TotalInspections,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY m.Method
ORDER BY TotalRequestedQty DESC;

-- Query 4 – Module Analysis
SELECT
    mo.Module,
    COUNT(f.InspectionID) AS TotalInspections,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
GROUP BY mo.Module
ORDER BY TotalRequestedQty DESC;

--Query 5 – Monthly Trend
SELECT
    c.Year,
    c.MonthName,
    COUNT(f.InspectionID) AS TotalInspections,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName
ORDER BY
    c.Year,
    c.MonthNumber;

--Query 6 – Completion % by Discipline
SELECT
    d.Discipline,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty,
    ROUND(
        SUM(f.CompletedQty) * 100.0 / NULLIF(SUM(f.RequestedQty), 0),
        2
    ) AS CompletionPercentage
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
GROUP BY d.Discipline
ORDER BY CompletionPercentage DESC;


--Query 7 – Variance by Discipline
SELECT
    d.Discipline,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty,
    SUM(f.CompletedQty) - SUM(f.RequestedQty) AS VarianceQty
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
GROUP BY d.Discipline
ORDER BY VarianceQty Desc --ABS(SUM(f.CompletedQty) - SUM(f.RequestedQty)) DESC;

--Query 8 – Variance by Method
SELECT
    m.Method,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty,
    SUM(f.CompletedQty) - SUM(f.RequestedQty) AS VarianceQty
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY m.Method
ORDER BY ABS(SUM(f.CompletedQty) - SUM(f.RequestedQty)) DESC;

--Query 9 – Top 5 Modules
SELECT TOP 5
    mo.Module,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
GROUP BY mo.Module
ORDER BY TotalRequestedQty DESC;

--Query 10 – Top 5 NDT Methods
SELECT TOP 5
    m.Method,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY m.Method
ORDER BY TotalRequestedQty DESC;

--Query 11: Monthly Trend by Method
SELECT
    c.Year,
    c.MonthName,
    m.Method,
    COUNT(f.InspectionID) AS TotalInspections,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName,
    m.Method
ORDER BY
    c.Year,
    c.MonthNumber,
    m.Method;

--Query 12: Inspection Count by Month
SELECT
    c.Year,
    c.MonthName,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName
ORDER BY
    c.Year,
    c.MonthNumber;

--Query 13 – Average Requested Quantity per Inspection by Method
SELECT
    m.Method,
    COUNT(f.InspectionID) AS TotalInspections,
    ROUND(AVG(f.RequestedQty),2) AS AvgRequestedQty,
    Round(AVG(f.CompletedQty),2) AS AvgCompletedQty
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY m.Method
ORDER BY AvgRequestedQty DESC;

--Query 14 – Top 10 Inspection Requests by Requested Quantity
SELECT TOP 10
    f.InspectionID,
    f.RequestNo,
    d.Discipline,
    mo.Module,
    m.Method,
    f.RequestedQty,
    f.CompletedQty
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
ORDER BY f.RequestedQty DESC;

--Query 15 – Inspection Requests with Variance (Completed Qty ≠ Requested Qty)
SELECT
    f.InspectionID,
    f.RequestNo,
    d.Discipline,
    mo.Module,
    m.Method,
    f.RequestedQty,
    f.CompletedQty,
    (f.CompletedQty - f.RequestedQty) AS VarianceQty
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
WHERE f.CompletedQty <> f.RequestedQty
ORDER BY ABS(f.CompletedQty - f.RequestedQty) DESC;

--Query 16 – Monthly Completion Percentage Trend
SELECT
    c.Year,
    c.MonthName,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty,
    ROUND(
        SUM(f.CompletedQty) * 100.0 / NULLIF(SUM(f.RequestedQty), 0),
        2
    ) AS CompletionPercentage
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName
ORDER BY
    c.Year,
    c.MonthNumber;

--Query 17 – Top 5 Modules by Completion Percentage
SELECT TOP 5
    mo.Module,
    SUM(f.RequestedQty) AS TotalRequestedQty,
    SUM(f.CompletedQty) AS TotalCompletedQty,
    ROUND(
        SUM(f.CompletedQty) * 100.0 / NULLIF(SUM(f.RequestedQty), 0),
        2
    ) AS CompletionPercentage
FROM fact_ndt_inspection f
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
GROUP BY mo.Module
ORDER BY CompletionPercentage DESC;

--Query 18 — JDR Quantity by Method
SELECT
    m.Method,
    m.JDRUnit,
    m.JDRDescription,
    ROUND(SUM(f.JDRQty),1) AS TotalJDRQty,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    m.Method,
    m.JDRUnit,
    m.JDRDescription
ORDER BY
    m.JDRUnit,
    TotalJDRQty DESC,
    m.Method;

--Query 19 — JDR Quantity by Module
SELECT
    mo.Module,
    m.Method,
    m.JDRUnit,
    ROUND(SUM(f.JDRQty), 1) AS TotalJDRQty,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    mo.Module,
    m.Method,
    m.JDRUnit
ORDER BY
    m.JDRUnit,
    TotalJDRQty DESC;

--Query 20 — JDR Quantity by JDRUnit
SELECT
    m.JDRUnit,
    ROUND(SUM(f.JDRQty),1) AS TotalJDRQty
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    m.JDRUnit
ORDER BY
    TotalJDRQty DESC;

--Query 21 – Monthly JDR Trend by Method
SELECT
    c.Year,
    c.MonthName,
    m.Method,
    m.JDRUnit,
    ROUND(SUM(f.JDRQty), 1) AS TotalJDRQty,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName,
    m.Method,
    m.JDRUnit
ORDER BY
    c.Year,
    c.MonthNumber,
    m.JDRUnit,
    m.Method;


--Query 22 – Monthly JDR Trend by Module
SELECT
    c.Year,
    c.MonthName,
    mo.Module,
    m.Method,
    m.JDRUnit,
    ROUND(SUM(f.JDRQty), 1) AS TotalJDRQty,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_calendar c
    ON f.RequestDateKey = c.DateKey
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    c.Year,
    c.MonthNumber,
    c.MonthName,
    mo.Module,
    m.Method,
    m.JDRUnit
ORDER BY
    c.Year,
    c.MonthNumber,
    mo.Module,
    m.Method,
    m.JDRUnit;

--Query 23 - Top 10 Highest JDR Inspection Requests
SELECT TOP 10
    f.InspectionID,
    f.RequestNo,
    d.Discipline,
    mo.Module,
    m.Method,
    m.JDRUnit,
    f.JDRQty,
    f.RequestedQty,
    f.CompletedQty 
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
ORDER BY
    f.JDRQty DESC;

--Query 24 – Average JDR Quantity per Inspection by Method
SELECT
    m.Method,
    m.JDRUnit,
    COUNT(f.InspectionID) AS TotalInspections,
    ROUND(AVG(f.JDRQty), 2) AS AvgJDRQtyPerInspection
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    m.Method,
    m.JDRUnit
ORDER BY
    m.JDRUnit,
    AvgJDRQtyPerInspection DESC;

--Query 25 — JDR Quantity by Discipline
SELECT
    d.Discipline,
    m.Method,
    m.JDRUnit,
    ROUND(SUM(f.JDRQty), 1) AS TotalJDRQty,
    COUNT(f.InspectionID) AS TotalInspections
FROM fact_ndt_inspection f
JOIN dim_discipline d
    ON f.DisciplineKey = d.DisciplineKey
JOIN dim_module mo
    ON f.ModuleKey = mo.ModuleKey
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    d.Discipline,
    m.Method,
    m.JDRUnit
ORDER BY
    m.JDRUnit,
    m.Method,
    TotalJDRQty DESC;

--Query 26 – JDR Contribution Percentage by Method
SELECT
    m.JDRUnit,
    m.Method,
    ROUND(SUM(f.JDRQty), 1) AS TotalJDRQty,
    ROUND(
        SUM(f.JDRQty) * 100.0
        / SUM(SUM(f.JDRQty)) OVER (PARTITION BY m.JDRUnit),
        2
    ) AS JDRContributionPercentage
FROM fact_ndt_inspection f
JOIN dim_method m
    ON f.MethodKey = m.MethodKey
GROUP BY
    m.JDRUnit,
    m.Method
ORDER BY
    m.JDRUnit,
    JDRContributionPercentage DESC;

--Query 27 – JDR Contribution Percentage by Method using CTE
WITH MethodTotals AS
(
    SELECT
        m.Method,
        m.JDRUnit,
        SUM(f.JDRQty) AS TotalJDRQty
    FROM fact_ndt_inspection f
    JOIN dim_method m
        ON f.MethodKey = m.MethodKey
    GROUP BY
        m.Method,
        m.JDRUnit
)
SELECT
    JDRUnit,
    Method,
    ROUND(TotalJDRQty, 1) AS TotalJDRQty,
    ROUND(
        TotalJDRQty * 100.0
        / SUM(TotalJDRQty) OVER (PARTITION BY JDRUnit),
        2
    ) AS JDRContributionPercentage
FROM MethodTotals
ORDER BY
    JDRUnit,
    JDRContributionPercentage DESC;
