SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--exec [dbo].[VS_SyUsersMenu_Rec]
--@p_MENU = @RV_GRID_GroupKey,  
--@p_FIDP = @QS_FID,   
--@p_FID = @QS_FID,  
--@p_Module = @_AppCode,
--@p_UserID = @_UserID

--exec [dbo].[VS_SyUsersMenu_Rec]
--@p_MENU = 'ZMT_RST',  
--@p_FIDP = '',   
--@p_FID = '',  
--@p_Module = 'ZMT',
--@p_UserID = 'TEST'

CREATE procedure [dbo].[VS_SyUsersMenu_Rec] 
( 
	@p_MENU nvarchar(80),
	@p_FIDP nvarchar(50), 
    @p_FID nvarchar(50), 
	@p_Module nvarchar(50), 
    @p_UserID nvarchar(30)
)
as
begin
 
	SELECT TOP 1 
  *
	FROM [dbo].[VS_SyUsersMenu] sym (NOLOCK)  
 	WHERE 1 = 1 AND @p_MENU = isnull(sym.MenuKey, @p_MENU) and @p_Module = isnull(ModuleCode, @p_Module) and @p_UserID = isnull(UserID,@p_UserID)
end













GO