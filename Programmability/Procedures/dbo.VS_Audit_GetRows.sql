SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Audit_GetRows](
    @TableName nvarchar(50),
	@FieldName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    SELECT
        RowID /*, _USERID_ */ 
    FROM VS_Audit
         WHERE TableName = @TableName AND FieldName = @FieldName
	GROUP BY RowID
GO