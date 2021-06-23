SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_LINES_Proc]
(
 
	@p_FormID nvarchar(50),
	@p_INOID int,
	@p_OBJ_COUNT int = 0,
	@p_OBJ_PSP nvarchar(30),  
	@p_STS_CHILD nvarchar(30),  
	@p_STS_PARENT nvarchar(30), 
	@p_VALUE numeric(18, 2),

	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime
	declare 
		  @v_STNID int = 0
		, @v_OBJID_MAIN int = 0
		, @v_OBJID_CHILD int = 0
		, @v_OBJID_CHILD_COUNT int = 0
		, @v_OBJ_PSPID int
		, @v_STS_CHILDID int
		, @v_STS_PARENTID int
		, @v_STS_BLANK smallint
		, @v_ADD_PARAMS xml	

	set @v_date = getdate()

	--raiserror('ilosc %i',16,1,@p_OBJ_COUNT)
	--return 1
 
	--Sprawdza czy istnieje element PSP
	select @v_OBJ_PSPID = PSP_ROWID from [dbo].[PSP] (nolock) where PSP_CODE = @p_OBJ_PSP
	if isnull(@v_OBJ_PSPID,0) = 0
	begin
		select @v_errorcode = 'PSP_001'
		goto errorlabel
	end	

	--Sprawdza czy istnieje szablon nadrzędny
	select @v_STS_PARENTID = STS_ROWID from [dbo].[STENCIL] (nolock) where STS_CODE = @p_STS_PARENT
	if isnull(@v_STS_PARENTID,0) = 0
	begin
		select @v_errorcode = 'STS_002'
		goto errorlabel
	end	

	--Sprawdza czy istnieje szablon podrzędny
	select @v_STS_CHILDID = STS_ROWID from [dbo].[STENCIL] (nolock) where STS_CODE = @p_STS_CHILD
	if isnull(@v_STS_CHILDID,0) = 0 and @p_STS_CHILD <> 'BRAK'
	begin
		select @v_errorcode = 'STS_003'
		goto errorlabel
	end	
	
	--numer miejsca / stacji docelowej (dla OBJSTATION)
	select @v_STNID = INO_STNID from [dbo].[INVTSK_NEW_OBJ] where INO_ROWID = @p_INOID
	if isnull(@v_STNID,0) = 0
	begin
		select @v_errorcode = 'STS_004'
		goto errorlabel
	end	

	--Ten element nie będzie wprowadzany (na liście wpisano 0)
	if isnull(@p_OBJ_COUNT,0) = 0
		return 0

	--dodaje element nadrzędny
	if @v_STS_PARENTID is not null
	begin
		--sprawdza czy istnieje zestaw/komplet nadrzędny
		select 
			@v_OBJID_MAIN = OBJ_ROWID,
			@v_STS_BLANK = @v_STS_BLANK
		from OBJ (nolock)
			join STENCIL (nolock) on STS_ROWID = OBJ_STSID 
			join SETTYPE (nolock) on STT_CODE = STS_SETTYPE
		where 
			OBJ_PSPID = @v_OBJ_PSPID 
			and OBJ_INOID = @p_INOID
			and OBJ_STSID = @v_STS_PARENTID 
			and STT_MAIN = 1 
 
		--jeśli nie ma zestawu (@v_OBJID_MAIN = 0), wprowadza zestaw (nie obowiązuje dla szablonów technicznych (zakładają PINPADy bez zestawu))
		if isnull(@v_OBJID_MAIN,0) = 0 and isnull(@v_STS_BLANK ,0) = 0
		begin		 
	
			BEGIN TRY
				set @v_ADD_PARAMS = (
						SELECT 
								@p_INOID as ADP_INOID
						FOR XML PATH('Params')
						)
	
				exec dbo.GenStsObj 
					 @p_STSID = @v_STS_PARENTID
					,@p_PSPID = @v_OBJ_PSPID
					,@p_ANOID = NULL
					,@p_PARENTID = NULL
					,@p_STNID = @v_STNID
					,@p_UserID = @p_UserID
					,@p_OBJID = @v_OBJID_MAIN output
					,@p_ADD_PARAMS = @v_ADD_PARAMS
					,@p_apperrortext = @p_apperrortext output


			END TRY
			BEGIN CATCH
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'STS_010' -- blad kasowania
				goto errorlabel
			END CATCH;
		end
 		  		
	end

	--dodaje elementy podrzędne
	if @v_STS_CHILDID is not null
	begin		
	 
		--zlicza ile obecnie jest podskładników w zestawie/komplecie		
		select 
			@v_OBJID_CHILD_COUNT = count (*)
		from dbo.OBJ (nolock)
			join dbo.STENCIL (nolock) on STS_ROWID = OBJ_STSID  
		where 
			OBJ_PSPID = @v_OBJ_PSPID 
			and OBJ_INOID = @p_INOID
			and OBJ_STSID = @v_STS_CHILDID  
			and isnull(OBJ_VALUE,0) = isnull(@p_VALUE,0)
 
		--dodaje obiekty do ilości podanej na formularzu
		while @v_OBJID_CHILD_COUNT < @p_OBJ_COUNT
		begin

			BEGIN TRY
			   set @v_ADD_PARAMS = (
									SELECT 
										 @p_VALUE as ADP_VALUE
										,@p_INOID as ADP_INOID
									FOR XML PATH('Params')
									)	
				
				exec dbo.GenStsObj 
					 @p_STSID = @v_STS_CHILDID
					,@p_PSPID = @v_OBJ_PSPID
					,@p_ANOID = NULL
					,@p_PARENTID = @v_OBJID_MAIN
					,@p_STNID = @v_STNID
					,@p_UserID = @p_UserID
					,@p_OBJID = @v_OBJID_CHILD output
					,@p_ADD_PARAMS = @v_ADD_PARAMS
					,@p_apperrortext = @p_apperrortext output
				
				--zlicza ile obecnie jest podskładników w zestawie/komplecie		
				select 
					@v_OBJID_CHILD_COUNT = @v_OBJID_CHILD_COUNT + 1
			 
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