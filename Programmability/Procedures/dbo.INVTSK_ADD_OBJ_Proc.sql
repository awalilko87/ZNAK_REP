SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_ADD_OBJ_Proc] 
(
 
	@p_FormID nvarchar(50), 
	@p_INOID int,
	@p_OBJ_PSP nvarchar(30),   
	@p_STS nvarchar(30), 

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
		, @v_OBJ_PSPID int  
		, @v_STSID int
		, @v_STNID int
		, @v_STS_BLANK smallint
		, @v_QTY int
		, @v_OBJ_COUNT int
		, @v_MAXIMUM_QTY int
		, @v_ADD_PARAMS xml
	--maksymalnie można wystawić 100 urządzeń (wszystko co ponad to będzie prawdopodobnie błędem)
	select @v_MAXIMUM_QTY = 100
	set @v_date = getdate()

	--Sprawdza czy istnieje element PSP
	select @v_OBJ_PSPID = PSP_ROWID from PSP (nolock) where PSP_CODE = @p_OBJ_PSP
	if isnull(@v_OBJ_PSPID,0) = 0
	begin
		select @v_errorcode = 'PSP_001'
		goto errorlabel
	end	
	 
	--Sprawdza czy istnieje szablon 
	select @v_STSID = STS_ROWID from STENCIL (nolock) where STS_CODE = @p_STS
	if isnull(@v_STSID,0) = 0
	begin
		select @v_errorcode = 'STS_002'
		goto errorlabel
	end	
 
	--numer miejsca / stacji docelowej (dla OBJSTATION)
	select @v_STNID = INO_STNID, @v_QTY = INO_QTY from [dbo].[INVTSK_NEW_OBJ] (nolock) where INO_ROWID = @p_INOID
	if isnull(@v_STNID,0) = 0 and ISNULL(@v_QTY,0) = 0
	begin
 		select @v_errorcode = 'STS_004'
		goto errorlabel
	end	
	
	select @v_OBJ_COUNT = count(*) from OBJ (nolock) where OBJ_INOID = @p_INOID
		 
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	--+++++++++++++++++++++++++++++INSERT++++++++++++++++++++++++++++++++++++
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	while @v_STSID is not null and @v_OBJ_COUNT < isnull(@v_QTY,1) and @v_MAXIMUM_QTY > 0
	begin
			 
 
			BEGIN TRY

				set @v_ADD_PARAMS = (
									SELECT 
										@p_INOID as ADP_INOID
									FOR XML PATH('Params')
									)
	
				exec dbo.GenStsObj 
					 @p_STSID = @v_STSID
					,@p_PSPID = @v_OBJ_PSPID
					,@p_ANOID = NULL
					,@p_PARENTID = NULL
					,@p_STNID = @v_STNID
					,@p_UserID = @p_UserID
					,@p_OBJID = @v_OBJID_MAIN output
					,@p_ADD_PARAMS = @v_ADD_PARAMS
					,@p_apperrortext = @p_apperrortext output
	
				--exec dbo.GenStsObj @v_STSID, @v_OBJ_PSPID, NULL, NULL, @v_STNID, @p_UserID, @v_OBJID_MAIN output, @p_apperrortext output

				--update [dbo].[OBJ] set OBJ_INOID = @p_INOID where  OBJ_PARENTID = @v_OBJID_MAIN
				
					 
			END TRY
			BEGIN CATCH
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'STS_010' -- blad kasowania
				goto errorlabel
			END CATCH;

		select @v_MAXIMUM_QTY = @v_MAXIMUM_QTY - 1
		select @v_OBJ_COUNT = count(*) from OBJ (nolock) where OBJ_INOID = @p_INOID
		
	end
	  
	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
end 


--select * from VS_LangMsgs where ObjectID = 'STS_010'
GO