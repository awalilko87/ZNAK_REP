SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Filters_Remove](
    @FormID nvarchar(50),
    @GroupID nvarchar(20),
    @UserID nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Filters
            WHERE FormID = @FormID AND GroupID = @GroupID AND UserID = @UserID
GO