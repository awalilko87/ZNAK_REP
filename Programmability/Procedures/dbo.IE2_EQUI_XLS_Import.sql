SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure  [dbo].[IE2_EQUI_XLS_Import]
 
as
begin
	declare @v_OBJID_MAIN int
	declare @v_KL5ID int
	declare @p_apperrortext nvarchar(max)

	declare @c_EQUNR nvarchar(30)
	declare @c_ASTID int
	declare @c_STSID int
	declare @c_STNID int

	declare c_cursor cursor static for
	select distinct cast(cast(EQUNR as int) as nvarchar),
	AST_ROWID, STS_ROWID, STN_ROWID from [dbo].[IE2_EQUI_XLS5]
 
		join stencil on sts_desc = eqktu
		join costcode on ccd_code =     cast(cast(KOSTL  as int) as nvarchar(100))
		join STATION on stn_CCDID = CCD_ROWID 
		join ASSET on AST_CODE = ANLNR and AST_SUBCODE = ANLUN

 
	open c_cursor

	fetch next from c_cursor 
	into @c_EQUNR, @c_ASTID, @c_STSID, @c_STNID


	while @@fetch_status = 0
	begin
		--print @c_STS
		--print @c_LP

		--select @v_STSID = STS_ROWID from STENCIL where STS_CODE = @c_STS
		--select @V_ASTID = AST_ROWID from ASSET
		select @v_KL5ID = STN_KL5ID from STATION (nolock) where  STN_ROWID = @c_STNID

		--print @v_STSID
		--print '' 

					--exec dbo.GenStsObj @v_STSID, @v_OBJ_PSPID, NULL, NULL, @v_STNID, @p_UserID, @v_OBJID_MAIN output, @p_apperrortext output
					exec dbo.GenStsObj @c_STSID, NULL, NULL, NULL, @c_STNID, 'SA', @v_OBJID_MAIN output, @p_apperrortext output
				 
					update [IE2_EQUI_XLS5] set OBJID = @v_OBJID_MAIN where EQUNR = @c_EQUNR
					
					update OBJ set OBJ_PM = @c_EQUNR where OBJ_ROWID = @v_OBJID_MAIN
					insert into OBJASSET(OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)
					select @v_OBJID_MAIN, @c_ASTID, getdate(), 'SA'
					
					if not exists ( select * from OBJSTATION (nolock) where OSA_OBJID = @v_OBJID_MAIN and OSA_STNID = @c_STNID and OSA_KL5ID = @v_KL5ID)

						insert into OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)
						select @v_OBJID_MAIN, @c_STNID, @v_KL5ID, getdate(), 'SA'


		--dane proceudry
		--@p_STSID int,
		--@p_PSPID int,
		--@p_ANOID int,
		--@p_PARENTID int,
		--@p_STNID int,	
		--@p_UserID nvarchar(30), -- uzytkownik

		fetch next from c_cursor
		into @c_EQUNR, @c_ASTID, @c_STSID, @c_STNID

	end

	close c_cursor
	deallocate c_cursor

 end
GO