SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFieldProfiles_Remove](
    @FieldID varchar(50) = NULL,
    @FormID nvarchar(50) = NULL
)
WITH ENCRYPTION
AS
    DELETE FROM VS_FormFieldProfiles WHERE FieldID = @FieldID AND FormID = @FormID
GO