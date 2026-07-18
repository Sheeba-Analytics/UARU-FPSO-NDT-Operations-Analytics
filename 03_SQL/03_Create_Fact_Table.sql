/*
UARU FPSO NDT Operations Analytics
Script 03: Create Fact Table

The fact data is prepared in Python and loaded into SQL Server.
*/

USE Uaru_NDT_DW;
GO

DROP TABLE IF EXISTS dbo.fact_ndt_inspection;
GO

CREATE TABLE dbo.fact_ndt_inspection
(
    InspectionID        BIGINT         NOT NULL,
    RequestNo           VARCHAR(100)   NULL,
    RequestDateKey      BIGINT         NULL,
    JDRDateKey          BIGINT         NULL,
    DisciplineKey       BIGINT         NOT NULL,
    ModuleKey           BIGINT         NOT NULL,
    MethodKey           BIGINT         NOT NULL,
    RequestedQty        DECIMAL(18,2)  NULL,
    CompletedQty        DECIMAL(18,2)  NULL,
    JDRQty              DECIMAL(18,2)  NULL,
    IsRequestDateValid  BIT            NULL,
    IsJDRDateValid      BIT            NULL
);
GO
