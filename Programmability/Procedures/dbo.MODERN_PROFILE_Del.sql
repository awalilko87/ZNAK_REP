SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[MODERN_PROFILE_Del]
(
@MDP_ROWID int
)as
begin 

	if  exists (select 1 from MODERN_PROFILE where MDP_ROWID = @MDP_ROWID)
		begin 

			delete from MODERN_PROFILE where MDP_ROWID = @MDP_ROWID 

		end 
end
GO