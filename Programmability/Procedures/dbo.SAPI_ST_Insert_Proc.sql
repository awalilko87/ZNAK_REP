SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SAPI_ST_Insert_Proc]
as
begin

	declare
		 @c_ROWID int
		,@c_ST1_CODE nvarchar(50)
		,@c_ST2_CODE nvarchar(50)
		,@c_CCT_CODE nvarchar(30)
		,@c_POSKI nvarchar(50)
		,@c_KOSTL nvarchar(50)
		,@c_GDLGRP nvarchar(50)
		,@c_ZMT_OBJ_CODE nvarchar(30)
		,@c_ACTIVE int
		,@c_STATUS_INW nvarchar(30)

	declare
		 @v_CCTID int
		,@v_CCDID int
		,@v_KL5ID int
		,@v_ORG nvarchar(30)
		,@v_OBJID int
		,@v_ASTID int
		,@v_STN_ROWID int

	select @v_ORG = 'PKN'

	declare ST_inserted cursor static for
	select top 10000
	ROWID, ANLN1, ANLN2, BUKRS,
	case
		when charindex('/', POSKI) > 0 then substring(POSKI, 1, charindex('/', POSKI)-1)
		else POSKI
	end POSKI,
	KOSTL, GDLGRP, TYPBZ, Active, STATUS_INW
	from [dbo].[IE2_ST] (nolock)
	where
	isnull([DOC_NEW_INSERTED],0) = 1
	-- rowid =2659927
	and BUKRS in (select CCT_CODE from COSTCENTER (nolock))
	--and anlue is not null
	--and anln1 = '000001448998'
	--and i_DateTime = '2017-01-26 00:00'
	order by ROWID asc;
	--select ROWID,* from [IE2_ST]

	open ST_inserted
	fetch next from ST_inserted	into @c_ROWID, @c_ST1_CODE, @c_ST2_CODE, @c_CCT_CODE, @c_POSKI, @c_KOSTL, @c_GDLGRP, @c_ZMT_OBJ_CODE, @c_ACTIVE, @c_STATUS_INW
	while @@fetch_status = 0
	begin

		print @c_ROWID
		print @c_ST1_CODE

		select @v_CCTID = NULL
		select @v_CCTID = CCT_ROWID from COSTCENTER (nolock) where CCT_CODE = @c_CCT_CODE

		select @v_CCDID = NULL
		select top 1 @v_CCDID = CCD_ROWID from COSTCODE (nolock) where CCD_SAP_KOSTL = @c_KOSTL order by CCD_SAP_ACTIVE desc

		select @v_KL5ID = NULL
		select top 1 @v_KL5ID = KL5_ROWID from KLASYFIKATOR5 (nolock) where KL5_CODE = @c_GDLGRP order by KL5_SAP_ACTIVE desc

		select @v_STN_ROWID = NULL
		select top 1 @v_STN_ROWID = STN_ROWID from STATION (nolock) where STN_KL5ID = @v_KL5ID

		if not exists (select * from ASSET (nolock) where AST_CODE = @c_POSKI and AST_SUBCODE = @c_ST2_CODE and AST_ORG = @v_ORG) and isnull(@v_CCTID,0) <> 0
		begin
			insert into ASSET (AST_CODE, AST_SUBCODE, AST_BARCODE, AST_ORG, AST_DESC, AST_NOTE, AST_DATE, AST_STATUS,
							AST_TYPE, AST_TYPE2, AST_TYPE3, AST_RSTATUS, AST_CREUSER, AST_CREDATE, AST_UPDUSER, AST_UPDDATE, AST_NOTUSED, AST_ID,
							AST_TXT01, AST_TXT02, AST_TXT03, AST_TXT04, AST_TXT05, AST_TXT06, AST_TXT07, AST_TXT08, AST_TXT09,
							AST_NTX01, AST_NTX02, AST_NTX03, AST_NTX04, AST_NTX05,
							AST_COM01, AST_COM02,
							AST_DTX01, AST_DTX02, AST_DTX03, AST_DTX04, AST_DTX05,
							AST_BUYVALUE, AST_TEXT1, AST_TEXT2, AST_TEXT3, AST_PSP, AST_CCTID, AST_CCDID, AST_KL5ID,
							AST_SAP_Active, AST_SAP_BUKRS, AST_SAP_ANLN1, AST_SAP_ANLN2, AST_SAP_ANLKL, AST_SAP_GEGST, AST_SAP_ERNAM, AST_SAP_ERDAT, AST_SAP_AENAM,
							AST_SAP_AEDAT, AST_SAP_KTOGR, AST_SAP_ANLTP, AST_SAP_ZUJHR, AST_SAP_ZUPER, AST_SAP_ZUGDT, AST_SAP_AKTIV, AST_SAP_ABGDT, AST_SAP_DEAKT,
							AST_SAP_GPLAB, AST_SAP_BSTDT, AST_SAP_ORD41, AST_SAP_ORD42, AST_SAP_ORD43, AST_SAP_ORD44, AST_SAP_ANEQK, AST_SAP_LIFNR, AST_SAP_LAND1,
							AST_SAP_LIEFE, AST_SAP_HERST, AST_SAP_EIGKZ, AST_SAP_URWRT, AST_SAP_ANTEI, AST_SAP_MEINS, AST_SAP_MENGE, AST_SAP_VMGLI, AST_SAP_XVRMW,
							AST_SAP_WRTMA, AST_SAP_EHWRT, AST_SAP_STADT, AST_SAP_GRUFL, AST_SAP_VBUND, AST_SAP_SPRAS, AST_SAP_TXT50, AST_SAP_KOSTL, AST_SAP_WERKS,
							AST_SAP_GSBER, AST_SAP_POSNR, AST_SAP_GDLGRP, AST_SAP_DOC_IDENT, AST_SAP_DOC_NUM, AST_SAP_DOC_YEAR, AST_SAP_DATA_WYST, AST_SAP_OSOBA_WYST, AST_ANLUE,
							AST_SAP_NDJARPER,AST_DONIESIENIE, AST_SAP_STATUS_INW)

			select @c_POSKI, @c_ST2_CODE, @c_POSKI + @c_ST2_CODE, @v_ORG, TXT50, NULL, getdate(), 'AST_001',
			'ST', NULL, NULL, 0, 'SA', getdate(), NULL, NULL, case isnull(Active,0) when 1 then 0 else 1 end, newid(),
			NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
			NULL, NULL, NULL, NULL, NULL,
			NULL, NULL,
			NULL, NULL, NULL, NULL, NULL,
			case when isnumeric(cast(replace(EHWRT,',','.') as decimal(30,6))) = 1 then cast(replace(EHWRT,',','.') as decimal(30,6)) else 0.00 end, NULL, NULL, NULL, POSNR, @v_CCTID, @v_CCDID, @v_KL5ID,
			Active, BUKRS, ANLN1, ANLN2, ANLKL, GEGST, ERNAM, ERDAT, AENAM,
			AEDAT, KTOGR, ANLTP, ZUJHR, ZUPER, ZUGDT, AKTIV, ABGDT, DEAKT,
			GPLAB, BSTDT, ORD41, ORD42, ORD43, ORD44, ANEQK, LIFNR, LAND1,
			LIEFE, HERST, EIGKZ, URWRT, ANTEI, MEINS, MENGE, VMGLI, XVRMW,
			WRTMA, EHWRT, STADT, GRUFL, VBUND, SPRAS, TXT50, KOSTL, WERKS,
			GSBER, POSNR, GDLGRP, DOC_IDENT, DOC_NUM, DOC_YEAR, DATA_WYST , OSOBA_WYST , ANLUE, NDJARPER,
			case when @c_ST2_CODE <> '0000' and (isnull(TXT50,'') = '' or ANLKL not in ('888-1***', '486-***1')) then 1 else 0 end,
			STATUS_INW
			from IE2_ST where ROWID = @c_ROWID
		end
		else if isnull(@v_CCTID,0) <> 0
		begin
			update ASSET set
				 AST_BARCODE = @c_POSKI + @c_ST2_CODE
				,AST_ORG = @v_ORG
				,AST_DESC = TXT50
				,AST_NOTE = AST_NOTE
				,AST_DATE = AST_DATE
				,AST_STATUS = 'AST_001'
				,AST_TYPE = NULL
				,AST_TYPE2 = NULL
				,AST_TYPE3 = NULL
				,AST_RSTATUS = 0
				,AST_UPDUSER = 'SA'
				,AST_UPDDATE = getdate()
				,AST_NOTUSED = case isnull(Active,0) when 1 then 0 else 1 end
				,AST_ID = AST_ID
				,AST_BUYVALUE = case when isnumeric(cast(replace(EHWRT,',','.') as decimal(30,6))) = 1 then cast(replace(EHWRT,',','.') as decimal(30,6)) else 0.00 end
				,AST_PSP = POSNR
				,AST_CCTID = @v_CCTID
				,AST_CCDID = @v_CCDID
				,AST_KL5ID = @v_KL5ID
				,AST_SAP_Active = Active
				,AST_SAP_BUKRS = BUKRS
				,AST_SAP_ANLN1 = ANLN1
				,AST_SAP_ANLN2 = ANLN2
				,AST_SAP_ANLKL = ANLKL
				,AST_SAP_GEGST = GEGST
				,AST_SAP_ERNAM = ERNAM
				,AST_SAP_ERDAT = ERDAT
				,AST_SAP_AENAM = AENAM
				,AST_SAP_AEDAT = AEDAT
				,AST_SAP_KTOGR = KTOGR
				,AST_SAP_ANLTP = ANLTP
				,AST_SAP_ZUJHR = ZUJHR
				,AST_SAP_ZUPER = ZUPER
				,AST_SAP_ZUGDT = ZUGDT
				,AST_SAP_AKTIV = AKTIV
				,AST_SAP_ABGDT = ABGDT
				,AST_SAP_DEAKT = DEAKT
				,AST_SAP_GPLAB = GPLAB
				,AST_SAP_BSTDT = BSTDT
				,AST_SAP_ORD41 = ORD41
				,AST_SAP_ORD42 = ORD42
				,AST_SAP_ORD43 = ORD43
				,AST_SAP_ORD44 = ORD44
				,AST_SAP_ANEQK = ANEQK
				,AST_SAP_LIFNR = LIFNR
				,AST_SAP_LAND1 = LAND1
				,AST_SAP_LIEFE = LIEFE
				,AST_SAP_HERST = HERST
				,AST_SAP_EIGKZ = EIGKZ
				,AST_SAP_URWRT = URWRT
				,AST_SAP_ANTEI = ANTEI
				,AST_SAP_MEINS = MEINS
				,AST_SAP_MENGE = MENGE
				,AST_SAP_VMGLI = VMGLI
				,AST_SAP_XVRMW = XVRMW
				,AST_SAP_WRTMA = WRTMA
				,AST_SAP_EHWRT = EHWRT
				,AST_SAP_STADT = STADT
				,AST_SAP_GRUFL = GRUFL
				,AST_SAP_VBUND = VBUND
				,AST_SAP_SPRAS = SPRAS
				,AST_SAP_TXT50 = TXT50
				,AST_SAP_KOSTL = KOSTL
				,AST_SAP_WERKS = WERKS
				,AST_SAP_GSBER = GSBER
				,AST_SAP_POSNR = POSNR
				,AST_SAP_GDLGRP = GDLGRP
				,AST_SAP_DOC_IDENT = DOC_IDENT
				,AST_SAP_DOC_NUM = DOC_NUM
				,AST_SAP_DOC_YEAR = DOC_YEAR
				,AST_SAP_DATA_WYST = DATA_WYST
				,AST_SAP_OSOBA_WYST = OSOBA_WYST
				,AST_ANLUE = ANLUE
				,AST_SAP_NDJARPER = NDJARPER
				,AST_SAP_STATUS_INW = STATUS_INW
			from ASSET ast (nolock)
			join IE2_ST on AST_CODE = @c_POSKI and AST_SUBCODE = @c_ST2_CODE
			where IE2_ST.ROWID = @c_ROWID
		end

		set @v_OBJID = null

		select @v_OBJID = OBJ_ROWID from dbo.OBJ (nolock) where OBJ_CODE = @c_ZMT_OBJ_CODE
		select @v_ASTID = AST_ROWID from dbo.ASSET (nolock) where AST_CODE = @c_POSKI and AST_SUBCODE = @c_ST2_CODE

		print 'OBJ?'
		print @v_OBJID
		--składnik pochodzi pierwotnie z ZMT
		if @v_OBJID is not null
		begin
		-- print @v_ASTID
		--aktualizacja połączenia skłądnik ZMT-składnik SAP
			if not exists (select * from OBJASSET (nolock) where OBA_OBJID = @v_OBJID)
				and @v_OBJID is not null
				and @v_ASTID is not null
			begin
				insert into OBJASSET(OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)
				select @v_OBJID, @v_ASTID, getdate(), 'SA'
			end
			else
			begin
				print 'update OBJASSET'
				print @v_KL5ID
				update OBJASSET set
					OBA_ASTID = @v_ASTID,
					OBA_UPDDATE = GETDATE(),
					OBA_UPDUSER = 'SA'
				where OBA_OBJID = @v_OBJID
			end

		--aktualizacja połączenia składnik ZMT-stacja paliw (serwis, magazyn whatever), dla składnika głównego
			if not exists (select * from OBJSTATION (nolock) where OSA_OBJID = @v_OBJID)
				and @v_OBJID is not null
				and @v_STN_ROWID is not null
				and dbo.GetSTNTYPE(@v_STN_ROWID) <> 'SERWIS'
			begin
				insert into OBJSTATION(OSA_OBJID, OSA_STNID, OSA_CREDATE, OSA_CREUSER)
				select @v_OBJID, @v_STN_ROWID, getdate(), 'SA'
			end
			--właściwie poniższe jest nadmiatowe ale niech zostanie
			else if @v_OBJID is not null and @v_STN_ROWID is not null and @v_KL5ID is not null and dbo.GetSTNTYPE(@v_STN_ROWID) <> 'SERWIS'
			begin
				update OBJSTATION set
					OSA_STNID = @v_STN_ROWID,
					OSA_KL5ID = @v_KL5ID,
					OSA_UPDDATE = GETDATE(),
					OSA_UPDUSER = 'SA'
				where OSA_OBJID = @v_OBJID
			end

		end

		if (@c_ACTIVE = 0 and @c_STATUS_INW = '') -- dodany warunek na rozróżnienie składników niedobór - zgłoszenie 423
		begin
			update dbo.OBJ set
				 OBJ_NOTUSED = 1
				,OBJ_STATUS = 'OBJ_007'
				,OBJ_UPDUSER = 'SAPI_ST'
				,OBJ_UPDDATE = getdate()
				,OBJ_IE2ROWID = @c_ROWID -- ID z tabeli IE2_ST 
			from dbo.OBJASSET
			where OBJ_ROWID = OBA_OBJID and OBA_ASTID = @v_ASTID
			and not exists (select 1 from dbo.ASSET where AST_CODE = @c_ST1_CODE and AST_NOTUSED = 0)
			and OBJ_NOTUSED = 0
		end


