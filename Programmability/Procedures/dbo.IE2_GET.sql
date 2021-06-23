SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[IE2_GET]
as
begin
	declare @v_errortext nvarchar(1000)
	
	declare @c_ID int
	declare @c_CODE nvarchar(30)
	declare @c_TYPE nvarchar(30)
	declare @v_LASTID int
	declare @v_LASTCODE nvarchar(30)
	declare @v_LASTDATE datetime
	declare @v_WinSync_LastRun datetime

	/*
	if convert(nvarchar(5),getdate(),108) between '20:00' and '23:59' or convert(nvarchar(5),getdate(),108) between '00:00' and '05:59'
	begin
		update dbo.IE2_DocRequest set
			ACTIVE = 0
		where ID_SLOWNIKA in ('ST','PSP','INW')
	end
	else
	begin
		update dbo.IE2_DocRequest set
			ACTIVE = 1
		where ID_SLOWNIKA in ('ST','PSP','INW')
	end
	*/
	
	select @v_WinSync_LastRun = dateadd(mi, INTERVAL*-1,NEXT_EXEC) from SQLWinSync_Scheduler where TASK_NO = 52
	--return
	--exec [SAPI_ST_Insert_Proc]
	
	select top 1 @v_LASTID = ROWID, @v_LASTCODE = CODE, @v_LASTDATE = UPDDATE from dbo.IE2_DocToGet where TYPE = 'ST' and TOGET in (0, 3) order by UPDDATE desc
	
	if exists (select 1 from dbo.IE2_ST where GDLGRP = @v_LASTCODE+'0' and i_DateTime > isnull(@v_LASTDATE,getdate()-0.5))
	begin
		print 1
		update dbo.IE2_DocRequest set
			ACTIVE = 0
		where ID_SLOWNIKA = 'ST_'+@v_LASTCODE
	end
	else
	begin
		if datediff(mi, @v_LASTDATE, @v_WinSync_LastRun) > 5
			and exists (select 1 from dbo.IE2_DocToGet where TYPE = 'ST' and TOGET = 1)
		begin
			update dbo.IE2_DocRequest set
				ACTIVE = 0
			where ID_SLOWNIKA = 'ST_'+@v_LASTCODE
		
			update IE2_DocToGet set
				TOGET = 3
			where ROWID = @v_LASTID
		end
	end
	
	select top 1 @v_LASTCODE = CODE, @v_LASTDATE = UPDDATE from dbo.IE2_DocToGet where TYPE = 'DS' and TOGET in (0, 3) order by UPDDATE desc
	print @v_LASTDATE
	print @v_LASTCODE+'<'
	
	if exists (select 1 from dbo.IE2_PSP where POSKI like @v_LASTCODE+'%' and i_DateTime > isnull(@v_LASTDATE,getdate()-0.5))
	begin
		print 'PSP 0'
		update dbo.IE2_DocRequest set
			ACTIVE = 0
		where ID_SLOWNIKA = 'PSP_'+@v_LASTCODE
	end
	else
	begin
		if datediff(mi, @v_LASTDATE, @v_WinSync_LastRun) > 5
			and exists (select 1 from dbo.IE2_DocToGet where TYPE = 'DS' and TOGET = 1)
		begin
			update dbo.IE2_DocRequest set
				ACTIVE = 0
			where ID_SLOWNIKA = 'PSP_'+@v_LASTCODE
		
			update IE2_DocToGet set
				TOGET = 3
			where ROWID = @v_LASTID
		end
	end
	
	declare CG cursor for select ROWID, CODE, TYPE from dbo.IE2_DocToGet where TOGET = 1 order by ROWID
	open CG
	fetch next from CG into @c_ID, @c_CODE, @c_TYPE
	while @@fetch_status = 0
	begin
		if @c_TYPE = 'ST'
		begin
			if exists (select 1 from dbo.IE2_DocRequest where ID_SLOWNIKA like 'ST[_]%' and ACTIVE = 1)
				goto nextstep

			update dbo.IE2_DocRequest set
				ID_SLOWNIKA = 'ST_'+@c_CODE
				,ACTIVE = 1
			where ID_SLOWNIKA like 'ST[_]%'
		end
		else if @c_TYPE = 'DS'
		begin
			if exists (select 1 from dbo.IE2_DocRequest where ID_SLOWNIKA like 'PSP[_]%' and ACTIVE = 1)
				goto nextstep
				
			update dbo.IE2_DocRequest set
				ID_SLOWNIKA = 'PSP_'+@c_CODE
				,ACTIVE = 1
			where ID_SLOWNIKA like 'PSP[_]%'
		end
		
		update dbo.IE2_DocToGet set
			TOGET = 0
			,UPDDATE = getdate()
		where ROWID = @c_ID
		
		nextstep:
		fetch next from CG into @c_ID, @c_CODE, @c_TYPE
	end
	deallocate CG
	

	
end
GO