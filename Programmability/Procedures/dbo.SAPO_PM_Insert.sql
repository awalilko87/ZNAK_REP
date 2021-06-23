SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SAPO_PM_Insert] (
@p_OBJID int, 
@p_OPER_TYPE  nvarchar(30), 
@p_STATUS nvarchar(30),
@p_UserID nvarchar(30)
)
as
begin
	
	declare 
		@v_errorcode nvarchar(50)
		, @v_syserrorcode nvarchar(4000)
		, @v_errortext nvarchar(4000)
		, @v_PMID int 
		, @v_ITOBTPLNR_old nvarchar(30)
	declare @ci varbinary(128), @ci_old varbinary(128)
	
	set @ci_old = isnull(context_info(), 0x)
	
	if convert(varchar,@ci_old) = 'NOPM'
	begin
		return
	end

	if exists (select 1 from OBJ(nolock) where OBJ_ROWID = @p_OBJID and OBJ_PM_TOSEND = 1 and isnull(OBJ_PM, '') = case @p_OPER_TYPE when 'U' then OBJ_PM when 'I' then '' end 
				and OBJ_CODE like 'ZMTSP%'/*and OBJ_PSPID is not null*/)
	begin
		insert into dbo.SAPO_PM(PM_OPER_TYPE, PM_ZMT_EQUNR, PM_IF_STATUS, PM_IF_SENTDATE, PM_IF_ERR, PM_IF_EQUNR, PM_ZMT_ROWID, PM_SAPUSER)
		select @p_OPER_TYPE, OBJ_CODE, 0, NULL, NULL, NULL, OBJ_ROWID, NULL
		from OBJ (nolock)
		where 
			/*OBJ_PSPID is not null
			and */OBJ_ROWID = @p_OBJID

		select @v_PMID = scope_identity()

		insert into dbo.SAPO_PMLN(PMLN_PMID, PMLN_COL_NAME, PMLN_COL_VALUE)
		select @v_PMID, PRO_PM_CECHA = PKC_KLASA+PKC_TYP+PKC_CECHA, PRV_VALUE_LIST
		from PROPERTYVALUESv
		inner join PROPERTIES on PRO_ROWID = PRV_PROID 
		inner join dbo.PMKLASACECHA on PKC_KLASA = PRO_PM_KLASA and PKC_CECHA = PRO_PM_CECHA
		where PRV_ENT = 'OBJ' and PRV_PKID = @p_OBJID and PRV_VALUE_LIST is not null and isnull(PRV_TOSEND,0) = case when PKC_KLASA+PKC_TYP+PKC_CECHA = 'ITOB-TPLNR' then 1 else isnull(PRV_TOSEND,0) end
		
		union all
		
		select @v_PMID, 'EQUI-ZMT_EQUNR', p.OBJ_CODE
		from dbo.OBJ p
		inner join dbo.OBJ o on o.OBJ_PARENTID = p.OBJ_ROWID
		where o.OBJ_ROWID = @p_OBJID and o.OBJ_PARENTID <> o.OBJ_ROWID and p.OBJ_PM_TOSEND = 1
		
		union all
		
		select @v_PMID, COL, VAL
		from
			(select 
				 OBJ_ROWID
				,[EQUI-EQUNR] = convert(nvarchar(80),OBJ_PM)
				,[EQUI-STTXT] = STA_DESC
				,[EQUI-SERGE] = convert(nvarchar(80),OBJ_SERIAL)
				,[IBIPEQUI-EQKTX] = OBJ_DESC
				,[EQUI-ANLNR] = convert(nvarchar(80),AST_SAP_ANLN1)
				,[EQUI-ANLUN] = convert(nvarchar(80),AST_SAP_ANLN2)
				,[ITOB-ANSWT] = convert(nvarchar(80), convert(numeric(10,2), OBJ_VALUE))
			from dbo.OBJ
			join dbo.STA on STA_ENTITY = 'OBJ' and STA_CODE = isnull(@p_STATUS, OBJ_STATUS)
			outer apply (select top 1 AST_SAP_ANLN1, AST_SAP_ANLN2 from dbo.ASSET join dbo.OBJASSET on OBA_ASTID = AST_ROWID and OBA_OBJID = OBJ_ROWID order by AST_SUBCODE)ast)o
		unpivot
			(VAL for COL in
				([EQUI-STTXT], [EQUI-SERGE], [EQUI-EQUNR], [IBIPEQUI-EQKTX], [EQUI-ANLNR], [EQUI-ANLUN], [ITOB-ANSWT])
		) ou
		where OBJ_ROWID = @p_OBJID
		and COL <> case when @p_OPER_TYPE = 'U' then 'IBIPEQUI-EQKTX' else '' end

		set @ci = convert(varbinary(128),'RETURN')
		set context_info @ci
		update dbo.PROPERTYVALUES set PRV_TOSEND = null where PRV_PKID = @p_OBJID
		set context_info @ci_old

		update dbo.SAPO_PM set PM_IF_STATUS = 1 where PM_ROWID = @v_PMID
		
	end
	else if (select OBJ_CODE from OBJ(nolock) where OBJ_ROWID = @p_OBJID) like 'ZMT_BRAK_STACJI%'
	begin
		raiserror('Błędny kod składnika',16,1)
		return 1
	end
	else 
	begin
		select @v_errorcode = '001'
		goto errorlabel
	end

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		--raiserror (@v_errortext, 16, 1) 
		return 1

end
GO