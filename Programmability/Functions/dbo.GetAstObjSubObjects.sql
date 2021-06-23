SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetAstObjSubObjects](@CODEID int)
returns table as return (
select distinct OBJ_ROWID from OBJ (nolock) where OBJ_PARENTID = @CODEID
)
--select * from  dbo.GetObjectIDFromStru(24)
 
GO