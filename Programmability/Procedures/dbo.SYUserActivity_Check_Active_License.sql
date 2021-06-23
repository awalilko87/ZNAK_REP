SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SYUserActivity_Check_Active_License](
 @status int OUT,
 @GroupId nvarchar(30)
)
WITH ENCRYPTION
AS

	  Declare @Count int,
			  @UserInGroup nvarchar(255),
			  @AvaliableLicences int

	  SET @UserInGroup = (select Typ from [SYGroups] where GroupID = @GroupId) 
	  Set @status = 0


	  IF(@UserInGroup = 'PE')
	  BEGIN
		  SET @Count =  (select count(UserGroupID) from [SYUsers] as u
							join [SYGroups] as g on u.UserGroupID = g.GroupID
							where u.UserID in (select UserID from [SYUserActivity]) and g.Typ = 'PE')	  	
		  SET @AvaliableLicences = CONVERT(int, (select SettingValue from SYSettings where KeyCode = 'LC'));

			IF(@Count > @AvaliableLicences)
				BEGIN
				Set @status = 1
				return
				END
	  END
	  ELSE IF(@UserInGroup = 'PR')
	  BEGIN

		  SET @Count =  (select count(UserGroupID) from [SYUsers] as u
						join [SYGroups] as g on u.UserGroupID = g.GroupID
						where u.UserID in (select UserID from [SYUserActivity]) and g.Typ = 'PR')

		  SET @AvaliableLicences =	CONVERT(int, (select SettingValue from SYSettings where KeyCode = 'LCP'))

		  IF(@Count > @AvaliableLicences)
		  BEGIN
		    Set @status = 2
			return
		  END

	  END
GO