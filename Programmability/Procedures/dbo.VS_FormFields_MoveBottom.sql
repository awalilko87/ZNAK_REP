SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_MoveBottom](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

--declare @maxNoRow int
--SELECT TOP 1 @maxNoRow = NoRow FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoRow DESC 
declare @tmpNoRow int
declare @tmpFieldID nvarchar(50)
declare @tmpNoColumn int
SELECT @tmpNoRow = NoRow + 1, @tmpNoColumn = NoColumn FROM VS_FormFields WHERE FieldID = @FieldID AND FormID = @FormID

--IF (@tmpNoRow <= @maxNoRow)
--BEGIN
    IF EXISTS (SELECT * FROM VS_FormFields WHERE FormID = @FormID AND NoRow = @tmpNoRow AND NoColumn = @tmpNoColumn)
    BEGIN 
        SELECT @tmpFieldID = FieldID FROM VS_FormFields WHERE FormID = @FormID AND NoRow = @tmpNoRow AND NoColumn = @tmpNoColumn
        UPDATE VS_FormFields SET
	    NoRow = NoRow - 1
	        WHERE FormID = @FormID AND FieldID = @tmpFieldID
        UPDATE VS_FormFields SET
	    NoRow = NoRow + 1
	        WHERE FormID = @FormID AND FieldID = @FieldID
    END
    ELSE
    BEGIN
        UPDATE VS_FormFields SET
	    NoRow = NoRow + 1
	        WHERE FormID = @FormID AND FieldID = @FieldID
    END
--END

GO