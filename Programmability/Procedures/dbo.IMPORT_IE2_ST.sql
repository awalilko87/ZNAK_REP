SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[IMPORT_IE2_ST]
AS
BEGIN
declare @BUKRS nvarchar(30)
declare @ANLN1 nvarchar(30)
declare @ANLN2 nvarchar(30)
declare @ANLKL nvarchar(30)
declare @GEGST nvarchar(30)
declare @ERNAM nvarchar(30)
declare @ERDAT nvarchar(30)
declare @AENAM nvarchar(30)
declare @AEDAT nvarchar(30)
declare @KTOGR nvarchar(30)
declare @ANLTP nvarchar(30)
declare @ZUJHR nvarchar(30)
declare @ZUPER nvarchar(30)
declare @ZUGDT nvarchar(30)
declare @AKTIV nvarchar(30)
declare @ABGDT nvarchar(30)
declare @DEAKT nvarchar(30)
declare @GPLAB nvarchar(30)
declare @BSTDT nvarchar(30)
declare @ORD41 nvarchar(30)
declare @ORD42 nvarchar(30)
declare @ORD43 nvarchar(30)
declare @ORD44 nvarchar(30)
declare @ANEQK nvarchar(30)
declare @LIFNR nvarchar(30)
declare @LAND1 nvarchar(30)
declare @LIEFE nvarchar(30)
declare @HERST nvarchar(30)
declare @EIGKZ nvarchar(30)
declare @URWRT nvarchar(30)
declare @ANTEI nvarchar(30)
declare @MEINS nvarchar(30)
declare @MENGE nvarchar(30)
declare @VMGLI nvarchar(30)
declare @XVRMW nvarchar(30)
declare @WRTMA nvarchar(30)
declare @EHWRT nvarchar(30)
declare @STADT nvarchar(30)
declare @GRUFL nvarchar(30)
declare @VBUND nvarchar(30)
declare @SPRAS nvarchar(30)
declare @TXT50 nvarchar(80)
declare @GDLGRP nvarchar(30)
declare @POSNR nvarchar(30)
declare @KOSTL nvarchar(30)
declare @WERKS nvarchar(30)
declare @GSBER nvarchar(30)

declare @imp_i_DateTime datetime = convert(datetime, convert(varchar(10), getdate(), 120))
declare @imp_Active int = 1
declare @imp_DOC_IDENT nvarchar(30)
declare @imp_DOC_NUM nvarchar(30) = '0000000000'
declare @imp_DOC_YEAR int = '0'
declare @imp_DATA_WYST datetime
declare @imp_OSOBA_WYST nvarchar(30)
declare @imp_DOC_NEW_INSERTED smallint = 1
declare @imp_POSKI nvarchar(50)
declare @imp_TYPBZ nvarchar(30) = null
declare @imp_NDJARPER nvarchar(100) = null

