SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_REQUEST_Update_Proc]    
(    
 @p_FORMID nvarchar(50),    
 @p_ID nvarchar(50),    
    @p_OBJID int,    
 @p_STNID int,     
  @p_TYPE nvarchar(30),    
 @p_REPLACEMENT nvarchar(100),    
 @p_STATUS nvarchar(20), -- SRQ_002(Utworzony), SRQ_001 (Zaplanowany)    
 @p_REASON nvarchar(2000),   
 @p_NR_ZAW_PM int,    
    @p_UserID varchar(30),      
    @p_GroupID nvarchar(30),    
 @p_apperrortext nvarchar(4000) = null output    
)    
as    
begin     
    
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_date datetime    
 declare @v_Rstatus int    
 declare @v_Pref nvarchar(20)    
 declare @v_MultiOrg bit    
 declare @v_ASTID int    
 declare @v_CODE nvarchar(30)    
 declare @v_OLDQTY numeric(30,6)    
 declare @v_ID nvarchar(50)    
 declare @v_ROTARY tinyint    
 declare @v_BARCODE nvarchar(30)    
  , @v_STNID_FROM int    
  , @v_KL5ID_FROM int    
  , @v_STNID_TO int    
  , @v_KL5ID_TO int    
  , @v_STNCODE_FROM nvarchar(30)    
  , @v_TYPE_old nvarchar(30) 
  , @v_OBJSTATUS nvarchar(30)   
     
 select     
  @v_STNID_FROM = OSA_STNID,     
  @v_KL5ID_FROM = OSA_KL5ID,    
  @v_STNCODE_FROM = STN_CODE    
 from dbo.OBJSTATION (nolock)     
 left join dbo.STATION on STN_ROWID = OSA_STNID    
 where OSA_OBJID = @p_OBJID    
    
 select     
  @v_STNID_TO = STN_ROWID,     
  @v_KL5ID_TO = STN_KL5ID    
 from dbo.STATION (nolock)     
 where STN_ROWID = @p_STNID    
     


 select    
  @v_ROTARY = isnull(STS_ROTARY,0)  
 ,@v_OBJSTATUS = OBJ_STATUS 
 from dbo.OBJ    
 left join dbo.STENCIL on STS_ROWID = OBJ_STSID    
 where OBJ_ROWID = @p_OBJID    
     
 if @v_STNID_TO is null and isnull(@p_TYPE,'') <> 'ZABRANIE'    
 begin    
  raiserror('Błędna stacja docelowa / serwis', 16, 1)    
  return 1    
 end    
    
 if 1=2    
 begin     
  select @v_errorcode = 'SYS_001'    
  goto errorlabel    
 end    
 
 /*Dla składników w statusie 'niedobór' można jedynie przenieść do serwisu*/
 if  @v_OBJSTATUS = 'OBJ_010' and @p_TYPE not in ('SERWIS','SERWIS_ZAST')

		begin 
		  select @v_errorcode = 'SRQ_008'    
		  goto errorlabel  	
		end
     
 if @p_FORMID = 'SP_REQUEST_DOK' and @p_TYPE = 'ZABRANIE'    
 begin    
  select @v_errorcode = 'SRQ_005'    
  goto errorlabel    
 end    
     
 if @p_TYPE = 'SERWIS_ZAST' and @v_ROTARY = 1    
 begin    
  select @v_errorcode = 'SRQ_006'    
  goto errorlabel    
 end    
     
 --if @v_STNID_TO = @v_STNID_FROM    
 --begin    
 -- select @v_errorcode = 'SRQ_007'    
 -- goto errorlabel    
 --end    
      
 if not exists (select 1 from [dbo].[SP_REQUEST] (nolock) where SRQ_ID = @p_ID)    
 begin    
  set @v_Pref = 'ZGL_'+isnull(@v_STNCODE_FROM+'_','')    
  exec dbo.VS_GetNumber 'ZGL', @v_Pref, '', @v_CODE output, null    
  set @v_ID = NEWID()    
  set @p_STATUS = case when @p_FORMID = 'SP_OBJ_RC' then 'SRQ_007' else 'SRQ_001' end    
      
  if exists (select 1 from dbo.SP_REQUEST where SRQ_OBJID = @p_OBJID and SRQ_STATUS not in ('SRQ_005', 'SRQ_006'))    
  begin    
   select @v_errorcode = 'SRQ_004'    
   goto errorlabel    
  end    
      
  if @p_OBJID in (select OBJID from dbo.GetBlockedObj())    
  begin    
   select @v_errorcode = 'SRQ_001'    
   goto errorlabel    
  end    
      
  begin try    
   insert into [dbo].[SP_REQUEST](SRQ_CODE, SRQ_ORG, SRQ_DESC, SRQ_DATE, SRQ_STATUS, SRQ_TYPE, SRQ_TYPE2, SRQ_TYPE3,    
           SRQ_RSTATUS, SRQ_CREUSER, SRQ_CREDATE, SRQ_UPDUSER, SRQ_UPDDATE, SRQ_NOTUSED, SRQ_ID,    
           SRQ_OBJID, SRQ_STNID_FROM, SRQ_KL5ID_FROM, SRQ_STNID_TO, SRQ_KL5ID_TO, SRQ_REPLACEMENT, SRQ_REASON, SRQ_NR_ZAW_PM)    
   select @v_CODE, 'PKN', '', GETDATE(), @p_STATUS, @p_TYPE, NULL, NULL,    
      0, @p_UserID, GETDATE(), NULL, NULL, 0, @v_ID,    
      @p_OBJID, @v_STNID_FROM, @v_KL5ID_FROM, @v_STNID_TO, @v_KL5ID_TO, @p_REPLACEMENT, @p_REASON, @p_NR_ZAW_PM    
        
   exec dbo.STAHIST_Add_Proc 'SRQ', @v_ID, @p_STATUS, null, @p_UserID    
       
   if @p_FORMID = 'SP_OBJ_RC' and @p_TYPE like 'SERWIS%'    
   begin    
    update dbo.OBJ set    
     OBJ_STATUS = 'OBJ_004'    
     ,OBJ_UPDUSER = @p_UserID    
     ,OBJ_UPDDATE = getdate()    
    where OBJ_ROWID = @p_OBJID    
   end    
    
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
   update [dbo].[SP_REQUEST] set    
    SRQ_DESC = '',    
    --SRQ_DATE = GETDATE(),    
    --SRQ_STATUS = @p_STATUS,    
    SRQ_TYPE = @p_TYPE,    
    SRQ_TYPE2 = NULL,    
    SRQ_TYPE3 = NULL,    
    SRQ_RSTATUS =  0,    
    SRQ_UPDUSER = @p_UserID,    
    SRQ_UPDDATE = GETDATE(),    
    SRQ_NOTUSED = 0,    
    --SRQ_ID = NEWID(),    
    SRQ_OBJID = @p_OBJID,    
    SRQ_STNID_FROM = @v_STNID_FROM,    
    SRQ_KL5ID_FROM = @v_KL5ID_FROM,    
    SRQ_STNID_TO = @v_STNID_TO,    
    SRQ_KL5ID_TO = @v_KL5ID_TO,    
    SRQ_REPLACEMENT = @p_REPLACEMENT ,    
    SRQ_REASON = @p_REASON,    
    @v_TYPE_old = SRQ_TYPE,  
    SRQ_NR_ZAW_PM = @p_NR_ZAW_PM             
   where SRQ_ID = @p_ID    
       
   if @p_TYPE like 'SERWIS%' and @v_TYPE_old = 'ZABRANIE'    
   begin    
    update dbo.OBJ set    
     OBJ_STATUS = 'OBJ_004'    
     ,OBJ_UPDUSER = @p_UserID    
     ,OBJ_UPDDATE = getdate()    
    where OBJ_ROWID = @p_OBJID       
   end    
   else if @p_TYPE like 'PRZENIESIENIE' and @v_TYPE_old = 'ZABRANIE'    
   begin    
    update dbo.OBJ set    
     OBJ_STATUS = 'OBJ_005'    
     ,OBJ_UPDUSER = @p_UserID    
     ,OBJ_UPDDATE = getdate()    
    where OBJ_ROWID = @p_OBJID       
   end    
  end try    
  begin catch    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'ERR_UPD'    
   goto errorlabel    
  end catch    
 end     
    
    
 /*if @p_TYPE = 'POWROT'     
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID = @p_OBJID    
 else if @p_TYPE = 'PRZENIESIENIE'    
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID = @p_OBJID    
 else if @p_TYPE = 'SERWIS'    
  update OBJ set OBJ_STATUS = 'OBJ_004' where OBJ_ROWID = @p_OBJID    
 else if @p_TYPE = 'SERWIS_ZAST'    
  update OBJ set OBJ_STATUS = 'OBJ_004' where OBJ_ROWID = @p_OBJID    
 else if @p_TYPE = 'ZABRANIE'    
  update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID = @p_OBJID*/    
       
 return 0    
     
errorlabel:    
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
 select @p_apperrortext = @v_errortext    
 return 1    
end 
GO