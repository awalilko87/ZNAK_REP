SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_ManageGridColumn](
    @FormID nvarchar(50),
	@Visible bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
if (@Visible=1)
	UPDATE dbo.VS_FormFields SET GridColIndex = c.colorder 
		FROM dbo.VS_FormFields f, syscolumns c 
		WHERE  f.FieldName=c.name AND FormID = @FormID
else
	UPDATE dbo.VS_FormFields SET GridColIndex = 0 WHERE FormID = @FormID
GO