SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_ErrorMessages_Insert_Proc]
as 
begin
 
	declare 
		@v_OT_ROWID int,
		@v_STATUS_NEW nvarchar(30)

	IF (SELECT CURSOR_STATUS('global','c_ErrorMessageInserted')) >= -1
	BEGIN
		IF (SELECT CURSOR_STATUS('global','c_ErrorMessageInserted')) > -1
		BEGIN
			CLOSE c_ErrorMessageInserted
		END
		DEALLOCATE c_ErrorMessageInserted
	END
	
	declare 
		  @c_ROWID int
		, @c_DateTime datetime
		, @c_OT_ROWID int
		, @c_OT_TYPE nvarchar(30)
		, @c_TYPE nvarchar(30)
		, @c_ID nvarchar(30)
		, @c_NUMBER nvarchar(30)
		, @c_MESSAGE  nvarchar(max)
		, @context_info varbinary(128)
		, @context_info_SAPI_ErrorMessages_Insert_Proc varbinary(128)


	declare c_ErrorMessageInserted cursor static for
	select top 100 ROWID, i_DateTime, OT_ROWID, OT_TYPE, TYPE, ID, NUMBER, MESSAGE from [dbo].[IE2_ERR_MSG] (nolock)
	where 
		isnull([DOC_NEW_INSERTED],0) = 1	
	order by OT_ROWID asc;
	--select ROWID, i_DateTime, OT_ROWID, OT_TYPE, TYPE, ID, NUMBER, MESSAGE from [IE2_ERR_MSG]

	open c_ErrorMessageInserted

	fetch next from c_ErrorMessageInserted
	into @c_ROWID, @c_DateTime, @c_OT_ROWID, @c_OT_TYPE, @c_TYPE, @c_ID, @c_NUMBER, @c_MESSAGE
	
	while @@fetch_status = 0 
	begin 
	 
		insert into dbo.ZWFOT_SAP_MESSAGES (
			OTM_OTID, 
			OTM_OTXXID, 
			OTM_DATE, 
			OTM_OT_TYPE, 
			OTM_TYPE, 
			OTM_MESSAGE,
			OTM_ERRID,
			OTM_USERID)
		select 
			OT_ROWID, 
			@c_OT_ROWID, --Integracja z SAP podaje nam np OT11_ROWID (SAPO_ZWFOT11) a nie OT_ROWID  (ZWFOT)
			@c_DateTime, 
			@c_OT_TYPE, 
			@c_TYPE, 
			isnull(@c_MESSAGE,N'Błąd integracji. Skontaktuj się z administratorem.'),
			@c_ROWID,
			'SAP'
 		from ZWFOT (nolock)
			 left join SAPO_ZWFOT11 (nolock) on OT11_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT11' and OT11_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT12 (nolock) on OT12_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT12' and OT12_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT21 (nolock) on OT21_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT21' and OT21_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT31 (nolock) on OT31_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT31' and OT31_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT32 (nolock) on OT32_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT32' and OT32_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT33 (nolock) on OT33_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT33' and OT33_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT42 (nolock) on OT42_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT42' and OT42_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT40 (nolock) on OT40_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT40' and OT40_ZMT_ROWID = OT_ROWID
			 left join SAPO_ZWFOT41 (nolock) on OT41_ROWID =  @c_OT_ROWID and @c_OT_TYPE = 'OT41' and OT41_ZMT_ROWID = OT_ROWID
		where coalesce(OT11_ROWID, OT12_ROWID, OT21_ROWID, OT31_ROWID, OT32_ROWID, OT33_ROWID, OT40_ROWID, OT41_ROWID, OT42_ROWID) is not null
		
		
		/* Wyłączam[DS]. [JK] naprawił problem w http://jira.eurotronic.net.pl/browse/PKNTA-134
		--Obsługa cofnięcia integracji poprzez ErrorMessage. Jeśli dostał błąd a dokument jest do integracji, wtedy musi go zatrzymać (problem był np. w dokumentcie MT3, ale obsłużyłem z tej strony wszystkie)
		if @c_TYPE = 'E' 
		begin
		
			--OT11
			if @c_OT_TYPE = 'OT11' and (select OT_STATUS from dbo.ZWFOT11v (nolock) where OT11_ROWID =  @c_OT_ROWID) = 'OT11_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT11_ZMT_ROWID, @v_STATUS_NEW = 'OT11_60' from dbo.SAPO_ZWFOT11 (nolock) where OT11_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT11 set OT11_IF_STATUS = 4 where OT11_ROWID =  @c_OT_ROWID
			end
			--OT12
			if @c_OT_TYPE = 'OT12' and (select OT_STATUS from dbo.ZWFOT12v (nolock) where OT12_ROWID =  @c_OT_ROWID) = 'OT12_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT12_ZMT_ROWID, @v_STATUS_NEW = 'OT12_60' from dbo.SAPO_ZWFOT12 (nolock) where OT12_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT12 set OT12_IF_STATUS = 4 where OT12_ROWID =  @c_OT_ROWID
			end
			--OT21
			if @c_OT_TYPE = 'OT21' and (select OT_STATUS from dbo.ZWFOT21v (nolock) where OT21_ROWID =  @c_OT_ROWID) = 'OT21_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT21_ZMT_ROWID, @v_STATUS_NEW = 'OT21_60' from dbo.SAPO_ZWFOT21 (nolock) where OT21_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT21 set OT21_IF_STATUS = 4 where OT21_ROWID =  @c_OT_ROWID
			end
			--OT31
			if @c_OT_TYPE = 'OT31' and (select OT_STATUS from dbo.ZWFOT31v (nolock) where OT31_ROWID =  @c_OT_ROWID) = 'OT31_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT31_ZMT_ROWID, @v_STATUS_NEW = 'OT31_60' from dbo.SAPO_ZWFOT31 (nolock) where OT31_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT31 set OT31_IF_STATUS = 4 where OT31_ROWID =  @c_OT_ROWID
			end
			--OT32
			if @c_OT_TYPE = 'OT32' and (select OT_STATUS from dbo.ZWFOT32v (nolock) where OT32_ROWID =  @c_OT_ROWID) = 'OT32_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT32_ZMT_ROWID, @v_STATUS_NEW = 'OT32_60' from dbo.SAPO_ZWFOT32 (nolock) where OT32_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT32 set OT32_IF_STATUS = 4 where OT32_ROWID =  @c_OT_ROWID
			end
			--OT33
			if @c_OT_TYPE = 'OT33' and (select OT_STATUS from dbo.ZWFOT33v (nolock) where OT33_ROWID =  @c_OT_ROWID) = 'OT33_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT33_ZMT_ROWID, @v_STATUS_NEW = 'OT33_60' from dbo.SAPO_ZWFOT33 (nolock) where OT33_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT33 set OT33_IF_STATUS = 4 where OT33_ROWID =  @c_OT_ROWID
			end
			--OT40
			if @c_OT_TYPE = 'OT40' and (select OT_STATUS from dbo.ZWFOT40v (nolock) where OT40_ROWID =  @c_OT_ROWID) = 'OT40_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT40_ZMT_ROWID, @v_STATUS_NEW = 'OT40_60' from dbo.SAPO_ZWFOT40 (nolock) where OT40_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT40 set OT40_IF_STATUS = 4 where OT40_ROWID =  @c_OT_ROWID
			end
			--OT41
			if @c_OT_TYPE = 'OT41' and (select OT_STATUS from dbo.ZWFOT41v (nolock) where OT41_ROWID =  @c_OT_ROWID) = 'OT41_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT41_ZMT_ROWID, @v_STATUS_NEW = 'OT41_60' from dbo.SAPO_ZWFOT41 (nolock) where OT41_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT41 set OT41_IF_STATUS = 4 where OT41_ROWID =  @c_OT_ROWID
			end
			--OT42
			if @c_OT_TYPE = 'OT42' and (select OT_STATUS from dbo.ZWFOT42v (nolock) where OT42_ROWID =  @c_OT_ROWID) = 'OT42_20' --jest do wysłania
			begin
				select @v_OT_ROWID = OT42_ZMT_ROWID, @v_STATUS_NEW = 'OT42_60' from dbo.SAPO_ZWFOT42 (nolock) where OT42_ROWID =  @c_OT_ROWID
				update SAPO_ZWFOT42 set OT42_IF_STATUS = 4 where OT42_ROWID =  @c_OT_ROWID
			end
			
			if @v_OT_ROWID is not null and @v_STATUS_NEW is not null
				exec [dbo].[ZWFOT_UpdateStatus] @p_OT_ROWID = @v_OT_ROWID, @p_STATUS_NEW = @v_STATUS_NEW, @p_UserID = 'SAP' --Odrzucony Workflow
		end
		*/
		 	
		select @context_info = isnull(CONTEXT_INFO(),0x)
		select @context_info_SAPI_ErrorMessages_Insert_Proc = cast('SAPI_ErrorMessages_Insert_Proc' as varbinary(128))--0x291846

		
		set context_info @context_info_SAPI_ErrorMessages_Insert_Proc

		update [dbo].[IE2_ERR_MSG] set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
			
		set context_info @context_info

		fetch next from c_ErrorMessageInserted
		into @c_ROWID, @c_DateTime, @c_OT_ROWID, @c_OT_TYPE, @c_TYPE, @c_ID, @c_NUMBER, @c_MESSAGE
	
	end

	close c_ErrorMessageInserted
	deallocate c_ErrorMessageInserted

end 
  





GO