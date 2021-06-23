SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabRights_Update](
    @UserID nvarchar(30) OUT,
    @TabGroup nvarchar(50) OUT
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM VS_TabRights WHERE TabGroup = @TabGroup AND UserID = @UserID)
BEGIN
    INSERT INTO VS_TabRights(
        UserID, TabGroup)
    VALUES (
        @UserID, @TabGroup)
END
GO