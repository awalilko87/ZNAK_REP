SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormRights_Update](
    @UserID nvarchar(30) OUT,
    @FormID nvarchar(50) OUT
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM VS_FormRights WHERE FormID = @FormID AND UserID = @UserID)
BEGIN
    INSERT INTO VS_FormRights(
        UserID, FormID)
    VALUES (
        @UserID, @FormID)
END
GO