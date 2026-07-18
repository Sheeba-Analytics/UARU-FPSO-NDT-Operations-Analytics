/*
UARU FPSO NDT Operations Analytics
Script 02: Create Dimension Tables

The dimension data is prepared in Python and loaded into SQL Server.
These table definitions document the dimensional model used by Power BI.
*/

USE Uaru_NDT_DW;
GO

DROP TABLE IF EXISTS dbo.dim_calendar;
DROP TABLE IF EXISTS dbo.dim_module;
DROP TABLE IF EXISTS dbo.dim_discipline;
DROP TABLE IF EXISTS dbo.dim_method;
GO

CREATE TABLE dbo.dim_method
(
    MethodKey          BIGINT        NOT NULL,
    Method             VARCHAR(20)   NOT NULL,
    MethodDescription  VARCHAR(100)  NULL,
    MethodCategory     VARCHAR(50)   NULL,
    JDRUnit            VARCHAR(10)   NULL,
    JDRDescription     VARCHAR(100)  NULL
);
GO

CREATE TABLE dbo.dim_discipline
(
    DisciplineKey  BIGINT       NOT NULL,
    Discipline     VARCHAR(50)  NOT NULL
);
GO

CREATE TABLE dbo.dim_module
(
    ModuleKey  BIGINT       NOT NULL,
    Module     VARCHAR(50)  NOT NULL
);
GO

CREATE TABLE dbo.dim_calendar
(
    DateKey      BIGINT       NOT NULL,
    [Date]       DATE         NOT NULL,
    [Year]       INT          NOT NULL,
    [Quarter]    VARCHAR(10)  NOT NULL,
    MonthNumber  INT          NOT NULL,
    MonthName    VARCHAR(20)  NOT NULL,
    MonthYear    VARCHAR(20)  NOT NULL,
    DayOfMonth   INT          NOT NULL,
    DayOfWeek    INT          NOT NULL,
    Weekday      VARCHAR(20)  NOT NULL,
    IsWeekend    VARCHAR(5)   NOT NULL
);
GO

/*
JDR units used in the project:
RT   -> Films
PMI  -> Pts
HT   -> Pts
UT   -> Mtr
PAUT -> Mtr
MT   -> Mtr
MPT  -> Mtr
PT   -> Mtr
DPT  -> Mtr
*/
