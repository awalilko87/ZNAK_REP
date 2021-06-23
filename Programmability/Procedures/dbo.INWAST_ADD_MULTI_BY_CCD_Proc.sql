SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_ADD_MULTI_BY_CCD_Proc](
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50), 
	@p_UserID nvarchar(30), 
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
	declare @v_MultiOrg bit
		, @v_SIN nvarchar(30)
		, @v_CCDID int
		, @v_STATUS nvarchar(30)
		, @v_SINID int
		, @v_KL5ID int
		
	declare @c_ASTID int
		,@c_OBJID int
		,@c_OBJ_BARCODE nvarchar(30)
		,@c_AST_BARCODE nvarchar(30)
		
	declare @t_assets table (ASTID int, [OBJID] int, OBJ_BARCODE nvarchar(30), AST_BARCODE nvarchar(30))

	select 
		@v_STATUS = SIN_STATUS, 
		@v_SIN = SIN_CODE, 
		@v_CCDID = SIN_CCDID,  
		@v_SINID = SIN_ROWID,
		@v_KL5ID = SIN_KL5ID
	from ST_INW where SIN_ID = @p_ID
	
	--select sin_rowid, SIN_STATUS from ST_INW where SIN_ID=  '6A1DFC4C-E542-422A-B25F-93D0B8EA0D78'

	if  @v_STATUS in ('SIN_001') --przekazanie do przygotowania spisu (aktualizuje tylko w I statusie)
	begin
	
		if (@v_KL5ID is not null)
		begin
			insert into @t_assets (ASTID, [OBJID], OBJ_BARCODE, AST_BARCODE) 
			/*select AST_ROWID, OBA_OBJID, OBJ_CODE, AST_CODE + '/' + cast(cast(AST_SUBCODE as int) as nvarchar(10)) 
			from dbo.ASSET (nolock) 
				left join (select OBA_ASTID, min(OBA_OBJID) OBA_OBJID from OBJASSET (nolock) group by OBA_ASTID) as OBJASSET_ONE on OBA_ASTID = AST_ROWID
				left join OBJ (nolock) on OBA_OBJID = OBJ_ROWID
					left join OBJSTATION (nolock) on OSA_OBJID = OBJ_ROWID
						left join STATION (nolock) on STN_ROWID = OSA_STNID and STN_KL5ID = @v_KL5ID
			where 
			--(AST_SUBCODE = '0000' or AST_SAP_ANLKL  in ('888-1***','486-***1'))
			AST_CCDID = @v_CCDID and
			AST_KL5ID = @v_KL5ID and
			isnull(OBJ_PARENTID,'') = ''*/
			select SIA_ASTID, SIA_OBJID, SIA_OBJCODE, SIA_ASTCODE + '/' + cast(cast(SIA_ASTSUBCODE as int) as nvarchar(10))
			from dbo.INWASTLN_ASTOBJ_LS_Get(@v_CCDID, @v_KL5ID, @p_UserID)
			where SIA_ASTDONIESIENIE = 0
			and exists (select 1 from AST_ANLKLX where SIA_ASTSAPANLKL between ANLKL_OD and ANLKL_DO and WYBOR = 1 and len(SIA_ASTSAPANLKL) = len(ANLKL_OD))
			and not exists (select 1 from AST_ANLKLX where SIA_ASTSAPANLKL between ANLKL_OD and ANLKL_DO and WYBOR = 0 and len(SIA_ASTSAPANLKL) = len(ANLKL_OD))
			--PKNTA-491
		end
		else
		begin
			raiserror('Brak KL5.', 16, 1)
			return 1
		end
		 
		--if @c_ASTID = 402850
		--raiserror ('aaaaa',16,1)
		--https://jira.eurotronic.net.pl/browse/PKNTA-327
		--Odrębnie na ASN są: ()
		--- kompletacja mebli 888-1***
		--- kompletacja urządzeń chłodniczych – 486-***1

		--Raportując te grupy muszą być oddzielnie, reszta razem do składnika głównego.
	
		------------------------------------------------------------------------------------------------------------		
		------------------------------czyszczenie inwentaryzacji (tylko z niezgodnym MPK----------------------------
		------------------------------------------------------------------------------------------------------------
		--OBIEKTY założone w ramach inwentaryzacji (połączenie z ASSETem SAPowym)
		delete from OBJASSET where OBA_OBJID in (
			select OBJ_ROWID from OBJ where OBJ_ANOID in (
				select ANO_ROWID from ASTINW_NEW_OBJ where ANO_SIAID in (
					select SIA_ROWID from AST_INWLN where SIA_SINID = @v_SINID and 
 					SIA_ASSETID not in (select ASTID from @t_assets))))
 		--OBIEKTY powiązanie ze stacjami
 		delete from OBJSTATION where OSA_OBJID in (
			select OBJ_ROWID from OBJ where OBJ_ANOID in (
				select ANO_ROWID from ASTINW_NEW_OBJ where ANO_SIAID in (
					select SIA_ROWID from AST_INWLN where SIA_SINID = @v_SINID and 
 					SIA_ASSETID not in (select ASTID from @t_assets))))
 	
 		--OBIEKTY już wpisane na protokoły oceny technicznej
 		delete from dbo.OBJTECHPROTLN where POL_OBJID in(
 			select OBJ_ROWID from OBJ where OBJ_ANOID in (
					select ANO_ROWID from ASTINW_NEW_OBJ where ANO_SIAID in (
						select SIA_ROWID from AST_INWLN where SIA_SINID = @v_SINID and 
 						SIA_ASSETID not in (select ASTID from @t_assets))))
 					
 		--OBIEKTY założone w ramach inwentaryzacji (Obiekt)		
		delete from OBJ where OBJ_ANOID in (
			select ANO_ROWID from ASTINW_NEW_OBJ where ANO_SIAID in (
				select SIA_ROWID from AST_INWLN where SIA_SINID = @v_SINID and 
 				SIA_ASSETID not in (select ASTID from @t_assets)))
	
		--NAGŁÓWKI dla nowych obiektów
		delete from ASTINW_NEW_OBJ where ANO_SIAID in (
			select SIA_ROWID from AST_INWLN where SIA_SINID = @v_SINID and 
 			SIA_ASSETID not in (select ASTID from @t_assets))
	
		--LINIE inwentaryzacji
		delete from AST_INWLN where SIA_SINID = @v_SINID and SIA_ASSETID not in (
			select ASTID from @t_assets)
		
	end 
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	
	declare c_CCD_ASSETS cursor for
	select ASTID, [OBJID], OBJ_BARCODE, AST_BARCODE from @t_assets
 
	open c_CCD_ASSETS 
	
	fetch next from c_CCD_ASSETS 
	into @c_ASTID, @c_OBJID, @c_OBJ_BARCODE, @c_AST_BARCODE
	
	while @@FETCH_STATUS = 0
	begin
		if not exists (select 1 from dbo.AST_INWLN (nolock) where SIA_SINID = @v_SINID and SIA_ASSETID = @c_ASTID and isnull(SIA_OBJID,0) = ISNULL(@c_OBJID,0) )
		begin 
		 
			begin try
				insert into dbo.AST_INWLN(
					SIA_SINID,
					SIA_ASSETID, 
					SIA_OBJID,
					SIA_BARCODE,
					SIA_OLDQTY,
					SIA_NEWQTY,
					SIA_COM01, 
					SIA_COM02,
					SIA_DTX01,
					SIA_DTX02, 
					SIA_DTX03, 
					SIA_DTX04, 
					SIA_DTX05, 
					SIA_NTX01, 
					SIA_NTX02, 
					SIA_NTX03, 
					SIA_NTX04, 
					SIA_NTX05,  
					SIA_CODE, 
					SIA_CREDATE, 
					SIA_CREUSER,  
					SIA_DATE, 
					SIA_DESC, 
					SIA_ID, 
					SIA_NOTE, 
					SIA_NOTUSED, 
					SIA_ORG, 
					SIA_RSTATUS, 
					SIA_STATUS,  
					SIA_TYPE,  
					SIA_TYPE2, 
					SIA_TYPE3, 
					SIA_TXT01,
					SIA_TXT02, 
					SIA_TXT03, 
					SIA_TXT04, 
					SIA_TXT05, 
					SIA_TXT06, 
					SIA_TXT07, 
					SIA_TXT08, 
					SIA_TXT09,
					SIA_PRICE)
				select
					@v_SINID, 
					@c_ASTID, 
					@c_OBJID,
					isnull(@c_OBJ_BARCODE, @c_AST_BARCODE),
					1,--OLDQTY
					NULL,--NEWQTY
					NULL,--@COM01, 
					NULL,--@COM02, 
					NULL,--@DTX01, 
					NULL,--@DTX02, 
					NULL,--@DTX03, 
					NULL,--@DTX04, 
					NULL,--@DTX05, 
					NULL,--@NTX01, 
					NULL,--@NTX02, 
					NULL,--@NTX03, 
					NULL,--@NTX04, 
					NULL,--@NTX05,  
					@v_SIN, 
					GETDATE(), 
					@p_UserID,  
					NULL,--@SIA_DATE
					NULL,--@SIA_DESC, 
					newid(),--@SIA_ID, 
					NULL,--@SIA_NOTE, 
					0,--@SIA_NOTUSED, 
					'PKN',--@SIA_ORG, 
					0,--@SIA_RSTATUS, 
					'NINW',--@SIA_STATUS,
					NULL,--@SIA_TYPE,  
					NULL,--@SIA_TYPE2, 
					NULL,--@SIA_TYPE3, 
					NULL,--@TXT01, 
					NULL,--@TXT02, 
					NULL,--@TXT03, 
					NULL,--@TXT04, 
					NULL,--@TXT05, 
					NULL,--@TXT06, 
					NULL,--@TXT07, 
					NULL,--@TXT08, 
					NULL,--@TXT09,
					0 
				
			end try
			begin catch
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'ERR_INS'
				goto errorlabel
			end catch
		end 
		else 
		begin 
		
			begin try
				update dbo.AST_INWLN set					
					SIA_BARCODE = isnull(@c_OBJ_BARCODE, @c_AST_BARCODE),
					SIA_UPDDATE = GETDATE(), 
					SIA_UPDUSER = @p_UserID, 
					SIA_NOTUSED = 0, 
					SIA_RSTATUS = 0, 
					SIA_STATUS = 'NINW',
					SIA_OBJID = @c_OBJID
				where 
					SIA_SINID = @v_SINID 
					and SIA_ASSETID = @c_ASTID
					and isnull(SIA_OBJID,0) = ISNULL(@c_OBJID,0)
			end try
			begin catch
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'ERR_UPD'
				goto errorlabel
			end catch
		end 

		fetch next from c_CCD_ASSETS 
		into @c_ASTID, @c_OBJID, @c_OBJ_BARCODE, @c_AST_BARCODE
		
	end
	 
	close c_CCD_ASSETS 
	deallocate c_CCD_ASSETS 
	
	return 0
	
errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	select @p_apperrortext = @v_errortext
	return 1
end



--declare @p_apperrortext nvarchar(max)

--	exec [dbo].[INWAST_ADD_MULTI_BY_CCD_Proc]
--		'INWAST_RC',
--		'4F94A3BE-71BF-4119-B785-F832FFFC44DE', 
--		'SA', 
--		@p_apperrortext output
GO