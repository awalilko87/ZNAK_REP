SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create proc [dbo].[POB_PRZEBIEG_InsUpd](
 @p_PBP_ROWID int
,@p_PBP_GROUP_CODE nvarchar(50) -- grupa urządzenia
,@p_PBP_PRZEBIEG numeric(24,4))
as 
	begin
	 
	 if not exists (select 1 from POB_PRZEBIEG where PBP_ROWID = @p_PBP_ROWID)
			begin 
				insert into dbo.POB_PRZEBIEG(PBP_GROUP_CODE, PBP_PRZEBIEG)
						values (@p_PBP_GROUP_CODE,@p_PBP_PRZEBIEG)
			end
		else 
			begin 
			update dbo.POB_PRZEBIEG
			set PBP_GROUP_CODE = @p_PBP_GROUP_CODE
			   ,PBP_PRZEBIEG = @p_PBP_PRZEBIEG
			where PBP_ROWID = @p_PBP_ROWID
			end

	end
GO