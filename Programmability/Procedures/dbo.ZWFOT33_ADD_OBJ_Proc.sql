SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT33_ADD_OBJ_Proc] 
(
 
	@p_FormID nvarchar(50), 
	@p_OT33ID int,
	@p_STNID nvarchar(30),  
	@p_STS nvarchar(30), 

	@p_UserID nvarchar(30) -- uzytkownik
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
	
	 
	--Sprawdza czy istnieje szablon 
	select @v_STSID = STS_ROWID from STENCIL (nolock) where STS_CODE = @p_STS
	if isnull(@v_STSID,0) = 0
	begin
		select @v_errorcode = 'STS_002'
		goto errorlabel
	end
		 
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	--+++++++++++++++++++++++++++++INSERT++++++++++++++++++++++++++++++++++++
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	if @v_STSID is not null and @p_STNID is not null
	begin
			 
			BEGIN TRY
	
				exec dbo.GenStsObj @v_STSID, NULL /*tu było psp*/, NULL, NULL, @p_STNID, @p_UserID, @v_OBJID_MAIN output

				update [dbo].[OBJ] set OBJ_OT33ID = @p_OT33ID where OBJ_PARENTID = @v_OBJID_MAIN
				
					 
			END TRY
			BEGIN CATCH
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'STS_010'
				goto errorlabel
			END CATCH;
		
	end
	  
	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext
		raiserror (@v_errortext, 16, 1) 
		--select @p_apperrortext = @v_errortext
		return 1
end 
GO