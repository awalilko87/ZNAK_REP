SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SAPI_KONTRAHENCI_Insert_Proc] 
as 
begin

	declare @c_ROWID int
	declare @c_VEN_CODE nvarchar(50)
	declare @c_POSKI nvarchar(50)

	declare VEN_inserted cursor static for
	select top 1000 ROWID, LIFNR, POSKI from dbo.IE2_KONTRAHENCI (nolock)
	where 
		isnull(DOC_NEW_INSERTED,0) = 1
	order by ROWID asc;
	--select ROWID,* from dbo.IE2_KONTRAHENCI
	--select * from ie2_desc where dict = 'KONTRAHENCI'

	open VEN_inserted

	fetch next from VEN_inserted
	into @c_ROWID, @c_VEN_CODE, @c_POSKI

	while @@fetch_status = 0 
	begin
	 
		if not exists (select * from dbo.VENDOR (nolock) where VEN_CODE = @c_POSKI) 
		begin
			insert into dbo.VENDOR (VEN_CODE, VEN_ORG, VEN_DESC, VEN_CREUSER, VEN_CREDATE, VEN_UPDUSER, VEN_UPDDATE, VEN_NOTUSED, VEN_STATUS, VEN_TYPE, VEN_SAP_Active, 
										VEN_SAP_LIFNR, VEN_SAP_LAND1, VEN_SAP_NAME1, VEN_SAP_MCOD1, VEN_SAP_NAME2, VEN_SAP_NAME3, VEN_SAP_NAME4, VEN_SAP_ORT01, VEN_SAP_ORT02, 
										VEN_SAP_PFACH, VEN_SAP_PSTL2, VEN_SAP_PSTLZ, VEN_SAP_MCOD2, VEN_SAP_STRAS, VEN_SAP_ADRNR, VEN_SAP_MCOD3, VEN_SAP_ANRED, VEN_SAP_BEGRU, 
										VEN_SAP_ERDAT, VEN_SAP_ERNAM, VEN_SAP_KTOKK, VEN_SAP_KUNNR, VEN_SAP_SPRAS, VEN_SAP_STCD1, VEN_SAP_STCD2)
			select @c_POSKI, 'PKN', NAME1, 'SA', getdate(), NULL, NULL, 1-Active, 'VEN_001', KTOKK, Active, 
				LIFNR, LAND1, NAME1, MCOD1, NAME2, NAME3, NAME4, ORT01, ORT02, 
				PFACH, PSTL2, PSTLZ, MCOD2, STRAS, ADRNR, MCOD3, ANRED, BEGRU, 
				ERDAT, ERNAM, KTOKK, KUNNR, SPRAS, STCD1, STCD2
			from dbo.IE2_KONTRAHENCI 
			where ROWID = @c_ROWID
		end
		else 
		begin
			update dbo.VENDOR set 
				  VEN_DESC = NAME1
				, VEN_UPDUSER = 'SA'
				, VEN_UPDDATE = getdate()
				, VEN_NOTUSED = 1-Active
				, VEN_STATUS = 'VEN_001'
				, VEN_TYPE = KTOKK
				, VEN_SAP_Active= Active
				, VEN_SAP_LIFNR	= LIFNR
				, VEN_SAP_LAND1	= LAND1
				, VEN_SAP_NAME1	= NAME1
				, VEN_SAP_MCOD1	= MCOD1
				, VEN_SAP_NAME2	= NAME2
				, VEN_SAP_NAME3	= NAME3
				, VEN_SAP_NAME4	= NAME4
				, VEN_SAP_ORT01	= ORT01
				, VEN_SAP_ORT02	= ORT02
				, VEN_SAP_PFACH	= PFACH
				, VEN_SAP_PSTL2	= PSTL2
				, VEN_SAP_PSTLZ	= PSTLZ
				, VEN_SAP_MCOD2	= MCOD2
				, VEN_SAP_STRAS	= STRAS
				, VEN_SAP_ADRNR	= ADRNR
				, VEN_SAP_MCOD3	= MCOD3
				, VEN_SAP_ANRED	= ANRED
				, VEN_SAP_BEGRU	= BEGRU
				, VEN_SAP_ERDAT	= ERDAT
				, VEN_SAP_ERNAM	= ERNAM
				, VEN_SAP_KTOKK	= KTOKK
				, VEN_SAP_KUNNR	= KUNNR
				, VEN_SAP_SPRAS	= SPRAS
				, VEN_SAP_STCD1	= STCD1
				, VEN_SAP_STCD2	= STCD2
			from dbo.IE2_KONTRAHENCI
			where ROWID = @c_ROWID and VEN_CODE = @c_POSKI

		end
	
		update dbo.IE2_KONTRAHENCI set DOC_NEW_INSERTED = 0 where ROWID = @c_ROWID
			
		fetch next from VEN_inserted
		into @c_ROWID, @c_VEN_CODE, @c_POSKI
	end

	close VEN_inserted
	deallocate VEN_inserted

end 
GO