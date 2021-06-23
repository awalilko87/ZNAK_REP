SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[IE2_PM_DICTIONARY_Insert_Proc]
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_PROID int

	declare @c_DICID bigint
	declare @c_CODE nvarchar(30)
	declare @c_DESC nvarchar(80)

	-- EQUI-RBNR
	declare C_RBNR cursor for select ROWID, RBNR, RBNRX from dbo.IE2_EQUI__RBNR where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_RBNR
	fetch next from C_RBNR into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'EQUI' and PRO_PM_CECHA = 'RBNR'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_EQUI__RBNR set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_RBNR into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_RBNR

	-- ITOB-EQTYP
	declare C_EQTYP cursor for select ROWID, EQTYP, TYPTX from dbo.IE2_ITOB__EQTYP where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'ITOB' and PRO_PM_CECHA = 'EQTYP'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_ITOB__EQTYP set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_INT_KOMUNIKACYJ/RODZAJ_INTERFEJSU
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_INT_KOMUNIKACYJ__RODZAJ_INTERFEJSU where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_INT_KOMUNIKACYJ' and PRO_PM_CECHA = 'RODZAJ_INTERFEJSU'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_INT_KOMUNIKACYJ__RODZAJ_INTERFEJSU set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_PRZEPLYW/RODZAJ_PALIWA
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_PRZEPLYW__RODZAJ_PALIWA where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_PRZEPLYW' and PRO_PM_CECHA = 'RODZAJ_PALIWA'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_PRZEPLYW__RODZAJ_PALIWA set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_ZB_KOM/RODZAJ_PALIWA
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_ZB_KOM__RODZAJ_PALIWA where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_ZB_KOM' and PRO_PM_CECHA = 'RODZAJ_PALIWA'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_ZB_KOM__RODZAJ_PALIWA set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_ZBIORNIK/RODZAJ_ZB
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_ZBIORNIK__RODZAJ_ZB where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_ZBIORNIK' and PRO_PM_CECHA = 'RODZAJ_ZB'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_ZBIORNIK__RODZAJ_ZB set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_ZBIORNIK_LF/OCHRONA_KATODOWA
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_ZBIORNIK_LF__OCHRONA_KATODOWA where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_ZBIORNIK_LF' and PRO_PM_CECHA = 'OCHRONA_KATODOWA'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_ZBIORNIK_LF__OCHRONA_KATODOWA set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

	-- S_ZBIORNIK_LF/RODZAJ_ZB_POSADOWIENIE
	declare C_EQTYP cursor for select ROWID, ATWRT, ATWTB from dbo.IE2_S_ZBIORNIK_LF__RODZAJ_ZB_POSADOWIENIE where DOC_NEW_INSERTED = 1 order by ROWID asc
	open C_EQTYP
	fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC
	while @@fetch_status = 0
	begin
		select @v_PROID = PRO_ROWID from dbo.PROPERTIES where PRO_PM_KLASA = 'S_ZBIORNIK_LF' and PRO_PM_CECHA = 'RODZAJ_ZB_POSADOWIENIE'

		if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE)
		begin
			insert into dbo.PROPERTIES_LIST (PRL_PROID, PRL_CODE, PRL_TEXT)
			values(@v_PROID, @c_CODE, @c_DESC)
		end
		else
		begin
			update dbo.PROPERTIES_LIST set
				 PRL_TEXT = @c_DESC
				,PRL_UPDATED = getdate()
				,PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0)+1
			where PRL_PROID = @v_PROID and PRL_CODE = @c_CODE
		end

		update dbo.IE2_S_ZBIORNIK_LF__RODZAJ_ZB_POSADOWIENIE set
			DOC_NEW_INSERTED = 0
		where ROWID = @c_DICID

		fetch next from C_EQTYP into @c_DICID, @c_CODE, @c_DESC

	end
	deallocate C_EQTYP

end
GO