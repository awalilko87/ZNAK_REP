SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MobileUsers_Update]
(
 @p_UserID nvarchar(20)
 ,@p_UserName nvarchar(100)
 ,@p_rowguid nvarchar(50) output
 ,@p_orgguid nvarchar(50)
 ,@p_Password_old nvarchar(50)
 ,@p_Password_new nvarchar(50)
 ,@p_Password_new2 nvarchar(50)
)
as
BEGIN
	IF @p_rowguid is null
	BEGIN
		IF EXISTS (select 1 from MobileUsers where UserID = @p_UserID)
		BEGIN
			raiserror('Podany login już istnieje.',16,1)
			return 1
		END

		set @p_rowguid = convert(nvarchar(50),newid())
		insert into MobileUsers (UserID, UserName, [Password], Module, UserGroupID, [LangID], [Admin], NoActive, orgguid, rowguid)
		select
			@p_UserID
			,@p_UserName
			,1
			,'ZMT'
			,'ADMIN'
			,'PL'
			,0
			,0
			,@p_orgguid
			,@p_rowguid
	END

	ELSE IF @p_rowguid is not null and @p_Password_new is null and @p_Password_new2 is null
	BEGIN
		update MobileUsers set
			UserID = @p_UserID
			,UserName = @p_UserName
		where convert(nvarchar(50),rowguid) = @p_rowguid
	END

	ELSE IF @p_rowguid is not null and @p_Password_old is not null 
		and @p_Password_new is not null and @p_Password_new2 is not null
	BEGIN
		IF NOT EXISTS (select 1 from MobileUsers 
					where convert(nvarchar(50),rowguid) = @p_rowguid 
					and [Password] = @p_Password_old)
		BEGIN
			raiserror('Podane stare hasło jest błędne.',16,1)
			return 1
		END

		IF @p_Password_new <> @p_Password_new2
		BEGIN
			raiserror ('Nowe oraz powtórzone hasło muszą być takie same.',16,1)
			return 1
		END

		IF @p_Password_new = @p_Password_old or @p_Password_old = @p_Password_new2
		BEGIN
			raiserror ('Nowe hasło jest takie samo jak stare.',16,1)
			return 1
		END

		UPDATE MobileUsers set [Password] = @p_Password_new 
		where convert(nvarchar(50),rowguid) = @p_rowguid
	END

END
GO