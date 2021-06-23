SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STENCILLN_IMPORTp]
as
begin

	declare
		@c_LP float,
		@c_CODE nvarchar(255),
		@c_PARENT nvarchar(255),
		@c_PROPERTY nvarchar(255), 
		@c_SIGNLOC nvarchar(255),
		@c_ONE nvarchar(255),
		@c_INVEST nvarchar(255),
		@c_CHANGEABLE nvarchar(255),

		@v_CODE_ACTUAL nvarchar(255),
		@c_PARENT_ACTUAL nvarchar(255),
		@c_ONE_ACTUAL nvarchar(255),
		@v_STSID int,
		@v_PROID int

	declare cur cursor static for
	select 
		STS_LP,
		STS_CODE,
		STL_CODE,
		STS_PROPERTY, 
		STS_SIGNLOC,
		STS_ONE,
		STS_INVEST,
		'NIE'
	from 
		STENCILLN_IMPORT

	open cur

	fetch next from cur
	into @c_LP, @c_PARENT, @c_CODE, @c_PROPERTY, @c_SIGNLOC, @c_ONE, @c_INVEST, @c_CHANGEABLE

	while @@FETCH_STATUS = 0 
	begin

		--aKTUALIZACJA KODU
		--if @c_CODE is not null select @v_CODE_ACTUAL = @c_CODE
		--	update STENCILLN_IMPORT set STS_CODE = @v_CODE_ACTUAL where STS_LP = @c_LP and STS_CODE is null
		--	--print isnull(@c_CODE,'nullek + ') + @v_CODE_ACTUAL

		--AKTUALIZACJA TYPÓW
		--if @c_PARENT is not null select @c_PARENT_ACTUAL = @c_PARENT
		--	update STENCILLN_IMPORT set STL_CODE = @c_PARENT_ACTUAL where STS_LP = @c_LP and STL_CODE is null
 
		--AKTUALIZACJA jeden na sp
 		--if @c_ONE is not null select @c_ONE_ACTUAL = @c_ONE
			--update STENCILLN_IMPORT set STS_ONE  = @c_ONE_ACTUAL where STS_LP = @c_LP and STS_ONE is null
 
		--elementy zestawów / kompletów
		--if not exists (select * from STENCIL (nolock) where STS_DESC = @c_CODE)
		--	insert into STENCIL (STS_CODE, STS_ORG, STS_DESC, STS_STATUS, STS_SETTYPE)
		--	select left(cast (newid() as nvarchar(50)),4), 'PKN', @c_CODE, 'STS_001', 'EZES'

		--insert into STENCILLN (STL_PARENTID, STL_CHILDID, STL_ORG, STL_REQUIRED, STL_ONE)
		--select PARENT.STS_ROWID, CHILD.STS_ROWID, PARENT.STS_ORG, 'NIE', @c_ONE from STENCIL PARENT (nolock) 
		--	cross join STENCIL CHILD (nolock) 
		--where PARENT.STS_DESC = @c_PARENT and CHILD.STS_DESC = @c_CODE
			 
--select @v_PROID = PRO_ROWID from PROPERTIES where PRO_TEXT = @c_PROPERTY
--select @v_STSID = STS_ROWID from STENCIL where STS_DESC = @c_CODE

--		if not exists (select * from ADDSTSPROPERTIES (nolock) where 
--			ASP_PROID = (@v_PROID) and
--			ASP_STSID = (@v_STSID))
--			insert into  ADDSTSPROPERTIES (ASP_PROID, ASP_ENT, ASP_STSID, ASP_REQUIRED)
--			select @v_PROID, 'OBJ', @v_STSID, 'NIE'

		fetch next from cur
		into @c_LP, @c_PARENT,@c_CODE , @c_PROPERTY, @c_SIGNLOC, @c_ONE, @c_INVEST, @c_CHANGEABLE

	end

	close cur
	deallocate cur

end

--exec STENCILLN_IMPORTp
--select * into STENCILLN_IMPORT_ORG from STENCILLN_IMPORT
--select * from STENCILLN_IMPORT
GO