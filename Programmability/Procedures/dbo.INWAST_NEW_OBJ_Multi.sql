SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_NEW_OBJ_Multi](
@p_KEY nvarchar(max),
@p_STS nvarchar(30),
@p_STNID int,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_SIAID int
	declare @v_OBJ nvarchar(30)
	declare @v_SETTYPE nvarchar(30)
	
	declare @c_ASTID int
	
	select @v_SETTYPE = STS_SETTYPE from dbo.STENCIL where STS_CODE = @p_STS
	
	if @v_SETTYPE in ('ZES','KOM') and (select count(*) from dbo.VS_Split3(@p_KEY, ';') where String <> '') > 1
	begin
		set @v_errortext = 'Dla szablonów ZESTAW i KOMPLET wymagane jest wybranie tylko jednego składnika'
		goto errorlabel
	end
	
	declare CC cursor for select String from dbo.VS_Split3(@p_KEY, ';') where String <> ''
	open CC
	fetch next from CC into @c_ASTID
	while @@fetch_status = 0
	begin		
		begin try
			exec dbo.INWAST_NEW_OBJ_Update_Proc @c_ASTID, @p_STS, @p_STNID, @p_UserID
		end try
		begin catch
			deallocate CC
			set @v_errortext = error_message()
			goto errorlabel
		end catch
		
		fetch next from CC into @c_ASTID
	end
	deallocate CC
	
	return 0
	
errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end

GO