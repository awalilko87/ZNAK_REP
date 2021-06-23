SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reporttables_Search](
    @TableName nvarchar(50),
    @FieldName nvarchar(50),
    @Description nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TableName, FieldName, Description /*, _USERID_ */ 
    FROM VS_Reporttables
            /* WHERE Description = @Description /*  AND _USERID_ = @_USERID_ */ */
GO