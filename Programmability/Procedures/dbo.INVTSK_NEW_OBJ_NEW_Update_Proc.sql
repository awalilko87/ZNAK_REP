SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_NEW_OBJ_NEW_Update_Proc]  
(  
 @p_ROWID int,  
 @p_PSP nvarchar(30),  @p_STS nvarchar(30),  @p_STNID int,  
 @p_QTY int,  
  
 @p_UserID nvarchar(30) = NULL, -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output ,
 @p_INOID INT = NULL OUTPUT -- GK [20200618]
)  
as  
begin  
     
 declare @v_errorcode nvarchar(50)  
  , @v_syserrorcode nvarchar(4000)  
  , @v_errortext nvarchar(4000)  
  , @v_date datetime  
  , @v_PSPID int   , @v_STSID int   , @v_EXSTSID int  
  , @v_STS_CODE nvarchar(30)  
  , @v_OBJ_COUNT int  
  , @v_OTID int  
  , @v_SETTYPE nvarchar(30)  
  , @v_OPER_TYPE nvarchar(10)  
  , @v_ITSID int
  
 set @v_date = getdate()  
    
 select @v_PSPID = PSP_ROWID, @v_ITSID = PSP_ITSID from PSP (nolock) where PSP_CODE = @p_PSP  
 select @v_STSID = STS_ROWID, @v_SETTYPE = STS_SETTYPE from STENCIL (nolock) where STS_CODE = @p_STS   
   
 if @v_SETTYPE in ('ZES','KOM')   --Przycisk na formatce: "Sprawdz szablon"  
  select @v_OPER_TYPE = 'CHECK'  
 else --Przycisk na formatce: "Utwórz składnik"  
  select @v_OPER_TYPE = 'INSERT'   
  
 --wystawiony składnik (przynajmniej jeden)  
 select top 1   
  @v_OBJ_COUNT = COUNT(*),  
  @v_EXSTSID = OBJ_STSID,  
  @v_OTID = OT_ROWID  
 from [INVTSK_NEW_OBJ] (nolock)  
  join STENCIL (nolock) on STS_ROWID = INO_STSID  
  join SETTYPE (nolock) on STT_CODE = STS_SETTYPE  
  left join OBJ (nolock) on OBJ_INOID = INO_ROWID  
  left join ZWFOT (nolock) on OT_INOID = INO_ROWID  
 where   
  INO_ROWID = @p_ROWID   
  --INO_PSPID = @v_PSPID --main = 1  
  --and INO_STSID = @v_STSID  
 group by   
  OBJ_STSID,OT_ROWID  
   
 --if exists (select 1 from OBJ (nolock) where    
 -- OBJ_INOID = @p_ROWID and   
 -- OBJ_OTID is not null  )  
 --begin   
 -- select @v_errorcode = 'ITS_001'--Dla tego elementu PSP został już wygenerowany dokument księgowy.  
 -- --select * From vs_langmsgs where objectid = 'ITS_001'  
 -- goto errorlabel  
 --end  
   
 --if ISNULL(@v_OBJ_COUNT,0) > 0  and isnull(@v_OTID,0) <> 0 and isnull(@v_OBJ_COUNT,0) >= isnull(@p_QTY,0)  
 --begin   
 -- select @v_errorcode = 'ITS_001'  
 -- --select * From vs_langmsgs where objectid = 'ITS_001'  
 -- goto errorlabel  
 --end  
 --else if ISNULL(@v_OBJ_COUNT,0) > 0 and isnull(@v_EXSTSID,0) = isnull(@v_STSID,0) and isnull(@v_OBJ_COUNT,0) >= @p_QTY  
 --begin    
 -- select @v_errorcode = 'ITS_003'  
 -- --select * From vs_langmsgs where objectid = 'ITS_003'  
 -- goto errorlabel  
 --end  
    
 if @p_STS NOT in   
 (  
  select STS_CODE  
  from dbo.STENCIL (nolock)  
   left JOIN dbo.STENCILLN (nolock) on STL_PARENTID = STS_ROWID  
  where STS_SETTYPE in ('ZES','KOM') AND STL_CHILDID IS NOT NULL  
  group by STS_ROWID,STS_CODE  
  having count(STL_CHILDID) > 0   
 ) and @p_STS in (select STS_CODE from STENCIL (nolock) where STS_CODE = @p_STS and STS_SETTYPE in ('ZES','KOM'))  
 begin   
  select @v_errorcode = 'ITS_005'  
  --select * From vs_langmsgs where objectid = 'ITS_005'  
  goto errorlabel  
 end  
  
 --Z formatki 0, to oznacza zakup centralny.  
 if @p_STNID = 0 select @p_STNID = NULL  
   
 if @v_OPER_TYPE = 'INSERT'  
  select @p_ROWID = NULL  
   
 --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
 --+++++++++++++++++++++++INSERT++++++++++++++++++++++++++++++++++++++++  
 --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
 if @p_ROWID is null  
 begin  
    
  --usuwa stare wpisy (dla których żaden składnik nie powstał) 
  ;with ob as (select OBJ_INOID from dbo.OBJ where OBJ_INOID is not null) 
  delete from [INVTSK_NEW_OBJ] where INO_CREUSER = @p_UserID and not exists (select 1 from ob where isnull(OBJ_INOID,0) = INO_ROWID)
    and not exists (select 1 from ZWFOT where ino_rowid = ot_inoid)  
     
  insert into [INVTSK_NEW_OBJ] (INO_ITSID, INO_QTY, INO_STSID, INO_PSPID, INO_STNID, INO_CODE, INO_ORG, INO_DESC, INO_DATE, INO_STATUS, INO_TYPE, INO_TYPE2, INO_TYPE3, INO_RSTATUS, INO_CREUSER, INO_CREDATE, INO_NOTUSED, INO_ID)  
  select @v_ITSID, @p_QTY, STS_ROWID, @v_PSPID, @p_STNID, NULL, STS_ORG, '', getdate(), NULL, NULL, NULL, NULL, 0, @p_UserID, getdate(), 0, newid()  
  from STENCIL (nolock) where STS_ROWID = @v_STSID  
  
  select @p_ROWID = IDENT_CURRENT('dbo.INVTSK_NEW_OBJ')  
     
  --wystawiam obiekt (tylko przy składnikach pojedynczych (nie dla zestawu i kompletu) w tym miejscu wystawiany jest nowy składnik)  
  --Przycisk na formatce: "utwórz składnik" tworzy,   
  if @v_OPER_TYPE = 'INSERT'  
  begin  
  
   exec [dbo].[INVTSK_ADD_OBJ_Proc]   
    @p_FormID = '',   
    @p_INOID = @p_ROWID,  
    @p_OBJ_PSP = @p_PSP,   
    @p_STS = @p_STS,  
    @p_UserID=@p_UserID;  
      
   raiserror(N'. Składnik został utworzony poprawnie ',1,1)  
    
  end  
  
 end  
 else  
 --+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=  
 --=+=+=+=+=+=+=+=+=+=+=+=UPDATE+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+  
 --+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=  
 begin  
  
  --Przycisk na formatce: "sprawdź szablon"  
  if @v_OPER_TYPE = 'CHECK'  
  begin  
  
   update [INVTSK_NEW_OBJ] set  
    INO_QTY = @p_QTY,   
    INO_STSID = @v_STSID,   
    INO_PSPID = @v_PSPID,   
    INO_STNID = @p_STNID,   
    INO_CODE = NULL,   
    INO_ORG = 'PKN',   
    INO_DESC = '',   
    INO_DATE = GETDATE(),   
    INO_STATUS = NULL,   
    INO_TYPE = NULL,   
    INO_TYPE2 = NULL,   
    INO_TYPE3 = NULL,   
    INO_RSTATUS = 0,   
    INO_CREUSER = @p_UserID,   
    INO_CREDATE = GETDATE()     
   where INO_ROWID = @p_ROWID  
  end  
  
 end  
   
   SET @p_INOID = @p_ROWID -- GK [20200618]

 return   
  
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
  
end

GO