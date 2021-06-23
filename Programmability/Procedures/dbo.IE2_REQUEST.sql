SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[IE2_REQUEST]
as
begin
	set nocount on

	declare @h tinyint = datepart(hh, getdate())
	declare @next_exec datetime
	declare @v_TASK_NO int
	declare @v_INTERVAL smallint

	--select FROM_DATE = '2010-01-01'
	--select ID_SLOWNIKA = 'KLASYFIKATOR5'
	--return

	select top 1 
		 @v_TASK_NO = TASK_NO
		,@v_INTERVAL = INTERVAL 
	from SQLWinSync_Scheduler 
	where (@h between H_FROM and H_TO or ((@h between H_FROM and 23 or @h between 0 and H_TO) and H_FROM > H_TO)) and NEXT_EXEC < getdate()
	
	if @v_TASK_NO is not null
	begin
		select @next_exec = dateadd(mi, datepart(mi, getdate())-datepart(mi, getdate())%@v_INTERVAL + @v_INTERVAL, dateadd(hh, datepart(hh, getdate()), convert(datetime, convert(date, getdate()))))

		update dbo.SQLWinSync_Scheduler set
			NEXT_EXEC = @next_exec
		where TASK_NO = @v_TASK_NO

		select top 1 
			FROM_DATE = convert(nvarchar(10),min(FROM_DATE),121) 
		from dbo.IE2_DocRequest (nolock)
		where ACTIVE = 1 and SCHEDID = @v_TASK_NO
		having count(*) > 0

		select ID_SLOWNIKA from dbo.IE2_DocRequest (nolock) where ACTIVE = 1 and SCHEDID = @v_TASK_NO

	end

end
GO