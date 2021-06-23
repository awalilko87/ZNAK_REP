SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_GetByFormID](
    @FormID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, TableName, GroupID, UserID, IsPrivate,
        SqlWhere /*, _USERID_ */ 
    FROM VS_Filters
         WHERE FormID = @FormID
GO