SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create PROCEDURE [dbo].[SYS_LANGMSGS_KPI_Update](
    @Caption nvarchar(4000),
    @OLD_Caption nvarchar(4000),
    @ControlID nvarchar(50) OUT,
    @OLD_ControlID nvarchar(50) OUT,
    @LangID nvarchar(10) OUT,
    @OLD_LangID nvarchar(10) OUT,
    @ObjectID nvarchar(150) OUT,
    @OLD_ObjectID nvarchar(150) OUT,
    @ObjectType nvarchar(20) OUT,
    @OLD_ObjectType nvarchar(20) OUT, 
    @_UserID nvarchar(30), 
    @_GroupID nvarchar(20), 
    @_LangID varchar(10)
)
AS
BEGIN TRAN 

DECLARE @Msg nvarchar(500), @IsErr bit
SELECT @Msg = '', @IsErr = 0 
 
--select @Msg = isnull(@ObjectID,'null')
--set @IsErr = 1


/* Error management */
IF @IsErr = 1
BEGIN
   GOTO ERR
END
 
IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE ObjectType = @OLD_ObjectType and ControlID = @OLD_ControlID AND LangID = @OLD_LangID)
BEGIN

INSERT INTO VS_LangMsgs(
    [Caption], [ControlID], [LangID], [ObjectID], [ObjectType]/*, [_UserID], [_GroupID], [_LangID]*/)
VALUES (
    @Caption, @ControlID, @LangID, @ObjectID, @ObjectType/*, @_UserID, @_GroupID, @_LangID*/)
END 
ELSE
 
BEGIN 

UPDATE VS_LangMsgs SET
    [Caption] = @Caption, [ControlID] = @ControlID, [LangID] = @LangID, [ObjectID] = @ObjectID, [ObjectType] = @ObjectType 
    WHERE ObjectType = @OLD_ObjectType and ControlID = @OLD_ControlID AND LangID = @OLD_LangID
END 
 
/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
   RETURN
ERR:
   IF @@TRANCOUNT>0 ROLLBACK TRAN
      RAISERROR(@Msg, 16, 1)
GO