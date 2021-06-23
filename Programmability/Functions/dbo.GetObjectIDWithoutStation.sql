SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[GetObjectIDWithoutStation](@p_OBJID int)  
returns table as return (  
 
  select OBJ_ROWID as [ID] from OBJ (nolock) where OBJ_ROWID not in (select OSA_OBJID from OBJSTATION (nolock))
 
)
GO