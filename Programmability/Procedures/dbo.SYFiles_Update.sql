SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYFiles_Update](
    @FileID int OUT,
    @FileName nvarchar(300),
    @FileSize int,
    @FileContentType nvarchar(255),
    @Img image = null,
    @TableName nvarchar(50),
    @ID nvarchar(50),
    @Alt nvarchar(100),
    @Description nvarchar(250),
	@FilePath nvarchar(150),
	@FileID2 nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM SYFiles WHERE FileID = @FileID)
BEGIN
    INSERT INTO SYFiles(
        [FileName], FileSize, FileContentType, img, [ID], TableName,
        Alt, [Description], FilePath /*, _USERID_ */ )
    VALUES (
        @FileName, @FileSize, @FileContentType, @Img, @ID, @TableName,
        @Alt, @Description, @FilePath /*, p_USERID_ */ )
	SET @FileID = @@IDENTITY
	IF @FileID is null
	  SET @FileID = 0
END
ELSE
BEGIN
    UPDATE SYFiles SET
        FileName = @FileName, FileSize = @FileSize, FileContentType = @FileContentType, img = @Img, TableName = @TableName, ID = @ID,
        Alt = @Alt, Description = @Description, FilePath = @FilePath /* , _USERID_ = @_USERID_ */ 
        WHERE FileID = @FileID
END
GO