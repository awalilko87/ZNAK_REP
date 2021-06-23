SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Audit_GetByRowID](
    @TableName nvarchar(50),
	@FieldName nvarchar(50),
	@RowID nvarchar(400),
	@DateFrom datetime,
	@DateTo datetime,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
SET @DateTo = @DateTo + 1
    SELECT
        AuditID, TableName, FieldName, RowID, UserID,
        DateWhen, OldValue, NewValue /*, _USERID_ */ 
    FROM VS_Audit
         WHERE TableName = @TableName AND FieldName = @FieldName AND RowID = @RowID AND DateWhen >= @DateFrom AND DateWhen <= @DateTo
	ORDER BY DateWhen
GO