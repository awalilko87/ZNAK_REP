SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabRights_GetByUserID](
    @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS

    SELECT
        UserID, TabGroup
    FROM VS_TabRights
         WHERE UserID = @UserID
GO