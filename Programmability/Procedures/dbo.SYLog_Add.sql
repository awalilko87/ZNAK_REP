SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SYLog_Add](
	@UserID nvarchar(30) = null,
    @Operation nvarchar(4000) = null,
    @Created datetime = null,
    @Type nvarchar(50) = null,
	@SessionID nvarchar(50) = null)
WITH ENCRYPTION
AS
IF @Created IS NULL
	SET @Created = convert(datetime,getdate())

INSERT INTO [dbo].[SYLog]
           ([UserID], [Operation], [Created], [Type], [SessionID])
     VALUES
           (@UserID, @Operation, @Created, @Type, @SessionID)
GO