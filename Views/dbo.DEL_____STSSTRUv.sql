SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create view [dbo].[DEL_____STSSTRUv]
as
	--komplety/zestawy
	select  
		STS_ROWID as STS_CHILDID,
		STS_CODE as STS_CHILD,
		null as STS_PARENTID,
		null as STS_PARENT,  
		STS_ORG as STS_ORG, 
		'<b>'+[STS_CODE]+'</b> [<i><small>'+[STS_DESC]+'</small></i>]<font color="orange"><small></small></font>' STS_DESC
	from dbo.STENCIL (nolock)
		join SETTYPE (nolock) on STT_CODE = STS_SETTYPE 
	where  
		isnull(STS_NOTUSED,0) = 0
		and STT_MAIN = 1 

	union
	
	--elementy
	--komplety/zestawy
	select  
		STL_CHILDID as STS_CHILDID,
		CHILD.STS_CODE as STS_CHILD,
		STL_PARENTID as STS_PARENTID,
		PARENT.STS_CODE as STS_PARENT,  
		CHILD.STS_ORG as STS_ORG, 
		'<b>'+CHILD.[STS_CODE]+'</b> [<i><small>'+CHILD.STS_DESC+'</small></i>]' STS_DESC
	from dbo.STENCILLN (nolock)
		join STENCIL (nolock) CHILD on CHILD.STS_ROWID = STL_CHILDID
		join STENCIL (nolock) PARENT on PARENT.STS_ROWID = STL_PARENTID
		join SETTYPE (nolock) on STT_CODE = CHILD.STS_SETTYPE 
	where  
		isnull(CHILD.STS_NOTUSED,0) = 0
		and STT_MAIN = 0
		  
GO