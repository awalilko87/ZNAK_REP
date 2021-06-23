SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT31DONv]
as

select  
	[OT31DON_LP] = ROW_NUMBER() OVER(PARTITION BY [OT31LN_OT31ID] ORDER BY [OT31LN_ANLN1],isnull(AST_SUBCODE,'') ASC)
	,[OT31DON_ROWID] 
	,[OT31DON_BUKRS] = AST_SAP_BUKRS
	,[OT31DON_ANLN1]=[OT31LN_ANLN1]
	,[OT31DON_ANLN1_POSKI]=[OT31LN_ANLN1_POSKI]
	,[OT31DON_ANLN1_POSKI_DESC] = (select top 1 AST_DESC from ASSET (nolock) where AST_CODE = [OT31LN_ANLN1_POSKI] and AST_SUBCODE = '0000')
	,[OT31DON_ANLN2] = isnull(AST_SUBCODE,'')
	,[OT31DON_ANLN2_DESC] = isnull(AST_DESC,'')
	,[OT31DON_ZMT_ROWID]
	,[OT31DON_OT31ID] = OT31LN_OT31ID

	--dane pozycji ZMT
	,[OTD_ROWID]
	,[OTD_OTID]
	,[OTD_OBJID]
	,[OTD_OBJ] = [OBJ_CODE]
	,[OTD_OBJ_DESC] = [OBJ_DESC]
	,[OTD_CODE]
	,[OTD_ORG]
	,[OTD_STATUS]
	,[OTD_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT31')
	,[OTD_TYPE]
	,[OTD_RSTATUS] = [OT_RSTATUS]
	,[OTD31_RSTATUS] = [OT_RSTATUS]
	,[OTD_ID]
	,[OTD_CREUSER]
	,[OTD_CREUSER_DESC] = dbo.UserName([OTD_CREUSER])
	,[OTD_CREDATE]
	,[OTD_UPDUSER]
	,[OTD_UPDUSER_DESC] = dbo.UserName(OTD_UPDUSER)
	,[OTD_UPDDATE] 

	--dane nagłówka
	,[OT_ID]
	,[OT_CODE]
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT31')
	,[OT31_IF_EQUNR] 

from
	--uzupełnienie wszystkimi składnikami
[dbo].[SAPO_ZWFOT31LN] (nolock) 
	join [dbo].[SAPO_ZWFOT31] (nolock) on OT31_ROWID = OT31LN_OT31ID
	join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT31LN_ZMT_ROWID
	join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --OTD_OTID często jest NULL, połączenie z ZWFOT poprzez [SAPO_ZWFOT31LN] które jest zawsze
	right join [dbo].[ASSET] (nolock) on AST_CODE = OT31LN_ANLN1_POSKI --zawszę wyświetlam doniesienia wartości dla OT31, musi tak być bo może doniesienie dojść już po wybraniu pozycji w SAPO_ZWFOT31LN
	--dane formatki
	left join [dbo].[SAPO_ZWFOT31DON] (nolock) on OT31DON_OT31ID = OT31LN_OT31ID and OT31DON_ANLN1 = AST_CODE and OT31DON_ANLN2 = AST_SUBCODE
	left join [dbo].[ZWFOTDON] (nolock) on OTD_ROWID = OT31DON_ZMT_ROWID
	left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTD_OBJID]
where 
	isnull([OT31_IF_STATUS],0) <> 4 --dla każdej pozycji z linii dokumenntu MT muszę powyciągać doniesienia (tylko aktualne, status 4 to archiwum)
	and OTL_NOTUSED = 0 
	--and OT_ROWID = 315
 



GO