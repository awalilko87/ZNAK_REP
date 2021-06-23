SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_REQUEST_Accept_Proc]  
(  
 @p_ID nvarchar(50),  
 @p_STATUS nvarchar(20),  
 @p_TYPE nvarchar(30),  
 @p_NOTE nvarchar(max),  
  
    @p_UserID varchar(20),    
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin   
  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_date datetime    
 declare @v_OBJID int  
 declare @v_OBJGROUP nvarchar(30)  
 declare @v_STNID_TO int  
 declare @v_STATUS_old nvarchar(30)
 declare @v_GUID nvarchar(50)  
  
 if exists (select 1 from [dbo].[SP_REQUEST] (nolock) where SRQ_ROWID = @p_ID)  
 begin  
   
  --SRQ_003 Potwierdzony  
  --SRQ_005 Odrzucony  
  
  /*if exists (select * from [dbo].[SP_REQUEST] (nolock) where SRQ_ID = @p_ID and SRQ_STATUS in ('SRQ_003','SRQ_005'))  
  begin   
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'SRQ_003'  
   goto errorlabel  
  end */  
    
  if @p_TYPE = 'ZABRANIE'  
  begin  
   select @v_errorcode = 'SRQ_005'  
   goto errorlabel  
  end  
    
  select   
    @v_OBJID = SRQ_OBJID  
   ,@v_STNID_TO = SRQ_STNID_TO  
   ,@v_STATUS_old = SRQ_STATUS
   ,@v_GUID = SRQ_ID  
  from [dbo].[SP_REQUEST] (nolock)  
  where SRQ_ROWID = @p_ID  
    
  if (@p_STATUS = 'SRQ_005')   
  begin  
    -- aktualizacja statusu na składniku w przypadku odrzucenia dokumentu  
    update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID = @v_OBJID   
     
  end  
    
  begin try  
   update dbo.SP_REQUEST set   
    SRQ_STATUS = @p_STATUS,  
    SRQ_NOTE = @p_NOTE,  
    SRQ_TYPE = @p_TYPE  
   where SRQ_ROWID = @p_ID  
     
   exec dbo.STAHIST_Add_Proc 'SRQ', @v_GUID, @p_STATUS, @v_STATUS_old, @p_UserID  
      
   select  
    @v_OBJGROUP = OBG_CODE  
   from dbo.OBJ  
   join dbo.OBJGROUP on OBG_ROWID = OBJ_GROUPID  
   where OBJ_ROWID = @v_OBJID  
     
   if @p_STATUS = 'SRQ_004' and @p_TYPE = 'PRZENIESIENIE' and @v_OBJGROUP = 'GRUPA VIII' and @v_OBJID is not null  
   begin  
    delete from dbo.OBJSTATION where OSA_OBJID = @v_OBJID  
      
    insert into dbo.OBJSTATION(OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)  
    select @v_OBJID, STN_ROWID, STN_KL5ID, getdate(), @p_UserID  
    from dbo.STATION  
    where STN_ROWID = @v_STNID_TO  
   end  
   else if @p_STATUS = 'SRQ_004' and @p_TYPE = 'ZABRANIE' and @v_OBJGROUP = 'GRUPA VIII' and @v_OBJID is not null  
   begin  
    delete from dbo.OBJSTATION where OSA_OBJID = @v_OBJID  
      
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_007'  
     ,OBJ_NOTUSED = 1  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
   end  
   else if @p_STATUS = 'SRQ_007' and @p_TYPE like 'SERWIS%'  
   begin  
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_004'  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
   end   
   else if @p_STATUS = 'SRQ_007' and @p_TYPE not like 'SERWIS%'  
   begin  
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_005'  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
   end   
   else if @p_STATUS = 'SRQ_008' and @v_STATUS_old = 'SRQ_007' and @p_TYPE like 'SERWIS%'  
   begin  
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_002'  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
       
    update dbo.SP_REQUEST set  
     SRQ_STATUS = 'SRQ_006'  
    where SRQ_ROWID = @p_ID  
      
    exec dbo.STAHIST_Add_Proc 'SRQ', @v_GUID, 'SRQ_006', @p_STATUS, @p_UserID  
   end  
   else if @p_STATUS = 'SRQ_008' and @p_TYPE like 'SERWIS%'  
   begin  
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_002'  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
       
    update dbo.SP_REQUEST set  
     SRQ_STATUS = 'SRQ_006'  
    where SRQ_ROWID = @p_ID  
      
    exec dbo.STAHIST_Add_Proc 'SRQ', @v_GUID, 'SRQ_006', @p_STATUS, @p_UserID  
       
    delete from dbo.OBJSTATION where OSA_OBJID = @v_OBJID  
       
    insert into dbo.OBJSTATION(OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)  
    select @v_OBJID, STN_ROWID, STN_KL5ID, getdate(), @p_UserID  
    from dbo.STATION  
    where STN_ROWID = @v_STNID_TO  
  
    update dbo.PROPERTYVALUES set  
      PRV_VALUE = STN_LF  
     ,PRV_TOSEND = 1  
    from dbo.OBJ  
    inner join dbo.ADDSTSPROPERTIES on ASP_STSID = OBJ_STSID  
    inner join dbo.PROPERTIES on PRO_ROWID = ASP_PROID and PRO_CODE = 'SAPPM_LOCATION'  
    inner join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID  
    inner join dbo.STATION on STN_ROWID = OSA_STNID  
    where OBJ_ROWID = @v_OBJID and PRV_PKID = OBJ_ROWID and PRV_PROID = PRO_ROWID and PRV_ENT = 'OBJ'  
   end  
   else if @p_STATUS = 'SRQ_008' and @p_TYPE not like 'SERWIS%'  
   begin  
    if not exists (select 1 from dbo.OBJASSET where OBA_OBJID = @v_OBJID)  
    begin  
     update dbo.OBJ set  
       OBJ_STATUS = 'OBJ_002'  
      ,OBJ_UPDUSER = @p_UserID  
      ,OBJ_UPDDATE = getdate()  
     where OBJ_ROWID = @v_OBJID  
       
     update dbo.SP_REQUEST set  
      SRQ_STATUS = 'SRQ_006'  
     where SRQ_ROWID = @p_ID  
       
     exec dbo.STAHIST_Add_Proc 'SRQ', @v_GUID, 'SRQ_006', @p_STATUS, @p_UserID  
       
     delete from dbo.OBJSTATION where OSA_OBJID = @v_OBJID  
       
     insert into dbo.OBJSTATION(OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)  
     select @v_OBJID, STN_ROWID, STN_KL5ID, getdate(), @p_UserID  
     from dbo.STATION  
     where STN_ROWID = @v_STNID_TO  
  
     update dbo.PROPERTYVALUES set  
       PRV_VALUE = replace(ASP_VALUE, '++++', right('0000'+isnull(convert(varchar,STN_CODE),''),4))  
      ,PRV_TOSEND = 1  
     from dbo.OBJ  
     inner join dbo.ADDSTSPROPERTIES on ASP_STSID = OBJ_STSID  
     inner join dbo.PROPERTIES on PRO_ROWID = ASP_PROID and PRO_CODE = 'SAPPM_LOCATION'  
     inner join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID  
     inner join dbo.STATION on STN_ROWID = OSA_STNID  
     where OBJ_ROWID = @v_OBJID and PRV_PKID = OBJ_ROWID and PRV_PROID = PRO_ROWID and PRV_ENT = 'OBJ'  
    end  
   end  
   else if @p_STATUS = 'SRQ_006' and @p_TYPE like 'SERWIS%'  
   begin  
    update dbo.OBJ set  
      OBJ_STATUS = 'OBJ_005'  
     ,OBJ_UPDUSER = @p_UserID  
     ,OBJ_UPDDATE = getdate()  
    where OBJ_ROWID = @v_OBJID  
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
  select @v_syserrorcode = error_message()  
  select @v_errorcode = 'ERR_UPD'  
  goto errorlabel  
 end   
     
 return 0  
   
errorlabel:  
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
 raiserror (@v_errortext, 16, 1)   
 select @p_apperrortext = @v_errortext  
 return 1  
end  
GO