SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_Remove](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_FormFields
            WHERE FieldID = @FieldID AND FormID = @FormID
            
	/*
	Usunięcie definicji pola, domyślnego filtra na formatce
    */
    UPDATE VS_Forms
    SET DefFField = NULL
    WHERE FormID = @FormID
    AND DefFField is not NULL
    AND isnull(ltrim(rtrim(DefFField)),'') = isnull(ltrim(rtrim(@FieldID)),'')
GO