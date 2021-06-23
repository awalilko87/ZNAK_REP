SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_GetByTableName](
    @TableName nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName, FieldName, Description /*, _USERID_ */ 
    FROM VS_Reporttables
         WHERE TableName = @TableName
GO