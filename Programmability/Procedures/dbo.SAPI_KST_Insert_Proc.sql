SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_KST_Insert_Proc] 
as 
begin

	declare @c_ROWID int
	declare @c_KST_CODE nvarchar(50)
	declare @c_POSKI nvarchar(50)
	declare @c_TXTSEG nvarchar(50)
	declare @c_NDPER_OD nvarchar(30)
	declare @c_NDPER_DO nvarchar(30)
	declare @c_NDPER_OD_num int
	declare @c_NDPER_DO_num int
	declare @v_ID int
	
	declare KST_inserted cursor static for
	select top 1000  ROWID, ANLKL, POSKI, TXTSEG, NDPER_OD, NDPER_DO from [dbo].[IE2_KST] 
	where 
		isnull([DOC_NEW_INSERTED],0) = 1
	order by ROWID asc;
	--select ROWID,* from ie2_KST

	open KST_inserted

	fetch next from KST_inserted
	into @c_ROWID, @c_KST_CODE, @c_POSKI, @c_TXTSEG, @c_NDPER_OD, @c_NDPER_DO

	while @@fetch_status = 0 
	begin
	 
		if not exists (select * from COSTCLASSIFICATION (nolock) where CCF_SAP_ANLKL = @c_KST_CODE) 
		begin
			insert into COSTCLASSIFICATION (CCF_CODE, CCF_ORG, CCF_DESC, CCF_CREUSER, CCF_CREDATE, CCF_UPDUSER, CCF_UPDDATE, CCF_NOTUSED, CCF_SAP_Active, CCF_SAP_ANLKL, CCF_SAP_TXK50, CCF_SAP_BUKRS, CCF_SAP_KTOGR)
			select @c_POSKI, 'PKN', TXK50, 'SA', getdate(), NULL, NULL, 0, Active, ANLKL, TXK50, BUKRS, KTOGR from IE2_KST where ROWID = @c_ROWID
		end
		else 
		begin
			update CCF 
			set 
				CCF_CODE = @c_POSKI 
				, CCF_ORG = 'PKN'
				, CCF_DESC = TXK50
				, CCF_UPDUSER = 'SA'
				, CCF_UPDDATE = getdate()
				, CCF_NOTUSED = 0
				, CCF_SAP_Active = Active
				, CCF_SAP_ANLKL = ANLKL
				, CCF_SAP_TXK50 = TXK50
				, CCF_SAP_BUKRS = BUKRS
				, CCF_SAP_KTOGR = KTOGR
			from COSTCLASSIFICATION CCF (nolock) join IE2_KST on CCF_CODE = POSKI where IE2_KST.ROWID = @c_ROWID
		end
		
		select @v_ID = CCF_ROWID from COSTCLASSIFICATION where CCF_CODE = @c_POSKI
		
----------------------------------- Update/Insert KST -----------------------------------------------------
		
		if isnumeric(@c_NDPER_OD) = 1 set @c_NDPER_OD_num = CAST(@c_NDPER_OD as int)
		if isnumeric(@c_NDPER_DO) = 1 set @c_NDPER_DO_num = CAST(@c_NDPER_DO as int)
		
		if not exists (select * from COSTCLASSIFICATION_KST where CCA_CCFID = @v_ID and CCA_TXTSEG = @c_TXTSEG)
		begin
			
			
			insert into COSTCLASSIFICATION_KST (CCA_CCFID, CCA_NDPER_OD, CCA_NDPER_DO, CCA_TXTSEG) 
			values (@v_ID, @c_NDPER_OD_num, @c_NDPER_DO_num, @c_TXTSEG)
		end
		else
		begin
			update COSTCLASSIFICATION_KST set 
				CCA_NDPER_OD = @c_NDPER_OD_num, 
				CCA_NDPER_DO = @c_NDPER_DO_num 
			where CCA_CCFID = @v_ID and CCA_TXTSEG = @c_TXTSEG
		end
----------------------------------- Update/Insert KST -----------------------------------------------------		
		update [dbo].[IE2_KST] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
		
		fetch next from KST_inserted
		into @c_ROWID, @c_KST_CODE, @c_POSKI, @c_TXTSEG, @c_NDPER_OD, @c_NDPER_DO
	end

	close KST_inserted
	deallocate KST_inserted
end
GO