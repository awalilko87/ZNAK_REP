SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFieldProfiles_Get]
WITH ENCRYPTION
AS
    SELECT FormID, FieldID, UserID, GridColIndex, GridColWidth, GridColVisible, GridColCaption
    FROM VS_FormFieldProfiles(NOLOCK)
GO