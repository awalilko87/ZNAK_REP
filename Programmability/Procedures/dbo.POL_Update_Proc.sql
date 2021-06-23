SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POL_Update_Proc]
(
@p_POTID int,      
@p_TO_STNID int,    
@p_TO_STN_DESC nvarchar(80),
@p_OBJID int,
@p_OBJ nvarchar(30),
@p_OLDQTY decimal(30,6),
@p_NEWQTY decimal(30,6),
@p_PARTIAL numeric(8,2),
@p_COM01 ntext,
@p_COM02 ntext,
@p_DTX01 datetime,
@p_DTX02 datetime,
@p_DTX03 datetime,
@p_DTX04 datetime,
@p_DTX05 datetime,
@p_NTX01 numeric(24,6),
@p_NTX02 numeric(24,6),
@p_NTX03 numeric(24,6),
@p_NTX04 numeric(24,6),
@p_NTX05 numeric(24,6),
@p_ROWID int = NULL,
@p_OLD_ROWID int = NULL,
@p_POL_CODE nvarchar(30) = NULL,
@p_OLD_POL_CODE nvarchar(30) = NULL,
@p_CREDATE datetime,
@p_CREUSER nvarchar(30),
@p_DATE datetime,
@p_DESC nvarchar(80),
@p_ID nvarchar(50),
@p_NOTE ntext,
@p_NOTUSED int,
@p_ORG nvarchar(30),
@p_RSTATUS int,
@p_STATUS nvarchar(30),
@p_STATUS_OLD nvarchar(30),
@p_TYPE nvarchar(30),
@p_TYPE2 nvarchar(30),
@p_TYPE3 nvarchar(30),
@p_UPDDATE datetime,
@p_UPDUSER nvarchar(30),
@p_TXT01 nvarchar(30),
@p_TXT02 nvarchar(30),
@p_TXT03 nvarchar(30),
@p_TXT04 nvarchar(30),
@p_TXT05 nvarchar(30),
@p_TXT06 nvarchar(80),
@p_TXT07 nvarchar(80),
@p_TXT08 nvarchar(255),
@p_TXT09 nvarchar(255),
@p_POL_BIZ_DEC int,
@p_POL_ADHOC int,
@p_POL_LIKW_TYPE int,
@p_POL_LIKW_ADHOC int,
@p_POL_TECHDEC_TYPE int,
@p_POL_WIEK nvarchar(30),
@p_POL_PRZEBIEG nvarchar(30),
@p_POL_TECHDEC_DESC nvarchar(max),
@p_POL_ATTACH nvarchar(max),
@p_POL_UMO_WART numeric(26,8),
@p_POL_MIN_ODSP numeric(26,8),
@p_POL_WART_ODSP numeric(26,8),
@p_POL_ZARZ_BIZ int,
@p_UserID varchar(20),
@p_GroupID varchar(10),
@p_LangID varchar(10),
@p_apperrortext nvarchar(4000) = null output
)
as
begin
 --raiserror (@p_STATUS,1,1) 
 declare @v_errorcode nvarchar(50)
 declare @v_syserrorcode nvarchar(4000)
 declare @v_errortext nvarchar(4000)
 declare @v_date datetime
 declare @v_Rstatus int
 declare @v_Pref nvarchar(10)
 declare @v_MultiOrg bit
 declare @v_OBJID int
 declare @v_OBGID int
 declare @v_POT_CODE nvarchar(30)
 declare @v_POT_DESC nvarchar(80)
 declare @v_OLDQTY numeric(30,6)
 declare @v_ASTID int
 declare @v_AST nvarchar(30)
 declare @v_AST_DESC nvarchar(80)
 declare @v_STATUS_OLD nvarchar(30)
 declare @v_AST_SAP_URWRT decimal
 declare @v_TO_STNID int
 declare @v_OBJ_DESC nvarchar(80)
 declare @v_STN_TYPE nvarchar(30)
 declare @v_POT_RETURN int 

 select @v_OBGID = OBJ_GROUPID, @v_STATUS_OLD  = OBJ_STATUS, @v_OBJ_DESC = OBJ_DESC from OBJ (nolock) where OBJ_ROWID = @p_OBJID        
 select @v_TO_STNID = STN_ROWID, @v_STN_TYPE = STN_TYPE from dbo.STATION_FILTERv where STN_FILTER = @p_TO_STN_DESC        
 select @v_ASTID = OBA_ASTID from dbo.OBJASSET (nolock) where OBA_OBJID = @p_OBJID        
 select @v_AST = AST_CODE, @v_AST_DESC = AST_DESC from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID 
 select @v_POT_RETURN = ISNull(POT_RETURN,0) from OBJTECHPROT where pot_rowid = @p_POTID

        
 IF @p_STATUS = 'POL_009' and @v_OBJ_DESC not like '%fiskal%'
 begin
  set @v_errorcode = ''
  RaisError ('Błąd! Nie można wybrać statusu "Do odczytu"! Status dostępny tylko dla drukarek fiskalnych!',16,1)
  goto errorlabel
 end

 if @p_STATUS is null
  select @p_STATUS = 'POL_004'     
 if @p_STATUS in ('POL_005', 'POL_003') and isnull(@p_TO_STNID, @v_TO_STNID) is null
 begin
  set @v_errorcode = ''
  select @v_errorcode = 'POLN_001'  --select * from vs_langmsgs where objectid = 'POLN_001'
  goto errorlabel
 end
 if @p_STATUS = 'POL_007' and @p_TO_STNID is null
 begin
  set @v_errorcode = ''
  RaisError ('Zmiana statusu zlecenia na Zablokowany jest niemożliwa. Status nadawany jest jedynie systemowo',16,1)
  goto errorlabel
 end

  if @v_STATUS_OLD = 'POL_010'
 begin
 declare @msg nvarchar(max)
 set @msg = 'Zmiana oceny dla składnika niemożliwa. Składnik :' + @p_OBJ + ' oznaczony jako niedobór.' 
  set @v_errorcode = ''
  RaisError (@msg,16,1)
  goto errorlabel
 end


 select @v_AST_SAP_URWRT = AST_SAP_URWRT from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID
 if (@v_AST_SAP_URWRT = '0.00')
  select @p_PARTIAL = 100
 else
  select @p_PARTIAL = 100 * OBJ_VALUE / (select AST_SAP_URWRT from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID)
  from dbo.OBJ (nolock)
  where OBJ_ROWID = @p_OBJID
 select top 1 @v_POT_CODE = POT_CODE, @v_POT_DESC = POT_DESC  from dbo.OBJTECHPROT(nolock) where POT_ROWID = @p_POTID
 select top 1 @v_OBJID = OBJ_ROWID from dbo.OBJ(nolock) where OBJ_CODE = @p_OBJ
 if exists (select 1 from dbo.OBJTECHPROT (nolock)join dbo.OBJTECHPROTLN (nolock) on POT_ROWID = POL_POTID
  where POL_OBJID = @v_OBJID and
  POL_ID <> isnull(@p_ID,'') --istnieje taki obiekt     
  and POL_STATUS not in ('POL_004')
  )
  and exists (select 1 from OBJ where OBJ_ROWID = @v_OBJID and OBJ_STATUS IN ('OBJ_005' , 'OBJ_006', 'OBJ_007', 'OBJ_008'))
 begin
  select @v_errorcode = 'SYS_022'  --select * from vs_langmsgs where objectid = 'SYS_005'
  declare @v_EXPOT nvarchar(20)
  select top 1
   @v_EXPOT = POT_CODE
  from  [dbo].[OBJTECHPROTLN] (nolock)
  join [dbo].[OBJTECHPROT] (nolock) on POT_ROWID = POL_POTID
  where
  POL_ID <> isnull(@p_ID,0)
  and POL_OBJID = @v_OBJID
  and POL_STATUS not in ('POL_004')
  and POT_STATUS not in ('POT_004')
  declare @description nvarchar(50)
  declare @description_all nvarchar(150)
  select @description = STA_DESC from OBJ
  left join STA on STA_CODE = OBJ_STATUS
  where OBJ_ROWID = @v_OBJID
  set @description_all = 'Status składnika - '+@description+' w protokole nr: '+@v_EXPOT
  update dbo.OBJTECHPROTLN set POL_DESC = @description_all where POL_POTID = @p_POTID and POL_OBJID = @v_OBJID
  goto errorlabel
 end
 if not exists (select 1 from dbo.OBJTECHPROTLN (nolock) where POL_ID = @p_ID)
 begin
  begin try
   insert into dbo.OBJTECHPROTLN(POL_POTID, POL_TO_STNID, POL_OBJID, POL_OLDQTY, POL_NEWQTY, POL_PARTIAL,
      POL_COM01, POL_COM02, POL_DTX01, POL_DTX02, POL_DTX03, POL_DTX04, POL_DTX05,
      POL_NTX01, POL_NTX02, POL_NTX03, POL_NTX04, POL_NTX05,
      POL_CODE, POL_CREDATE, POL_CREUSER, POL_DATE, POL_DESC, POL_ID, POL_NOTE, POL_NOTUSED, POL_ORG, POL_RSTATUS, POL_STATUS,
      POL_TYPE, POL_TYPE2, POL_TYPE3, POL_TXT01, POL_TXT02, POL_TXT03, POL_TXT04, POL_TXT05, POL_TXT06, POL_TXT07, POL_TXT08, POL_TXT09,
	  POL_BIZ_DEC, POL_ADHOC ,POL_LIKW_TYPE ,POL_LIKW_ADHOC ,POL_TECHDEC_TYPE ,POL_WIEK,POL_PRZEBIEG,
	  POL_TECHDEC_DESC ,POL_ATTACH ,POL_UMO_WART ,POL_MIN_ODSP ,POL_WART_ODSP ,POL_ZARZ_BIZ)
   select  @p_POTID, @v_TO_STNID, @v_OBJID, @v_OLDQTY, @p_NEWQTY, @p_PARTIAL,
    @p_COM01, @p_COM02, @p_DTX01, @p_DTX02, @p_DTX03, @p_DTX04, @p_DTX05,
    @p_NTX01, @p_NTX02, @p_NTX03, @p_NTX04, @p_NTX05,
    @v_POT_CODE, @p_CREDATE, @p_CREUSER, @p_DATE, @v_POT_DESC, @p_ID, @p_NOTE, @p_NOTUSED, @p_ORG, @p_RSTATUS, @p_STATUS,
    @p_TYPE, @p_TYPE2, @p_TYPE3, @p_TXT01, @p_TXT02, @p_TXT03, @p_TXT04, @p_TXT05, @p_TXT06, @p_TXT07, @p_TXT08, @p_TXT09,
	@p_POL_BIZ_DEC, @p_POL_ADHOC ,@p_POL_LIKW_TYPE ,@p_POL_LIKW_ADHOC ,@p_POL_TECHDEC_TYPE ,@p_POL_WIEK,@p_POL_PRZEBIEG,
	@p_POL_TECHDEC_DESC ,@p_POL_ATTACH ,@p_POL_UMO_WART ,@p_POL_MIN_ODSP ,@p_POL_WART_ODSP ,@p_POL_ZARZ_BIZ
  end try
  begin catch
   select @v_syserrorcode = error_message()
   select @v_errorcode = 'ERR_INS'
   goto errorlabel
  end catch
 end
 else
 begin
  begin try


  /*Ustawienie statusu zablokowany dla wszytskich pozostałych dokumentów, jeżeli dla danego składnika została zmieniona ocena*/
  if @p_STATUS not in ('POL_004','POL_007') and exists (select * from dbo.OBJTECHPROTLN where POL_OBJID = @p_OBJID and POL_STATUS = 'POL_004')
	begin
		update dbo.OBJTECHPROTLN
		set POL_STATUS = 'POL_007'
		where POL_POTID <> @p_ROWID
		and POL_OBJID = @p_OBJID
		and POL_STATUS = 'POL_004'
	end

	/*Jeżeli została zmieniona ocena dla składnika, wywalamy komunikat*/
	if @p_STATUS not in ('POL_004','POL_007') and exists (select * from dbo.OBJTECHPROTLN where POL_OBJID = @p_OBJID and POL_STATUS not in ('POL_004','POL_007'))
	begin 
	declare @mess nvarchar(max)
	select @mess = 'Nie można zmienić statusu składnika. Składnik ' + @p_OBJ + ' jest już obsługiwany w innym dokumencie.'
		set @v_errorcode = ''
		RaisError (@mess,16,1)
		goto errorlabel
	end



  declare @STS_SETTYPE nvarchar(30)
  select @STS_SETTYPE = STS_SETTYPE from STENCIL where STS_ROWID = (select OBJ_STSID from OBJ where OBJ_ROWID = @p_OBJID)
  if @STS_SETTYPE in ('ZES') --and (@p_STATUS_OLD <> @p_STATUS and @p_STATUS_OLD = 'POL_004')
  begin
	select @v_syserrorcode = error_message()
	select @v_errorcode = 'POLN_003'
	goto errorlabel
  end
  if @STS_SETTYPE in ('EZES') and @v_POT_RETURN = 0 and (@p_STATUS_OLD <> @p_STATUS and @p_STATUS_OLD <> 'POL_004')  and exists (select * from dbo.OBJTECHPROTLN    
  where POL_POTID = @p_POTID
  and POL_OBJID in (select OBJ_ROWID from OBJ where OBJ_STSID in
    (select OBJ_STSID from OBJ where OBJ_ROWID = @p_OBJID
    union all
    (select STL_CHILDID from STENCILLN where STL_PARENTID in (select OBJ_STSID from OBJ where OBJ_ROWID = @p_OBJID))
 union all
 (select STL_PARENTID  from STENCILLN where STL_CHILDID in (select OBJ_STSID from OBJ where OBJ_ROWID = @p_OBJID))
 union all
 select STL_CHILDID from STENCILLN where STL_PARENTID in (select STL_PARENTID  from STENCILLN where STL_CHILDID in (select OBJ_STSID from OBJ where OBJ_ROWID = @p_OBJID)))
 ) )
 begin
 select @v_syserrorcode = error_message()
 select @v_errorcode = 'POLN_002'
   goto errorlabel
 end
  update dbo.OBJTECHPROTLN set        
   POL_TO_STNID = case when @p_STATUS in('POL_005','POL_003') then @v_TO_STNID else null end,
   POL_OBJID = @v_OBJID,
   POL_OLDQTY = @v_OLDQTY,
   POL_NEWQTY = @p_NEWQTY,
   POL_PARTIAL = @p_PARTIAL,
   POL_COM01 = @p_COM01,
   POL_COM02 = @p_COM02,
   POL_DTX01 = @p_DTX01,
   POL_DTX02 = @p_DTX02,
   POL_DTX03 = @p_DTX03,
   POL_DTX04 = @p_DTX04,
   POL_DTX05 = @p_DTX05,
   POL_NTX01 = @p_NTX01,
   POL_NTX02 = @p_NTX02,
   POL_NTX03 = @p_NTX03,
   POL_NTX04 = @p_NTX04,
   POL_NTX05 = @p_NTX05,
   POL_TXT01 = @p_TXT01,
   POL_TXT02 = @p_TXT02,
   POL_TXT03 = @p_TXT03,
   POL_TXT04 = @p_TXT04,        
   POL_TXT05 = @p_TXT05,
   POL_TXT06 = @p_TXT06,   
   POL_TXT07 = @p_TXT07,
   POL_TXT08 = @p_TXT08,
   POL_TXT09 = @p_TXT09,
   POL_CODE = @v_POT_CODE,
   POL_DATE = @p_DATE,
   POL_DESC = @v_POT_DESC,
   POL_NOTE = @p_NOTE,
   POL_NOTUSED = @p_NOTUSED,
   POL_ORG = @p_ORG,   
   POL_RSTATUS = @p_RSTATUS,
   POL_STATUS = @p_STATUS,
   POL_TYPE = @p_TYPE,
   POL_TYPE2 = @p_TYPE2, 
   POL_TYPE3 = @p_TYPE3,
   POL_UPDDATE = getdate(),
   POL_UPDUSER = @p_UserID,
   POL_PRICE = 0,
   POL_BIZ_DEC = @p_POL_BIZ_DEC,
   POL_ADHOC = @p_POL_ADHOC,
   POL_LIKW_TYPE = @p_POL_LIKW_TYPE,
   POL_LIKW_ADHOC = @p_POL_LIKW_ADHOC,
   POL_TECHDEC_TYPE = @p_POL_TECHDEC_TYPE,
   POL_WIEK = @p_POL_WIEK,
   POL_PRZEBIEG = @p_POL_PRZEBIEG,
   POL_TECHDEC_DESC = @p_POL_TECHDEC_DESC,
   POL_ATTACH = @p_POL_ATTACH,
   POL_UMO_WART = @p_POL_UMO_WART,
   POL_MIN_ODSP = @p_POL_MIN_ODSP,
   POL_WART_ODSP = @p_POL_WART_ODSP,
   POL_ZARZ_BIZ = @p_POL_ZARZ_BIZ 
  where POL_ID = @p_ID  
  end try
  begin catch
   select @v_syserrorcode = error_message()
   select @v_errorcode = 'ERR_UPD'
   goto errorlabel
  end catch 
 end
 return 0

errorlabel:   
exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output        
 raiserror (@v_errortext, 16, 1)
 select @p_apperrortext = @v_errortext        
 return 1        
end
GO