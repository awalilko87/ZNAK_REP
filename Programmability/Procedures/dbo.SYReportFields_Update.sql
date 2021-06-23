SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_Update](
    @ReportID nvarchar(50) OUT,
    @FieldID nvarchar(50) OUT,
    @Caption nvarchar(100),
    @FieldType nvarchar(1),
    @RowSQL nvarchar(500),
    @AllowEmpty bit,
    @EmptyValue nvarchar(1),
    @OrderByClause numeric(18,5),
    @DefLength numeric(18,5),
    @DefListHeight numeric(18,5),
    @SQLFieldToDisp nvarchar(50),
    @SQLFieldToKey nvarchar(50),
    @HostFieldName nvarchar(50),
    @DefaultValue nvarchar(500),
    @Height int,
    @Width int,
    @NoUsed bit,
    @Description nvarchar(max) = null,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FieldID is null
    SET @FieldID = NewID()
IF @FieldID =''
    SET @FieldID = NewID()
IF @ReportID is null
    SET @ReportID = NewID()
IF @ReportID =''
    SET @ReportID = NewID()

IF NOT EXISTS (SELECT * FROM SYReportFields WHERE FieldID = @FieldID AND ReportID = @ReportID)
BEGIN
    INSERT INTO SYReportFields(
        ReportID, FieldID, Caption, FieldType, RowSQL,
        AllowEmpty, EmptyValue, OrderByClause, DefLength, DefListHeight,
        SQLFieldToDisp, SQLFieldToKey, HostFieldName, DefaultValue, Height,
        Width, NoUsed, Description /*, _USERID_ */ )
    VALUES (
        @ReportID, @FieldID, @Caption, @FieldType, @RowSQL,
        @AllowEmpty, @EmptyValue, @OrderByClause, @DefLength, @DefListHeight,
        @SQLFieldToDisp, @SQLFieldToKey, @HostFieldName, @DefaultValue, @Height,
        @Width, @NoUsed, @Description /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYReportFields SET
        Caption = @Caption, FieldType = @FieldType, RowSQL = @RowSQL, AllowEmpty = @AllowEmpty, EmptyValue = @EmptyValue,
        OrderByClause = @OrderByClause, DefLength = @DefLength, DefListHeight = @DefListHeight, SQLFieldToDisp = @SQLFieldToDisp,
        SQLFieldToKey = @SQLFieldToKey,HostFieldName = @HostFieldName, DefaultValue = @DefaultValue, Height = @Height,
        Width = @Width, NoUsed = @NoUsed, Description = @Description /* , _USERID_ = @_USERID_ */ 
        WHERE FieldID = @FieldID AND ReportID = @ReportID
END
GO