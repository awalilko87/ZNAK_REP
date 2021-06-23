SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_RemoveByFormID](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Rights
            WHERE FormID = @FormID
GO