SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_Update2](
    @FileID2 nvarchar(50) OUTPUT,
    @FileName nvarchar(300),
    @FileSize int,
    @FileContentType nvarchar(255),
    @Img image= null,
    @TableName nvarchar(50),
    @ID nvarchar(50),
    @Alt nvarchar(100),
    @Description nvarchar(250),
	@FilePath nvarchar(150),
	@FileID nvarchar(50),	
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FileID2 is null
    SET @FileID2 = NewID()
IF @FileID2 =''
    SET @FileID2 = NewID()

IF NOT EXISTS (SELECT * FROM SYFiles WHERE FileID2 = @FileID2)
BEGIN
    INSERT INTO SYFiles(
        [FileName], FileSize, FileContentType, img, [ID], TableName,
        Alt, [Description], FilePath, FileID2, PathID /*, _USERID_ */ )
    VALUES (
        @FileName, @FileSize, @FileContentType, @Img, @ID, @TableName,
        @Alt, @Description, @FilePath, @FileID2, CASE WHEN ISNULL(@FilePath,'') ='' THEN NULL ELSE @FileID2  END /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYFiles SET
        [FileName] = @FileName, FileSize = @FileSize, FileContentType = @FileContentType, img = @Img, TableName = @TableName, ID = @ID,
        Alt = @Alt, [Description] = @Description, FilePath = @FilePath /* , _USERID_ = @_USERID_ */ 
        WHERE FileID2 = @FileID2
END
GO