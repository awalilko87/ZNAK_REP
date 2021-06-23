SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_Remove](
    @FieldName nvarchar(50),
    @TableName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Reporttables
            WHERE FieldName = @FieldName AND TableName = @TableName
GO