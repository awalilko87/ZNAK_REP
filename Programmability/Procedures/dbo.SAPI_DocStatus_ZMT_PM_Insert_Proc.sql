SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_DocStatus_ZMT_PM_Insert_Proc] 
as 
begin

	declare 
		  @c_ROWID int
		, @c_DOCTYPE nvarchar(50)
		, @c_DOCKEY nvarchar(50)
		, @c_STATCODE nvarchar(30)
		, @c_COLS nvarchar(max)
		, @c_VALS nvarchar(max)		
		, @Statement nvarchar(max)		
		, @context_info varbinary(128)
		, @context_info_SAPI_DocStatus_Insert_Proc varbinary(128)
		, @v_FROM_USER nvarchar(30)
		, @v_STAT_DESC nvarchar(255)
		, @v_COMM_1 nvarchar(255)
		, @v_COMM_2 nvarchar(255)
		, @v_COMM_3 nvarchar(255)
		, @v_COMM_4 nvarchar(255)
		, @v_OBJCODE nvarchar(30)
		, @v_OBJPM nvarchar(30)
	 
	declare DocStatusPM_inserted cursor static for
	select top 100 ROWID, DOC_TYPE, DOC_KEY, STAT_CODE, COLS, VALS 
	from [dbo].[IE2_DocStatus] (nolock)
	where DOC_TYPE = 'ZMT_PM'
		and isnull([DOC_NEW_INSERTED],0) = 1	
	order by ROWID asc;
	--select ROWID, DOC_TYPE, DOC_KEY, STAT_CODE,* from ie2_DocStatus

	open DocStatusPM_inserted

	fetch next from DocStatusPM_inserted
	into @c_ROWID, @c_DOCTYPE, @c_DOCKEY, @c_STATCODE, @c_COLS, @c_VALS

	while @@fetch_status = 0 
	begin
		--------------------------------------------------------------------------------------------------------------------------
		---------------------------------------komunikat z SAP (przychodzi jako COLS i VALS---------------------------------------
		--------------------------------------------------------------------------------------------------------------------------
		create table #t_status_message  (
			[FROM_USER] nvarchar(50), [TO_USER] nvarchar(50), [CUR_USER] nvarchar(50), [DOC_KEY] nvarchar(50) 
			,[TO_USER_1] nvarchar(50), [TO_USER_2] nvarchar(50), [TO_USER_3] nvarchar(50), [TO_USER_4] nvarchar(50),[TO_USER_5] nvarchar(50), [TO_USER_6] nvarchar(50), [TO_USER_7] nvarchar(50), [TO_USER_8] nvarchar(50), [TO_USER_9] nvarchar(50), [TO_USER_10] nvarchar(50)  
			,[TO_USER_11] nvarchar(50), [TO_USER_12] nvarchar(50), [TO_USER_13] nvarchar(50), [TO_USER_14] nvarchar(50),[TO_USER_15] nvarchar(50), [TO_USER_16] nvarchar(50), [TO_USER_17] nvarchar(50), [TO_USER_18] nvarchar(50), [TO_USER_19] nvarchar(50), [TO_USER_20] nvarchar(50)  
			,[TO_USER_21] nvarchar(50), [TO_USER_22] nvarchar(50), [TO_USER_23] nvarchar(50), [TO_USER_24] nvarchar(50),[TO_USER_25] nvarchar(50), [TO_USER_26] nvarchar(50), [TO_USER_27] nvarchar(50), [TO_USER_28] nvarchar(50), [TO_USER_29] nvarchar(50), [TO_USER_30] nvarchar(50)  
			,[TO_USER_31] nvarchar(50), [TO_USER_32] nvarchar(50), [TO_USER_33] nvarchar(50), [TO_USER_34] nvarchar(50),[TO_USER_35] nvarchar(50), [TO_USER_36] nvarchar(50), [TO_USER_37] nvarchar(50), [TO_USER_38] nvarchar(50), [TO_USER_39] nvarchar(50), [TO_USER_40] nvarchar(50)  
			,[TO_USER_41] nvarchar(50), [TO_USER_42] nvarchar(50), [TO_USER_43] nvarchar(50), [TO_USER_44] nvarchar(50),[TO_USER_45] nvarchar(50), [TO_USER_46] nvarchar(50), [TO_USER_47] nvarchar(50), [TO_USER_48] nvarchar(50), [TO_USER_49] nvarchar(50), [TO_USER_50] nvarchar(50)  
			,[ACC_USER 1] nvarchar(50), [ACC_USER 2] nvarchar(50),[ACC_USER 3] nvarchar(50), [ACC_USER 4] nvarchar(50),[ACC_USER 5] nvarchar(50), [ACC_USER 6] nvarchar(50), [ACC_USER 7] nvarchar(50), [ACC_USER 8] nvarchar(50), [ACC_USER 9] nvarchar(50), [ACC_USER 10] nvarchar(50)
			,[COMM_1] nvarchar(255), [COMM_2] nvarchar(255), [COMM_3] nvarchar(255), [COMM_4] nvarchar(255),[COMM_5] nvarchar(255), [COMM_6] nvarchar(255), [COMM_7] nvarchar(255), [COMM_8] nvarchar(255), [COMM_9] nvarchar(255), [COMM_10] nvarchar(255)  
			,[COMM_11] nvarchar(255), [COMM_12] nvarchar(255), [COMM_13] nvarchar(255), [COMM_14] nvarchar(255),[COMM_15] nvarchar(255), [COMM_16] nvarchar(255), [COMM_17] nvarchar(255), [COMM_18] nvarchar(255), [COMM_19] nvarchar(255), [COMM_20] nvarchar(255)  
			,[STAT_DESC] nvarchar(max),[i_DateTime] datetime) 
		
		IF RIGHT(@c_COLS,1)=',' SELECT @c_COLS=@c_COLS+'[i_DateTime]'
		IF RIGHT(@c_VALS,1)=',' SELECT @c_VALS=@c_VALS+'#'+CONVERT(nvarchar,GETDATE(),121)+'#'
		SELECT @c_VALS=REPLACE(@c_VALS,'#00000000#','null')
		SELECT @c_VALS=REPLACE(@c_VALS,'''','''''')
		SELECT @c_VALS=REPLACE(@c_VALS,'#','''')

		SET @Statement = 
		N' insert into #t_status_message'+N'('+@c_COLS+N') VALUES('+@c_VALS+N');'
 
		EXEC sp_executesql @Statement;	
	  
		select
			 @v_FROM_USER = [FROM_USER]
			,@v_STAT_DESC = [STAT_DESC]
			,@v_COMM_1 = [COMM_1]
			,@v_COMM_2 = [COMM_2]
			,@v_COMM_3 = [COMM_3]
			,@v_COMM_4 = [COMM_4]
		from #t_status_message
		
		if @c_STATCODE = 'CREATE'
		begin
			set @v_OBJCODE = coalesce(@v_COMM_4, @v_COMM_3, @v_COMM_2)
			
			update dbo.OBJ set
				OBJ_PM_REQUEST = @c_DOCKEY
			where OBJ_CODE = @v_OBJCODE
		end
		else if @c_STATCODE = 'PROCESS'
		begin
			set @v_OBJCODE = (select OBJ_CODE from dbo.OBJ where OBJ_PM_REQUEST = @c_DOCKEY)
			set @v_OBJPM = coalesce(@v_COMM_4, @v_COMM_3, @v_COMM_2)
			
			if isnull(@v_COMM_1, '')+isnull(@v_COMM_2, '')+isnull(@v_COMM_3, '')+isnull(@v_COMM_4, '') like '%stworzono%'
			begin			
				update dbo.OBJ set
					OBJ_PM = replace(@v_OBJPM, '(0) ', '')
				where OBJ_CODE = @v_OBJCODE
			end
		end
		
		drop table #t_status_message

		update [dbo].[IE2_DocStatus]  set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
		
		fetch next from DocStatusPM_inserted
		into @c_ROWID, @c_DOCTYPE, @c_DOCKEY, @c_STATCODE, @c_COLS, @c_VALS
	end

	close DocStatusPM_inserted
	deallocate DocStatusPM_inserted

end
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
GO