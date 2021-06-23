SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormRights_GetByUserID](
    @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS

    SELECT UserID, FormID
    FROM VS_FormRights
    WHERE UserID = @UserID
GO