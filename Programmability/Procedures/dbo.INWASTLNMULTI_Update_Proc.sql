SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWASTLNMULTI_Update_Proc] 
(
	@p_FormID nvarchar(50),
	@p_SINID int, 
	@p_ASTID int,   
	@p_UserID nvarchar(30) , -- uzytkownik,
	@p_ORG nvarchar(50)
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime

	declare @v_CODE nvarchar(30)
   
	if @p_SINID is null
	begin
		select @v_errorcode = 'INT_201' -- blad aktualizacji zgloszenia
		goto errorlabel
	end;
   
	select top 1 @v_CODE = SIN_CODE/*, @v_MAG = SIN_MAG */from ST_INW (nolock) where SIN_ROWID = @p_SINID  

	if @v_CODE is null
		
	set @v_CODE = '1'

	BEGIN TRY

		IF not exists ( select 1 from AST_INWLN (nolock) where [SIA_SINID] = @p_SINID and [SIA_ASSETID] = @p_ASTID)
		BEGIN 

			INSERT INTO [dbo].[AST_INWLN]
			(
				[SIA_SINID]
				,[SIA_CODE]
				,[SIA_BARCODE]
				,[SIA_ORG]
				,[SIA_DESC]
				,[SIA_NOTE]
				,[SIA_DATE]
				,[SIA_STATUS]
				,[SIA_TYPE]
				,[SIA_TYPE2]
				,[SIA_TYPE3]
				,[SIA_RSTATUS]
				,[SIA_CREUSER]
				,[SIA_CREDATE]
				,[SIA_UPDUSER]
				,[SIA_UPDDATE]
				,[SIA_NOTUSED]
				,[SIA_ID]
				,[SIA_ASSETID]
				,[SIA_OLDQTY]
				,[SIA_NEWQTY]
				,[SIA_PRICE]
			)

			select

				@p_SINID
				,@v_CODE
				,AST_BARCODE
				,@p_ORG
				,''
				,'' 
				,getdate()
				,'NINW'
				,'INW'
				,NULL
				,NULL
				,0
				,@p_UserID
				,getdate()
				,NULL
				,NULL
				,0
				,newid()
				,@p_ASTID
				,1
				,null
				,AST_BUYVALUE
			 from ASSET (nolock) where AST_ROWID = @p_ASTID

			update [dbo].[ST_INW]
			set SIN_BTN_ENABLE = 1
			where SIN_ROWID = @p_SINID
			 
		END
		ELSE
		BEGIN

			UPDATE [dbo].[AST_INWLN] SET

				[SIA_SINID] = @p_SINID
				,[SIA_CODE] = @v_CODE
				,[SIA_BARCODE] = (select AST_BARCODE from ASSET (nolock) where AST_ROWID = @p_ASTID)
				,[SIA_ORG] = @p_ORG
				,[SIA_DESC] = ''
				,[SIA_NOTE] = ''
				,[SIA_DATE] = getdate()
				,[SIA_STATUS] = 'NINW'
				,[SIA_TYPE] = 'INW'
				,[SIA_TYPE2] = NULL
				,[SIA_TYPE3] = NULL
				,[SIA_RSTATUS] = 0
				,[SIA_CREUSER] = @p_UserID
				,[SIA_CREDATE] = getdate()
				,[SIA_UPDUSER] = NULL
				,[SIA_UPDDATE] = NULL
				,[SIA_NOTUSED] = 0
				,[SIA_ID] = newid()
				,[SIA_ASSETID] = @p_ASTID
				,[SIA_OLDQTY] = 1
				,[SIA_NEWQTY] = NULL
				,[SIA_PRICE] = (select AST_BUYVALUE from ASSET (nolock) where AST_ROWID = @p_ASTID)


			WHERE [SIA_SINID] = @p_SINID and [SIA_ASSETID] = @p_ASTID 
		END

	END TRY

	BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'TSKOBJMULTI_001' -- blad aktualizacji zgloszenia
		goto errorlabel
	END CATCH;

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		return 1
end   
GO