SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MobileUsers_UPDATE](
    @UserID nvarchar(20), 
    @UserName nvarchar(100), 
    @Password nvarchar(50), 
    @Module nvarchar(20), 
    @LangID nvarchar(10), 
    @Admin bit, 
    @NoActive bit, 
    @orgguid uniqueidentifier, 
    @rowguid uniqueidentifier, 
    @UserGroupID nvarchar(20)
) AS
IF NOT EXISTS (SELECT * FROM [MobileUsers] WHERE [UserID] = @UserID)
    INSERT INTO [MobileUsers] ([UserID], [UserName], [Password], [Module], [LangID], [Admin], [NoActive], [orgguid], [rowguid], [UserGroupID])
    VALUES (@UserID, @UserName, @Password, @Module, @LangID, @Admin, @NoActive, @orgguid, @rowguid, @UserGroupID)
ELSE
    UPDATE [MobileUsers] SET [UserID] = @UserID, [UserName] = @UserName, [Password] = @Password, [Module] = @Module, [LangID] = @LangID, [Admin] = @Admin, [NoActive] = @NoActive, [orgguid] = @orgguid, [rowguid] = @rowguid, [UserGroupID] = @UserGroupID WHERE [UserID] = @UserID
GO