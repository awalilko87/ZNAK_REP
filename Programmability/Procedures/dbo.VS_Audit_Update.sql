SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Audit_Update](
    @AuditID nvarchar(50) OUT,
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

IF @AuditID is null
    SET @AuditID = NewID()
IF @AuditID =''
    SET @AuditID = NewID()

IF NOT EXISTS (SELECT * FROM VS_Audit WHERE AuditID = @AuditID)
BEGIN
    INSERT INTO VS_Audit(
        AuditID, TableName, FieldName, RowID, UserID,
        DateWhen, OldValue, NewValue /*, _USERID_ */ )
    VALUES (
        @AuditID, @TableName, @FieldName, @RowID, @UserID,
        @DateWhen, @OldValue, @NewValue /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_Audit SET
        TableName = @TableName, FieldName = @FieldName, RowID = @RowID, UserID = @UserID, DateWhen = @DateWhen,
        OldValue = @OldValue, NewValue = @NewValue /* , _USERID_ = @_USERID_ */ 
        WHERE AuditID = @AuditID
END
GO