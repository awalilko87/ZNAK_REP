SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZOLN_LSRC_Accept_All_Proc]      
(      
@p_ROWID int,    
@p_POT_ROWID int,      
@p_STATUS nvarchar(30),      
@p_DATE datetime,      
@p_DTX01 datetime,      
@p_COM01 nvarchar(max),      
@p_COM02 nvarchar(max),     
@p_PS_ACCEPT int,       
@p_PS_COMMENT nvarchar(max),       
@p_UserID nvarchar(30)      
)      
as      
begin      
 if exists (select 1 from dbo.OBJTECHPROTLN where POL_POTid = @p_POT_ROWID and POL_STATUS = 'PZL_001' and IsNull(POL_PS_ACCEPT,0) = 0)   
  
  begin   
  
   declare @p_ID int -- zmienna do sterowania kursorem  
  
    declare akceptacja cursor for   
    select POL_ROWID from dbo.OBJTECHPROTLN where POL_POTID = @p_POT_ROWID and POL_STATUS = 'PZL_001' and IsNull(POL_PS_ACCEPT,0) = 0   
  
    open akceptacja   
    fetch next from akceptacja  
    into @p_ID  
    while @@fetch_status = 0  
     begin   
      exec PZOLN_LSRC_PS_Update_Proc 'PZOLN_LSRC_ODB',          
            @p_ID ,             
            1 ,         
            @p_PS_COMMENT,        
            @p_UserID  
  
       fetch next from akceptacja  
       into @p_ID  
     end   
  
   close akceptacja   
   deallocate akceptacja  
  
  
  end      
end   
  
GO