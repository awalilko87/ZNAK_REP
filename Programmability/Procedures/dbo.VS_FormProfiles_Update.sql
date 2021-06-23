SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormProfiles_Update](
    @FormID nvarchar(50) OUT,
    @UserID nvarchar(30) OUT,
    @DefaultDataSpy nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @FormID is null
    SET @FormID = NewID()
IF @FormID =''
    SET @FormID = NewID()
IF @UserID is null
    SET @UserID = NewID()
IF @UserID =''
    SET @UserID = NewID()

IF NOT EXISTS (SELECT * FROM VS_FormProfiles WHERE FormID = @FormID AND UserID = @UserID)
BEGIN
    INSERT INTO VS_FormProfiles(
        FormID, UserID, DefaultDataSpy /*, _USERID_ */ )
    VALUES (
        @FormID, @UserID, @DefaultDataSpy /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_FormProfiles SET
        DefaultDataSpy = @DefaultDataSpy /* , _USERID_ = @_USERID_ */ 
        WHERE FormID = @FormID AND UserID = @UserID
END
GO