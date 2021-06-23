SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_SetGridColumns](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS
	DECLARE cur CURSOR KEYSET FOR
	SELECT FieldID
		FROM VS_FormFields
	WHERE FormID = @FormID AND GridColIndex > 0 AND GridColWidth >= 0 AND NotUse = 0 
	ORDER BY GridColIndex, Caption

	DECLARE @FieldID nvarchar(50)
	DECLARE @ColIndex int
	SET @ColIndex = 1

	OPEN cur
	 
	FETCH NEXT FROM cur INTO @FieldID
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			UPDATE VS_FormFields SET GridColIndex = @ColIndex WHERE FormID = @FormID AND FieldID = @FieldID
			SET @ColIndex = @ColIndex + 1
		END

		FETCH NEXT FROM cur INTO @FieldID
	END
	CLOSE cur
	DEALLOCATE cur
GO