SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_AuditConfig_Search](
    @TableName nvarchar(50),
    @FieldName nvarchar(50),
    @EnableAudit bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName, FieldName, EnableAudit /*, _USERID_ */ 
    FROM VS_AuditConfig
            /* WHERE EnableAudit = @EnableAudit /*  AND _USERID_ = @_USERID_ */ */
GO