-- ############################# ZGŁOSZENIE 423 ##############################

/*Dla składników, dla kóry wraca z SAP Rodzaj operacji = 'NIEDOBOR' i Aktiv = 0  zmieniamy status na "niedobór", ze statusu do "w eksploatacji"*/
	if (@c_ACTIVE = 0 and @c_STATUS_INW = 'NIEDOBOR')
			begin 
				update dbo.OBJ set
				 OBJ_NOTUSED = 0
				,OBJ_STATUS = 'OBJ_010'
				,OBJ_UPDUSER = 'SAPI_ST'
				,OBJ_UPDDATE = getdate()
				,OBJ_IE2ROWID = @c_ROWID --ID z tabeli IE2_ST 
			from dbo.OBJASSET
			where OBJ_ROWID = OBA_OBJID and OBA_ASTID = @v_ASTID
			and not exists (select 1 from dbo.ASSET where AST_CODE = @c_ST1_CODE and AST_NOTUSED = 0)
			and OBJ_NOTUSED = 0 and OBJ_STATUS = 'OBJ_002'
			end


/*Dla składników, dla który wraca z SAP Rodzaj operacji = NULL i Aktiv = 1  zmieniamy status na "W eksploatacji", ze statusu do "niedobór"*/
	if (@c_ACTIVE = 1 and @c_STATUS_INW is null)
			begin 
				update dbo.OBJ set
				 OBJ_NOTUSED = 0
				,OBJ_STATUS = 'OBJ_002'
				,OBJ_UPDUSER = 'SAPI_ST'
				,OBJ_UPDDATE = getdate()
				,OBJ_IE2ROWID = @c_ROWID --ID z tabeli IE2_ST 
			from dbo.OBJASSET
			where OBJ_ROWID = OBA_OBJID and OBA_ASTID = @v_ASTID
			and not exists (select 1 from dbo.ASSET where AST_CODE = @c_ST1_CODE and AST_NOTUSED = 0)
			and OBJ_NOTUSED = 0 and OBJ_STATUS = 'OBJ_010'
			end


