SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormRights_Remove](
    @FormID nvarchar(50),
    @UserID nvarchar(30)
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_FormRights
            WHERE FormID = @FormID AND UserID = @UserID
GO