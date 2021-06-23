SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[GOLDENBOX_Update_Proc] 
(
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_ROWID int,
	@p_CODE nvarchar(30),
	@p_DESC nvarchar(80),
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_STREET nvarchar(100),
	@p_CITY nvarchar(100),
	@p_VOIVODESHIP nvarchar(10),
	@p_CCD nvarchar(30),  
	@p_KL5 nvarchar(30),  
	@p_NOTUSED int, 
	@p_ORG nvarchar(30),
	@p_LF nvarchar(30),
 
 	--- tutaj ewentualnie swoje parametry/zmienne/dane
	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime
	declare @v_Rstatus int
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg BIT
	declare 
		@v_CODE nvarchar(30),
		@v_CCDID int,
		@v_KL5ID int,
		@v_PARENTID int
 
	select @v_CODE = @p_CODE
	-- dlaczego tak było? Przy update podmieniał nr stacji na KL5
	--cast(@p_KL5 as nvarchar(30)) 
	select @v_date = getdate()
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS

	select @v_CCDID = CCD_ROWID from COSTCODE (nolock) where CCD_CODE = @p_CCD
 	select @v_KL5ID = KL5_ROWID from KLASYFIKATOR5 (nolock) where KL5_CODE = @p_KL5
 
	if @p_TYPE = 'STACJA' or @p_TYPE = 'SERWIS'
		 select @v_PARENTID = NULL
	else
	begin
		select top 1 @v_PARENTID = STN_ROWID from dbo.STATION (nolock) where STN_CCDID =  @v_CCDID order by STN_ROWID asc
		
		if @v_PARENTID is null
		begin
			select @v_errorcode = 'STN_001'--STN_001 - Nie można wskazać użytkownika zastępcznego dla stacji która nie istnieje w ZMT.
			goto errorlabel
		end
	end																		    

	if @p_DESC is NULL 
		select @p_DESC = 'SP' + cast (@p_CODE as nvarchar(5)) + ' ' + @p_CITY
		--select @p_DESC = 'SP ' + cast (@p_NUMBER as nvarchar(5)) + ' ul. ' + @p_STREET + ', ' + @p_CITY

	-- czy klucze niepuste
	if @p_ID is null or @v_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end

	--set @v_date = getdate()
  	
	--begin try
	--	set @p_TIME = replace(@p_TIME,'_','0')
	--	set @p_DATE = @p_DATE+@p_TIME
	--end try
	--begin catch
	--select @v_errorcode = 'SYS_006'
	--goto errorlabel
	--end CATCH

	set @p_CODE = nullif(@p_CODE,0)
   
	--insert 
	if not exists (select * from dbo.STATION (nolock) where STN_ID = @p_ID)
	begin

		--numeracja
		--declare @v_Number nvarchar(50), @v_No int
		--exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output
		--select @v_Number, @v_No

		BEGIN TRY
			insert into dbo.STATION
			( 
				STN_CODE,
				STN_ORG,
				STN_STATUS,
				STN_TYPE,
				STN_STREET,
				STN_CITY,
				STN_VOIVODESHIP,
				STN_CCDID,
				STN_KL5ID,
				STN_PARENTID,
				STN_DESC  ,
				STN_NOTUSED, 
				STN_CREDATE,
				STN_CREUSER,
				STN_ID,
				STN_LF
			)
			values 
			(
				@v_CODE,
				@p_ORG,
				@p_STATUS,
				@p_TYPE,
				@p_STREET,
				@p_CITY,
				@p_VOIVODESHIP,
				@v_CCDID,
				@v_KL5ID,
				@v_PARENTID,
				@p_DESC,
				@p_NOTUSED,
				@v_date,
				@p_UserID, 
				@p_ID,
				@p_LF
			)
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
	end
	else
	begin

		if not exists(select * from dbo.STATION (nolock) where STN_ID = @p_ID and ISNULL(STN_STATUS,0) = ISNULL(@p_STATUS_old,0))
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
			goto errorlabel
		end   

		if exists(select * from dbo.STATION (nolock) where STN_ID = @p_ID AND STN_CODE <> @p_CODE)
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
			goto errorlabel
		end   

		BEGIN TRY
			UPDATE [dbo].[STATION] SET
 				STN_CODE = @v_CODE,
				STN_ORG = @p_ORG,
				STN_STATUS = @p_STATUS,
				STN_TYPE = @p_TYPE,
				STN_STREET = @p_STREET,
				STN_CITY = @p_CITY,
				STN_VOIVODESHIP = @p_VOIVODESHIP,
				STN_CCDID = @v_CCDID,
				STN_KL5ID = @v_KL5ID,
				STN_PARENTID = @v_PARENTID,
				STN_DESC = @p_DESC,
				STN_NOTUSED = @p_NOTUSED, 
				STN_UPDDATE = @v_date,
				STN_UPDUSER = @p_UserID,
				STN_LF = @p_LF
 			where STN_ID = @p_ID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OBG_002' -- blad aktualizacji zgloszenia
			goto errorlabel
		END CATCH;
	end

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
end
GO