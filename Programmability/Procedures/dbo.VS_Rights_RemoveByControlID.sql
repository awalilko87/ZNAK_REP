SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_RemoveByControlID](
    @FormID nvarchar(50),
	@FieldID nvarchar(50),
	@Cond nvarchar(100)
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Rights
            WHERE FormID = @FormID AND FieldID = @FieldID AND Cond = @Cond
GO