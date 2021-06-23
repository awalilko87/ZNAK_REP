SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetBlockedObjOT](@p_OT_ID nvarchar(50))  
returns table  
as  
return  
select OBJID = OTO_OBJID   
from  dbo.ZWFOTOBJ
join ZWFOT on OT_ROWID = OTO_OTID  
where OT_ID = @p_OT_ID
and OT_STATUS not in ('OT31_50', 'OT31_70', 'OT32_50', 'OT32_70', 'OT33_50', 'OT33_70', 'OT42_50', 'OT42_70', 'OT41_50', 'OT41_70')    
GO