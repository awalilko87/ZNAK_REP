SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Audit_Search](
    @AuditID nvarchar(50),
    @TableName nvarchar(50),
    @FieldName nvarchar(50),
    @RowID nvarchar(400),
    @UserID nvarchar(30),
    @DateWhen datetime,
    @OldValue nvarchar(max),
    @NewValue nvarchar(max),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        AuditID, TableName, FieldName, RowID, UserID,
        DateWhen, OldValue, NewValue /*, _USERID_ */ 
    FROM VS_Audit
            /* WHERE TableName = @TableName AND FieldName = @FieldName AND RowID = @RowID AND UserID = @UserID AND DateWhen = @DateWhen AND
            OldValue = @OldValue AND NewValue = @NewValue /*  AND _USERID_ = @_USERID_ */ */
GO