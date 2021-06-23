SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[POT_ZWFOT_Correct_Lines]
@POT_CODE nvarchar(40)

AS
BEGIN

	declare @PrawidloweSkladniki table (id int identity, SAP_rowid int, ZWFOT_rowid int, SPOS_LIKW int, OBJ_ROWID int, POL_STATUS nvarchar(20), OTO_OTLID int, OTO_ASTCODE nvarchar(20), OTO_ASTSUBCODE nvarchar(20))

	insert into @PrawidloweSkladniki
	select distinct sap.OT42_ROWID, sap.OT42_ZMT_ROWID, sap.OT42_SPOSOBLIKW, poln.POL_OBJID, poln.POL_STATUS, OTO_OTLID, OTO_ASTCODE, OTO_ASTSUBCODE
	from OBJTECHPROTLN poln
	left join SAPO_ZWFOT42 sap on poln.POL_OT42ID = sap.OT42_ZMT_ROWID
	left join ZWFOTOBJ zw on poln.POL_OBJID = zw.OTO_OBJID and sap.OT42_ZMT_ROWID = zw.OTO_OTID
	where POL_CODE = @POT_CODE
	order by OTO_ASTCODE, OTO_ASTSUBCODE

	if (select count(distinct ZWFOT_rowid) from @PrawidloweSkladniki) > 1
	begin

		declare @NieprawidloweSkladniki table (wrong_id int identity, wrong_OTO_OTID int, wrong_OTO_OTLID int, wrong_OTO_OBJID int, wrong_OTO_ASTCODE nvarchar(20), wrong_OTO_ASTSUBCODE nvarchar(20))

		insert into @NieprawidloweSkladniki
		select OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE from ZWFOTOBJ
		where OTO_OTID in (select distinct ZWFOT_rowid from @PrawidloweSkladniki)
		and OTO_OTLID not in (select OTO_OTLID from @PrawidloweSkladniki)

		if exists (select 1 from @NieprawidloweSkladniki)
		begin
			delete from ZWFOTOBJ where OTO_OTLID in (select wrong_OTO_OTLID from @NieprawidloweSkladniki)

			delete from SAPO_ZWFOT42LN
			where OT42LN_ZMT_ROWID in (select wrong_OTO_OTLID from @NieprawidloweSkladniki)

			delete from ZWFOTLN
			where OTL_ROWID in (select wrong_OTO_OTLID from @NieprawidloweSkladniki)
		end


		exec POT_KOM_GENERATE @POT_CODE
	end

END

GO