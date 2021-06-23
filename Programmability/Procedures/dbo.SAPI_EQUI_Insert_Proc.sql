SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SAPI_EQUI_Insert_Proc] 
as 
begin
return
--	declare 
--		@c_ROWID int
--		, @c_POSKI nvarchar(50)
 
--	declare INW_inserted cursor static for
--	select top 1000
--		ROWID, POSKI from [dbo].[IE2_EQUI] (nolock)
--	where 
--		isnull([DOC_NEW_INSERTED],0) = 1	 
--		--and POSKI <> ''
--		and kostl like '%7091462'
--	order by ROWID asc;
--	--select ROWID, POSID, * from ie2_INW
--	--update [IE2_EQUI] set [DOC_NEW_INSERTED] = 1 where kostl like '%7091462'

--	open INW_inserted

--	fetch next from INW_inserted
--	into @c_ROWID, @c_POSID, @c_PSPHI, @c_POSKI
	
--	while @@fetch_status = 0 
--	begin
	  
--		if not exists (select ITS_SAP_POSID from INVTSK (nolock) where ITS_CODE = @c_POSKI/*ITS_SAP_POSID = @c_POSID*/) 
--		begin
--			insert into  dbo.INVTSK 
--				(ITS_CODE, ITS_ORG, ITS_DESC, ITS_CREUSER, ITS_CREDATE, ITS_UPDUSER, ITS_UPDDATE, ITS_NOTUSED, ITS_SAP_ACTIVE, ITS_SAP_PSPHI,ITS_SAP_POSKI,
--				ITS_SAP_PSPNR, ITS_SAP_POST1, ITS_SAP_POSID, ITS_SAP_OBJNR, ITS_SAP_ERNAM, ITS_SAP_ERDAT, ITS_SAP_AENAM, ITS_SAP_AEDAT, ITS_SAP_STSPR, ITS_SAP_VERNR, ITS_SAP_VERNA, ITS_SAP_ASTNR, ITS_SAP_ASTNA, ITS_SAP_VBUKR, ITS_SAP_VGSBR, ITS_SAP_VKOKR, ITS_SAP_PRCTR, ITS_SAP_PWHIE, ITS_SAP_ZUORD, ITS_SAP_PLFAZ, ITS_SAP_PLSEZ, ITS_SAP_KALID, ITS_SAP_VGPLF, ITS_SAP_EWPLF, ITS_SAP_ZTEHT, ITS_SAP_PLNAW, ITS_SAP_PROFL, ITS_SAP_BPROF, ITS_SAP_TXTSP, ITS_SAP_KOSTL, ITS_SAP_KTRG, ITS_SAP_SCPRF, ITS_SAP_IMPRF, ITS_SAP_PPROF, ITS_SAP_ZZKIER, ITS_SAP_STUFE, ITS_SAP_BANFN, ITS_SAP_BNFPO, ITS_SAP_ZEBKN, ITS_SAP_EBELN, ITS_SAP_EBELP, ITS_SAP_ZEKKN)
--			select 
--				@c_POSKI, 'PKN', cast(POST1 as nvarchar(80)), 'SA', getdate(), NULL, NULL, 0, Active, PSPHI,POSKI,
--				PSPNR, POST1, POSID, OBJNR, ERNAM, ERDAT, AENAM, AEDAT, STSPR, VERNR, VERNA, ASTNR, ASTNA, VBUKR, VGSBR, VKOKR, PRCTR, PWHIE, ZUORD, PLFAZ, PLSEZ, KALID, VGPLF, EWPLF, ZTEHT, PLNAW, PROFL, BPROF, TXTSP, KOSTL, KTRG, SCPRF, IMPRF, PPROF, ZZKIER, STUFE, BANFN, BNFPO, ZEBKN, EBELN, EBELP, ZEKKN
			
