SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_PSP_Insert_Proc] 
as 
begin

	declare @c_ROWID int
		, @c_PSPNR nvarchar(50)
		, @c_POSID nvarchar(50)
		, @c_PSPHI nvarchar(30)
		, @c_POSKI nvarchar(50)
		, @c_BANFN nvarchar(30)
		, @c_EBELN nvarchar(30)
		
	declare @v_ITSID int
		, @v_PSP_CODE nvarchar(30)
		, @v_STSID int
		, @v_OBJ_PSPID int 
		, @v_INOID int
		, @v_OBJID_MAIN int
		, @v_STNID int
		, @v_apperrortext nvarchar(4000) = null 
	
	declare PSP_inserted cursor static for
	select top 2000
		ROWID, PSPNR, POSID, PSPHI, POSKI, BANFN, EBELN from [dbo].[IE2_PSP] (nolock)
	where 
		isnull([DOC_NEW_INSERTED],0) = 1
		and POSKI <> ''
	order by ROWID asc;
	--select ROWID,PSPNR, POSID, * from ie2_PSP_BAK
 
	open PSP_inserted

	fetch next from PSP_inserted
	into @c_ROWID, @c_PSPNR, @c_POSID, @c_PSPHI, @c_POSKI, @c_BANFN, @c_EBELN
	
	while @@fetch_status = 0 
	begin
	
	set @v_ITSID = NULL 
	 
		select @v_ITSID = ITS_ROWID from INVTSK (nolock) join IE2_INW (nolock) on ITS_SAP_POSID = IE2_INW.POSID where IE2_INW.PSPHI = @c_PSPHI
		select @v_PSP_CODE = @c_POSKI
			--SUBSTRING(@c_POSID,1,7) + 
			--case when SUBSTRING(@c_POSID,8,3) = '' then '' else '/' + isnull(SUBSTRING(@c_POSID,8,3),'') end + 
			--case when SUBSTRING(@c_POSID,11,3) = '' then '' else '/' + isnull(SUBSTRING(@c_POSID,11,3),'') end +  
			--case when SUBSTRING(@c_POSID,14,3) = '' then '' else '/' + isnull(SUBSTRING(@c_POSID,14,3),'') end
			
		if not exists (select * from dbo.PSP (nolock) where PSP_CODE = @c_POSKI) 
		begin
			
			insert into [dbo].[PSP] 
				(PSP_CODE, 
				PSP_ORG, PSP_DESC, PSP_CREUSER, PSP_CREDATE, PSP_UPDUSER, PSP_UPDDATE, PSP_NOTUSED, PSP_SAP_ACTIVE, PSP_ITSID, PSP_SAP_PSPHI,
				PSP_SAP_PSPNR, PSP_SAP_POST1, PSP_SAP_POSID, PSP_SAP_OBJNR, PSP_SAP_ERNAM, PSP_SAP_ERDAT, PSP_SAP_AENAM, PSP_SAP_AEDAT, PSP_SAP_STSPR, PSP_SAP_VERNR, PSP_SAP_VERNA, PSP_SAP_ASTNR, PSP_SAP_ASTNA, PSP_SAP_VBUKR, PSP_SAP_VGSBR, PSP_SAP_VKOKR, PSP_SAP_PRCTR, PSP_SAP_PWHIE, PSP_SAP_ZUORD, PSP_SAP_PLFAZ, PSP_SAP_PLSEZ, PSP_SAP_KALID, PSP_SAP_VGPLF, PSP_SAP_EWPLF, PSP_SAP_ZTEHT, PSP_SAP_PLNAW, PSP_SAP_PROFL, PSP_SAP_BPROF, PSP_SAP_TXTSP, PSP_SAP_KOSTL, PSP_SAP_KTRG, PSP_SAP_SCPRF, PSP_SAP_IMPRF, PSP_SAP_PPROF, PSP_SAP_ZZKIER, PSP_SAP_STUFE, PSP_SAP_BANFN, PSP_SAP_BNFPO, PSP_SAP_ZEBKN, PSP_SAP_EBELN, PSP_SAP_EBELP, PSP_SAP_ZEKKN)
			select 
				@v_PSP_CODE, 
				'PKN', cast(POST1 as nvarchar(80)), 'SA', getdate(), NULL, NULL, 0, Active,@v_ITSID, PSPHI,
				PSPNR, POST1, POSID, OBJNR, ERNAM, ERDAT, AENAM, AEDAT, STSPR, VERNR, VERNA, ASTNR, ASTNA, VBUKR, VGSBR, VKOKR, PRCTR, PWHIE, ZUORD, PLFAZ, PLSEZ, KALID, VGPLF, EWPLF, ZTEHT, PLNAW, PROFL, BPROF, TXTSP, KOSTL, KTRG, SCPRF, IMPRF, PPROF, ZZKIER, STUFE, BANFN, BNFPO, ZEBKN, EBELN, EBELP, ZEKKN
			
			from IE2_PSP where ROWID = @c_ROWID
		end
		else 
		begin
		  
			update PSP 
			set 
				PSP_CODE = @v_PSP_CODE,
				PSP_ORG = 'PKN',
				PSP_DESC = cast(POST1 as nvarchar(80)),
				PSP_UPDUSER = 'SA',
				PSP_UPDDATE = getdate(), 
				PSP_NOTUSED = 0,
				PSP_SAP_ACTIVE = Active,
				PSP_SAP_PSPNR = PSPNR,
				PSP_SAP_POST1 = POST1,
				PSP_SAP_POSID = POSID,
				PSP_SAP_OBJNR = OBJNR,
				PSP_SAP_ERNAM = ERNAM,
				PSP_SAP_ERDAT = ERDAT,
				PSP_SAP_AENAM = AENAM,
				PSP_SAP_AEDAT = AEDAT,
				PSP_SAP_STSPR = STSPR,
				PSP_SAP_VERNR = VERNR,
				PSP_SAP_VERNA = VERNA,
				PSP_SAP_ASTNR = ASTNR,
				PSP_SAP_ASTNA = ASTNA,
				PSP_SAP_VBUKR = VBUKR,
				PSP_SAP_VGSBR = VGSBR,
				PSP_SAP_VKOKR = VKOKR,
				PSP_SAP_PRCTR = PRCTR,
				PSP_SAP_PWHIE = PWHIE,
				PSP_SAP_ZUORD = ZUORD,
				PSP_SAP_PLFAZ = PLFAZ,
				PSP_SAP_PLSEZ = PLSEZ,
				PSP_SAP_KALID = KALID,
				PSP_SAP_VGPLF = VGPLF,
				PSP_SAP_EWPLF = EWPLF,
				PSP_SAP_ZTEHT = ZTEHT,
				PSP_SAP_PLNAW = PLNAW,
				PSP_SAP_PROFL = PROFL,
				PSP_SAP_BPROF = BPROF,
				PSP_SAP_TXTSP = TXTSP,
				PSP_SAP_KOSTL = KOSTL,
				PSP_SAP_KTRG = KTRG,
				PSP_SAP_SCPRF = SCPRF,
				PSP_SAP_IMPRF = IMPRF,
				PSP_SAP_PPROF = PPROF,
				PSP_SAP_ZZKIER = ZZKIER,
				PSP_SAP_STUFE = STUFE,
				PSP_SAP_BANFN = BANFN,
				PSP_SAP_BNFPO = BNFPO,
				PSP_SAP_ZEBKN = ZEBKN,
				PSP_SAP_EBELN = EBELN,
				PSP_SAP_EBELP = EBELP,
				PSP_SAP_ZEKKN = ZEKKN,
				PSP_SAP_PSPHI = PSPHI,
				PSP_ITSID = @v_ITSID
			from PSP (nolock) 
				join IE2_PSP (nolock) on PSP_SAP_POSID = POSID where IE2_PSP.ROWID = @c_ROWID 

		end
		
		update [dbo].[IE2_PSP] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
