SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[ZWFOT_UpdateStatus]
(
	@p_OT_ROWID int,
	@p_STATUS_NEW nvarchar(30),
	@p_UserID nvarchar(30)
)
as
begin

	declare @v_rstatus int
		, @v_STATUS_OLD nvarchar(30) 
		, @v_ID nvarchar(50)
		, @v_Pref nvarchar(10)
		, @v_OT_TYPE nvarchar(30)
	
	declare @c_OBJID int
	DECLARE @v_OBJ_OTID nvarchar(max)

	set @v_OBJ_OTID =  convert(nvarchar(max), @p_OT_ROWID)
	--select STA_RFLAG from STA where STA_ENTITY = left('OT11_60',4) and STA_CODE = 'OT11_60'
	select @v_Pref = left(@p_STATUS_NEW,4)
	select @v_rstatus = STA_RFLAG from STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS_NEW
	 
	select 
		@v_STATUS_OLD = OT_STATUS,
		@v_ID = OT_ID,
		@v_OT_TYPE = OT_TYPE
	from ZWFOT (nolock) 
	where OT_ROWID = @p_OT_ROWID
 
	if isnull(@v_STATUS_OLD,'') <> isnull(@p_STATUS_NEW,'') and @v_ID is not null
	begin
		declare C_OBJOT cursor for select OBJID from dbo.GetBlockedObjOT(@v_ID)
		open C_OBJOT
		fetch next from C_OBJOT into @c_OBJID
		while @@fetch_status = 0
		begin		
			if @v_OT_TYPE = 'SAPO_ZWFOT31' and @p_STATUS_NEW = 'OT31_50'
			begin
				update dbo.OBJ set
					 OBJ_STATUS = case when STN_TYPE = 'SERWIS' then 'OBJ_003' else 'OBJ_002' end
					,OBJ_PARENTID = case when STN_TYPE = 'SERWIS' then OBJ_ROWID else OBJ_PARENTID end
					,OBJ_UPDDATE = getdate()
				from dbo.OBJSTATION
				inner join dbo.STATION on STN_ROWID = OSA_STNID
				where OBJ_ROWID = @c_OBJID and OSA_OBJID = OBJ_ROWID
			end
		
			if @v_OT_TYPE = 'SAPO_ZWFOT33' and @p_STATUS_NEW = 'OT33_50'
			begin
				update dbo.OBJ set
					 OBJ_STATUS = case when STN_TYPE = 'SERWIS' then 'OBJ_003' else 'OBJ_002' end
					,OBJ_UPDDATE = getdate()
				from dbo.OBJSTATION
				inner join dbo.STATION on STN_ROWID = OSA_STNID
				where OBJ_ROWID = @c_OBJID and OSA_OBJID = OBJ_ROWID
			end
		
			if @v_OT_TYPE = 'SAPO_ZWFOT40' and @p_STATUS_NEW = 'OT40_50'
			begin
				update dbo.OBJ set
					 OBJ_NOTUSED = 1
					,OBJ_STATUS = 'OBJ_007'
					,OBJ_UPDDATE = getdate()
				where OBJ_ROWID = @c_OBJID
			END

			if @v_OT_TYPE = 'SAPO_ZWFOT11' and @p_STATUS_NEW = 'OT11_60'
			BEGIN
				UPDATE dbo.OBJ SET
				OBJ_OTID = NULL,
				OBJ_CANCELLED_OT_DOC = CONCAT(OBJ_CANCELLED_OT_DOC, ', ', '@p_OT_ROWID')
				WHERE OBJ_OTID = @p_OT_ROWID  
			end


			fetch next from C_OBJOT into @c_OBJID
		end
		deallocate C_OBJOT
   
		update [dbo].[ZWFOT] set 
			OT_RSTATUS = @v_rstatus,
			OT_STATUS = @p_STATUS_NEW
		where OT_ROWID = @p_OT_ROWID
		
		exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @v_ID, @p_STATUS = @p_STATUS_NEW, @p_STATUS_old = @v_STATUS_OLD, @p_UserID = @p_UserID

	end
			
end

GO