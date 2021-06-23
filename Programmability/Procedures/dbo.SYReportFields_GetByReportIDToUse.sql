SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_GetByReportIDToUse](
    @ReportID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, FieldID, Caption, FieldType, RowSQL,
        AllowEmpty, EmptyValue, OrderByClause, DefLength, DefListHeight,
        SQLFieldToDisp, SQLFieldToKey, HostFieldName, DefaultValue, Height,
        Width, NoUsed, '' AS Description /*, _USERID_ */ 
    FROM SYReportFields
         WHERE ReportID = @ReportID AND NoUsed <> 1
	ORDER BY OrderByClause
GO