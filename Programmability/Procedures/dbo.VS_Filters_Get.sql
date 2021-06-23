SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, TableName, GroupID, UserID, IsPrivate,
        SqlWhere /*, _USERID_ */ 
    FROM VS_Filters
GO