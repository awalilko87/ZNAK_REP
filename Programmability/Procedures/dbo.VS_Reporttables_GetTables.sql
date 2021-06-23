SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_GetTables](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName--, FieldName, Description /*, _USERID_ */ 
    FROM VS_Reporttables
	GROUP BY TableName
GO