SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_REPORTS_Delete_Proc]  
(  
 @p_UserID nvarchar(50)  
,@p_ReportID nvarchar(50)  
,@p_FileInDB int  
)

--exec [SYS_REPORTS_Delete_Proc] 'SA','ENT_STATUS',0
  
as   
begin  
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_error int    
   
if @p_FileInDB=1  
  begin  
 select @v_errorcode ='ERR_RPT_DEL'  
 goto errorlabel  
  end  
  
if @p_FileInDB<>1  
 begin    
  begin try   
 begin tran   
  delete from dbo.SYReportFields where ReportID=@p_ReportID;  
  delete from dbo.SYReports where ReportID=@p_ReportID;  
  delete from dbo.VS_IsReportTemplate where ReportID=@p_ReportID;  
  delete from dbo.VS_FormFields where FormID like 'CR_'+@p_ReportID;  
  delete from dbo.VS_Forms where FormID like 'CR_'+@p_ReportID;  
  delete from dbo.VS_Rights where FormID like 'CR_'+@p_ReportID;
  delete from dbo.SYMenus where HTTPLink like '%FID=CR_'+@p_ReportID+'''%';   
 commit tran  
  end try    
  begin catch  
   rollback tran    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'ERR_DEL'    
   goto errorlabel    
  end catch    
  end    
  return 
errorlabel:     
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
 return 1    
  
end
GO