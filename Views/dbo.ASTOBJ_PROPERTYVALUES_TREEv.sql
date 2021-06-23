SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[ASTOBJ_PROPERTYVALUES_TREEv]
as
with TREE as
(

--drzewo dla składników
	select 
		NULL as OBJ_PARENT,
		'S' as OBJ_CHILD, 
		OBJ_PSPID,  
		OBJ_ANOID,
		OBJ_INOID,
		N'Wszystkie składniki: ' as OBJ_CODE,
		N'Wszystkie składniki: ' as OBJ_DESC, 
		count(PRV_ROWID) as OBJ_OK, 
		count(ASP_ROWID) as OBJ_NOK
	from OBJ (nolock)
		join STENCIL S (nolock) on STS_ROWID = OBJ_STSID  
		join ADDSTSPROPERTIES A (nolock) on ASP_STSID = STS_ROWID
		join PROPERTIES P (nolock) on A.ASP_PROID = P.PRO_ROWID and isnull(PRO_NOTUSED,0) = 0 
		left join PROPERTYVALUES PV (nolock) on PRV_PROID = PRO_ROWID and PRV_PKID = OBJ_ROWID and isnull(PV.PRV_NOTUSED,0) = 0
	group by  
		OBJ_PSPID, OBJ_ANOID, OBJ_INOID

union all

	select 
		'S' as OBJ_PARENT,
		OBJ_CODE as OBJ_CHILD, 
		OBJ_PSPID, 
		OBJ_ANOID, 
		OBJ_INOID,
		OBJ_CODE,
		OBJ_DESC + ' ' + cast( ROW_NUMBER() OVER(PARTITION BY  OBJ_STSID, OBJ_PSPID  ORDER BY OBJ_ROWID DESC) as nvarchar(5)) as OBJ_DESC, 
		count(PRV_ROWID), 
		count (ASP_ROWID)
	from OBJ (nolock)
		join STENCIL S (nolock) on STS_ROWID = OBJ_STSID  
		join ADDSTSPROPERTIES A (nolock) on ASP_STSID = STS_ROWID
		join PROPERTIES P (nolock) on A.ASP_PROID = P.PRO_ROWID and isnull(PRO_NOTUSED,0) = 0
		left join PROPERTYVALUES PV (nolock) on PRV_PROID = PRO_ROWID and PRV_PKID = OBJ_ROWID and isnull(PV.PRV_NOTUSED,0) = 0
	group by 
		OBJ_ROWID, 
		OBJ_PSPID,
		OBJ_ANOID,
		OBJ_INOID,
		OBJ_STSID,
		OBJ_CODE,
		OBJ_DESC

union all

--drzewo dla parametrów
	select 
		NULL as OBJ_PARENT,
		'P' as OBJ_CHILD, 
		OBJ_PSPID,
		OBJ_ANOID,  
		OBJ_INOID,  
		N'Wszystkie parametry' as OBJ_CODE,
		N'Wszystkie parametry' as OBJ_DESC, 
		count(PRV_ROWID) as OBJ_OK, 
		count(ASP_ROWID) as OBJ_NOK
	from OBJ (nolock)
		join STENCIL S (nolock) on STS_ROWID = OBJ_STSID  
		join ADDSTSPROPERTIES A (nolock) on ASP_STSID = STS_ROWID
		join PROPERTIES P (nolock) on A.ASP_PROID = P.PRO_ROWID and isnull(PRO_NOTUSED,0) = 0
		left join PROPERTYVALUES PV (nolock) on PRV_PROID = PRO_ROWID and PRV_PKID = OBJ_ROWID and isnull(PV.PRV_NOTUSED,0) = 0 and isnull(PRV_ERROR,'') = ''
	group by  
		OBJ_PSPID, OBJ_ANOID, OBJ_INOID

union all

	select 
		'P' as OBJ_PARENT,
		PRO_CODE as OBJ_CHILD, 
		OBJ_PSPID, 
		OBJ_ANOID,  
		OBJ_INOID,
		PRO_CODE as OBJ_CODE,
		PRO_TEXT as OBJ_DESC, 
		count(PRV_ROWID), 
		count (ASP_ROWID)
	from OBJ (nolock)
		join STENCIL S (nolock) on STS_ROWID = OBJ_STSID  
		join ADDSTSPROPERTIES A (nolock) on ASP_STSID = STS_ROWID
		join PROPERTIES P (nolock) on A.ASP_PROID = P.PRO_ROWID  and isnull(PRO_NOTUSED,0) = 0
		left join PROPERTYVALUES PV (nolock) on PRV_PROID = PRO_ROWID and PRV_PKID = OBJ_ROWID and isnull(PV.PRV_NOTUSED,0) = 0 and isnull(PRV_ERROR,'') = ''
	group by 
		OBJ_PSPID,
		OBJ_ANOID,
		OBJ_INOID,
		PRO_ROWID,
		PRO_CODE,
		PRO_TEXT

)
	select 
		OBJ_PARENT,
		OBJ_CHILD,   
		OBJ_PSPID,
		OBJ_ANOID,
		OBJ_INOID,
		OBJ_DESC = 
		case when OBJ_OK = OBJ_NOK
			then '<b>'+/*[OBJ_CODE] + ' - ' + */[OBJ_DESC]+'</b> [<i><font color="green"><small>Parametry ' + cast(OBJ_OK as nvarchar) +' z ' + cast (OBJ_NOK as nvarchar) +'</small></i>]<small></small></font>'
			else '<b>'+/*[OBJ_CODE] + ' - ' + */[OBJ_DESC]+'</b> [<i><font color="red"><small>Parametry ' + cast(OBJ_OK as nvarchar) +' z ' + cast (OBJ_NOK as nvarchar) +'</small></i>]<small></small></font>' end
	from TREE
		--join PSP (nolock) on PSP_ROWID = OBJ_PSPID

GO