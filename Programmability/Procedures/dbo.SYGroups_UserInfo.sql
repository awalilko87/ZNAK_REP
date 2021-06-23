SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYGroups_UserInfo](
    @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS
	--Procedura tylko dla araddina
    --SELECT
    --    UserID = @UserID, '' GroupID, '' LangID /*, _USERID_ */ 
	
	if exists(select * from SYUsers where UserID = @UserID)
		select
            UserID = @UserID, UserGroupID GroupID, LangID, ManageDataSpy
        from SYUsers 
		where UserID = @UserID
	else
		select
            UserID = @UserID, usr_group GroupID, usr_lang LangID, case USR_EDITDATASPY when '+' then 1 else 0 end ManageDataSpy
        from r5users 
		where usr_code = @UserID

GO