/*Jeżeli dla podskładnika zostanie w SAP zmienione pole „Rodzaj oper.” na = „ZERO” (w przeciwnym wypadku jest pusty) i pole „Aktywne” jest = „0” oznacza to, 
że jest wykonywane ulepszenie składnika głównego na rzecz podskładnika. 
Wówczas w ZMT na podskładniku ma być ustawiana wartość 0 (zero)(czyli np. składnik 1453073-0006 zmienia wartość doniesienia na 1453073-0000) bez likwidacji urządzenia.  */

	if (@c_ACTIVE = 0 and @c_STATUS_INW = 'ZERO')
			begin 
				update dbo.OBJ set
				 OBJ_VALUE = 0
				,OBJ_UPDUSER = 'SAPI_ST'
				,OBJ_UPDDATE = getdate()
				,OBJ_IE2ROWID = @c_ROWID --ID z tabeli IE2_ST 
			from dbo.OBJASSET
			where OBJ_ROWID = OBA_OBJID and OBA_ASTID = @v_ASTID
			and not exists (select 1 from dbo.ASSET where AST_CODE = @c_ST1_CODE and AST_NOTUSED = 0)
			and OBJ_NOTUSED = 0 and OBJ_STATUS = 'OBJ_010'
			end



--####################################################################################


		-- aktualizacja powiązania składnika ZMT - stacja paliw(uwzglednia niewprowadzone w ZMT,wykonane ręcznie połączenie w OBJASSET podczas zasileń iwnentaryzacyjnych)
		update OBJSTATION set
			OSA_STNID = @v_STN_ROWID,
			OSA_KL5ID = @v_KL5ID,
			OSA_UPDDATE = getdate(),
			OSA_UPDUSER = 'SA'
		from dbo.OBJSTATION
		join dbo.OBJ (nolock) on OBJ_ROWID = OSA_OBJID
		join dbo.OBJASSET (nolock) on OBJ_ROWID = OBA_OBJID
		join dbo.ASSET (nolock) on OBA_ASTID = AST_ROWID		
		where AST_ROWID = @v_ASTID and @v_STN_ROWID is not null and OSA_STNID <> @v_STN_ROWID and dbo.GetSTNTYPE(@v_STN_ROWID) <> 'SERWIS'

		update [dbo].[IE2_ST] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID

		update dbo.IE2_DocRequest set
			ACTIVE = 0
		where ID_SLOWNIKA = 'ST_'+left(@c_GDLGRP,7)

		fetch next from ST_inserted into @c_ROWID, @c_ST1_CODE, @c_ST2_CODE, @c_CCT_CODE, @c_POSKI, @c_KOSTL, @c_GDLGRP, @c_ZMT_OBJ_CODE, @c_ACTIVE, @c_STATUS_INW
	end

	c_return:

	close ST_inserted
	deallocate ST_inserted

end



--select kostl, * from IE2_ST where kostl like '%7257594%'
--select kostl, * from IE2_ST where kostl like '%7257113%'
--select KOSTL, * from ie2_st
--select CCD_SAP_ACTIVE, * from COSTCODE where CCD_CODE = '7257113' 
GO