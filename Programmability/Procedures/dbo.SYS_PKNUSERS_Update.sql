SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SYS_PKNUSERS_Update](
@p_UserID nvarchar(30),
@p_UserID_old nvarchar(30),
@p_ADLogin nvarchar(30),
@p_UserName nvarchar(100),
@p_FirstName nvarchar(30),
@p_LastName nvarchar(80),
@p_UserGroupID nvarchar(30),
@p_LangID nvarchar(10),
@p_DefUrl nvarchar(1000),
@p_Email nvarchar(80),
@p_MessagePhone nvarchar(50),
@p_SAPLogin nvarchar(30),
@p_SAPRealizator int,
@p_NoActive int
)
as
begin

	declare @v_errortext nvarchar(1000)

	begin try
		begin tran

		if @p_UserID_old is null
		begin
			if exists (select 1 from dbo.SYUsers where UserID = @p_UserID)
			begin
				raiserror('Użytkownik [%s] już istnieje w systemie.', 16, 1, @p_UserID)
			end

			if exists (select 1 from dbo.SYUsers where ADLogin = @p_ADLogin)
			begin
				raiserror('Użytkownik [%s] już istnieje w systemie.', 16, 1, @p_ADLogin)
			end

			insert into dbo.SYUsers(UserID, ADLogin, UserName, Password, UserGroupID, UserGroupID2, FirstName, LastName, Module, 
									Email, MessagePhone, LangID, DefUrl, AccountExpirationDate, NoActive, SAPLogin, SAPRealizator, CreatedOn)
			values(@p_UserID, @p_ADLogin, @p_UserName, '', @p_UserGroupID, upper(sys.fn_varbintohexstr(hashbytes('MD5',@p_UserID+'VISION'+@p_UserGroupID))), @p_FirstName, @p_LastName, 'ZMT',
					@p_Email, @p_MessagePhone, @p_LangID, @p_DefUrl, '99991231', @p_NoActive, @p_SAPLogin, @p_SAPRealizator, getdate())
		end
		else
		begin
			update dbo.SYUsers set
				UserName = @p_UserName
				,ADLogin = @p_ADLogin
				,UserGroupID = @p_UserGroupID
				,UserGroupID2 = upper(sys.fn_varbintohexstr(hashbytes('MD5',@p_UserID+'VISION'+@p_UserGroupID)))
				,FirstName = @p_FirstName
				,LastName = @p_LastName
				,Email = @p_Email
				,MessagePhone = @p_MessagePhone
				,LangID = @p_LangID
				,DefUrl = @p_DefUrl
				,NoActive = @p_NoActive
				,SAPLogin = @p_SAPLogin
				,SAPRealizator = @p_SAPRealizator
			where UserID = @p_UserID
		end

		commit tran
	end try
	begin catch
		rollback tran
		set @v_errortext = 'Błąd podczas zapisu: '+error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO