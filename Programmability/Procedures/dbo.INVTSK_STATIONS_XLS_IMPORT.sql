SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_STATIONS_XLS_IMPORT] 
(
	@p_ITSID int,
	@p_UserID nvarchar(30)
)
as 
begin 

 
	declare	
		@c_ROWID int, 
		@c_STN_CODE nvarchar(5), 
		@v_STNID int,
 		@v_apperrortext nvarchar(max);
 		  
	declare c_STNNUM cursor static for
	select 
		ROWID,
		c01
	from dbo.INVTSK_STATIONS_EXCEL (nolock)
	where 
		ImportUser = @p_UserID 
  
	open c_STNNUM 

	fetch next from c_STNNUM 
	into @c_ROWID, @c_STN_CODE
 
	while @@FETCH_STATUS = 0 
	begin
	
		select top 1 @v_STNID = STN_ROWID from STATION (nolock) where cast(STN_CODE as nvarchar(50)) = @c_STN_CODE
		
		if not exists (select * from INVTSK_STATIONS (nolock) where INS_ITSID = @p_ITSID and INS_STNID = @v_STNID) and @v_STNID is not null
		begin
			insert into INVTSK_STATIONS (INS_ITSID, INS_STNID)
			select @p_ITSID, @v_STNID
		end
		--else if @v_STNID is not null
		--begin
		--	update INVTSK_STATIONS 
		--	set INS_STNID = @v_STNID 	
		--	where INS_ITSID = @p_ITSID
		--end
		
		select @v_STNID = NULL
		
		fetch next from c_STNNUM
		into @c_ROWID, @c_STN_CODE
	end

	close c_STNNUM 
	deallocate c_STNNUM 
	 
 end 

GO