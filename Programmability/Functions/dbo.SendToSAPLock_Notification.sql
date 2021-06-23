SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE function [dbo].[SendToSAPLock_Notification] (@OT_CODE nvarchar(30))
returns nvarchar(300)
as
begin
	
declare @ZWFOT_rowid int = (select top 1 OT_ROWID from ZWFOT where OT_CODE = @OT_CODE)
declare @POT_CODE nvarchar(30) = (select top 1 POL_CODE from OBJTECHPROTLN where POL_OT42ID = @ZWFOT_rowid)
declare @result int = 0

declare @SkladnikiDokumentu table
(
	id int identity
	, ZWFOTLN_rowid int
	, ZWFOT_rowid int
	, ASSET_CODE int
	, ASSET_SUBCODE nvarchar(4)
	, SAPO_ZWFOT_rowid int
	, OT_CODE nvarchar(30)
	, OT_STATUS nvarchar(15)
	, OT_CREDATE datetime
	, OBJ_ROWID int
	, OBJ_STA nvarchar(15)
	, nr_SAP_PLki nvarchar(20)
	, ZWFOT_ROK int
	, STS_ROWID int
	, STS_SETTYPE nvarchar(20)
)

insert into @SkladnikiDokumentu
(
	ZWFOTLN_rowid
	, ZWFOT_rowid
	, ASSET_CODE
	, ASSET_SUBCODE
	, SAPO_ZWFOT_rowid
	, OT_CODE
	, OT_STATUS
	, OT_CREDATE
	, OBJ_ROWID
	, OBJ_STA
	, nr_SAP_PLki
	, ZWFOT_ROK
	, STS_ROWID
	, STS_SETTYPE
)
select
	OTL_ROWID
	, OTL_OTID
	, b.OT42LN_ANLN1_POSKI
	, b.OT42LN_ANLN2
	, b.OT42LN_OT42ID
	, c.OT_CODE
	, c.OT_STATUS
	, c.OT_CREDATE
	, d.OTO_OBJID
	, e.OBJ_STATUS
	, f.OT42_IF_EQUNR
	, f.OT42_IF_YEAR
	, e.OBJ_STSID
	, g.STS_SETTYPE
	from ZWFOTLN a
	left join SAPO_ZWFOT42LN b on a.OTL_ROWID = b.OT42LN_ZMT_ROWID
	left join ZWFOT c on a.OTL_OTID = c.OT_ROWID
	left join ZWFOTOBJ d on a.OTL_ROWID = OTO_OTLID
	left join OBJ e on d.OTO_OBJID = e.OBJ_ROWID
	left join SAPO_ZWFOT42 f on a.OTL_OTID = f.OT42_ZMT_ROWID
	left join STENCIL g on e.OBJ_STSID = g.STS_ROWID
	where OTL_OTID in (select distinct POL_OT42ID from OBJTECHPROTLN where POL_CODE = @POT_CODE)

	if exists (
	select 1 from @SkladnikiDokumentu where OT_CODE = @OT_CODE and STS_SETTYPE in ('KOM', 'EKOM') and ASSET_SUBCODE = '0000')
		begin

			if exists (
--			select a.*, b.OT40_ZMT_ROWID, c.OT_STATUS, c.OT_CODE from @SkladnikiDokumentu a
			select 1 from @SkladnikiDokumentu a
			left join SAPO_ZWFOT40 b on a.nr_SAP_PLki = b.OT40_PL_DOC_NUM and a.ZWFOT_ROK = b.OT40_PL_DOC_YEAR
			left join ZWFOT c on b.OT40_ZMT_ROWID = c.OT_ROWID
				where a.ASSET_CODE in
					(select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and STS_SETTYPE in ('KOM', 'EKOM') and ASSET_SUBCODE = '0000')
				and a.OT_CODE <> @OT_CODE and ASSET_SUBCODE <> '0000'
				and (ISNULL(a.OT_STATUS, '') <> 'OT42_50' or ISNULL(c.OT_STATUS, '') <> 'OT40_50')
				--and ISNULL(a.OT_STATUS, '') <> 'OT42_50'
				--and ISNULL(c.OT_STATUS, '') <> 'OT42_50'
			)
				begin
					set @result = 1
				end
		end

		declare @ListaKodow table (KodDokumentu nvarchar(40))
		declare @komunikat nvarchar(300)

		if @result = 1
			begin
				insert into @ListaKodow
				select distinct a.OT_CODE from @SkladnikiDokumentu a
				left join SAPO_ZWFOT40 b on a.nr_SAP_PLki = b.OT40_PL_DOC_NUM and a.ZWFOT_ROK = b.OT40_PL_DOC_YEAR
				left join ZWFOT c on b.OT40_ZMT_ROWID = c.OT_ROWID
					where a.ASSET_CODE in
						(select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and STS_SETTYPE in ('KOM', 'EKOM') and ASSET_SUBCODE = '0000')
					and a.OT_CODE <> @OT_CODE and ASSET_SUBCODE <> '0000'
					and (ISNULL(c.OT_STATUS, '') <> 'OT40_50' and ISNULL(a.OT_STATUS, '') <> 'OT42_50')
					--and (ISNULL(a.OT_STATUS, '') <> 'OT42_50' or ISNULL(c.OT_STATUS, '') <> 'OT40_50')
					--and ISNULL(a.OT_STATUS, '') <> 'OT42_50'
					--and ISNULL(c.OT_STATUS, '') <> 'OT42_50'
					and ISNULL(a.OT_CODE, '') <> ''
				union
				select distinct c.OT_CODE from @SkladnikiDokumentu a
				left join SAPO_ZWFOT40 b on a.nr_SAP_PLki = b.OT40_PL_DOC_NUM and a.ZWFOT_ROK = b.OT40_PL_DOC_YEAR
				left join ZWFOT c on b.OT40_ZMT_ROWID = c.OT_ROWID
					where a.ASSET_CODE in
						(select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and STS_SETTYPE in ('KOM', 'EKOM') and ASSET_SUBCODE = '0000')
					and a.OT_CODE <> @OT_CODE and ASSET_SUBCODE <> '0000'
					and (ISNULL(a.OT_STATUS, '') <> 'OT42_50' or ISNULL(c.OT_STATUS, '') <> 'OT40_50')
					--and ISNULL(a.OT_STATUS, '') <> 'OT42_50'
					--and ISNULL(c.OT_STATUS, '') <> 'OT42_50'
					and ISNULL(c.OT_CODE, '') <> ''

					select @komunikat = 'Przycisk "Zapisz i wyślij do SAP" zablokowany z powodu niezakończonego procesowania dokumentów: ' + Stuff((select '; ' + KodDokumentu from @ListaKodow for xml path ('')),1,2,N'')
			end


		if exists
			(
			select 1 from ZWFOT a left join STA b on a.OT_STATUS = b.STA_CODE
			where 1 = 1
			and OT_CODE like 'MT%'
			and OT_CODE <> @OT_CODE
			and STA_DESC not in ('Zaksięgowany', 'Anulowany')
			and OT_ROWID in
			(
			select b.OT31_ZMT_ROWID from SAPO_ZWFOT31LN left join SAPO_ZWFOT31 b on OT31LN_OT31ID = b.OT31_ROWID
			where OT31LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
			union
			select b.OT32_ZMT_ROWID from SAPO_ZWFOT32LN left join SAPO_ZWFOT32 b on OT32LN_OT32ID = b.OT32_ROWID
			where OT32LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
			union
			select b.OT33_ZMT_ROWID from SAPO_ZWFOT33LN left join SAPO_ZWFOT33 b on OT33LN_OT33ID = b.OT33_ROWID
			where OT33LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
			--union
			--select b.OT41_ZMT_ROWID from SAPO_ZWFOT41LN left join SAPO_ZWFOT41 b on OT41LN_OT41ID = b.OT41_ROWID
			--where OT41LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
			--union
			--select b.OT42_ZMT_ROWID from SAPO_ZWFOT42LN left join SAPO_ZWFOT42 b on OT42LN_OT42ID = b.OT42_ROWID
			--where OT42LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')	
			)
			)
				begin
					select @komunikat = case when len(@komunikat) > 4 then @komunikat + ' oraz '
					else 'Przycisk "Zapisz i wyślij do SAP" zablokowany z powodu niezakończonego procesowania dokumentów: ' end
					+ stuff((select OT_CODE + ' (' + STA_DESC + ')' + ', ' from ZWFOT a left join STA b on a.OT_STATUS = b.STA_CODE
					where 1 = 1
					and OT_CODE like 'MT%'
					and OT_CODE <> @OT_CODE
					and STA_DESC not in ('Zaksięgowany', 'Anulowany')
					and OT_ROWID in
					(
					select b.OT31_ZMT_ROWID from SAPO_ZWFOT31LN left join SAPO_ZWFOT31 b on OT31LN_OT31ID = b.OT31_ROWID
					where OT31LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
					union
					select b.OT32_ZMT_ROWID from SAPO_ZWFOT32LN left join SAPO_ZWFOT32 b on OT32LN_OT32ID = b.OT32_ROWID
					where OT32LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
					union
					select b.OT33_ZMT_ROWID from SAPO_ZWFOT33LN left join SAPO_ZWFOT33 b on OT33LN_OT33ID = b.OT33_ROWID
					where OT33LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
					--union
					--select b.OT41_ZMT_ROWID from SAPO_ZWFOT41LN left join SAPO_ZWFOT41 b on OT41LN_OT41ID = b.OT41_ROWID
					--where OT41LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
					--union
					--select b.OT42_ZMT_ROWID from SAPO_ZWFOT42LN left join SAPO_ZWFOT42 b on OT42LN_OT42ID = b.OT42_ROWID
					--where OT42LN_ANLN1_POSKI in (select ASSET_CODE from @SkladnikiDokumentu where OT_CODE = @OT_CODE and ASSET_SUBCODE = '0000' and STS_SETTYPE = 'EKOM')
					)
					for xml path ('')),1,0,N'')
				end		

  return (isnull(@komunikat, ''))

end
GO