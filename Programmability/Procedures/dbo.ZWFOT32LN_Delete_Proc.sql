SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT32LN_Delete_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,

	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime 
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg BIT
	declare @v_Rstatus int
	declare @v_OT32ID int
	declare @v_OTID int
 
	-- czy klucze niepuste
	if @p_ROWID is null
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
	
	select @v_OTID = OT_ROWID from ZWFOT (nolock)
		join dbo.SAPO_ZWFOT32 (nolock) on OT32_ZMT_ROWID = OT_ROWID
			join dbo.SAPO_ZWFOT32LN (nolock) on OT32LN_OT32ID = OT32_ROWID
	where OT32LN_ROWID = @p_ROWID
	
	begin
	 

		BEGIN TRY
		 
			--nagłówek
			update 
				[dbo].[ZWFOTLN]
			set
				OTL_NOTUSED = 1
			where OTL_ROWID in 
				(
					select 
						OT32LN_ZMT_ROWID 
					from  
						[dbo].[SAPO_ZWFOT32LN] (nolock)
					where
						OT32LN_ROWID = @p_ROWID
				)
				
			--doniesienia przy założeniu że jest tylko jedna pozycja
			update 
				[dbo].[ZWFOTDON]
			set
				OTD_NOTUSED = 1
			where OTD_OTID = @v_OTID

			delete from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID	
						
			--aktualizacja nagłówka
			update [dbo].[ZWFOT]
			set
				OT_UPDUSER = @p_UserID,
				OT_UPDDATE = GETDATE()
			where OT_ROWID = @v_OTID
	
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad aktualizacji 
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