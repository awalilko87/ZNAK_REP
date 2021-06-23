SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STENCIL_IMPORTp]
as
begin

	declare
		@c_LP float,
		@c_CODE nvarchar(255),
		@c_SETTYPE nvarchar(255),
		@c_PROPERTY nvarchar(255),
		@c_PROPERTY_SAMPLE nvarchar(255),
		@c_SIGNLOC nvarchar(255),
		@c_ONE nvarchar(255),
		@c_INVEST nvarchar(255),
		@c_CHANGEABLE nvarchar(255),

		@v_CODE_ACTUAL nvarchar(255),
		@c_SETTYPE_ACTUAL nvarchar(255),
		@c_ONE_ACTUAL nvarchar(255),
		@v_STSID int,
		@v_PROID int

	declare cur cursor static for
	select 
		STS_LP,
		STS_CODE,
		STS_SETTYPE,
		STS_PROPERTY,
		STS_PROPERTY_SAMPLE,
		STS_SIGNLOC,
		STS_ONE,
		STS_INVEST,
		STS_CHANGEABLE
	from 
		STENCIL_IMPORT

	open cur

	fetch next from cur
	into @c_LP, @c_CODE, @c_SETTYPE, @c_PROPERTY, @c_PROPERTY_SAMPLE, @c_SIGNLOC, @c_ONE, @c_INVEST, @c_CHANGEABLE

	while @@FETCH_STATUS = 0 
	begin

		--aKTUALIZACJA KODU
		--if @c_CODE is not null select @v_CODE_ACTUAL = @c_CODE
		--	update STENCIL_IMPORT set STS_CODE = @v_CODE_ACTUAL where STS_LP = @c_LP and STS_CODE is null
		--	--print isnull(@c_CODE,'nullek + ') + @v_CODE_ACTUAL

		--AKTUALIZACJA TYPÓW
		--if @c_SETTYPE is not null select @c_SETTYPE_ACTUAL = @c_SETTYPE
		--	update STENCIL_IMPORT set STS_SETTYPE = @c_SETTYPE_ACTUAL where STS_LP = @c_LP and STS_SETTYPE is null
 
		--AKTUALIZACJA jeden na sp
 		--if @c_ONE is not null select @c_ONE_ACTUAL = @c_ONE
			--update STENCIL_IMPORT set STS_ONE  = @c_ONE_ACTUAL where STS_LP = @c_LP and STS_ONE is null
 
		if not exists (select * from STENCIL (nolock) where STS_DESC = @c_CODE)
			insert into STENCIL (STS_CODE, STS_ORG, STS_DESC, STS_STATUS, STS_SETTYPE)
			select left(cast (newid() as nvarchar(50)),4), 'PKN', @c_CODE, 'STS_001', @c_SETTYPE

select @v_PROID = PRO_ROWID from PROPERTIES where PRO_TEXT = @c_PROPERTY
select @v_STSID = STS_ROWID from STENCIL where STS_DESC = @c_CODE

		if not exists (select * from ADDSTSPROPERTIES (nolock) where 
			ASP_PROID = (@v_PROID) and
			ASP_STSID = (@v_STSID))
			insert into  ADDSTSPROPERTIES (ASP_PROID, ASP_ENT, ASP_STSID, ASP_REQUIRED)
			select @v_PROID, 'OBJ', @v_STSID, 'NIE'

		fetch next from cur
		into @c_LP, @c_CODE, @c_SETTYPE, @c_PROPERTY, @c_PROPERTY_SAMPLE, @c_SIGNLOC, @c_ONE, @c_INVEST, @c_CHANGEABLE

	end

	close cur
	deallocate cur

end

--exec STENCIL_IMPORTp
--select * into STENCIL_IMPORT_ORG from STENCIL_IMPORT
GO