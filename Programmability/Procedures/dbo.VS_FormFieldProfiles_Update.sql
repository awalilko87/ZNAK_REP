SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFieldProfiles_Update](
	   @FormID nvarchar(50) OUT
      ,@FieldID nvarchar(50) OUT
      ,@UserID nvarchar(30)
      ,@GridColIndex nvarchar(50)
      ,@GridColWidth nvarchar(50)
      ,@GridColVisible nvarchar(50)
      ,@GridColCaption nvarchar(50)
      )
WITH ENCRYPTION
AS
	IF NOT EXISTS (SELECT * FROM VS_FormFieldProfiles(NOLOCK) WHERE FieldID = @FieldID AND FormID = @FormID and UserID = @UserID)
	BEGIN
			INSERT INTO VS_FormFieldProfiles(FormID, FieldID, UserID, GridColIndex, GridColWidth, GridColVisible
				, GridColCaption)
			VALUES(@FormID, @FieldID, @UserID, @GridColIndex, @GridColWidth, @GridColVisible
				, @GridColCaption)
	END
	ELSE
	BEGIN
		UPDATE VS_FormFieldProfiles SET GridColIndex = @GridColIndex, GridColWidth = @GridColWidth, GridColVisible = @GridColVisible
				, GridColCaption = @GridColCaption
		WHERE FormID = @FormID AND FieldID = @FieldID AND UserID = @UserID
	END
GO