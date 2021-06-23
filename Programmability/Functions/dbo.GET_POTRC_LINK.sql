SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GET_POTRC_LINK](@p_POT_CODE nvarchar(30))    
RETURNS nvarchar(MAX)    
AS    
BEGIN    
  
declare @pot_type nvarchar(30)
declare @potid int
declare @link nvarchar(max)  

select @pot_type = POT_TYPE, @potid = POT_ROWID from OBJTECHPROT where POT_CODE = @p_POT_CODE
  
  
select @link = case when @pot_type = 'OCENA' -- jeżeli typ protokołu : POT  
 then   
  '  
  <a href="'+dbo.[VS_EncryptLink]('/link.aspx?B=' + dbo.VS_EncodeBase64('~/Tabs3.aspx/?MID=ZMT_MOVE_POT&TGR=POT&TAB=POT_RC&FID=POT_RC&POT_ROWID=' + convert(varchar,@potid)))+'"><b>'+@p_POT_CODE +'</b></a>    
  '  
 else -- jeżeli typ protokołu : CPO  
  '    
  <a href="'+dbo.[VS_EncryptLink]('/link.aspx?B=' + dbo.VS_EncodeBase64('~/Tabs3.aspx/?MID=ZMT_MOVE_CPO&TGR=CPO&TAB=CPO_RC&FID=CPO_RC&POT_ROWID=' + convert(varchar,@potid)))+'"><b>'+@p_POT_CODE +'</b></a>    
  '  
 end   
    
return  @link   
    
    
END  
  
GO