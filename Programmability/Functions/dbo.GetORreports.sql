SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[GetORreports](@p_MenuKey nvarchar(50))  
returns nvarchar(max)  
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
    '<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="btn260" name="k" value="'+isnull(MenuCaption,'')+'" onclick="javascript:window.open('''+   
    dbo.VS_EncryptLink('/Reporting/RdlReportView.aspx?FID='
  
    --link do OR 
    +(substring(HTTPLink,charindex('FID',HTTPLink)+4,1000)))  
    +'; return false;" /> </td>'  
    +'</tr>' 
from SYMENUS (nolock)    
where GroupKey = @p_MenuKey

   set @return = @return  + '</table></body>'
return @return 

end    
GO