SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_NEW_OBJ_Update_Proc]  
(  
 @p_ASTID int,  
 @p_STS nvarchar(30),  
 @p_STNID int,  
 @p_UserID nvarchar(30) = NULL, -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
     
 declare @v_errorcode nvarchar(50)  
  , @v_syserrorcode nvarchar(4000)  
  , @v_errortext nvarchar(4000)  
  , @v_date datetime  
  , @v_STSID int  
  , @v_OBJID int  
  , @v_ASTID int  
  , @v_EXIST_STSID int --już istniejący składnik z szablonu  
  , @v_EXIST_OBJID nvarchar(30) --już istniejący obiekt  
  , @v_STS_CODE nvarchar(30)  
  , @v_STT_MAIN int  
  , @v_SETTYPE NVARCHAR(30)  
  , @v_ANOID int   
    
    
 set @v_date = getdate()  
  
 select @v_STSID = STS_ROWID, @v_SETTYPE = STS_SETTYPE from STENCIL (nolock) where STS_CODE = @p_STS  
         
 /*if @v_SETTYPE in ('KOM','ZES') and not exists (select * from STENCILLN (nolock) where STL_PARENTID = @v_STSID)  
 begin  
  select @v_errorcode = 'STS_006'--Błędna konfiguracja szablonu. Wybrany zestaw/komplet nie ma żadnego elementu.  
  goto errorlabel --select * From vs_langmsgs where objectid = 'STS_006'  
 end*/  
  
 --wystawiony składnik (przynajmniej jeden)  
 select top 1   
  @v_EXIST_OBJID = OBJ_ROWID,  
  @v_EXIST_STSID = OBJ_STSID,  
  @v_STT_MAIN = STT_MAIN --gdy jest mai  
 from [dbo].[ASTINW_NEW_OBJ] (nolock)  
  join [dbo].[STENCIL] (nolock) on STS_ROWID = ANO_STSID  
  join [dbo].[SETTYPE] (nolock) on STT_CODE = STS_SETTYPE  
  left join [dbo].[OBJ] (nolock) on OBJ_ANOID = ANO_ROWID  
 where ANO_ASTID = @p_ASTID --main = 1  
  --and INO_STSID = @v_STSID  
   
 if @v_EXIST_OBJID is not null and isnull(@v_EXIST_STSID,0) <> isnull(@v_STSID,0)  
 begin   
  --select @v_errorcode = 'ANO_003'--Dla tej pozycji inwentaryzacji został już wygenerowany składnik z innego szablonu.  
  --goto errorlabel --select * From vs_langmsgs where objectid = 'ANO_003'
   update OBJ
 set OBJ_ANOID = null
 where OBJ_ROWID = @v_EXIST_OBJID
    
 end  
   
 if @v_EXIST_OBJID is not null and isnull(@v_EXIST_STSID,0) = isnull(@v_STSID,0)  
 begin   
  select @v_errorcode = 'ANO_004'--Dla tej pozycji inwentaryzacji został już wygenerowany składnik z tego szablonu.  

    
  goto errorlabel --select * From vs_langmsgs where objectid = 'ANO_004'  
 end  
   
 --nie istnieje skłądnik (wystawiam z szablonu)  
 if not exists (select 1 from [ASTINW_NEW_OBJ] (nolock) where ANO_ASTID = @p_ASTID)  
 begin  
  insert into [ASTINW_NEW_OBJ] (ANO_ASTID, ANO_STSID, ANO_STNID, ANO_CODE, ANO_ORG, ANO_DESC, ANO_DATE, ANO_STATUS, ANO_TYPE, ANO_TYPE2, ANO_TYPE3, ANO_RSTATUS, ANO_CREUSER, ANO_CREDATE, ANO_NOTUSED, ANO_ID)  
  select @p_ASTID, STS_ROWID, @p_STNID, NULL, STS_ORG, '', getdate(), NULL, NULL, NULL, NULL, 0, @p_UserID, getdate(), 0, newid()  
  from STENCIL (nolock)   
  where STS_ROWID = @v_STSID  
 end  
 else  
 begin  
   update [ASTINW_NEW_OBJ] set  
   ANO_STSID = @v_STSID,  
   ANO_UPDDATE = getdate(),  
   ANO_UPDUSER = @p_UserID  
  where ANO_ASTID = @p_ASTID  
 end  
   
 select top 1 @v_ANOID = ANO_ROWID from [ASTINW_NEW_OBJ] (nolock) where ANO_ASTID = @p_ASTID  
 select @v_SETTYPE = STS_SETTYPE  from dbo.STENCIL (nolock) where STS_CODE = @p_STS  
    
 --wystawiam obiekt  
 if @v_SETTYPE not in ('ZES','KOM')  
 begin   
  exec [dbo].[INWAST_ADD_OBJ_Proc]   
   @p_FormID = '',   
   @p_ANOID = @v_ANOID,  
   @p_UserID=@p_UserID  
   
  raiserror(N'. Składnik został utworzony poprawnie ',1,1)  
    
 end  
   
 if not exists (select * from OBJASSET (nolock) where OBA_ASTID = @v_ASTID and OBA_OBJID = @v_OBJID)   
  and @v_ASTID is not null  
  and @v_OBJID is not null  
 begin  
   
  insert into OBJASSET (OBA_OBJID, OBA_ASTID, OBA_CREDATE)  
  select @v_OBJID, @v_ASTID, GETDATE()  
     
 end  
 else if @v_ASTID is not null and @v_OBJID is not null  
 begin  
  update OBJASSET   
  set OBA_OBJID = @v_OBJID  
  where OBA_ASTID = @v_ASTID  
 end  
   
 return   
  
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
  
end  
GO