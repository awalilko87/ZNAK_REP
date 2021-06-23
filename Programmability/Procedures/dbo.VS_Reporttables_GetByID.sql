SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_GetByID](
    @FieldName nvarchar(50) = '%',
    @TableName nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName, FieldName, Description /*, _USERID_ */ 
    FROM VS_Reporttables
         WHERE FieldName LIKE @FieldName AND TableName LIKE @TableName
GO