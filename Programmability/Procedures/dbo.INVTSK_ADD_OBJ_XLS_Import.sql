SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_XLS_Import]         
(         
@p_ITSID int,        
@p_PSP nvarchar(30),      
@p_UserID nvarchar(30)        
)        
 as         
 begin         
         
 declare          
  @v_PARENTID int,        
  @v_STSID int,        
  @c_STN int,        
  @v_STNID int,       
  @c_PSPID int,        
  @c_PSP nvarchar(30),        
  @v_OBJID int,        
  @v_ASTID int,        
  @c_STS nvarchar(30), --STS_CODE        
  @c_VALUE numeric(24,6), --VALUE        
  @c_QTY int, --QTY        
  @v_COUNT int = 0, --QTY        
  @v_INOID int = 0 ,        
  @c_PARENT_OBJ nvarchar(30),        
  @c_ROWID int,        
  @v_NEW_OBJID int,   
  @c_SERIAL nvarchar(30),
  @c_NIESTAND nvarchar(30),   
  @v_NIESTAND numeric(8,2),    
  @v_i int,        
  @v_ADD_PARAMS xml,  
  @v_errorcode nvarchar(50),        
  @v_errortext nvarchar(4000),        
  @v_syserrorcode nvarchar(4000),        
  @p_apperrortext nvarchar(max),
  @c_DEVICE_PM_NUMBER nvarchar(max),
  @c_REQUIREMENT nvarchar(max);        
        
-- select @v_PSPID = PSP_ROWID from dbo.PSP where PSP_CODE = @p_PSP        
        
 declare c_XLS cursor for        
 select rowid, c01, c02, c03, replace(replace(nullif(c04,''),',','.'),' ',''), replace(replace(nullif(c05,''),',','.'),' ',''), c06, c07, c08, c09, c10 from dbo.INVTSK_ADD_OBJ_XLS where importuser = @p_UserID order by rowid        
 open c_XLS        
 fetch next from c_XLS into @c_ROWID, @c_STN, @c_STS, @c_PARENT_OBJ, @c_QTY, @c_VALUE, @c_PSP, @c_SERIAL, @c_NIESTAND, @c_DEVICE_PM_NUMBER, @c_REQUIREMENT
 while @@FETCH_STATUS = 0         
 begin        
      
if (@c_PSP is null or @c_PSP = '')    
set @c_PSP = @p_PSP    

 select @v_NIESTAND = case when @c_NIESTAND = 'TAK' then '1' else '0' end
    
 select @c_PSPID = PSP_ROWID FROM PSP WHERE psp_code = @c_PSP      
  
  set @v_i = isnull(@c_QTY,1)        
    
  select @v_STSID =   
  case   
  when @c_STS  = '' and @c_PARENT_OBJ <> '' then (select OBJ_STSID from obj where OBJ_CODE =  @c_PARENT_OBJ)  
  when @c_STS <> '' and @c_PARENT_OBJ <> '' then (select STS_ROWID from dbo.STENCIL where STS_CODE = @c_STS)   
  when @c_STS <> '' and @c_PARENT_OBJ = '' then (select STS_ROWID from dbo.STENCIL where STS_CODE = @c_STS)   
  end  

     
  select top 1 @v_STNID = STN_ROWID from dbo.STATION where STN_CODE = @c_STN and STN_TYPE in ('STACJA', 'SERWIS') order by nullif(STN_TYPE, 'STACJA')        
  set @v_PARENTID = (select OBJ_ROWID from dbo.OBJ where OBJ_CODE = @c_PARENT_OBJ)        
        
  while @v_i > 0        
  begin        
   set @v_NEW_OBJID = null        
        
   insert into INVTSK_NEW_OBJ (        
    INO_ITSID, INO_STSID, INO_PSPID, INO_STNID, INO_CODE, INO_ORG, INO_DESC, INO_DATE,        
    INO_STATUS, INO_TYPE, INO_TYPE2, INO_TYPE3, INO_RSTATUS, INO_CREUSER, INO_CREDATE,        
    INO_NOTUSED, INO_ID, INO_QTY, INO_MULTI)        
          
   select         
    @p_ITSID, @v_STSID, @c_PSPID, @v_STNID, NULL, 'PKN', '', getdate(),        
    NULL, NULL, NULL, NULL, 0, @p_UserID,  getdate(),        
    0, newid(), @c_QTY, 1    
           
   select @v_INOID = scope_identity()        
        
   if not exists (select 1 from dbo.INVTSK_STATIONS where INS_ITSID = @p_ITSID and INS_STNID = @v_STNID)        
   begin        
    insert into dbo.INVTSK_STATIONS(INS_ITSID, INS_STNID)        
    values(@p_ITSID, @v_STNID)        
   end        
  
   set @v_ADD_PARAMS = (  
      SELECT   
        @c_SERIAL as ADP_SERIAL  
       ,@c_VALUE as ADP_VALUE  
       ,@v_INOID as ADP_INOID  
      FOR XML PATH('Params')  
      )  
          
   exec dbo.GenStsObj @v_STSID, @c_PSPID, null, @v_PARENTID, @v_STNID, @p_UserID, @v_NEW_OBJID output, @v_ADD_PARAMS    

   update OBJ
   set 
   OBJ_NTX05 = @v_NIESTAND,
   OBJ_PM = @c_DEVICE_PM_NUMBER,
   OBJ_TXT10 = @c_REQUIREMENT
   where OBJ_ROWID = @v_NEW_OBJID
        
   set @v_i = @v_i - 1        
  end        
        
  fetch next from c_XLS into @c_ROWID, @c_STN, @c_STS, @c_PARENT_OBJ, @c_QTY, @c_VALUE, @c_PSP, @c_SERIAL, @c_NIESTAND, @c_DEVICE_PM_NUMBER, @c_REQUIREMENT         
 end       
 deallocate c_XLS        
        
 delete from dbo.INVTSK_ADD_OBJ_XLS where importuser = @p_UserID        
        
 return 0        
        
errorlabel:        
 raiserror(@v_errortext, 16, 1)        
 return 1        
end 


GO