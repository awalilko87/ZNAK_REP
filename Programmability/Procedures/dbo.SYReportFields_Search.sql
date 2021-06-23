SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_Search](
    @ReportID nvarchar(50),
    @FieldID nvarchar(50),
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

    SELECT
        ReportID, FieldID, Caption, FieldType, RowSQL,
        AllowEmpty, EmptyValue, OrderByClause, DefLength, DefListHeight,
        SQLFieldToDisp, SQLFieldToKey, HostFieldName, DefaultValue, Height,
        Width, NoUsed, Description /*, _USERID_ */ 
    FROM SYReportFields
            /* WHERE Caption = @Caption AND FieldType = @FieldType AND RowSQL = @RowSQL AND AllowEmpty = @AllowEmpty AND EmptyValue = @EmptyValue AND
            OrderByClause = @OrderByClause AND DefLength = @DefLength AND DefListHeight = @DefListHeight AND SQLFieldToDisp = @SQLFieldToDisp AND SQLFieldToKey = @SQLFieldToKey AND
            HostFieldName = @HostFieldName AND DefaultValue = @DefaultValue AND Height = @Height AND NoUsed = @NoUsed AND Description = @Description /*  AND _USERID_ = @_USERID_ */ */
GO