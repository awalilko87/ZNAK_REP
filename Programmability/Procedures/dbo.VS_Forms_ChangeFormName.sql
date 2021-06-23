SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_ChangeFormName](
    @OLD_FormID nvarchar(50),
	@FormID nvarchar(50)
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT FormID FROM VS_Forms WHERE FormID = @FormID)
BEGIN
	UPDATE VS_Forms SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_FormFields SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_DataSpy SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID 

	UPDATE VS_Filters SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_FormProfiles SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_LangMsgs SET
		ObjectID = @FormID
	WHERE
		ObjectID = @OLD_FormID

	UPDATE VS_Rights SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_Tabs SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID

	UPDATE VS_TLines SET
		FormID = @FormID
	WHERE
		FormID = @OLD_FormID
	SELECT 1	
END
ELSE
BEGIN
	SELECT 0
END
GO