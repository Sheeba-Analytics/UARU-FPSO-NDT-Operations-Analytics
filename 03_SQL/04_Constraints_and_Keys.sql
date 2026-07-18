/*
UARU FPSO NDT Operations Analytics
Script 04: Primary Keys and Foreign Keys

Run after the dimension and fact data have been loaded.
*/

USE Uaru_NDT_DW;
GO

ALTER TABLE dbo.dim_method
ADD CONSTRAINT PK_dim_method
PRIMARY KEY (MethodKey);
GO

ALTER TABLE dbo.dim_discipline
ADD CONSTRAINT PK_dim_discipline
PRIMARY KEY (DisciplineKey);
GO

ALTER TABLE dbo.dim_module
ADD CONSTRAINT PK_dim_module
PRIMARY KEY (ModuleKey);
GO

ALTER TABLE dbo.dim_calendar
ADD CONSTRAINT PK_dim_calendar
PRIMARY KEY (DateKey);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT PK_fact_ndt_inspection
PRIMARY KEY (InspectionID);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT FK_fact_method
FOREIGN KEY (MethodKey)
REFERENCES dbo.dim_method(MethodKey);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT FK_fact_discipline
FOREIGN KEY (DisciplineKey)
REFERENCES dbo.dim_discipline(DisciplineKey);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT FK_fact_module
FOREIGN KEY (ModuleKey)
REFERENCES dbo.dim_module(ModuleKey);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT FK_fact_requestdate
FOREIGN KEY (RequestDateKey)
REFERENCES dbo.dim_calendar(DateKey);
GO

ALTER TABLE dbo.fact_ndt_inspection
ADD CONSTRAINT FK_fact_jdrdate
FOREIGN KEY (JDRDateKey)
REFERENCES dbo.dim_calendar(DateKey);
GO

-- Verify primary-key constraints
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY TABLE_NAME;
GO

-- Verify foreign-key relationships
SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS FactTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS FactColumn,
    OBJECT_NAME(fk.referenced_object_id) AS DimensionTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS DimensionColumn
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY fk.name;
GO
