SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[ZWFOT33DONv]
as

select

	[OT33DON_LP] = ROW_NUMBER() OVER(PARTITION BY [OT33LN_OT33ID] ORDER BY [OT33LN_ANLN1],isnull(AST_SUBCODE,'') ASC)
	,[OT33DON_ROWID] 
 
	,[OT33DON_ZMT_ROWID]
	,[OT33DON_OT33ID] = OT33LN_OT33ID
	    
	,[OT33DON_ANLN1]=[OT33LN_ANLN1]
	,[OT33DON_ANLN1_POSKI]=[OT33LN_ANLN1_POSKI] 
	,[OT33DON_ANLN1_POSKI_DESC] = (select top 1 AST_DESC from ASSET (nolock) where AST_CODE = [OT33LN_ANLN1_POSKI] and AST_SUBCODE = '0000')
	 
	,[OT33DON_ANLN2] = isnull(AST_SUBCODE,'')
	,[OT33DON_ANLN2_DESC] = isnull(AST_DESC,'')
	
	,[OT33DON_TXT50]
	,[OT33DON_WARST]
	,[OT33DON_NDJARPER]
	,[OT33DON_MTOPER]
	,[OT33DON_ANLN1_DO]
	,[OT33DON_ANLN1_DO_POSKI] 
	,[OT33DON_ANLN1_DO_POSKI_DESC] = (select top 1 AST_DESC from ASSET (nolock) where AST_CODE = [OT33DON_ANLN1_DO_POSKI] and AST_SUBCODE = '0000')
	,[OT33DON_ANLN2_DO]
	,[OT33DON_ANLN2_DO_DESC] = (select top 1 AST_DESC from ASSET (nolock) where AST_CODE = [OT33DON_ANLN1_DO_POSKI] and AST_SUBCODE = [OT33DON_ANLN2_DO])
	,[OT33DON_ANLKL_DO]
	,[OT33DON_ANLKL_DO_POSKI]
	,[OT33DON_ANLKL_DO_POSKI_DESC] = (select CCF_DESC from [dbo].[COSTCLASSIFICATION] (nolock) where CCF_CODE = [OT33DON_ANLKL_DO_POSKI])
	,[OT33DON_KOSTL_DO]
	,[OT33DON_KOSTL_DO_POSKI]
	,[OT33DON_KOSTL_DO_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT33DON_KOSTL_DO_POSKI])
	,[OT33DON_UZYTK_DO]
	,[OT33DON_UZYTK_DO_POSKI]
	,[OT33DON_UZYTK_DO_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT33DON_UZYTK_DO_POSKI])
	,[OT33DON_PRAC_DO]
	,[OT33DON_PRCNT_DO] --= coalesce([OT33DON_PRCNT_DO],100)
	,[OT33DON_WARST_DO] = case when OT33DON_MTOPER = 'X' then coalesce([OT33DON_WARST_DO], AST_SAP_URWRT, 0.00) else null end
	,[OT33DON_TXT50_DO]
	,[OT33DON_NDPER_DO]
	,[OT33DON_CHAR_DO]
	,[OT33DON_BELNR]
	,[OT33DON_RSTATUS] = 
		(select case 
			when OT33_MTOPER in ('8') and [OT33DON_ANLN2] <> '0000' then 1 --https://jira.eurotronic.net.pl/browse/PKNTA-219
			when OT33_MTOPER in ('1','2','3') and [OT33DON_ANLN2] <> '0000' then 1 --https://jira.eurotronic.net.pl/browse/PKNTA-246
			when OT33_MTOPER in ('4','5','6','7') and [OT33DON_ANLN2] = '0000' then 1 
		else [OT_RSTATUS] end) --https://jira.eurotronic.net.pl/browse/PKNTA-246

	--dane pozycji ZMT
	,[OTD_ROWID]
	,[OTD_OTID]
	,[OTD_OBJID]
	,[OTD_OBJ] = OBJ.[OBJ_CODE]
	,[OTD_OBJ_DESC] = OBJ.[OBJ_DESC]
	,[OTD_CODE]
	,[OTD_ORG]
	,[OTD_STATUS]
	,[OTD_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT33')
	,[OTD_TYPE]
	,[OTD_RSTATUS] = 0
	,[OTD33_RSTATUS] = 0
	,[OTD_ID] = isnull(OTD_ID, newid())
	,[OTD_CREUSER]
	,[OTD_CREUSER_DESC] = dbo.UserName([OTD_CREUSER])
	,[OTD_CREDATE]
	,[OTD_UPDUSER]
	,[OTD_UPDUSER_DESC] = dbo.UserName(OTD_UPDUSER)
	,[OTD_UPDDATE] 

	--dane nagłówka
	,[OT_ROWID]
	,[OT_ORG]
	,[OT_ID]
	,[OT_CODE]
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT33')
	,[OT33_IF_EQUNR] 

	,[STS_CODE]
	,[OSA_STNID]
	,[STN_DESC]
	,OT33_SAPURWRT = convert(decimal(16,2),AST_SAP_URWRT)
 
from
	--uzupełnienie wszystkimi składnikami
[dbo].[SAPO_ZWFOT33LN] (nolock) 
	join [dbo].[SAPO_ZWFOT33] (nolock) on OT33_ROWID = OT33LN_OT33ID
	join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT33LN_ZMT_ROWID
	join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --OTD_OTID często jest NULL, połączenie z ZWFOT poprzez [SAPO_ZWFOT33LN] które jest zawsze
	right join [dbo].[ASSET] (nolock) on AST_CODE = OT33LN_ANLN1_POSKI and AST_NOTUSED=0 --zawszę wyświetlam doniesienia wartości dla OT33, musi tak być bo może doniesienie dojść już po wybraniu pozycji w SAPO_ZWFOT33LN
	--dane formatki
	left join [dbo].[SAPO_ZWFOT33DON] (nolock) on OT33DON_OT33ID = OT33LN_OT33ID /*and OT33DON_ANLN1 = AST_CODE /*dokument MT3 ma tylko jedną pozycję*/*/and OT33DON_ANLN2 = AST_SUBCODE
	left join [dbo].[ZWFOTDON] (nolock) on OTD_ROWID = OT33DON_ZMT_ROWID
		left join [dbo].[OBJ] as obj_new on obj_new.OBJ_OT33ID = [OTD_ROWID]
			left join [dbo].[STENCIL] on obj_new.OBJ_STSID = STS_ROWID
			left join [dbo].[OBJSTATION] on OSA_OBJID = obj_new.OBJ_ROWID
				left join [dbo].[STATION] on OSA_STNID = STN_ROWID
	left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTD_OBJID]

where 
	isnull([OT33_IF_STATUS],0) <> 4 --dla każdej pozycji z linii dokumenntu MT muszę powyciągać doniesienia (tylko aktualne, status 4 to archiwum)
	and OTL_NOTUSED = 0 
	--and 
	--	((OT33_MTOPER in (1,2,3,8) and [OT33DON_ANLN2] = '0000') 
	--	or 
	--	(OT33_MTOPER in (4,5,6,7)))
	--and OT_ROWID = 335
GO