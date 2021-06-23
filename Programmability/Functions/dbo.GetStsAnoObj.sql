SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetStsAnoObj] (@p_ANOID int)
returns table as return
	select 
		PARENT.STS_ROWID  as STS_PARENTID,
		PARENT.STS_CODE as STS_PARENT,
		PARENT.STS_DESC as STS_PARENTDESC,
		CHILD.STS_ROWID as STS_CHILDID,
		CHILD.STS_CODE as STS_CHILD,
		CHILD.STS_DESC as STS_CHILDDESC,
		countv.OBJ_ANOID as OBJ_ANOID,
		isnull(OBJ_COUNT,0) as OBJ_COUNT
	from STENCIL (nolock) PARENT
		join STENCILLN (nolock) on STL_PARENTID = PARENT.STS_ROWID 
		join STENCIL (nolock) CHILD on STL_CHILDID = CHILD.STS_ROWID 
		left join [STSANOOBJ_COUNTv] countv on countv.STS_CHILDID = CHILD.STS_ROWID and countv.STS_PARENTID = PARENT.STS_ROWID and OBJ_ANOID = @p_ANOID

		--left join PSP (nolock) on PSP_CODE = @p_PSP-- +'asdas'
		--left join OBJ (nolock) on CHILD.STS_ROWID = OBJ_STSID and OBJ_PSPID = PSP_ROWID
 
 
 --select * from dbo.GetStsPspObj ('DS/75516/314/00a1')
 --select * from dbo.GetStsPspObj ('DS28887/312/001')
GO