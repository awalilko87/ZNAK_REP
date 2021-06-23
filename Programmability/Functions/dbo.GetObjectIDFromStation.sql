SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create function [dbo].[GetObjectIDFromStation](@p_STNID int)  
returns table as return (  

  select OSA_OBJID as [ID] from OBJSTATION (nolock) where OSA_STNID = @p_STNID

)

GO