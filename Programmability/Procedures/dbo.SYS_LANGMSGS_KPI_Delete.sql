SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create PROCEDURE [dbo].[SYS_LANGMSGS_KPI_Delete](
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

/* Error management */
IF @IsErr = 1
BEGIN
   GOTO ERR
END
 
 DELETE VS_LangMsgs WHERE ObjectType = @ObjectType and ControlID = @ControlID AND LangID = @LangID
 
/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
   RETURN
ERR:
   IF @@TRANCOUNT>0 ROLLBACK TRAN
      RAISERROR(@Msg, 16, 1)
GO