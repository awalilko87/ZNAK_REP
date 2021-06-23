SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[POB_WIEK_InsUpd](
 @p_PBW_ROWID int
,@p_PBW_GROUP_CODE nvarchar(50) -- grupa urządzenia
,@p_PBW_WIEK numeric(24,4))
as 
	begin
	 
	 if not exists (select 1 from POB_WIEK where PBW_ROWID = @p_PBW_ROWID)
			begin 
				insert into dbo.POB_WIEK(PBW_GROUP_CODE, PBW_WIEK)
						values (@p_PBW_GROUP_CODE,@p_PBW_WIEK)
			end
		else 
			begin 
			update dbo.POB_WIEK
			set PBW_GROUP_CODE = @p_PBW_GROUP_CODE
			   ,PBW_WIEK = @p_PBW_WIEK
			where PBW_ROWID = @p_PBW_ROWID
			end

	end
GO