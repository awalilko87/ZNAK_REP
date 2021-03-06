SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_AuditConfig_GetEnableByTableName](
    @TableName nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName, FieldName, EnableAudit /*, _USERID_ */ 
    FROM VS_AuditConfig
         WHERE TableName = @TableName AND EnableAudit = 1
GO