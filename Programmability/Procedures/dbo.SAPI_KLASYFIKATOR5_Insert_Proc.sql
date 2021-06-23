SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_KLASYFIKATOR5_Insert_Proc] 
 
as 
begin

	declare @c_ROWID int
	declare @c_KLASYFIKATOR5_CODE nvarchar(50)
	declare @c_POSKI nvarchar(50)
	declare @c_Active int
	
	declare @v_KL5ID int
	declare @v_CCDID int

	update dbo.IE2_KLASYFIKATOR5 set
		DOC_NEW_INSERTED = 0
	where DOC_NEW_INSERTED = 1 and not exists (select 1 from COSTCODE (nolock) where GDLGRP like CCD_CODE+'%')

	declare KLASYFIKATOR5_inserted cursor static for
	select ROWID, GDLGRP, POSKI, Active from [dbo].[IE2_KLASYFIKATOR5] (nolock)
	where 
		isnull([DOC_NEW_INSERTED],0) = 1
	order by ROWID asc;
 
	open KLASYFIKATOR5_inserted

	fetch next from KLASYFIKATOR5_inserted
	into @c_ROWID, @c_KLASYFIKATOR5_CODE, @c_POSKI, @c_Active

	while @@fetch_status = 0 
	begin
	  
		if not exists (select * from dbo.KLASYFIKATOR5 (nolock) where KL5_SAP_GDLGRP = @c_KLASYFIKATOR5_CODE) 
		begin
			insert into dbo.KLASYFIKATOR5 (KL5_CODE, KL5_ORG, KL5_DESC, KL5_CREUSER, KL5_CREDATE, KL5_NOTUSED, KL5_SAP_GDLGRP, KL5_SAP_GDLGRP_TXT, KL5_SAP_ACTIVE)
			select @c_POSKI, 'PKN', GDLGRP_TXT, 'SA', getdate(), case when ACTIVE = 0 then 1 else 0 end, GDLGRP, GDLGRP_TXT, ACTIVE 
			from dbo.IE2_KLASYFIKATOR5 
			where ROWID = @c_ROWID
		end
		else 
		begin
			update dbo.KLASYFIKATOR5 set 
				 KL5_DESC = GDLGRP_TXT
				,KL5_UPDUSER = 'SA'
				,KL5_UPDDATE = getdate()
				,KL5_NOTUSED = case when ACTIVE = 0 then 1 else 0 end
				,KL5_SAP_GDLGRP = GDLGRP
				,KL5_SAP_GDLGRP_TXT = GDLGRP_TXT
				,KL5_SAP_ACTIVE = ACTIVE 
			from IE2_KLASYFIKATOR5
			where KL5_CODE = POSKI and IE2_KLASYFIKATOR5.ROWID = @c_ROWID 

		end
		
		/*
		select @v_KL5ID = KL5_ROWID from KLASYFIKATOR5 KL5 (nolock) where KL5_CODE = @c_POSKI
		select @v_CCDID = CCD_ROWID from COSTCODE (nolock) where left(@c_POSKI,7) = left(CCD_CODE,7) and (CCD_DESC like 'SP %' or CCD_DESC like 'MO%')
		 	
		--STACJE PALIW
		if not exists (select STN_CODE from STATION (nolock) where STN_CCDID = @v_CCDID and STN_KL5ID = @v_KL5ID) 
			and @v_KL5ID is not null
			and @v_CCDID is not null
		
		begin

			insert into STATION(STN_CODE, STN_ORG, STN_CCDID, STN_KL5ID, STN_DESC, STN_NOTUSED, STN_CREDATE, STN_CREUSER,
								STN_STREET, STN_CITY, STN_STATUS, STN_ID, STN_TYPE, STN_VOIVODESHIP)
 
			select cast(right(CCD_CODE,4) as int), 'PKN', CCD_ROWID, KL5_ROWID, 'SP'+ cast((CAST (right(CCD_CODE,4) as int)) as nvarchar) + ' ' + right(CCD_DESC, LEN(CCD_DESC) - 3), 0, GETDATE(), 'SA',
					'', right(CCD_DESC, LEN(CCD_DESC) - 3), 'STN_002', NEWID(), case right(KL5_CODE,1) when '0' then 'STACJA' else null end, NULL
			from 
				COSTCODE (nolock) 
					join KLASYFIKATOR5 (nolock) on left(KL5_CODE,7) = left(CCD_CODE,7) 
			where  
				CCD_ROWID = @v_CCDID
				and KL5_ROWID = @v_KL5ID
		end
		else 
		begin
			update S
				set STN_NOTUSED = case when @c_Active = 0 then 1 else 0 end
			from STATION (nolock) S				 
			where 
				STN_CCDID = @v_CCDID
				and STN_KL5ID = @v_KL5ID
		end
		*/
		 		
		update [dbo].[IE2_KLASYFIKATOR5] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
		
		fetch next from KLASYFIKATOR5_inserted
		into @c_ROWID, @c_KLASYFIKATOR5_CODE, @c_POSKI, @c_Active
	end

	close KLASYFIKATOR5_inserted
	deallocate KLASYFIKATOR5_inserted

end 
GO