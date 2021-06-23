SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabRights_Remove](
    @TabGroup nvarchar(50),
    @UserID nvarchar(30)
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_TabRights
            WHERE TabGroup = @TabGroup AND UserID = @UserID
GO