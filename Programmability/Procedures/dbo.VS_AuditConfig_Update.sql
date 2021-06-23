SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_AuditConfig_Update](
    @TableName nvarchar(50) OUT,
    @FieldName nvarchar(50) OUT,
    @EnableAudit bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FieldName is null
    SET @FieldName = NewID()
IF @FieldName =''
    SET @FieldName = NewID()
IF @TableName is null
    SET @TableName = NewID()
IF @TableName =''
    SET @TableName = NewID()

IF NOT EXISTS (SELECT * FROM VS_AuditConfig WHERE FieldName = @FieldName AND TableName = @TableName)
BEGIN
    INSERT INTO VS_AuditConfig(
        TableName, FieldName, EnableAudit /*, _USERID_ */ )
    VALUES (
        @TableName, @FieldName, @EnableAudit /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_AuditConfig SET
        EnableAudit = @EnableAudit /* , _USERID_ = @_USERID_ */ 
        WHERE FieldName = @FieldName AND TableName = @TableName
END
GO