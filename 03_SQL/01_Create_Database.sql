/*
UARU FPSO NDT Operations Analytics
Script 01: Create Database

Run this script first.
*/

IF DB_ID('Uaru_NDT_DW') IS NULL
BEGIN
    CREATE DATABASE Uaru_NDT_DW;
END;
GO

USE Uaru_NDT_DW;
GO
