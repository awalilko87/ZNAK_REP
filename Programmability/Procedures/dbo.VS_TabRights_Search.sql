SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabRights_Search](
    @UserID nvarchar(30),
    @TabGroup nvarchar(50)
)
WITH ENCRYPTION
AS

    SELECT
        UserID, TabGroup
    FROM VS_TabRights
            /* WHERE */
GO