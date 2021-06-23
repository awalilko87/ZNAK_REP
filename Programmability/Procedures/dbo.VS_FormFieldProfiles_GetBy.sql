SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFieldProfiles_GetBy](
    @UserID varchar(50) = NULL,
    @FormID nvarchar(50) = NULL
)
WITH ENCRYPTION
AS
    SELECT FormID, FieldID, UserID, GridColIndex, GridColWidth, GridColVisible, GridColCaption
    FROM VS_FormFieldProfiles(NOLOCK)
    WHERE ((UserID=@UserID) OR(@UserID IS NULL)) AND ((FormID=@FormID)OR(@FormID IS NULL))
GO