SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_DocStatus_Insert_Proc]
as 
begin

	declare 
		  @v_OT_ROWID int
		, @v_OT11ID int
		, @v_OT12ID int
		, @v_OT21ID int
		, @v_OT31ID int
		, @v_OT32ID int
		, @v_OT33ID int
		, @v_OT42ID int
		, @v_OT41ID int
		, @v_OT40ID int
		, @v_STATUS_NEW nvarchar(30)
		, @v_ASTCODE nvarchar(30)
		, @v_ASTSUBCODE nvarchar(30)
		, @v_OT_GUID nvarchar(50)
		, @v_ASTID int
		, @v_STNID int
		, @v_KL5ID int
		, @v_PARENTID int
		, @v_MT3_OPER nvarchar(1)
		, @v_TO_KL5 nvarchar(30)
		, @c_ROWID int
		, @c_GUID nvarchar(50)
		, @c_POZ nvarchar(5)
		, @c_DOCTYPE nvarchar(50)
		, @c_DOCKEY nvarchar(50)
		, @c_STATCODE nvarchar(30)
		, @c_COLS nvarchar(max)
		, @c_VALS nvarchar(max)		
		, @c_OBJID int
		, @Statement nvarchar(max)		
		, @context_info varbinary(128)
		, @context_info_SAPI_DocStatus_Insert_Proc varbinary(128)
	declare @ci varbinary(128), @ci_old varbinary(128)
	 
	declare DocStatus_inserted cursor static for
	select top 100 ROWID, [GUID], ltrim(rtrim(POZ)), DOC_TYPE, DOC_KEY, STAT_CODE, COLS, VALS from [dbo].[IE2_DocStatus] (nolock)
	where DOC_TYPE not in ('ZMT_PM')
		and isnull([DOC_NEW_INSERTED],0) = 1
	order by ROWID asc;
	--select ROWID, DOC_TYPE, DOC_KEY, STAT_CODE,* from ie2_DocStatus

	open DocStatus_inserted

	fetch next from DocStatus_inserted
	into @c_ROWID, @c_GUID, @c_POZ, @c_DOCTYPE, @c_DOCKEY, @c_STATCODE, @c_COLS, @c_VALS

	while @@fetch_status = 0 
	begin
	  
		--OT,OTK,W (Tabela [SAPI_DocStatus_Legend] jest niewystarczająca i używam jako wartość domyślna)
		if @c_DOCTYPE = 'OT11'
		begin

			select @v_OT11ID = OT11_ROWID, @v_OT_ROWID = OT11_ZMT_ROWID from SAPO_ZWFOT11 (nolock) where OT11_IF_EQUNR + cast(year(OT11_IF_SENTDATE) as nvarchar(4)) + OT11_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT11 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE

			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin
				if charindex(N'#OT z inwestycji - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_31'
				else if charindex(N'#OT z inwestycji - realizator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_32'
				else if charindex(N'#OT z inwestycji - dysponent', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_33'
				else if charindex(N'#OT z inwestycji - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_34'
				else if charindex(N'#OT z inwestycji - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_35'
				else if charindex(N'#OT z inwestycji - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_50'
				else if charindex(N'#OT z inwestycji - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT11_40' 
			end
		end
		
		else if @c_DOCTYPE = 'OT12'
		begin

			select @v_OT12ID = OT12_ROWID, @v_OT_ROWID = OT12_ZMT_ROWID from SAPO_ZWFOT12 (nolock) where OT12_IF_EQUNR + cast(year(OT12_IF_SENTDATE) as nvarchar(4)) + OT12_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT12 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin			
				if charindex(N'#OT z kompletacji - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_31'
				else if charindex(N'#OT z kompletacji - realizator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_32'
				else if charindex(N'#OT z kompletacji - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_33'
				else if charindex(N'#OT z kompletacji - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_34'
				else if charindex(N'#OT z kompletacji - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_50'
				else if charindex(N'#OT z kompletacji - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT12_40'
			end 
		end
		
		else if @c_DOCTYPE = 'OT21'
		begin

			select @v_OT21ID = OT21_ROWID, @v_OT_ROWID = OT21_ZMT_ROWID from SAPO_ZWFOT21 (nolock) where OT21_IF_EQUNR + cast(year(OT21_IF_SENTDATE) as nvarchar(4)) + OT21_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT21 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin
				if charindex(N'#Dokument W - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_31'
				else if charindex(N'#Dokument W - realizator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_32'
				else if charindex(N'#Dokument W - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_33'
				else if charindex(N'#Dokument W - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_34'
				else if charindex(N'#Dokument W - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_50'
				else if charindex(N'#Dokument W - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT21_40' 
			end
		end
		
		--MT1, MT2, MT3
		else if @c_DOCTYPE = 'OT31'
		begin

			select @v_OT31ID = OT31_ROWID, @v_OT_ROWID = OT31_ZMT_ROWID from SAPO_ZWFOT31 (nolock) where OT31_IF_EQUNR + cast(year(OT31_IF_SENTDATE) as nvarchar(4)) + OT31_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT31 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Dokument MT - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_31'
				else if charindex(N'#Dokument MT - użytkownik wydający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_32'
				else if charindex(N'#Dokument MT - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_33'
				else if charindex(N'#Dokument MT - użytkownik przyjmujący', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_34'
				else if charindex(N'#Dokument MT - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_50'
				else if charindex(N'#Dokument MT - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT31_40' 
			end

		end
		
		else if @c_DOCTYPE = 'OT32'
		begin
			select @v_OT32ID = OT32_ROWID, @v_OT_ROWID = OT32_ZMT_ROWID from SAPO_ZWFOT32 (nolock) where OT32_IF_EQUNR + cast(year(OT32_IF_SENTDATE) as nvarchar(4)) + OT32_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT32 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Dokument MT - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_31'
				else if charindex(N'#Dokument MT - użytkownik wydający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_32'
				else if charindex(N'#Dokument MT - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_33'
				else if charindex(N'#Dokument MT - użytkownik przyjmujący', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_34'
				else if charindex(N'#Dokument MT - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_50'
				else if charindex(N'#Dokument MT - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT32_40' 
			end

		end
		
		else if @c_DOCTYPE = 'OT33'
		begin
			select @v_OT33ID = OT33_ROWID, @v_OT_ROWID = OT33_ZMT_ROWID, @v_MT3_OPER = OT33_MTOPER from SAPO_ZWFOT33 (nolock) where OT33_IF_EQUNR + cast(year(OT33_IF_SENTDATE) as nvarchar(4)) + OT33_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT33 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Dokument MT - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_31'
				else if charindex(N'#Dokument MT - użytkownik wydający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_32'
				else if charindex(N'#Dokument MT - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_33'
				else if charindex(N'#Dokument MT - użytkownik przyjmujący', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_34'
				else if charindex(N'#Dokument MT - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_50'
				else if charindex(N'#Dokument MT - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT33_40' 
			end

		end
		
		--PL, LTS, LTW
		else if @c_DOCTYPE = 'OT42'
		begin
			if @c_POZ = 1 and @c_STATCODE = 'WYSLIJ'
			begin
				update SAPO_ZWFOT42 set 
					 OT42_IF_STATUS = 3
					,OT42_IF_SENTDATE = GetDate()
					,OT42_IF_EQUNR = substring(@c_DOCKEY,1,10)
					,OT42_IF_YEAR = substring(@c_DOCKEY,11,4)
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT42_ZMT_ROWID = OT_ROWID and OT42_IF_STATUS = 2
			end
			else if @c_POZ = 1 and @c_STATCODE = 'ODRZUC'
			begin
				update SAPO_ZWFOT42 set 
					 OT42_IF_STATUS = 9
					 ,@v_OT41ID = OT42_ROWID
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT42_ZMT_ROWID = OT_ROWID and OT42_IF_STATUS = 2
			end

			select @v_OT42ID = OT42_ROWID, @v_OT_ROWID = OT42_ZMT_ROWID from SAPO_ZWFOT42 (nolock) where OT42_IF_EQUNR + cast(year(OT42_IF_SENTDATE) as nvarchar(4)) + OT42_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT42 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
			
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Dokument PL - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_31'
				else if charindex(N'#Dokument PL - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_32'
				else if charindex(N'#Dokument PL - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_33'
				else if charindex(N'#Dokument PL - upoważniony', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_34'
				else if charindex(N'#Dokument PL - dyrektor', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_35'
				else if charindex(N'#Dokument PL - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_50'
				else if charindex(N'#Dokument PL - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT42_40' 
			end

			if @v_STATUS_NEW = 'OT42_50'
			begin 
				exec dbo.PL_DOC_MAIL_Proc @v_OT_ROWID
			end


 		end
		
		else if @c_DOCTYPE = 'OT40'
		begin
			if @c_POZ = 1 and @c_STATCODE = 'AKCEPTUJ'
			begin
				update SAPO_ZWFOT40 set 
					 OT40_IF_STATUS = 3
					,OT40_IF_SENTDATE = GetDate()
					,OT40_IF_EQUNR = substring(@c_DOCKEY,1,10)
					,OT40_IF_YEAR = substring(@c_DOCKEY,11,4)
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT40_ZMT_ROWID = OT_ROWID and OT40_IF_STATUS = 2
			end
			else if @c_POZ = 1 and @c_STATCODE = 'ODRZUC'
			begin
				update SAPO_ZWFOT40 set 
					 OT40_IF_STATUS = 9
					 ,@v_OT41ID = OT40_ROWID
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT40_ZMT_ROWID = OT_ROWID and OT40_IF_STATUS = 2
			end

			select @v_OT40ID = OT40_ROWID, @v_OT_ROWID = OT40_ZMT_ROWID from SAPO_ZWFOT40 (nolock) where OT40_IF_EQUNR + cast(year(OT40_IF_SENTDATE) as nvarchar(4)) + OT40_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT40 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	 
				
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Dokument LT - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_31'
				else if charindex(N'#Dokument LT - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_32'
				else if charindex(N'#Dokument LT - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_33'
				else if charindex(N'#Dokument LT - upoważniony', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_34'
				else if charindex(N'#Dokument LT - dyrektor', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_35'
				else if charindex(N'#Dokument LT - BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_50'
				else if charindex(N'#Dokument LT - BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT40_40' 
			end

		end
		
		else if @c_DOCTYPE = 'OT41'
		begin
			if @c_POZ = 1 and @c_STATCODE = 'AKCEPTUJ'
			begin
				update SAPO_ZWFOT41 set 
					 OT41_IF_STATUS = 3
					,OT41_IF_SENTDATE = GetDate()
					,OT41_IF_EQUNR = substring(@c_DOCKEY,1,10)
					,OT41_IF_YEAR = substring(@c_DOCKEY,11,4)
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT41_ZMT_ROWID = OT_ROWID and OT41_IF_STATUS = 2
			end
			else if @c_POZ = 1 and @c_STATCODE = 'ODRZUC'
			begin
				update SAPO_ZWFOT41 set 
					 OT41_IF_STATUS = 9
					 ,@v_OT41ID = OT41_ROWID
				from dbo.ZWFOT
				where OT_ID = @c_GUID and OT41_ZMT_ROWID = OT_ROWID and OT41_IF_STATUS = 2
			end

			select @v_OT41ID = OT41_ROWID, @v_OT_ROWID = OT41_ZMT_ROWID from SAPO_ZWFOT41 (nolock) where OT41_IF_EQUNR + OT41_IF_YEAR + OT41_BUKRS = @c_DOCKEY
			select @v_STATUS_NEW = OT41 from [dbo].[SAPI_DocStatus_Legend] (nolock) where SAP_STAT_CODE = @c_STATCODE	
				
			if @c_STATCODE in ('WYSLIJ', 'AKCEPTUJ')
			begin 
				if charindex(N'#Wniosek dok. LT wyposażenia - wystawiający', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_31'
				else if charindex(N'#Wniosek dok. LT wyposażenia - użytkownik', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_32'
				else if charindex(N'#Wniosek dok. LT wyposażenia - weryfikator', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_33'
				else if charindex(N'#Wniosek dok. LT wyposażenia - upoważniony', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_34'
				else if charindex(N'#Wniosek dok. LT wyposażenia - dyrektor', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_35'
				else if charindex(N'#Wniosek dok. LT wyposażenia - księgowy BOM - zakończenie procesu', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_50'
				else if charindex(N'#Wniosek dok. LT wyposażenia - księgowy BOM', @c_VALS) > 0 
					select @v_STATUS_NEW = 'OT41_40' 
			end
 
		end
		
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
			,[COMM_11] nvarchar(255), [COMM_12] nvarchar(255), [COMM_13] nvarchar(255), [COMM_14] nvarchar(255),[COMM_15] nvarchar(255), [COMM_16] nvarchar(255), [COMM_17] nvarchar(255), [COMM_18] nvarchar(255), [COMM_19] nvarchar(255), [COMM_20] nvarchar(255), [COMM_21] nvarchar(255), [COMM_22] nvarchar(255)  
			,[MESS_1] nvarchar(255)
			,[STAT_DESC] nvarchar(max)
			,[SAT_NAME] nvarchar(80)
			,[i_DateTime] datetime) 
		
		IF RIGHT(@c_COLS,1)=',' SELECT @c_COLS=@c_COLS+'[i_DateTime]'
		IF RIGHT(@c_VALS,1)=',' SELECT @c_VALS=@c_VALS+'#'+CONVERT(nvarchar,GETDATE(),121)+'#'
		SELECT @c_VALS=REPLACE(@c_VALS,'#00000000#','null')
		SELECT @c_VALS=REPLACE(@c_VALS,'''','''''')
		SELECT @c_VALS=REPLACE(@c_VALS,'#','''')

		SET @Statement = 
		N' insert into #t_status_message'+N'('+@c_COLS+N') VALUES('+@c_VALS+N');'
 
		EXEC sp_executesql @Statement;	
		
		if @c_DOCTYPE = 'OT33' and @c_STATCODE = 'FINISH' and @v_MT3_OPER in ('2', '4', '6')
		begin
			select
				 @v_ASTCODE = case
								when charindex('/', SAT_NAME) > 0 then substring(SAT_NAME, 1, charindex('/', SAT_NAME)-1)
								else SAT_NAME
							end
				,@v_ASTSUBCODE = case
									when charindex('/', SAT_NAME) > 0 then substring(SAT_NAME, charindex('/', SAT_NAME)+1, len(SAT_NAME)-charindex('/', SAT_NAME)+1)
									else '0000'
								end
			from #t_status_message
			
			if @v_ASTCODE is not null
			begin
				while left(@v_ASTCODE,1) = '0'
				begin
					set @v_ASTCODE = substring(@v_ASTCODE, 2, 30)
				end
				
				select @v_OT_GUID = OT_ID from dbo.ZWFOT where OT_ROWID = @v_OT_ROWID
				
				declare C_OBJ33 cursor for select OBJID from dbo.GetBlockedObjOT(@v_OT_GUID)
				open C_OBJ33
				fetch next from C_OBJ33 into @c_OBJID
				while @@fetch_status = 0
				begin
					if not exists (select 1 from dbo.ASSET where AST_CODE = @v_ASTCODE and AST_SUBCODE = @v_ASTSUBCODE and AST_ORG = 'PKN')
					begin
						insert into dbo.ASSET(AST_CODE, AST_SUBCODE, AST_ORG, AST_NOTUSED, AST_BARCODE, AST_CCTID)
						values(@v_ASTCODE, @v_ASTSUBCODE, 'PKN', 1, @v_ASTCODE+@v_ASTSUBCODE, 1)
						
						set @v_ASTID = scope_identity()
					end
					else
					begin
						select @v_ASTID = AST_ROWID from dbo.ASSET where AST_CODE = @v_ASTCODE and AST_SUBCODE = @v_ASTSUBCODE and AST_ORG = 'PKN'
					end

					--pobieranie danych dla serwisow
					if exists (select 1 from dbo.ZWFOT33DONv
								join dbo.KLASYFIKATOR5 on KL5_CODE = OT33DON_UZYTK_DO_POSKI
								join dbo.STATION on STN_KL5ID = KL5_ROWID
								where OT_ID = @v_OT_GUID and OT33DON_MTOPER = 'X' and STN_TYPE = 'SERWIS')
					begin
						select
							 @v_STNID = POL_TO_STNID
							,@v_KL5ID = STN_KL5ID
						from dbo.OTPOLv
						join dbo.STATION on STN_ROWID = POL_TO_STNID
						where OTO_OBJID = @c_OBJID

						select
							 @v_PARENTID = OBJ_ROWID
						from dbo.OBJ
						join OBJSTATION on OSA_OBJID = OBJ_ROWID
						where OSA_STNID = @v_STNID
						and OBJ_STSID = 23
					end
					else
					begin
						select top 1
							@v_PARENTID = OBA_OBJID 
						from dbo.OBJASSET 
						join ASSET on AST_ROWID = OBA_ASTID 
						join OBJ on OBJ_ROWID = OBA_OBJID
						where AST_CODE = @v_ASTCODE and AST_SUBCODE = '0000' and AST_DONIESIENIE = 0
						order by case when OBJ_ROWID = OBJ_PARENTID then 0 else 1 end, AST_SUBCODE
					
						select
							 @v_STNID = OSA_STNID
							,@v_KL5ID = STN_KL5ID
						from dbo.OBJSTATION
						join dbo.STATION on STN_ROWID = OSA_STNID
						where OSA_OBJID = @v_PARENTID
					end
					
					update dbo.OBJ set
						OBJ_PARENTID = isnull(@v_PARENTID,OBJ_ROWID)
					where OBJ_ROWID = @c_OBJID
					
					delete from dbo.OBJASSET where OBA_OBJID = @c_OBJID
					
					insert into dbo.OBJASSET(OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)
					values(@c_OBJID, @v_ASTID, getdate(), 'OT33')
					
					delete from dbo.OBJSTATION where OSA_OBJID = @c_OBJID
					
					insert into dbo.OBJSTATION(OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)
					values(@c_OBJID, @v_STNID, @v_KL5ID, getdate(), 'OT33')

					set @ci_old = isnull(context_info(), 0x)
					set @ci = convert(varbinary(128),'RETURN')
					set context_info @ci
					update dbo.PROPERTYVALUES set
						 PRV_VALUE = replace(ASP_VALUE, '++++', right('0000'+isnull(convert(varchar,STN_CODE),''),4))
						,PRV_TOSEND = 1
					from dbo.OBJ
					inner join dbo.ADDSTSPROPERTIES on ASP_STSID = OBJ_STSID
					inner join dbo.PROPERTIES on PRO_ROWID = ASP_PROID and PRO_CODE = 'SAPPM_LOCATION'
					inner join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID
					inner join dbo.STATION on STN_ROWID = OSA_STNID
					where OBJ_ROWID = @c_OBJID and PRV_PKID = OBJ_ROWID and PRV_PROID = PRO_ROWID and PRV_ENT = 'OBJ'
					set context_info @ci_old

					fetch next from C_OBJ33 into @c_OBJID
				end
				deallocate C_OBJ33
			end
		end

		if @c_DOCTYPE = 'OT31' and @c_STATCODE = 'KONIEC'
		begin
			select @v_OT_GUID = OT_ID from dbo.ZWFOT where OT_ROWID = @v_OT_ROWID
				
			declare C_OBJ31 cursor for select OBJID from dbo.GetBlockedObjOT(@v_OT_GUID)
			open C_OBJ31
			fetch next from C_OBJ31 into @c_OBJID
			while @@fetch_status = 0
			begin
				select top 1 
					@v_TO_KL5 = OT31LN_UZYTKOWNIK
				from dbo.SAPO_ZWFOT31LN 
				inner join dbo.ZWFOTLN on OTL_ROWID = OT31LN_ZMT_ROWID and OTL_NOTUSED = 0
				where OT31LN_OT31ID = @v_OT31ID

				delete from dbo.OBJSTATION where OSA_OBJID = @c_OBJID
					
				insert into dbo.OBJSTATION(OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)
				select @c_OBJID, STN_ROWID, STN_KL5ID, getdate(), 'OT31'
				from dbo.STATION
				inner join dbo.KLASYFIKATOR5 on KL5_ROWID = STN_KL5ID
				where KL5_CODE = @v_TO_KL5

				set @ci_old = isnull(context_info(), 0x)
				set @ci = convert(varbinary(128),'RETURN')
				set context_info @ci
				update dbo.PROPERTYVALUES set
					 PRV_VALUE = isnull(STN_LF, replace(ASP_VALUE, '++++', right('0000'+isnull(convert(varchar,STN_CODE),''),4)))
					,PRV_TOSEND = 1
				from dbo.OBJ
				inner join dbo.ADDSTSPROPERTIES on ASP_STSID = OBJ_STSID
				inner join dbo.PROPERTIES on PRO_ROWID = ASP_PROID and PRO_CODE = 'SAPPM_LOCATION'
				inner join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID
				inner join dbo.STATION on STN_ROWID = OSA_STNID
				where OBJ_ROWID = @c_OBJID and PRV_PKID = OBJ_ROWID and PRV_PROID = PRO_ROWID and PRV_ENT = 'OBJ'
				set context_info @ci_old

				fetch next from C_OBJ31 into @c_OBJID
			end
			deallocate C_OBJ33
		end

		
		--aktualizacja 	statusu
		if @v_OT_ROWID is not null and isnull(@v_STATUS_NEW,'') <> '' 
			exec [dbo].[ZWFOT_UpdateStatus] @p_OT_ROWID = @v_OT_ROWID, @p_STATUS_NEW = @v_STATUS_NEW, @p_UserID = 'SAP' --Procesowany Workflow - Wystawiający
		else
			insert into dbo.IE2_DocStatus_Log (DocStatus_ROWID, LogMessage) 
			select @c_ROWID,  N'Nie ma powiązań dla statusu: ' + isnull(@c_STATCODE,'')
	  
		if not exists (select 1 from dbo.ZWFOT_SAP_MESSAGES where OTM_STAID = @c_ROWID)
		begin
		
			insert into dbo.ZWFOT_SAP_MESSAGES (
				OTM_OTID, 
				OTM_OTXXID, 
				OTM_DATE, 
				OTM_OT_TYPE, 
				OTM_TYPE, 
				OTM_MESSAGE,
				OTM_STAID,
				OTM_USERID)
			select 
				OT_ROWID, 
				coalesce(OT11_ROWID, OT12_ROWID, OT21_ROWID, OT31_ROWID, OT32_ROWID, OT33_ROWID, @v_OT40ID, @v_OT41ID, @v_OT42ID),
				getdate(), 
				@c_DOCTYPE, 
				'S', 
				
				isnull((select top 1 
						cast(CONVERT(nvarchar(10),i_DateTime,121) as nvarchar(10)) + '. ' + 
						+ isnull(STAT_DESC+ '. ','') 
						+ isnull('Przekazał: ' +[FROM_USER],'') 
						+ isnull('Przekazał: ' +[CUR_USER],'') 
						+ isnull(' do: ' + [TO_USER], '')
						+ isnull(' do użytkownika (ów): ' + [TO_USER_1], '')	+ isnull('; ' + [TO_USER_2], '')+ isnull('; ' + [TO_USER_3], '')	+ isnull('; ' + [TO_USER_4], '') + isnull('; ' + [TO_USER_5], '')+ isnull('; ' + [TO_USER_6], '')	+ isnull('; ' + [TO_USER_7], '') + isnull('; ' + [TO_USER_8], '')+ isnull('; ' + [TO_USER_9], '')	+ isnull('; ' + [TO_USER_10], '')
						+ isnull('; ' + [TO_USER_11], '')	+ isnull('; ' + [TO_USER_12], '')+ isnull('; ' + [TO_USER_13], '')	+ isnull('; ' + [TO_USER_14], '') + isnull('; ' + [TO_USER_15], '')+ isnull('; ' + [TO_USER_16], '')	+ isnull('; ' + [TO_USER_17], '') + isnull('; ' + [TO_USER_18], '')+ isnull('; ' + [TO_USER_19], '')	+ isnull('; ' + [TO_USER_20], '')
						+ isnull('; ' + [TO_USER_21], '')	+ isnull('; ' + [TO_USER_22], '')+ isnull('; ' + [TO_USER_23], '')	+ isnull('; ' + [TO_USER_24], '') + isnull('; ' + [TO_USER_25], '')+ isnull('; ' + [TO_USER_26], '')	+ isnull('; ' + [TO_USER_27], '') + isnull('; ' + [TO_USER_28], '')+ isnull('; ' + [TO_USER_29], '')	+ isnull('; ' + [TO_USER_30], '')
						+ isnull('; ' + [TO_USER_31], '')	+ isnull('; ' + [TO_USER_32], '')+ isnull('; ' + [TO_USER_33], '')	+ isnull('; ' + [TO_USER_34], '') + isnull('; ' + [TO_USER_35], '')+ isnull('; ' + [TO_USER_36], '')	+ isnull('; ' + [TO_USER_37], '') + isnull('; ' + [TO_USER_38], '')+ isnull('; ' + [TO_USER_39], '')	+ isnull('; ' + [TO_USER_40], '')
						+ isnull('; ' + [TO_USER_41], '')	+ isnull('; ' + [TO_USER_42], '')+ isnull('; ' + [TO_USER_43], '')	+ isnull('; ' + [TO_USER_44], '') + isnull('; ' + [TO_USER_45], '')+ isnull('; ' + [TO_USER_46], '')	+ isnull('; ' + [TO_USER_47], '') + isnull('; ' + [TO_USER_48], '')+ isnull('; ' + [TO_USER_49], '')	+ isnull('; ' + [TO_USER_50], '')
						+ isnull(' do akceptacji: ' + [ACC_USER 1], '')	+ isnull('; ' + [ACC_USER 2], '')+ isnull('; ' + [ACC_USER 3], '')	+ isnull('; ' + [ACC_USER 4], '') + isnull('; ' + [ACC_USER 5], '')+ isnull('; ' + [ACC_USER 6], '')	+ isnull('; ' + [ACC_USER 7], '') + isnull('; ' + [ACC_USER 8], '')+ isnull('; ' + [ACC_USER 9], '')	+ isnull('; ' + [ACC_USER 10], '')
						+ isnull(' .Komentarz(e): ' + [COMM_1], '')	+ isnull('; ' + [COMM_2], '')+ isnull('; ' + [COMM_3], '')	+ isnull('; ' + [COMM_4], '') + isnull('; ' + [COMM_5], '')+ isnull('; ' + [COMM_6], '')	+ isnull('; ' + [COMM_7], '') + isnull('; ' + [COMM_8], '')+ isnull('; ' + [COMM_9], '')	+ isnull('; ' + [COMM_10], '')
						+ isnull('; ' + [COMM_11], '')	+ isnull('; ' + [COMM_12], '')+ isnull('; ' + [COMM_13], '')	+ isnull('; ' + [COMM_14], '') + isnull('; ' + [COMM_15], '')+ isnull('; ' + [COMM_16], '')	+ isnull('; ' + [COMM_17], '') + isnull('; ' + [COMM_18], '')+ isnull('; ' + [COMM_19], '')	+ isnull('; ' + [COMM_20], '')	+ isnull('; ' + [COMM_21], '')	+ isnull('; ' + [COMM_22], '')
						+ isnull('; ' + [MESS_1], '')
					from #t_status_message), N'Błąd integracji. Skontaktuj się z administratorem.'),
				@c_ROWID,
				'SAP'
 			from ZWFOT (nolock)
				 left join SAPO_ZWFOT11 (nolock) on OT11_ROWID = @v_OT11ID and @c_DOCTYPE = 'OT11' and OT11_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT12 (nolock) on OT12_ROWID = @v_OT12ID and @c_DOCTYPE = 'OT12' and OT12_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT21 (nolock) on OT21_ROWID = @v_OT21ID and @c_DOCTYPE = 'OT21' and OT21_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT31 (nolock) on OT31_ROWID = @v_OT31ID and @c_DOCTYPE = 'OT31' and OT31_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT32 (nolock) on OT32_ROWID = @v_OT32ID and @c_DOCTYPE = 'OT32' and OT32_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT33 (nolock) on OT33_ROWID = @v_OT33ID and @c_DOCTYPE = 'OT33' and OT33_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT42 (nolock) on OT42_ROWID = @v_OT42ID and @c_DOCTYPE = 'OT42' and OT42_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT40 (nolock) on OT40_ROWID = @v_OT40ID and @c_DOCTYPE = 'OT40' and OT40_ZMT_ROWID = @v_OT_ROWID
				 left join SAPO_ZWFOT41 (nolock) on OT41_ROWID = @v_OT41ID and @c_DOCTYPE = 'OT41' and OT41_ZMT_ROWID = @v_OT_ROWID
			where 
				coalesce(OT11_ROWID, OT12_ROWID, OT21_ROWID, OT31_ROWID, OT32_ROWID, OT33_ROWID, @v_OT40ID, @v_OT41ID, @v_OT42ID) is not null
				and (OT_ROWID = @v_OT_ROWID or OT_ID = @c_GUID)
			order by  coalesce(OT11_ROWID, OT12_ROWID, OT21_ROWID, OT31_ROWID, OT32_ROWID, OT33_ROWID, OT40_ROWID, OT41_ROWID, OT42_ROWID) desc
	  
		end
		
		drop table #t_status_message
	
		select @context_info = isnull(CONTEXT_INFO(),0x)
		select @context_info_SAPI_DocStatus_Insert_Proc = cast('SAPI_DocStatus_Insert_Proc' as varbinary(128))--0x291846

		
		set context_info @context_info_SAPI_DocStatus_Insert_Proc

		update [dbo].[IE2_DocStatus]  set [DOC_NEW_INSERTED] = 0 where ROWID = @c_ROWID
		
		set context_info @context_info

		fetch next from DocStatus_inserted
		into @c_ROWID, @c_GUID, @c_POZ, @c_DOCTYPE, @c_DOCKEY, @c_STATCODE, @c_COLS, @c_VALS
	end

	close DocStatus_inserted
	deallocate DocStatus_inserted

end
		 	--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem	
GO