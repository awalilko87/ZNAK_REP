SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[CPO_TYPE_DEL]
(
@TYP_CODE nvarchar(30)
,@TYP2_ROWID int
,@TYP2_CODE nvarchar(30)
)

AS
BEGIN 

	IF EXISTS (select 1 from OBJ where OBJ_TYPE = @TYP_CODE and OBJ_TYPE2 = @TYP2_CODE)
			BEGIN 
				RAISERROR ('Nie można usunąć podtypu! Istnieją w systemie obiekty powiązane z tym podtypem!',16,1)
			END
ELSE 
	BEGIN 
		DELETE FROM TYP2 WHERE TYP2_ROWID = @TYP2_ROWID
	END 

END
GO