SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_Check_Update_Proc_new]  
(  
    @p_POTID int,   
	@p_UserID varchar(20),   
    @p_GroupID varchar(10),   
    @p_LangID varchar(10),  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin   
  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_date datetime  
 declare @v_Rstatus int  
 declare @v_Pref nvarchar(10)  
 declare @v_MultiOrg bit 
 declare @v_POC_GROUPID varchar(20) 

 select @v_POC_GROUPID = case when @p_GroupID in ('DZR', 'DZRA') then 'DZR'
							  when @p_GroupID in ('IT', 'ITA') then 'IT'
							  when @p_GroupID in ('RKB', 'RKBA') then 'RKB'
							  when @p_GroupID in ('UR', 'URA') then 'UR'
						 end
						   
 if @v_POC_GROUPID is null  
 begin   
  select @v_errorcode = 'SYS_003'  
  goto errorlabel  
 end     
    
 if not exists (select 1 from dbo.OBJTECHPROTCHECK_GU (nolock) where POC_POTID = @p_POTID and POC_GROUPID = @v_POC_GROUPID)  
 begin  
    
  begin try  
   
   insert into dbo.OBJTECHPROTCHECK_GU  
   (  
    POC_POTID,  
    POC_GROUPID,  
    POC_CHECKUSER,  
    POC_CHECKDATE,  
    POC_UPDUSER,  
    POC_UPDDATE  
   )  
   select  
    @p_POTID,  
    @v_POC_GROUPID,  
    @p_UserID,  
    getdate(),  
    @p_UserID,  
    getdate()  
  
    exec POT_mail_conf @p_POTID  
    exec PZO_mail_conf @p_POTID  
         
  end try  
  begin catch  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'ERR_INS'  
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