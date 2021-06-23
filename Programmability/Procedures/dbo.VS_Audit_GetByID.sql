SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Audit_GetByID](
    @AuditID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        AuditID, TableName, FieldName, RowID, UserID,
        DateWhen, OldValue, NewValue /*, _USERID_ */ 
    FROM VS_Audit
         WHERE AuditID LIKE @AuditID
GO