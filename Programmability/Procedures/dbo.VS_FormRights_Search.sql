SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormRights_Search](
    @UserID nvarchar(30),
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

    SELECT
        UserID, FormID
    FROM VS_FormRights

GO