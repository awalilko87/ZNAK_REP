SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormRights_GetByID](
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS

    SELECT UserID, FormID
    FROM VS_FormRights
    WHERE FormID LIKE @FormID AND UserID LIKE @UserID
GO