SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[Getreports](@p_UserID nvarchar(30),@p_MenuKey nvarchar(50),@p_GroupID nvarchar(50), @p_AppCode nvarchar(30))            
returns nvarchar(max)            
as            
begin            
declare @return nvarchar(max)            
  
declare @v_LangID nvarchar(10)  
select @v_LangID = [dbo].[fn_GetLangID] (@p_UserID)  
           
declare @t table (MenuKey nvarchar(80), HTTPLink nvarchar(4000), ReportName nvarchar(80), ReportCaption nvarchar(4000), Orders int)  
 insert into @t (MenuKey, HTTPLink, ReportName, ReportCaption, Orders)  
 select MenuKey, HTTPLink, isnull(Caption,MenuCaption), ReportCaption, Orders  
 from SYMENUS (nolock)          
 left join SYReports s (nolock) on s.ReportID=replace((replace((left((substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)),(charindex(''',',(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000))))-1)),'CR_','')),'CR_','')           
 left join VS_IsReportTemplate i (nolock) on i.ReportID=s.ReportID  
 left join VS_LangMSGS on ControlID = MenuKey and [LangID]=@v_LangID           
 where   
  SYMENUS.GroupKey = @p_MenuKey and ModuleName = @p_AppCode  
  and HTTPLink not like '%SimpleReport%'   
  and isnull(SYMENUS.IsVisible,0) =1    
  order by i.ReportName,Orders  
          
set @return =           
'<head>          
<style type="text/css">          
#tabela {          
   border: 0px solid black;          
            
}          
.td {}          
</style>          
</head>          
<body>'+          
          
'<table id="tabela" style="width:900px; ">'          
  
if @p_GroupID='SA'  
 begin              
  select @return = @return +              
   '<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="e2-button e2-button-260" name="k" value="'+isnull(ReportName,0)+'" onclick="javascript:window.open('''+           
   dbo.VS_EncryptLink('/Forms/SimplePopup.aspx?FID='          
            
   --nazwa formatki          
   +left((substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)),(charindex(''',',(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000))))-1) )          
             
   --ustawienia popupa          
   +SubString(HTTPLink,charindex(',',HTTPLink,charindex('FID',HTTPLink))-1,500)          
                 
   +'; return false;" /> </td>'          
                
   --opis raportu          
   +'<td style="width:600px">'+substring(ReportCaption,0,100) + (case when len(ReportCaption)>=100 then '...' else '' end)+'</td>'          
   +'</tr>'                
            
  from @t   
 end  
  
if @p_GroupID<>'SA'  
 begin            
  select @return = @return +              
   '<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="e2-button e2-button-260" name="k" value="'+isnull(ReportName,0)+'" onclick="javascript:window.open('''+           
   dbo.VS_EncryptLink('/Forms/SimplePopup.aspx?FID='          
            
   --nazwa formatki          
   +left((substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)),(charindex(''',',(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000))))-1) )          
             
   --ustawienia popupa          
   +SubString(HTTPLink,charindex(',',HTTPLink,charindex('FID',HTTPLink))-1,500)          
                 
   +'; return false;" /> </td>'          
                
   --opis raportu          
   +'<td style="width:600px">'+substring(ReportCaption,0,100) + (case when len(ReportCaption)>=100 then '...' else '' end)+'</td>'          
   +'</tr>'          
            
  from @t  
  where MenuKey in (select MenuKey from VS_SyUsersMenu (nolock) where userID=@p_GroupID and Visible=1)           
 end  
  
set @return = @return  + '</table></body>'     
return @return           
          
end   
GO