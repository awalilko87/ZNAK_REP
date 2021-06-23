SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[ANO_Delete](
@p_KEY nvarchar(max)
)
as
begin
	delete from dbo.ASTINW_NEW_OBJ where ANO_ASTID in (select String from dbo.VS_Split(@p_KEY,';'))
			and not exists (select 1 from dbo.OBJ where OBJ_ANOID in (select ANO_ROWID from dbo.ASTINW_NEW_OBJ where ANO_ASTID in (select String from dbo.VS_Split(@p_KEY,';'))))
end
GO