SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabRights_GetByID](
    @TabGroup nvarchar(50) = '%',
    @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS

    SELECT
        UserID, TabGroup
    FROM VS_TabRights
         WHERE TabGroup LIKE @TabGroup AND UserID LIKE @UserID
GO