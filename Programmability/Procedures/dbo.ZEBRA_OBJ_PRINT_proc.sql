SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZEBRA_OBJ_PRINT_proc]
(
	@p_KEY nvarchar(max)
)
as
begin
    update dbo.OBJ 
     set OBJ_PRINTDATE = getdate() 
    where OBJ_ROWID in (select string from dbo.VS_Split3(@p_KEY,';') where String <> '')
end
GO