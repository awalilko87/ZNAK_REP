SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OBJ_STS_Change](
@p_OBJID int
,@p_STSID int
,@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)

	declare @v_GROUP nvarchar(30)
	declare @v_GROUP_old nvarchar(30)
	declare @v_STN nvarchar(30)
	declare @v_PRO_VALUE nvarchar(80)
	declare @v_PRO_NVALUE numeric(24,6)
	declare @v_PRO_DVALUE datetime
	declare @v_STSID_old int

	declare @c_ASP_PROID int    
	declare @c_ASP_PM nvarchar(30)    
	declare @c_ASP_VALUE nvarchar(500)    
	declare @c_TYPE nvarchar(30) 

	if @p_STSID is null
	begin
		set @v_errortext = 'Szablon nie istnieje lub jest nieaktywny'
		goto errorlabel
	end

	select
		@v_GROUP = OBG_CODE
	from dbo.STENCIL
	inner join dbo.OBJGROUP on OBG_ROWID = STS_GROUPID
	where STS_ROWID = @p_STSID

	select
		 @v_GROUP_old = OBG_CODE
		,@v_STSID_old = OBJ_STSID
	from dbo.OBJ
	inner join dbo.OBJGROUP on OBG_ROWID = OBJ_GROUPID
	where OBJ_ROWID = @p_OBJID

	--if @v_GROUP <> @v_GROUP_old
	--begin
	--	set @v_errortext = 'Wybrany szablon jest z innej grupy niż urządzenie'
	--	goto errorlabel
	--end

	if @p_STSID = @v_STSID_old
	begin
		set @v_errortext = 'Należy wybrać inny szablon niż dotychczasowy'
		goto errorlabel
	end

	begin try
		update dbo.OBJ set
			 OBJ_DESC = STS_DESC
			,OBJ_TYPE = STS_TYPE
			,OBJ_TYPE2 = STS_TYPE2
			,OBJ_TYPE3 = STS_TYPE3
			,OBJ_GROUPID = STS_GROUPID
			,OBJ_VALUE = STS_VALUE
			,OBJ_SIGNED = STS_SIGNED
			,OBJ_SIGNLOC = STS_SIGNLOC
			,OBJ_STSID = STS_ROWID
			,OBJ_PM_TOSEND = STS_PM_TOSEND
		from dbo.STENCIL
		where OBJ_ROWID = @p_OBJID and STS_ROWID = @p_STSID

		update dbo.ASTINW_NEW_OBJ set
			ANO_STSID = @p_STSID
		from dbo.OBJ
		where OBJ_ANOID = ANO_ROWID
		and OBJ_ROWID = @p_OBJID

		delete from dbo.PROPERTYVALUES where PRV_ENT = 'OBJ' and PRV_PKID = @p_OBJID 
					and not exists (select 1 from dbo.ADDSTSPROPERTIES where ASP_STSID = @p_STSID and ASP_PROID = PRV_PROID)

		declare asp_cur cursor for select ASP_PROID, PRO_PM_KLASA+'-'+PRO_PM_CECHA, ASP_VALUE, PRO_TYPE 
									from dbo.ADDSTSPROPERTIES 
									join dbo.PROPERTIES on PRO_ROWID = ASP_PROID 
									where ASP_STSID = @p_STSID
									and not exists (select 1 from dbo.PROPERTYVALUES where PRV_PKID = @p_OBJID and PRV_ENT = 'OBJ' and PRV_PROID = ASP_PROID)
		open asp_cur
		fetch next from asp_cur into @c_ASP_PROID, @c_ASP_PM, @c_ASP_VALUE, @c_TYPE
		while @@fetch_status = 0
		begin
			select @v_PRO_VALUE = null, @v_PRO_NVALUE = null, @v_PRO_DVALUE = null

			if @c_TYPE = 'NTX'
				set @v_PRO_NVALUE = replace(@c_ASP_VALUE ,',','.')
			else if @c_TYPE = 'DTX'
				set @v_PRO_DVALUE = @c_ASP_VALUE
			else
				set @v_PRO_VALUE = case when @c_ASP_PM = 'ITOB-TPLNR' then replace(@c_ASP_VALUE, '++++', right('0000'+isnull(@v_STN,''),4)) else @c_ASP_VALUE end
      
			if exists (select 1 from dbo.PROPERTYVALUES where PRV_PKID = @p_OBJID and PRV_PROID = @c_ASP_PROID)
			begin
				insert into dbo.PROPERTYVALUES (PRV_PROID, PRV_PKID, PRV_ENT, PRV_VALUE, PRV_NVALUE, PRV_DVALUE, PRV_UPDATECOUNT, PRV_CREATED)
				values (@c_ASP_PROID, @p_OBJID, 'OBJ', @v_PRO_VALUE, @v_PRO_NVALUE, @v_PRO_DVALUE, 1, getdate())
			end
			else
			begin
				update dbo.PROPERTYVALUES set
					 PRV_VALUE = @v_PRO_VALUE
					,PRV_NVALUE = @v_PRO_NVALUE
					,PRV_DVALUE = @v_PRO_DVALUE
					,PRV_UPDATECOUNT = PRV_UPDATECOUNT+1
					,PRV_UPDATED = getdate()
				where PRV_PKID = @p_OBJID and PRV_PROID = @c_ASP_PROID
			end  

			fetch next from asp_cur into @c_ASP_PROID, @c_ASP_PM, @c_ASP_VALUE, @c_TYPE
		end
		deallocate asp_cur

		insert into dbo.VS_Audit(AuditID, TableName, FieldName, RowID, TableRowID, OldValue, NewValue, DateWhen, SystemID, Oper, UserID)
		values(newid(), 'OBJ', 'OBJ_STSID', @p_OBJID, @p_OBJID, @v_STSID_old, @p_STSID, getdate(), 'ZMT', 'ZMIANA', @p_UserID)
	end try
	begin catch
		if cursor_status('global', 'asp_cur') = 1
			deallocate asp_cur
		set @v_errortext = error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO