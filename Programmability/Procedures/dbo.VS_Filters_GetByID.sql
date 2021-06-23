SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_GetByID](
    @FormID nvarchar(50) = '%',
    @GroupID nvarchar(20) = '%',
    @UserID nvarchar(30) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, TableName, GroupID, UserID, IsPrivate,
        SqlWhere /*, _USERID_ */ 
    FROM VS_Filters
         WHERE FormID LIKE @FormID AND GroupID LIKE @GroupID AND UserID LIKE @UserID
GO