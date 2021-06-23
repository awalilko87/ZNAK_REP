SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SYUsers_Create_Administrator] (
@_UserID nvarchar(30) = null,
@_Password nvarchar(30) = null
)
as
IF EXISTS (SELECT null FROM DBO.SYUsers WHERE UserID = @_UserID)
BEGIN
  UPDATE DBO.SYUsers SET Admin = 1
    , UserGroupID = 'ADMIN'
    , Password = @_Password 
  WHERE UserID = @_UserID
END
ELSE
BEGIN
  INSERT INTO DBO.SYUsers (UserID, UserName, Password, LangID, Admin, UserGroupID)
  SELECT @_UserID, 'Administrator', @_Password, 'PL', 1, 'ADMIN'
END

GO