SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_Remove2](
    @FileID2 nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYFiles
            WHERE FileID2 = @FileID2
GO