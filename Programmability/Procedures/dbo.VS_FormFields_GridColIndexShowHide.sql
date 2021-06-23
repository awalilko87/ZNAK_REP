SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GridColIndexShowHide](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

DECLARE @tmpGridColIndex int, @type nvarchar(10)

SELECT @tmpGridColIndex = GridColIndex FROM VS_FormFields WHERE FieldID = @FieldID AND FormID = @FormID

IF (@tmpGridColIndex = 0)
    BEGIN
	UPDATE VS_FormFields SET
	    GridColIndex = 1
	        WHERE FieldID = @FieldID AND FormID = @FormID
    END
ELSE
    BEGIN
	UPDATE VS_FormFields SET
	    GridColIndex = 0
	        WHERE FieldID = @FieldID AND FormID = @FormID
    END
GO