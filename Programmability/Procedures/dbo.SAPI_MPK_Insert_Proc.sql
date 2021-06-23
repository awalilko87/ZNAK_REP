SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_MPK_Insert_Proc] 
as 
begin

	declare @c_ROWID int
	declare @c_MPK_CODE nvarchar(50)
	declare @c_POSKI nvarchar(50)
	
	declare MPK_inserted cursor static for
	select ROWID, KOSTL, POSKI from [dbo].[IE2_MPK] 
	where 
		isnull([DOC_NEW_INSERTED],0) = 1
		and KOSTL NOT IN ('XXX1', '302C')
		and ISNUMERIC(KOSTL) = 1
	order by ROWID asc
	--select ROWID,* from ie2_mpk

	open MPK_inserted

	fetch next from MPK_inserted
	into @c_ROWID, @c_MPK_CODE, @c_POSKI

	while @@fetch_status = 0 
	begin
		if isnumeric(@c_MPK_CODE) = 1
		begin
			if not exists (select * from COSTCODE (nolock) where CCD_SAP_KOSTL = @c_MPK_CODE) 
			begin
				insert into dbo.COSTCODE (CCD_CODE, CCD_ORG, CCD_DESC, CCD_CREUSER, CCD_CREDATE, CCD_NOTUSED, 
									CCD_SAP_MCTXT, CCD_SAP_KOKRS, CCD_SAP_KOSTL, CCD_SAP_DATBI, CCD_SAP_DATAB, 
									CCD_SAP_BUKRS, CCD_SAP_GSBER, CCD_SAP_KOSAR, CCD_SAP_VERAK, CCD_SAP_VERAK_USER, 
									CCD_SAP_WAERS, CCD_SAP_ERSDA, CCD_SAP_USNAM, CCD_SAP_ABTEI, CCD_SAP_SPRAS, 
									CCD_SAP_FUNC_AREA, CCD_SAP_KOMPL, CCD_SAP_OBJNR, CCD_SAP_ACTIVE)
				select POSKI, 'PKN', MCTXT, 'SA', getdate(), case when ACTIVE = 0 then 1 else 0 end, 
						MCTXT, KOKRS, KOSTL, DATBI, DATAB, 
						BUKRS, GSBER, KOSAR, VERAK, VERAK_USER, 
						WAERS, ERSDA, USNAM, ABTEI, SPRAS, 
						FUNC_AREA, KOMPL, OBJNR, ACTIVE 
				from dbo.IE2_MPK 
				where ROWID = @c_ROWID
			end
			else 
			begin
				update dbo.COSTCODE set 
					 CCD_DESC = MCTXT
					,CCD_UPDUSER = 'SA'
					,CCD_UPDDATE = getdate()
					,CCD_NOTUSED = case when ACTIVE = 0 then 1 else 0 end
					,CCD_SAP_MCTXT = MCTXT
					,CCD_SAP_KOKRS = KOKRS
					,CCD_SAP_KOSTL = KOSTL
					,CCD_SAP_DATBI = DATBI
					,CCD_SAP_DATAB = DATAB
					,CCD_SAP_BUKRS = BUKRS
					,CCD_SAP_GSBER = GSBER
					,CCD_SAP_KOSAR = KOSAR
					,CCD_SAP_VERAK = VERAK
					,CCD_SAP_VERAK_USER = VERAK_USER
					,CCD_SAP_WAERS = WAERS
					,CCD_SAP_ERSDA = ERSDA
					,CCD_SAP_USNAM = USNAM
					,CCD_SAP_ABTEI = ABTEI
					,CCD_SAP_SPRAS = SPRAS
					,CCD_SAP_FUNC_AREA = FUNC_AREA
					,CCD_SAP_KOMPL = KOMPL 
					,CCD_SAP_OBJNR = OBJNR 
					,CCD_SAP_ACTIVE = ACTIVE 
				from dbo.IE2_MPK 
				where CCD_CODE = POSKI and IE2_MPK.ROWID = @c_ROWID 

			end
		end
		
		update [dbo].[IE2_MPK] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
		
		fetch next from MPK_inserted
		into @c_ROWID, @c_MPK_CODE, @c_POSKI
	end

	close MPK_inserted
	deallocate MPK_inserted

end 
   
--select * from  ie2_mpk set DOC_NEW_INSERTED = 1, 
--select CCD_SAP_ACTIVE , * from COSTCODE where CCD_CODE like '%701800%'
--[SAPI_MPK_Insert_Proc] 
--0007257594
GO