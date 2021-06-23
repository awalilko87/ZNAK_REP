SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_ADD_MULTI_BY_CCD_Proc]    
(     
 @p_POTID int,    
 @p_STNID int,    
 @p_UserID nvarchar(30),     
 @p_CHK_GU_DZR int,     
 @p_CHK_GU_IT int,     
 @p_CHK_GU_RKB int,     
 @p_CHK_GU_UR int,    
 @p_CHK_GU_UR_USER nvarchar(30),    
 @p_apperrortext nvarchar(4000) = null output    
)    
as    
begin    
     
 declare @v_STATUS nvarchar(30)    
  , @v_EXPOT nvarchar(30)    
  , @v_EXPOT_STATUS nvarchar(30)    
  , @v_EXMOV nvarchar(30)    
  , @v_ORG nvarchar(30)    
  , @v_TYPE nvarchar(30)    
  , @dzr varchar(10)    
  , @it  varchar(10)    
  , @rkb varchar(10)    
  , @ur  varchar(10)    
  , @c_OBJID int    
  , @description varchar(50)    
  , @status_new varchar(20)    
  , @description2 varchar(150)    
  , @status_new2 varchar(20)    
  , @v_SRQ nvarchar(30)    
  , @v_SRQ_STAT nvarchar(80)    
      
    
 select @v_STATUS = POT_STATUS , @v_ORG = POT_ORG, @v_TYPE = POT_TYPE from [OBJTECHPROT] (nolock) where POT_ROWID = @p_POTID    
 ------------------------------------------------------------------------------------------------    
 -------------------KURSOR do uzupełnienia pozycji składników do przeniesienia-------------------    
 ------------------------------------------------------------------------------------------------    
 --tylko podczas zapisu formularza w statusie "utworzony"!    
 if @v_STATUS in ('POT_001')    
 begin    
      
  if @p_CHK_GU_DZR = 1    
   set @dzr = 'DZR'    
  else    
   set @dzr = null;    
    
  if @p_CHK_GU_IT = 1    
   set @it = 'IT'    
  else    
   set @it = null;    
    
  if @p_CHK_GU_RKB = 1    
   set @rkb = 'RKB'    
  else    
   set @rkb = null;    
    
  if @p_CHK_GU_UR = 1    
   set @ur = 'UR'    
  else    
   set @ur = null;    
      
  delete from dbo.OBJTECHPROTLN where POL_POTID = @p_POTID    
      
  declare c_cursor cursor static for    
      
  --select OBJ_ROWID from dbo.OBJ (nolock)     
  -- join dbo.OBJSTATION (nolock) on OSA_OBJID = OBJ_ROWID    
  --where OSA_STNID = isnull(@p_STNID,0)    
    
  select distinct o.OBJ_ROWID    
  from dbo.OBJ o (nolock)     
   join dbo.OBJSTATION s (nolock)    
   on s.OSA_OBJID = o.OBJ_ROWID    
    
   left join dbo.PRVOBJ p    
    left join dbo.SYGroups gu    
    on gu.GroupID = p.PVO_GROUPID    
   on p.PVO_OBGID = o.OBJ_GROUPID    
  where 1 = 1    
  and isnull(OBJ_NOTUSED,0) = 0    
  and OSA_STNID = isnull(@p_STNID,0)    
  and gu.GroupID IN (@dzr, @it, @rkb, @ur)    
      
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
     and POL_STATUS not in ('POL_004','CPOLN_004')      
     --and POT_STATUS in ('POT_001','POT_002') --select * from sta where sta_code like 'POT%'    
         
    select    
     @v_SRQ = SRQ_CODE    
     ,@v_SRQ_STAT = SRQ_STATUS    
    from dbo.SP_REQUEST    
    where SRQ_OBJID = @c_OBJID    
         
    ----Sprawdza czy są na innych protokołach    
    --select     
    -- @v_EXMOV = MOV_CODE    
    --from     
    -- [dbo].[MOVEMENTLN] (nolock)     
    -- join [dbo].[MOVEMENT] (nolock) on MOV_ROWID = MOL_MOVID     
    --where     
    -- MOL_OBJID = @c_OBJID     
    -- and MOL_STATUS in ('MOV_001','MOV_002')     
    -- and @c_OBJID = MOL_OBJID     
        
      --- sprawdzenie czy istnieje obiekt ze statusem "zablokowany"    
      select @v_EXMOV = OBJ_STATUS    
      from OBJ (nolock)    
      where OBJ_ROWID = @c_OBJID    
      and OBJ_STATUS IN ('OBJ_005' , 'OBJ_006', 'OBJ_007', 'OBJ_008')    
        
    if (@v_EXPOT is null and @v_EXMOV is null and @c_OBJID not in (select OBJID from dbo.GetBlockedObj()) )   
    begin    
        
     insert into dbo.OBJTECHPROTLN        
     (    
      POL_POTID, POL_OBJID, POL_OLDQTY, POL_NEWQTY, POL_CODE,     
      POL_CREDATE, POL_CREUSER,  POL_DATE, POL_DESC, POL_ID,     
      POL_NOTE, POL_NOTUSED, POL_ORG, POL_RSTATUS, POL_STATUS, POL_TYPE    
     )    
     select    
      @p_POTID, @c_OBJID, 0, 0, '',     
      GETDATE(), @p_UserID, getdate(), '' , NEWID(),     
      '', 0, @v_ORG, 0, 'POL_004', @v_TYPE    
         
    end    
    else    
    begin    
         
      select @description = STA_DESC, @status_new = OBJ_STATUS from OBJ (nolock)    
       left join STA on STA_CODE = OBJ_STATUS    
      where OBJ_ROWID = @c_OBJID    
          
		 /*Składnik nie jest już "w eksploatacji" i znajduje się w jakimś "otwartym" POT*/
      if @status_new in ('OBJ_005' , 'OBJ_006', 'OBJ_007', 'OBJ_008') and @v_EXPOT_STATUS not in ('POT_003','CPO_003', 'POT_004','CPO_004')    
      begin    
       set @status_new2 = 'POL_007'    
       set @description2 = 'Status składnika - '+@description+' w protokole nr: ' + @v_EXPOT    
      end    
      else	  
	  	 /*Sprawdzamy, czy dla składnika została zmieniona ocena w jakimkolwiek "otwartym" dokumencie*/
		  if @status_new = 'OBJ_002' and exists (select * from OBJTECHPROTLN join OBJTECHPROT on POL_POTID = POT_ROWID 
												where POL_POTID <> isnull(@p_POTID,0) and POT_STATUS 
												not in ('POT_003','CPO_003', 'POT_004','CPO_004')  and POL_OBJID = @c_OBJID and POL_STATUS <> 'POL_004')
			  begin 
				 set @status_new2 = 'POL_007'    
				 set @description2 = 'Ocena składnika obsługiwana w protokole nr: ' + @v_EXPOT 
			  end
	  else /*Składnik znajduje się na aktywnym zgłoszeniu ruchu*/
	   if @v_SRQ is not null and @v_SRQ_STAT not in ('SRQ_005', 'SRQ_006')    
      begin    
       set @status_new2 = 'POL_007'    
       select @v_SRQ_STAT = STA_DESC from dbo.STA where STA_ENTITY = 'SRQ' and STA_CODE = @v_SRQ_STAT    
       set @description2 = 'Składnik zablokowany na zgłoszeniu - '+@v_SRQ+', status: ' + @v_SRQ_STAT           
      end    
      else /*Składnik znajduje się w tabeli obiektów zablokowanych*/
	  if @c_OBJID in (select OBJID from dbo.GetBlockedObj())    
      begin    
       set @status_new2 = 'POL_007'    
       set @description2 = 'Składnik zablokowany - GetBlockedObj'    
      end    
      else	  
      begin    
       set @status_new2 = 'POL_004'    
       set @description2 = ''    
      end    
         
     insert into dbo.OBJTECHPROTLN        
     (    
      POL_POTID, POL_OBJID, POL_OLDQTY, POL_NEWQTY, POL_CODE,     
      POL_CREDATE, POL_CREUSER,  POL_DATE, POL_DESC, POL_ID,     
      POL_NOTE, POL_NOTUSED, POL_ORG, POL_RSTATUS, POL_STATUS, POL_TYPE , POL_BIZ_DEC, POL_ADHOC   
     )    
     select    
      @p_POTID, @c_OBJID, 0, 0, '',     
      GETDATE(), @p_UserID, getdate(), @description2 , NEWID(),     
      '', 0, @v_ORG, 0, @status_new2, @v_TYPE, 0, 0     
    end    
        
    select @v_EXPOT = NULL, @v_EXMOV= NULL, @v_SRQ = null    
   end    
          
   fetch next from c_cursor     
   into @c_OBJID     
  end    
      
  close c_cursor     
  deallocate c_cursor     
      
 end    
     
 ------------------------------------------------------------------------------------------------    
 ------------------------------------------------------------------------------------------------    
 ------------------------------------------------------------------------------------------------    
end 
GO