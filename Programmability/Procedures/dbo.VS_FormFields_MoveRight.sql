SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_MoveRight](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

--declare @maxNoColumn int
--SELECT TOP 1 @maxNoColumn = NoColumn FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoColumn DESC 
declare @tmpNoColumn int
declare @tmpFieldID nvarchar(50)
declare @tmpNoRow int
SELECT @tmpNoColumn = NoColumn + 1, @tmpNoRow = NoRow FROM VS_FormFields WHERE FieldID = @FieldID AND FormID = @FormID

--IF (@tmpNoColumn <= @maxNoColumn)
--BEGIN
    IF EXISTS (SELECT * FROM VS_FormFields WHERE FormID = @FormID AND NoColumn = @tmpNoColumn AND NoRow = @tmpNoRow)
    BEGIN 
        SELECT @tmpFieldID = FieldID FROM VS_FormFields WHERE FormID = @FormID AND NoColumn = @tmpNoColumn AND NoRow = @tmpNoRow
        UPDATE VS_FormFields SET
	    NoColumn = NoColumn - 1
	        WHERE FormID = @FormID AND FieldID = @tmpFieldID
        UPDATE VS_FormFields SET
	    NoColumn = NoColumn + 1
	        WHERE FormID = @FormID AND FieldID = @FieldID
    END
    ELSE
    BEGIN
        UPDATE VS_FormFields SET
	    NoColumn = NoColumn + 1
	        WHERE FormID = @FormID AND FieldID = @FieldID
    END
--END

GO