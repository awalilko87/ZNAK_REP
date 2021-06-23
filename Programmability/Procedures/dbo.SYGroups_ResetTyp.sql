SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYGroups_ResetTyp]
WITH ENCRYPTION
AS

	DECLARE @GroupID nvarchar(20), @Typ nvarchar(50), @Typ2 nvarchar(50)
	DECLARE groupCursor CURSOR FOR SELECT GroupID, Typ FROM SYGroups
	OPEN groupCursor
	FETCH NEXT FROM groupCursor INTO @GroupID, @Typ
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@Typ = 'PR')
		BEGIN
			SET @Typ = 'PE' 	
			UPDATE SYGroups 
			SET Typ = @Typ, Typ2 = UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@GroupID+'VISION'+@Typ)))
			WHERE GroupID = @GroupID 
		END
		FETCH NEXT FROM groupCursor INTO @GroupID, @Typ
	END
	CLOSE groupCursor
	DEALLOCATE groupCursor
GO