declare @ANLN1_NEW nvarchar(30)
declare @ANLN2_NEW nvarchar(4)
declare @AEDAT_NEW nvarchar(30)
declare @ERDAT_NEW nvarchar(30)
declare @ZUGDT_NEW nvarchar(30)
declare @AKTIV_NEW nvarchar(30)
declare @ABGDT_NEW nvarchar(30)
declare @BSTDT_NEW nvarchar(30)
declare @DEAKT_NEW nvarchar(30)
declare @KTOGR_NEW nvarchar(30)
declare @ZUPER_NEW nvarchar(30)
declare @MENGE_NEW nvarchar(30)

	declare cur cursor static for
	
	SELECT [BUKRS],[ANLN1],[ANLN2],[ANLKL],[GEGST],[ERNAM],[ERDAT],[AENAM],[AEDAT],[KTOGR],[ANLTP]
    ,[ZUJHR],[ZUPER],[ZUGDT],[AKTIV],[ABGDT],[DEAKT],[GPLAB],[BSTDT],[ORD41],[ORD42],[ORD43],[ORD44]
    ,[ANEQK],[LIFNR],[LAND1],[LIEFE],[HERST],[EIGKZ],[URWRT],[ANTEI],[MEINS],[MENGE],[VMGLI],[XVRMW]
    ,[WRTMA],[EHWRT],[STADT],[GRUFL],[VBUND],[SPRAS],[TXT50],[GDLGRP],[POSNR],[KOSTL],[WERKS],[GSBER]
	FROM [ZMT_PROD].[dbo].[IE2_ST_TEST]
	where 1=1
	and GDLGRP = KOSTL+'0'
	and (DEAKT is null or DEAKT = '00.00.0000')
	--and '00000'+ANLN1+RIGHT('000'+ANLN2, 4) NOT IN (select ANLN1+ANLN2 from IE2_ST)
	
	open cur
	
	fetch next from cur
	into @BUKRS,@ANLN1,@ANLN2,@ANLKL,@GEGST,@ERNAM,@ERDAT,@AENAM,@AEDAT,@KTOGR,@ANLTP
    ,@ZUJHR,@ZUPER,@ZUGDT,@AKTIV,@ABGDT,@DEAKT,@GPLAB,@BSTDT,@ORD41,@ORD42,@ORD43,@ORD44
    ,@ANEQK,@LIFNR,@LAND1,@LIEFE,@HERST,@EIGKZ,@URWRT,@ANTEI,@MEINS,@MENGE,@VMGLI,@XVRMW
    ,@WRTMA,@EHWRT,@STADT,@GRUFL,@VBUND,@SPRAS,@TXT50,@GDLGRP,@POSNR,@KOSTL,@WERKS,@GSBER
    
    while @@fetch_status = 0 
	begin
	
	
		set @ANLN1_NEW = '00000'+@ANLN1

		set @ANLN2_NEW = RIGHT('000'+@ANLN2, 4)
		
		set @AEDAT_NEW = RIGHT(@AEDAT, 4)+SUBSTRING(@AEDAT, 4, 2)+LEFT(@AEDAT, 2)

		set @ERDAT_NEW = RIGHT(@ERDAT, 4)+'-'+SUBSTRING(@ERDAT, 4, 2)+'-'+LEFT(@ERDAT, 2)+' 00:00:00.000'

		set @ZUGDT_NEW = RIGHT(@ZUGDT, 4)+'-'+SUBSTRING(@ZUGDT, 4, 2)+'-'+LEFT(@ZUGDT, 2)+' 00:00:00.000'
		
		set @AKTIV_NEW = RIGHT(@AKTIV, 4)+'-'+SUBSTRING(@AKTIV, 4, 2)+'-'+LEFT(@AKTIV, 2)+' 00:00:00.000'
		
		if @ABGDT = '00.00.0000'
			set @ABGDT_NEW = NULL
		else
			set @ABGDT_NEW = RIGHT(@ABGDT, 4)+'-'+SUBSTRING(@ABGDT, 4, 2)+'-'+LEFT(@ABGDT, 2)+' 00:00:00.000'
		
		if @BSTDT = '00.00.0000'
			set @BSTDT_NEW = NULL
		else
			set @BSTDT_NEW = RIGHT(@BSTDT, 4)+'-'+SUBSTRING(@BSTDT, 4, 2)+'-'+LEFT(@BSTDT, 2)
		
		if @DEAKT = '00.00.0000'
			set @DEAKT_NEW = NULL
		else
			set @DEAKT_NEW = RIGHT(@DEAKT, 4)+SUBSTRING(@DEAKT, 4, 2)+LEFT(@DEAKT, 2)
			
		if @GPLAB = '00.00.0000'
			set @GPLAB = NULL
		else
			set @GPLAB = RIGHT(@GPLAB, 4)+SUBSTRING(@GPLAB, 4, 2)+LEFT(@GPLAB, 2)
	
		set @KTOGR_NEW = RIGHT('000'+@KTOGR, 8)
		
		set @ZUPER_NEW = RIGHT('00'+@ZUPER, 3)
	
	
	if @URWRT = '0'
		set @URWRT = '0.00'
		set @URWRT=REPLACE (@URWRT,',','.')
		
	if @ANTEI = '0'
		set @ANTEI = '0.00'
		
		set @MENGE_NEW = @MENGE+'.000'
		
	if @WRTMA = '0'
		set @WRTMA = '0.00'
		
	if @EHWRT = '0'
		set @EHWRT = '0.00'
		
	if @GRUFL = '0'
		set @GRUFL = '0.00'
		
	declare @KOSTL_NEW nvarchar(30)
		set @KOSTL_NEW = '000'+@KOSTL
		
	if @POSNR = '0'
		set @POSNR = null
		
	set @imp_POSKI = @ANLN1
		
	
		
		insert into [dbo].[IE2_ST]
		([i_DateTime]
		,[Active]
		,[BUKRS]
		,[ANLN1]
		,[ANLN2]
		,[ANLKL]
		,[GEGST]
		,[ERNAM]
		,[ERDAT]
		,[AENAM]
		,[AEDAT]
		,[KTOGR]
		,[ANLTP]
		,[ZUJHR]
		,[ZUPER]
		,[ZUGDT]
		,[AKTIV]
		,[ABGDT]
		,[DEAKT]
		,[GPLAB]
		,[BSTDT]
		,[ORD41]
		,[ORD42]
		,[ORD43]
		,[ORD44]
		,[ANEQK]
		,[LIFNR]
		,[LAND1]
		,[LIEFE]
		,[HERST]
		,[EIGKZ]
		,[URWRT]
		,[ANTEI]
		,[MEINS]
		,[MENGE]
		,[VMGLI]
		,[XVRMW]
		,[WRTMA]
		,[EHWRT]
		,[STADT]
		,[GRUFL]
		,[VBUND]
		,[SPRAS]
		,[TXT50]
		,[KOSTL]
		,[WERKS]
		,[GSBER]
		,[POSNR]
		,[GDLGRP]
		,[DOC_IDENT]
		,[DOC_NUM]
		,[DOC_YEAR]
		,[DATA_WYST]
		,[OSOBA_WYST]
		,[DOC_NEW_INSERTED]
		,[POSKI]
		,[TYPBZ]
		,[NDJARPER])
		values 
		(@imp_i_DateTime
		,@imp_Active
		,@BUKRS
		,@ANLN1_NEW
		,@ANLN2_NEW
		,@ANLKL
		,@GEGST
		,@ERNAM
		,@ERDAT_NEW
		,@AENAM
		,@AEDAT_NEW
		,@KTOGR_NEW
		,@ANLTP
		,@ZUJHR
		,@ZUPER_NEW
		,@ZUGDT_NEW
		,@AKTIV_NEW
		,@ABGDT_NEW
		,@DEAKT_NEW
		,@GPLAB
		,@BSTDT_NEW
		,@ORD41
		,@ORD42
		,@ORD43
		,@ORD44
		,@ANEQK
		,@LIFNR
		,@LAND1
		,@LIEFE
		,@HERST
		,@EIGKZ
		,@URWRT
		,@ANTEI
		,@MEINS
		,@MENGE_NEW
		,@VMGLI
		,@XVRMW
		,@WRTMA
		,@EHWRT
		,@STADT
		,@GRUFL
		,@VBUND
		,@SPRAS
		,@TXT50
		,@KOSTL_NEW
		,@WERKS
		,@GSBER
		,@POSNR
		,@GDLGRP
		,@imp_DOC_IDENT
		,@imp_DOC_NUM
		,@imp_DOC_YEAR
		,@imp_DATA_WYST
		,@imp_OSOBA_WYST
		,@imp_DOC_NEW_INSERTED
		,@imp_POSKI
		,@imp_TYPBZ
		,@imp_NDJARPER
		)
		
		--insert into IE2_ST_TEST2
		--select @BUKRS,@ANLN1_NEW,@ANLN2_NEW,@ANLKL,@GEGST,@ERNAM,@ERDAT_NEW,@AENAM,@AEDAT_NEW,@KTOGR_NEW,@ANLTP
		--,@ZUJHR,@ZUPER_NEW,@ZUGDT_NEW,@AKTIV_NEW,@ABGDT_NEW,@DEAKT_NEW,@GPLAB,@BSTDT_NEW,@ORD41,@ORD42,@ORD43,@ORD44
		--,@ANEQK,@LIFNR,@LAND1,@LIEFE,@HERST,@EIGKZ,@URWRT,@ANTEI,@MEINS,@MENGE_NEW,@VMGLI,@XVRMW
		--,@WRTMA,@EHWRT,@STADT,@GRUFL,@VBUND,@SPRAS,@TXT50,@GDLGRP,@POSNR,@KOSTL_NEW,@WERKS,@GSBER
	
	fetch next from cur
	into @BUKRS,@ANLN1,@ANLN2,@ANLKL,@GEGST,@ERNAM,@ERDAT,@AENAM,@AEDAT,@KTOGR,@ANLTP
    ,@ZUJHR,@ZUPER,@ZUGDT,@AKTIV,@ABGDT,@DEAKT,@GPLAB,@BSTDT,@ORD41,@ORD42,@ORD43,@ORD44
    ,@ANEQK,@LIFNR,@LAND1,@LIEFE,@HERST,@EIGKZ,@URWRT,@ANTEI,@MEINS,@MENGE,@VMGLI,@XVRMW
    ,@WRTMA,@EHWRT,@STADT,@GRUFL,@VBUND,@SPRAS,@TXT50,@GDLGRP,@POSNR,@KOSTL,@WERKS,@GSBER
    
	end

	close cur
	deallocate cur

END
GO