SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_ClearTimeout](
	@UserID nvarchar(50),
	@SessionID nvarchar(50),
	@TimeOut int
)

AS
	if ISNULL(@SessionID,'') = ''
		return 0;

	if(isnull(@UserID,'') = '')
		return 0;

	if(isnull(@TimeOut, 0) = 0)
		return 0;

	if exists (select null from SYUserActivity where UserID = @UserID and SessionID = @SessionID and dateadd(minute, @TimeOut, LastUpdate) <= GetDate())
		delete SYUserActivity where UserID = @UserID and SessionID = @SessionID

    select * from SYUserActivity where UserID = @UserID and SessionID = @SessionID
GO