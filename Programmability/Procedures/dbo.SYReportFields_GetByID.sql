SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_GetByID](
    @FieldID nvarchar(50) = '%',
    @ReportID nvarchar(50) = '%',
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
    WHERE FieldID LIKE @FieldID AND ReportID LIKE @ReportID
GO