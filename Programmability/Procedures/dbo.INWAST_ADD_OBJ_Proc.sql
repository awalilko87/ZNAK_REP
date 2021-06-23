SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_ADD_OBJ_Proc] 
(
 	@p_FormID nvarchar(50), 
	@p_ANOID int,
	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime
	declare @v_OBJID_MAIN int = 0 
		--, @v_OBJ_PSPID int  
		, @v_STSID int
		, @v_STNID int
		, @v_ASTID int
		, @v_STS_BLANK smallint
	
	set @v_date = getdate()
 
	--numer miejsca / stacji docelowej (dla OBJSTATION)
	select 
		@v_STNID = ANO_STNID,
		@v_ASTID = ANO_ASTID,
		@v_STSID = ANO_STSID
	from [dbo].[ASTINW_NEW_OBJ] (nolock) 
	where ANO_ROWID = @p_ANOID
	
	if isnull(@v_STNID,0) = 0
	begin
 		select @v_errorcode = 'STS_004'
		goto errorlabel
	end	
	 
	--Sprawdza czy istnieje szablon 
	if isnull(@v_STSID,0) = 0
	begin
		select @v_errorcode = 'STS_002'
		goto errorlabel
	end	

	--dodaje element
	if @v_STSID is not null
	begin
		 
		--sprawdza czy istnieje zestaw/komplet/element nadrzędny (tylko jeden dla wpisu [INVTSK_NEW_OBJ] i wystawiana transakcja OT11 
		select 
			@v_OBJID_MAIN = OBJ_ROWID,
			@v_STS_BLANK = STS_BLANK
		from OBJ (nolock)
			join STENCIL (nolock) on STS_ROWID = OBJ_STSID 
			join SETTYPE (nolock) on STT_CODE = STS_SETTYPE
		where 
			OBJ_ANOID = @p_ANOID
			and OBJ_STSID = @v_STSID 
			--and STT_MAIN = 1 --wtedy nie może być modernizacji (tylko jeden dla wpisu [INVTSK_NEW_OBJ] i wystawiana transakcja OT11 
			
		--jeśli nie ma składnika (OBJID_MAIN = 0), wprowadza zestaw/skłądnik (nie obowiązuje dla szablonów technicznych)
		if isnull(@v_OBJID_MAIN,0) = 0 and isnull(@v_STS_BLANK ,0) = 0
		begin		 
	
			BEGIN TRY
	
				exec dbo.GenStsObj @v_STSID, NULL, @p_ANOID, NULL, @v_STNID, @p_UserID, @v_OBJID_MAIN output, @p_apperrortext output

				if not exists (select * from dbo.OBJASSET where OBA_OBJID = @v_OBJID_MAIN)
					insert into dbo.OBJASSET(OBA_OBJID, OBA_ASTID) select @v_OBJID_MAIN, @v_ASTID 
				else
					update dbo.OBJASSET set OBA_ASTID = @v_ASTID where OBA_OBJID = @v_OBJID_MAIN
					
			END TRY
			BEGIN CATCH
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'STS_010' -- blad kasowania
				goto errorlabel
			END CATCH;
		end
	end
	  
	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
end 
GO