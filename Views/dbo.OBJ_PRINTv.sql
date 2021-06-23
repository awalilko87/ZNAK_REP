SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[OBJ_PRINTv]
as
select
 o.OBJ_ROWID
,o.OBJ_PARENTID
,OBJ_PARENT = case when O.OBJ_ROWID = O.OBJ_PARENTID then '' else p.OBJ_CODE end
,OBJ_PARENT_DESC = case when O.OBJ_ROWID = O.OBJ_PARENTID then '' else p.OBJ_DESC end
,OBJ_STNID = OSA_STNID
,OBJ_STATION = STN_CODE
,OBJ_STATION_DESC = STN_DESC
,OBJ_PSP = PSP_CODE
,o.OBJ_GROUPID
,o.OBJ_SERIAL
,o.OBJ_SIGNED
,o.OBJ_SIGNLOC
,o.OBJ_ID
,o.OBJ_PRINTDATE
,o.OBJ_CODE
,OBJ_DESC = (select case 
				when STS_CODE = '2016_MEBLE_00562' then (select top 1 AST_DESC from ASSET (nolock) join OBJASSET (nolock) on OBA_ASTID = AST_ROWID where OBA_OBJID = o.OBJ_ROWID) 
				else o.OBJ_DESC 	
			end)  
,o.OBJ_DATE
,o.OBJ_STATUS
,OBJ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = o.OBJ_STATUS and STA_ENTITY = 'OBJ')
,o.OBJ_TYPE 
,OBJ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = o.OBJ_TYPE and TYP_ENTITY = 'OBJ')
,OBJ_GROUP = OBG_CODE
,OBJ_GROUP_DESC = OBG_DESC
,OBJ_ASSET = ASSET
,OBJ_ASSET_DESC = AST_DESC
,OBJ_ASTAKTIV = AST_SAP_AKTIV
,STS_CODE
	
,CODE = null
,[FileName] = null
from dbo.OBJ (nolock) o  
join dbo.OBJGROUP (nolock) on OBG_ROWID = o.OBJ_GROUPID
left join dbo.OBJ (nolock) p on p.OBJ_ROWID = o.OBJ_PARENTID
left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID
left join dbo.STATION s (nolock) on s.STN_ROWID = OSA_STNID
left join dbo.PSP (nolock) on PSP_ROWID = p.OBJ_PSPID
left join dbo.STENCIL (nolock) on O.OBJ_STSID = STS_ROWID
outer apply (select top 1  ASSET = AST_CODE + ' - '+ AST_SUBCODE, AST_DESC, AST_SAP_AKTIV from dbo.ASSET (nolock) join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID where OBA_OBJID = o.OBJ_ROWID order by AST_SUBCODE)a
where isnull(o.OBJ_NOTUSED,0) = 0
GO