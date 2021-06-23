SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GridColIndexBottom](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

	UPDATE VS_FormFields 
	SET GridColIndex = GridColIndex + 1
	WHERE FieldID = @FieldID AND FormID = @FormID
GO