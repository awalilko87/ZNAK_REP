SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_GetByID2](
    @FileID2 nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FileID2, [FileName], FileSize, FileContentType, img, TableName,
        ID, Alt, [Description], CreateDate, FilePath, FileID, PathID /*, _USERID_ */ 
    FROM SYFiles
         WHERE FileID2 LIKE @FileID2
GO