/*		
		select top 1 @v_STSID = STS_ROWID from [dbo].[STENCIL] (nolock) where STS_AUTO_PSP = @v_PSP_CODE
		select	@v_OBJ_PSPID = PSP_ROWID from PSP (nolock) where PSP_CODE = @v_PSP_CODE
		
		select top 1 @v_STNID = STN_ROWID
			from STATION (nolock) 
				join INVTSK_STATIONS (nolock) on INS_STNID = STN_ROWID
				join INVTSK (nolock) on ITS_ROWID = INS_ITSID
			where ITS_SAP_PSPHI = @c_PSPHI
			order by STN_DESC
			
		if 
			@c_EBELN is not null  --wprowadzone zamówienie
			and @v_STSID is not null  --szablon
			and @v_OBJ_PSPID is not null --element PSP zamówienia
			and @v_STNID is not null --do zadania jest podpięta stacja paliw
		begin
			
			
			exec [dbo].[GenStsObj] @v_STSID, @v_OBJ_PSPID, NULL, @v_STNID, 'SA', @v_OBJID_MAIN output, @v_apperrortext output

			insert into [dbo].[INVTSK_NEW_OBJ] (INO_STSID, INO_PSPID, INO_ORG, INO_STNID)
			select @v_STSID, @v_OBJ_PSPID, 'PKN', @v_STNID
			
			select @v_INOID = ident_current('[dbo].[INVTSK_NEW_OBJ]')
			
			update [dbo].[OBJ] set OBJ_INOID = @v_INOID where /*OBJ_STSID = @v_STSID and*/ OBJ_PSPID = @v_OBJ_PSPID
				  	 
		end
		else if @c_EBELN is not null  --wprowadzone zamówienie
			and (@v_STSID is null  --brak szablonu 
			or @v_OBJ_PSPID is null -- brak element PSP zamówienia
			or @v_STNID is null) -- nie podłączona stacja paliw
		begin
		
			update [dbo].[IE2_PSP] set [DOC_NEW_INSERTED] = 1 where ROWID = @c_ROWID
		
		end
*/		 
		fetch next from PSP_inserted
		into @c_ROWID, @c_PSPNR, @c_POSID, @c_PSPHI, @c_POSKI, @c_BANFN, @c_EBELN
	end

	close PSP_inserted
	deallocate PSP_inserted

end 
  
 
GO