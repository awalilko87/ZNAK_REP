SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_Update](
    @UserID nvarchar(30) OUT,
    @FormID nvarchar(50) OUT,
    @FieldID nvarchar(50) OUT,
    @Rights nvarchar(4000),
    @Cond nvarchar(100) OUT,
    @rReadOnly nvarchar(4000),
    @rVisible nvarchar(4000),
    @rRequire nvarchar(4000),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @Cond is null
    SET @Cond = ''

IF @FieldID is null
    SET @FieldID = NewID()
IF @FieldID =''
    SET @FieldID = NewID()
IF @FormID is null
    SET @FormID = NewID()
IF @FormID =''
    SET @FormID = NewID()
IF @UserID is null
    SET @UserID = NewID()
IF @UserID =''
    SET @UserID = NewID()

IF NOT EXISTS (SELECT null FROM VS_Rights WHERE Cond = @Cond AND FieldID = @FieldID AND FormID = @FormID AND UserID = @UserID)
BEGIN
    INSERT INTO VS_Rights(
        UserID, FormID, FieldID, Rights, Cond,
        rReadOnly, rVisible, rRequire /*, _USERID_ */ )
    VALUES (
        @UserID, @FormID, @FieldID, @Rights, @Cond,
        @rReadOnly, @rVisible, @rRequire /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_Rights SET
        Rights = @Rights, rReadOnly = @rReadOnly, rVisible = @rVisible, rRequire = @rRequire /* , _USERID_ = @_USERID_ */ 
        WHERE Cond = @Cond AND FieldID = @FieldID AND FormID = @FormID AND UserID = @UserID
END
GO