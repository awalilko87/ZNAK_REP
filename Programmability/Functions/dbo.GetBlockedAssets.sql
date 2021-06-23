SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetBlockedAssets] ()
returns   
	@t_ASSET_BLOCKED table 
	(ANLN1_ANLN2 nvarchar(50))
as
begin
insert into @t_ASSET_BLOCKED (ANLN1_ANLN2)
		select OT31LN_ANLN1_POSKI + OT31DON_ANLN2 from dbo.SAPO_ZWFOT31 (nolock)
			join dbo.ZWFOT (nolock) on OT_ROWID = OT31_ZMT_ROWID
			join dbo.SAPO_ZWFOT31LN (nolock) on OT31LN_OT31ID = OT31_ROWID
			join dbo.SAPO_ZWFOT31DON (nolock) on OT31DON_OT31ID = OT31_ROWID 
		where OT_STATUS not in ('OT31_50','OT31_60', 'OT31_70')
		union  
		select OT32LN_ANLN1_POSKI + OT32DON_ANLN2 from dbo.SAPO_ZWFOT32 (nolock)
			join dbo.ZWFOT (nolock) on OT_ROWID = OT32_ZMT_ROWID
			join dbo.SAPO_ZWFOT32LN (nolock) on OT32LN_OT32ID = OT32_ROWID
			join dbo.SAPO_ZWFOT32DON (nolock) on OT32DON_OT32ID = OT32_ROWID 
		where OT_STATUS not in ('OT32_50','OT32_60', 'OT32_70') 
		union  
		select OT33LN_ANLN1_POSKI + OT33DON_ANLN2 from dbo.SAPO_ZWFOT33 (nolock)
			join dbo.ZWFOT (nolock) on OT_ROWID = OT33_ZMT_ROWID
			join dbo.SAPO_ZWFOT33LN (nolock) on OT33LN_OT33ID = OT33_ROWID
			join dbo.SAPO_ZWFOT33DON (nolock) on OT33DON_OT33ID = OT33_ROWID and OT33DON_MTOPER = 'X'
		where OT_STATUS not in ('OT33_50','OT33_60', 'OT33_70') --and OT33LN_ANLN1_POSKI = '1457585'
		union  
		select OT42LN_ANLN1_POSKI + OT42LN_ANLN2 from dbo.SAPO_ZWFOT42 (nolock)
			join dbo.ZWFOT (nolock) on OT_ROWID = OT42_ZMT_ROWID
			join dbo.SAPO_ZWFOT42LN (nolock) on OT42LN_OT42ID = OT42_ROWID
		where OT_STATUS not in ('OT42_50','OT42_60', 'OT42_70')  --and OT42LN_ANLN1_POSKI = '1457585'
		 union  
		select OT41LN_ANLN1_POSKI + '0000' from dbo.SAPO_ZWFOT41 (nolock)
			join dbo.ZWFOT (nolock) on OT_ROWID = OT41_ZMT_ROWID
			join dbo.SAPO_ZWFOT41LN (nolock) on OT41LN_OT41ID = OT41_ROWID
		where OT_STATUS not in ('OT41_50','OT41_60', 'OT41_70') --and OT41LN_ANLN1_POSKI = '1457585'

	return
end 
GO