--			from IE2_INW (nolock) where ROWID = @c_ROWID
--		end
--		else 
--		begin
--			update dbo.INVTSK 
--			set  
--				ITS_CODE = @c_POSKI,
--				ITS_ORG = 'PKN',
--				ITS_DESC = cast(POST1 as nvarchar(80)),
--				ITS_UPDUSER = 'SA',
--				ITS_UPDDATE = getdate(), 
--				ITS_NOTUSED = 0, 
--				ITS_SAP_ACTIVE = Active, 
--				ITS_SAP_POST1 = POST1,
--				ITS_SAP_POSID = POSID,
--				ITS_SAP_OBJNR = OBJNR,
--				ITS_SAP_ERNAM = ERNAM,
--				ITS_SAP_ERDAT = ERDAT,
--				ITS_SAP_AENAM = AENAM,
--				ITS_SAP_AEDAT = AEDAT,
--				ITS_SAP_STSPR = STSPR,
--				ITS_SAP_VERNR = VERNR,
--				ITS_SAP_VERNA = VERNA,
--				ITS_SAP_ASTNR = ASTNR,
--				ITS_SAP_ASTNA = ASTNA,
--				ITS_SAP_VBUKR = VBUKR,
--				ITS_SAP_VGSBR = VGSBR,
--				ITS_SAP_VKOKR = VKOKR,
--				ITS_SAP_PRCTR = PRCTR,
--				ITS_SAP_PWHIE = PWHIE,
--				ITS_SAP_ZUORD = ZUORD,
--				ITS_SAP_PLFAZ = PLFAZ,
--				ITS_SAP_PLSEZ = PLSEZ,
--				ITS_SAP_KALID = KALID,
--				ITS_SAP_VGPLF = VGPLF,
--				ITS_SAP_EWPLF = EWPLF,
--				ITS_SAP_ZTEHT = ZTEHT,
--				ITS_SAP_PLNAW = PLNAW,
--				ITS_SAP_PROFL = PROFL,
--				ITS_SAP_BPROF = BPROF,
--				ITS_SAP_TXTSP = TXTSP,
--				ITS_SAP_KOSTL = KOSTL,
--				ITS_SAP_KTRG = KTRG,
--				ITS_SAP_SCPRF = SCPRF,
--				ITS_SAP_IMPRF = IMPRF,
--				ITS_SAP_PPROF = PPROF,
--				ITS_SAP_ZZKIER = ZZKIER,
--				ITS_SAP_STUFE = STUFE,
--				ITS_SAP_BANFN = BANFN,
--				ITS_SAP_BNFPO = BNFPO,
--				ITS_SAP_ZEBKN = ZEBKN,
--				ITS_SAP_EBELN = EBELN,
--				ITS_SAP_EBELP = EBELP,
--				ITS_SAP_ZEKKN = ZEKKN,
--				ITS_SAP_PSPHI = PSPHI,
--				ITS_SAP_POSKI = POSKI

--			from INVTSK (nolock) join IE2_INW on ITS_SAP_POSID = POSID where IE2_INW.ROWID = @c_ROWID 

--		end
		
--		--Aktualizacja elementów PSP które może się zdarzyć że przyjdą PRZED odpowiednim zadaniem inw
--		if exists (select PSP_SAP_PSPHI from dbo.PSP (nolock) where PSP_ITSID is null and PSP_SAP_PSPHI = @c_PSPHI)
--		begin
 
--			update PSP
--				set PSP_ITSID = ITS.ITS_ROWID			
--			from dbo.INVTSK (nolock) ITS
--				join dbo.PSP (nolock) PSP on PSP.PSP_SAP_PSPHI = ITS.ITS_SAP_PSPHI
--			where 
--				PSP.PSP_ITSID is null
--				and PSP.PSP_SAP_PSPHI = @c_PSPHI
--		end

--		update [dbo].[IE2_INW] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
			 
--		fetch next from INW_inserted
--		into @c_ROWID, @c_POSID, @c_PSPHI, @c_POSKI
--	end
	
--	close INW_inserted
--	deallocate INW_inserted
----	delete from ie2_equi where i_datetime > '2016-05-11 16:56:06.760'

----select * from ie2_equi_xls1

----update ie2_equi_xls1 set poski = cast(right(EQUNR,8) as nvarchar)


----update ie2_equi_xls1 set poski = cast(right(EQUNR,8) as nvarchar)


end 
  



GO