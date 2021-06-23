SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_Search](
    @FileID int,
    @FileName nvarchar(300),
    @FileSize int,
    @FileContentType nvarchar(255),
    @TableName nvarchar(50),
    @ID nvarchar(50),
    @Alt nvarchar(100),
    @Description nvarchar(250),
    @CreateDate datetime,
    @FilePath nvarchar(150),
	@FileID2 nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FileID, [FileName], FileSize, FileContentType, img, TableName,
        ID, Alt, [Description], CreateDate, FilePath, FileID2, PathID /*, _USERID_ */ 
    FROM SYFiles
            /* WHERE FileName = @FileName AND FileSize = @FileSize AND FileContentType = @FileContentType AND TableName = @TableName AND ID = @ID AND
            Alt = @Alt AND Description = @Description AND CreateDate = @CreateDate AND FilePath = @FilePath /*  AND _USERID_ = @_USERID_ */ */
GO