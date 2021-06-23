SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_Get](
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
GO