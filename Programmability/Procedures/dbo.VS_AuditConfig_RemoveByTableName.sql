SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_AuditConfig_RemoveByTableName](
    @TableName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_AuditConfig
            WHERE TableName = @TableName
GO