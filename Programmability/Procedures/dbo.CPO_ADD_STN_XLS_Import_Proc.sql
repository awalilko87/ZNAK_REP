SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_ADD_STN_XLS_Import_Proc]               
(@p_potID int          
,@p_UserID nvarchar(30)              
)              
 as               
 begin               
               
 declare       
  @c_ROWID int,               
  @v_stnid int,     
  @v_mpk nvarchar(30),        
  @v_errorcode nvarchar(50),              
  @v_errortext nvarchar(4000),              
  @v_syserrorcode nvarchar(4000),              
  @p_apperrortext nvarchar(max);              
                    
              
  declare c_XLS cursor for              
  select rowid, stnid, mpk from dbo.CPO_ADD_STN_XLS where importuser = @p_UserID order by rowid              
  open c_XLS              
  fetch next from c_XLS into @c_ROWID, @v_stnid, @v_mpk      
  while @@FETCH_STATUS = 0               
    begin 
	
	if (@v_stnid is null or @v_stnid = 0)

	begin 
	
		declare @stn int -- identyfikacja stacji paliw po MPK
		declare @mpkID int 
		select @mpkID =  CCD_ROWID from dbo.COSTCODE where CCD_CODE = @v_mpk
		select @stn = stn_code from dbo.STATION where STN_CCDID = @mpkID

		if not exists (select 1 from dbo.CPO_STATIONS where CPS_CPOID = @p_potID and CPS_STNID = @stn and CPS_CPOID = @p_potID)          
			  begin                      
				 insert into CPO_STATIONS (CPS_CPOID,CPS_STNID)              
				   select  @p_potID,@stn                
			 end 

	end 
	
	
	  else

 begin             
			if not exists (select 1 from dbo.CPO_STATIONS where CPS_CPOID = @p_potID and CPS_STNID = @v_stnid and CPS_CPOID = @p_potID)          
			  begin                      
				 insert into CPO_STATIONS (CPS_CPOID,CPS_STNID)              
				   select  @p_potID,@v_stnid                
			 end           
         end     
   fetch next from c_XLS into @c_ROWID, @v_stnid, @v_mpk      
  end             
  deallocate c_XLS              
              
 delete from dbo.CPO_ADD_STN_XLS where importuser = @p_UserID              
              
 return 0              
              
errorlabel:              
 raiserror(@v_errortext, 16, 1)              
 return 1              
end   
  
  
  
  
GO