SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_LN_GEN_Proc]        
(         
 @p_POTID int --= 213,        
 ,@p_UserID nvarchar(30) --= 'ALEKSANDRA.KUNA',         
 ,@p_apperrortext nvarchar(4000) = null output        
)        
as        
begin        
         
 declare @v_STATUS nvarchar(30)        
  , @v_EXPOT nvarchar(30)        
  , @v_EXPOT_STATUS nvarchar(30)        
  , @v_EXMOV nvarchar(30)        
  , @v_ORG nvarchar(30)        
  , @v_TYPE nvarchar(30)        
  , @c_OBJID int        
  , @description varchar(50)        
  , @status_new varchar(20)        
  , @description2 varchar(150)        
  , @status_new2 varchar(20)        
  , @v_SRQ nvarchar(30)        
  , @v_SRQ_STAT nvarchar(80)        
  , @v_ASTID int
  , @v_AST nvarchar(30)
  , @v_AST_DESC nvarchar(80)
  , @v_AST_SAP_URWRT decimal
  , @p_PARTIAL int 

 select @v_STATUS = POT_STATUS , @v_ORG = POT_ORG, @v_TYPE = POT_TYPE from [OBJTECHPROT] (nolock) where POT_ROWID = @p_POTID        
 ------------------------------------------------------------------------------------------------        
 -------------------KURSOR do uzupełnienia pozycji składników do -------------------        
 ------------------------------------------------------------------------------------------------        
 --tylko podczas zapisu formularza w statusie "utworzony"!        
 if @v_STATUS in ('CPO_001')        
 begin        
          
          
  delete from dbo.OBJTECHPROTLN where POL_POTID = @p_POTID        
          
  declare c_cursor cursor static for        
          
        
  SELECT DISTINCT o.OBJ_ROWID  
     FROM dbo.OBJ o (nolock)         
  inner JOIN CPO_OBJECT_STENCIL on CPT_STSID = o.OBJ_STSID    
   JOIN OBJSTATION on OSA_OBJID = OBJ_ROWID      
     JOIN STATION on OSA_STNID = STN_ROWID      
     JOIN CPO_STATIONS on stn_code = CPS_STNID      
     where isnull(OBJ_NOTUSED,0) = 0      
     and CPT_CPOID = CPS_CPOID    
  and CPT_CPOID = @p_POTID     
    and OBJ_STATUS = 'OBJ_002'   
 and not exists (select * from OBJTECHPROTln where POL_OBJID = OBJ_ROWID and POL_STATUS not in ('POL_004', 'CPOLN_002'))       
          
  open c_cursor         
          
  fetch next from c_cursor         
  into @c_OBJID         
           
  while @@FETCH_STATUS = 0        
  begin        
   if not exists (select * from dbo.OBJTECHPROTLN (nolock) where POL_OBJID = @c_OBJID and POL_POTID = @p_POTID)        
   begin        
            
    --Sprawdza czy są na innych protokołach lub formularzach przeniesienia (aktywnych)        
    select         
     @v_EXPOT = POT_CODE, @v_EXPOT_STATUS = POT_STATUS        
    from         
     [dbo].[OBJTECHPROTLN] (nolock)         
     join [dbo].[OBJTECHPROT] (nolock) on POT_ROWID = POL_POTID         
    where         
     POT_ROWID <> isnull(@p_POTID,0)        
     and POL_OBJID = @c_OBJID         
     and POL_STATUS not in ('CPOLN_002')          
     --and POT_STATUS in ('POT_001','POT_002') --select * from sta where sta_code like 'POT%'        
               
      --- sprawdzenie czy istnieje obiekt ze statusem "zablokowany"        
      select @v_EXMOV = OBJ_STATUS        
      from OBJ (nolock)        
      where OBJ_ROWID = @c_OBJID        
      and OBJ_STATUS IN ('OBJ_005' , 'OBJ_006', 'OBJ_007', 'OBJ_008')     
	  
	  
	  /*Wylicza % likwidacji dla linii*/
	 select @v_ASTID = OBA_ASTID from dbo.OBJASSET (nolock) where OBA_OBJID = @c_OBJID        
	 select @v_AST = AST_CODE, @v_AST_DESC = AST_DESC from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID
 	        
	 select @v_AST_SAP_URWRT = AST_SAP_URWRT from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID        
          
	 if (@v_AST_SAP_URWRT = '0.00')        
	  select @p_PARTIAL = 100        
	 else        
	  select @p_PARTIAL = 100 * OBJ_VALUE / (select AST_SAP_URWRT from dbo.ASSET (nolock) where AST_ROWID = @v_ASTID)         
	  from dbo.OBJ (nolock)       
	  where OBJ_ROWID = @c_OBJID


	     
            
    if @v_EXPOT is null and @v_EXMOV is null and @c_OBJID not in (select OBJID from dbo.GetBlockedObj())        
     begin        
            
      insert into dbo.OBJTECHPROTLN            
      (        
       POL_POTID, POL_OBJID, POL_OLDQTY, POL_NEWQTY, POL_CODE,         
       POL_CREDATE, POL_CREUSER,  POL_DATE, POL_DESC, POL_ID,         
       POL_NOTE, POL_NOTUSED, POL_ORG, POL_RSTATUS, POL_STATUS, POL_TYPE, POL_PARTIAL        
      )        
      select        
       @p_POTID, @c_OBJID, 0, 0, '',         
       GETDATE(), @p_UserID, getdate(), '' , NEWID(),         
       '', 0, @v_ORG, 0, 'CPOLN_002', @v_TYPE, @p_PARTIAL        
             
     end        
    else        
     begin        
             
       select @description = STA_DESC, @status_new = OBJ_STATUS from OBJ (nolock)        
        left join STA on STA_CODE = OBJ_STATUS        
       where OBJ_ROWID = @c_OBJID        
              
       if @status_new in ('OBJ_005' , 'OBJ_006', 'OBJ_007', 'OBJ_008') and @v_EXPOT_STATUS not in ('POT_003', 'POT_004','CPO_003', 'CPO_004')        
       begin        
        set @status_new2 = 'CPOLN_007'        
        set @description2 = N'Status składnika - '+@description+' w protokole nr: ' + @v_EXPOT        
       end        
       else if @v_SRQ is not null and @v_SRQ_STAT not in ('SRQ_005', 'SRQ_006')        
       begin        
        set @status_new2 = 'CPOLN_007'       
        select @v_SRQ_STAT = STA_DESC from dbo.STA where STA_ENTITY = 'SRQ' and STA_CODE = @v_SRQ_STAT        
        set @description2 = N'Składnik zablokowany na zgłoszeniu - '+@v_SRQ+', status: ' + @v_SRQ_STAT               
       end        
       else if @c_OBJID in (select OBJID from dbo.GetBlockedObj())        
       begin        
        set @status_new2 = 'CPOLN_007'        
        set @description2 = N'Składnik zablokowany - GetBlockedObj'        
       end        
       else        
       begin        
        set @status_new2 = 'CPOLN_002'        
        set @description2 = ''        
       end        
             
      insert into dbo.OBJTECHPROTLN            
      (        
       POL_POTID, POL_OBJID, POL_OLDQTY, POL_NEWQTY, POL_CODE,         
       POL_CREDATE, POL_CREUSER,  POL_DATE, POL_DESC, POL_ID,         
       POL_NOTE, POL_NOTUSED, POL_ORG, POL_RSTATUS, POL_STATUS, POL_TYPE, POL_PARTIAL        
      )        
      select        
       @p_POTID, @c_OBJID, 0, 0, '',         
       GETDATE(), @p_UserID, getdate(), @description2 , NEWID(),         
       '', 0, @v_ORG, 0, @status_new2, @v_TYPE, @p_PARTIAL         
     end        
            
    select @v_EXPOT = NULL, @v_EXMOV= NULL, @v_SRQ = null        
   end        
              
   fetch next from c_cursor         
   into @c_OBJID         
  end        
          
  close c_cursor         
  deallocate c_cursor         
          
 end        
         
 declare @ile int        
 select @ile = count(1) from OBJTECHPROTLN where POL_POTID = @p_POTID        
 declare @Mes nvarchar(80)        
 select @Mes = 'Składniki wygenerowane poprawnie. Wygenerowano ' +cast(@ile as nvarchar(2))+' składników'        
 RaisError(@Mes,1,1)        
 ------------------------------------------------------------------------------------------------        
 ------------------------------------------------------------------------------------------------        
 ------------------------------------------------------------------------------------------------        
end 
GO