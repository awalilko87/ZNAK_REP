SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ActValuesWait](
@p_ENTITY nvarchar(30),
@p_ENTID int,
@p_INTERVAL nvarchar(10) = null,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_i int = 2
	declare @v_c int = 1
	declare @v_SAVID int = (select top 1 SAV_ROWID from dbo.SAPIO_ActValuesHeaders where SAV_ENTITY = @p_ENTITY and SAV_ENTID = @p_ENTID order by SAV_ROWID desc)
	declare @v_SASID int

	set @p_INTERVAL = isnull(@p_INTERVAL, '00:00:01')

	while @v_i > 0
	begin
		select @v_SASID = SAV_SASROWID from dbo.SAPIO_ActValuesHeaders where SAV_ROWID = @v_SAVID

		if @v_SASID > 601	
			break

		waitfor delay @p_INTERVAL

		if @v_SASID = 601 and @v_c > 0
		begin
			set @v_c = @v_c - 1
		end
		
		set @v_i = @v_i - 1
	end

	return 0
end
GO