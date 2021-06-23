SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetAccess](
	@UserID nvarchar(30),
	@ModuleName varchar(50),
	@TabGroup nvarchar(50) = null,
	@FormID nvarchar(50) = null,
  @MenuToolTip nvarchar(1000)
)
WITH ENCRYPTION
AS
BEGIN
IF @TabGroup is null SET @TabGroup = ''
IF @FormID is null SET @FormID = ''

IF @UserID = 'SA'
	SELECT 1
ELSE
	IF EXISTS (
	  SELECT SYMenus.ModuleName AS Col
	  FROM SYMenus 
	    INNER JOIN SYUserMenu on SYUserMenu.MenuKey = SYMenus.MenuKey
	  WHERE SYMenus.ModuleName = @ModuleName AND SYUserMenu.UserID = @UserID
      AND SYUserMenu.ModuleCode = @ModuleName AND SYMenus.MenuToolTip LIKE '%' + @MenuToolTip + '%'
		UNION
		SELECT TabGroup AS Col FROM VS_TabRights WHERE UserID = @UserID AND TabGroup = @TabGroup
		UNION
		SELECT FormID AS Col FROM VS_FormRights WHERE UserID = @UserID AND FormID = @FormID) 
		SELECT 1
	ELSE
		SELECT 0
END

GO