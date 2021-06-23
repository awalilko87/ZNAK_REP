SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_SetAutoRefresh](
  @UserID nvarchar(30),
	@SessionID nvarchar(50),
  @IsAutoRefresh bit
 
)
WITH ENCRYPTION
AS


  UPDATE SYUserActivity
  SET IsAutoRefresh = @IsAutoRefresh
		 /*, Login = @Login*/ /* , _USERID_ = @_USERID_ */ 
  WHERE [UserID] = @UserID  and  SessionID = @SessionID 
  
GO