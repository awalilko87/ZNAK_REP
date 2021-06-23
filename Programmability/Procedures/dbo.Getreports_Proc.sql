SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure  [dbo].[Getreports_Proc](@p_MenuKey nvarchar(50))                   
as          
begin   
       
declare @return nvarchar(max)          
         
        
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
        
select @return = @return +            
    '<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="btn260" name="k" value="'+isnull(i.ReportName,0)+'" onclick="javascript:window.open('''+         
    dbo.VS_EncryptLink('/Forms/SimplePopup.aspx?FID='        
        
    --nazwa formatki        
    +left((substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)),(charindex(''',',(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000))))-1) )        
         
    --ustawienia popupa        
    +SubString(HTTPLink,charindex(',',HTTPLink,charindex('FID',HTTPLink))-1,500)        
             
    +'; return false;" /> </td>'        
            
    --opis raportu        
    +'<td style="width:600px">'+substring(ReportCaption,0,100) + (case when len(ReportCaption)>=100 then '...' else '' end)+'</td>'        
 +'</tr>'        
        
from SYMENUS (nolock)        
left join SYReports s (nolock) on s.ReportID=replace((replace((left((substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)),(charindex(''',',(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000))))-1)),'CR_','')),'CR_','')         
left join VS_IsReportTemplate i (nolock) on i.ReportID=s.ReportID        
where GroupKey = @p_MenuKey and HTTPLink not like '%SimpleReport%' and SYMENUS.IsVisible =1    
  
       
      
   set @return = @return  + '</table></body>'        
return @return         
        
end 
GO