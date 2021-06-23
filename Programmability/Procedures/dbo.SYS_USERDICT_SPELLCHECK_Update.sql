SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 
CREATE PROCEDURE [dbo].[SYS_USERDICT_SPELLCHECK_Update](
    @Caption nvarchar(4000) = NULL,
    @OLD_Caption nvarchar(4000) = NULL,
    @ControlID nvarchar(50) = NULL OUT,
    @OLD_ControlID nvarchar(50) = NULL OUT,
    @LangID nvarchar(10) = NULL OUT,
    @OLD_LangID nvarchar(10) = NULL OUT,
    @ObjectID nvarchar(150) = NULL OUT,
    @OLD_ObjectID nvarchar(150) = NULL OUT,
    @ObjectType nvarchar(20) = NULL OUT,
    @OLD_ObjectType nvarchar(20) = NULL OUT 
  
)
WITH ENCRYPTION
AS
BEGIN TRAN 

 
DECLARE @Msg nvarchar(500), @IsErr bit
SELECT @Msg = '', @IsErr = 0 
 
/* Error management */
IF @IsErr = 1
BEGIN
   SET @Msg = '<b>Komunikat bledu</b>'
   GOTO ERR
END

IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE ControlID = @ControlID AND LangID = @LangID AND ObjectID = @ObjectID AND ObjectType = @ObjectType)
BEGIN
INSERT INTO VS_LangMsgs(
    [Caption], [ControlID], [LangID], [ObjectID], [ObjectType])
VALUES (
    @Caption, @Caption, @LangID, @ObjectID, @ObjectType)
END 
ELSE 
BEGIN 
UPDATE VS_LangMsgs SET
    [Caption] = @Caption, [ControlID] = @Caption, [LangID] = @LangID, [ObjectID] = @ObjectID, [ObjectType] = @ObjectType/*, [_UserID] = @_UserID, [_GroupID] = @_GroupID, [_LangID] = @_LangID*/ 
    WHERE ControlID = @OLD_ControlID AND LangID = @OLD_LangID AND ObjectID = @OLD_ObjectID AND ObjectType = @OLD_ObjectType
END 
 
/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
   RETURN
ERR:
   IF @@TRANCOUNT>0 ROLLBACK TRAN
      RAISERROR(@Msg, 16, 1)
GO