SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


/****** Object:  StoredProcedure [dbo].[VS_Trace_Add]    Script Date: 06/03/2013 11:08:03 ******/
CREATE procedure [dbo].[VS_Trace_Add](
	@TRC_FORM [varchar](30),
	@TRC_ACTION [varchar](30),
	@TRC_START_DATE [datetime],
	@TRC_BANDWIDTH float = null,
	@TRC_USER [nvarchar](30),
	@TRC_ROWGUID uniqueidentifier)
AS
	if @TRC_START_DATE is null
	  select @TRC_START_DATE = getdate()
	  
	if not exists (select null from dbo.VS_Trace where TRC_ROWGUID = @TRC_ROWGUID)
	  insert into dbo.VS_Trace(TRC_FORM, TRC_ACTION, TRC_START_DATE, TRC_USER, TRC_ROWGUID, TRC_BANDWIDTH)
	  values( @TRC_FORM, @TRC_ACTION, @TRC_START_DATE, @TRC_USER, @TRC_ROWGUID, @TRC_BANDWIDTH)
	else begin 
	  declare @guid varchar(36)
	  set @guid = @TRC_ROWGUID
	  raiserror('Duplikat [%s,%s,%s,%s] w tabeli VS_Trace.', 16,1, @TRC_FORM, @TRC_ACTION, @TRC_USER, @guid )
	  return 1
	end

GO