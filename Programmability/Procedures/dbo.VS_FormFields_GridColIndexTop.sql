SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GridColIndexTop](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

DECLARE @tmpGridColIndex int
SELECT @tmpGridColIndex = GridColIndex FROM VS_FormFields WHERE FieldID = @FieldID AND FormID = @FormID

IF (@tmpGridColIndex > 0)
    BEGIN
		UPDATE VS_FormFields 
		SET GridColIndex = GridColIndex - 1
		WHERE FieldID = @FieldID AND FormID = @FormID
    END
GO