SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOTv]
as
SELECT 
	 
	[OT_ROWID]
	,[OT_CODE]
	,[OT_ORG]
	,[OT_STATUS]
	,[OT_STATUS_DESC] = (select STA_DESC from [dbo].[STA] (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = LEFT ([OT_STATUS],4))
	,[OT_TYPE]
	,[OT_TYPE_DESC] = (select TYP_DESC from [dbo].[TYP] (nolock) where TYP_CODE = [OT_TYPE])
	,[OT_RSTATUS]
	--,[OT11_RSTATUS] = [OT_RSTATUS]
	,[OT_ID]
	,[OT_CREUSER]
	,[OT_CREUSER_DESC] = dbo.UserName(OT_UPDUSER)
	,[OT_CREDATE]
	,[OT_UPDUSER]
	,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)
	,[OT_UPDDATE] 
	,[OT_ITSID]
	,[OT_ITS] = ITS_CODE	 
	,[OT_PSPID] 	 
	,[OT_PSP] = PSP_CODE
	,[OT_INOID]
	,[OT_SRQID]
FROM  [dbo].[ZWFOT]  (nolock)
	left join [dbo].[INVTSK] (nolock) on ITS_ROWID = OT_ITSID
	left join [dbo].[PSP] (nolock) on PSP_ROWID = OT_PSPID


GO