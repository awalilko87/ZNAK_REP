SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormProfiles_Remove](
    @FormID nvarchar(50),
    @UserID nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_FormProfiles
            WHERE FormID = @FormID AND UserID = @UserID
GO