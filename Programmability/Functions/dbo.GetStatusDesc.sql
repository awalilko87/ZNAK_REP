SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create function [dbo].[GetStatusDesc]   
(  
  @p_Status nvarchar(30),
  @p_Entity nvarchar(30)
    
)  
returns   
nvarchar(80)  
  
as  
begin  
  declare @r_value nvarchar(80)  
	select @r_value = isnull(STA_DESC,STA_CODE) from dbo.STA (nolock) where STA_ENTITY = @p_Entity and STA_CODE = @p_Status
  return @r_value
end
GO