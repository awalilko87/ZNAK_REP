SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[VS_Trace_Update](
	@TRC_END_DATE [datetime] = [getdate()],
	@TRC_ROWGUID uniqueidentifier)
AS
	if @TRC_END_DATE is null
		select @TRC_END_DATE = getdate()

	if not exists (select null from dbo.VS_Trace where TRC_ROWGUID = @TRC_ROWGUID) begin
	  declare @guid varchar(36)
	  set @guid = @TRC_ROWGUID
	  raiserror('Brak rekordu [%s] w tabeli VS_Trace.', 16,1, @guid )
	  return 1
	end
	else begin 
	  update dbo.VS_Trace 
	  set TRC_END_DATE = @TRC_END_DATE
	  where TRC_ROWGUID = @TRC_ROWGUID
	end
GO