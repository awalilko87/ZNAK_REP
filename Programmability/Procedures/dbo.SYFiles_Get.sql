SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FileID, [FileName], FileSize, FileContentType, img, TableName,
        ID, Alt, [Description], CreateDate, FilePath, FileID2, PathID /*, _USERID_ */ 
    FROM SYFiles
GO