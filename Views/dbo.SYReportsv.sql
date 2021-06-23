SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[SYReportsv]                
as                
select                
 s.ReportID                
,v.ReportName  
,FilesName=dbo.GetEngString (s.ReportName)          
,s.ReportCaption                
,FileInDB = convert(int,FileInDB)                
,s.RptFileID2                
,s.OutputType              
,MenuLink=(select 'javascript:window.open(''SimplePopup.aspx?FID=CR_'+s.ReportID+''',null,''top=100 left=300,scrollbars=no,menubar=no,resizable=no'');void(0);')            
,FormID='CR_'+s.ReportID            
,Template=isnull(v.Template,0)
,IsPrint=isnull(v.IsPrint,0)        
from dbo.SYReports(nolock) s      
left join VS_IsReportTemplate v (nolock) on v.ReportID=s.ReportID   
  
GO