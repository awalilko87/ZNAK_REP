SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ActValuesRequest](
@p_ENTITY nvarchar(30),
@p_ENTID int,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_LASTDATE datetime
	declare @v_LASTSTATUS int

	select top 1
		 @v_LASTDATE = SAV_CREDATE
		,@v_LASTSTATUS = SAV_SASROWID
	from dbo.SAPIO_ActValuesHeaders
	where SAV_ENTITY = @p_ENTITY and SAV_ENTID = @p_ENTID
	
	if datediff(ss, @v_LASTDATE, getdate()) < 120 or @v_LASTSTATUS <= 401
	begin
		return 0
	end

	begin try
		create table #SAV_ASSETS (AST_ROWID int)

		if @p_ENTITY = 'POT'
		begin
			insert into #SAV_ASSETS
			select distinct AST_ROWID 
			from dbo.OBJTECHPROTLN
			join dbo.OBJASSETv on OBJ_ROWID = POL_OBJID
			where 1=1
			and POL_POTID = @p_ENTID
		end
		else if @p_ENTITY = 'OT11'
		begin
			insert into #SAV_ASSETS
			select distinct AST_ROWID
			from dbo.SAPO_ZWFOT11
			inner join dbo.ASSET on AST_CODE = OT11_ANLN1_POSKI and AST_SUBCODE = '0000'
			where 1=1
			and OT11_IF_STATUS <> 4
			and OT11_ZMT_ROWID = @p_ENTID 
		end
		else if @p_ENTITY = 'OT42'
		begin
			insert into #SAV_ASSETS
			select distinct AST_ROWID
			from dbo.SAPO_ZWFOT42LN
			inner join dbo.SAPO_ZWFOT42 on OT42_ROWID = OT42LN_OT42ID  
			inner join dbo.ZWFOTLN on OTL_ROWID = OT42LN_ZMT_ROWID
			inner join dbo.ASSET on AST_CODE = OT42LN_ANLN1_POSKI and AST_SUBCODE = OT42LN_ANLN2
			where 1=1
			and OT42_IF_STATUS <> 4
			and isnull(OTL_NOTUSED,0) = 0
			and OT42_ZMT_ROWID = @p_ENTID 
		end
		else if @p_ENTITY = 'OT41'
		begin
			insert into #SAV_ASSETS
			select distinct AST_ROWID
			from dbo.SAPO_ZWFOT41LN
			inner join dbo.SAPO_ZWFOT41 on OT41_ROWID = OT41LN_OT41ID  
			inner join dbo.ZWFOTLN on OTL_ROWID = OT41LN_ZMT_ROWID
			inner join dbo.ASSET on AST_CODE = OT41LN_ANLN1_POSKI
			where 1=1
			and OT41_IF_STATUS <> 4
			and isnull(OTL_NOTUSED,0) = 0
			and OT41_ZMT_ROWID = @p_ENTID 
		end
		else if @p_ENTITY = 'OBJ'
		begin
			insert into #SAV_ASSETS
			select distinct AST_ROWID
			from dbo.OBJASSETv
			where 1=1
			and OBJ_ROWID = @p_ENTID
			and AST_NOTUSED = 0
		end

		exec dbo.SAPIO_ActValuesHeader_Add null, null, @p_ENTITY, @p_ENTID, @p_UserID, null
	end try
	begin catch
		set @v_errortext = error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO