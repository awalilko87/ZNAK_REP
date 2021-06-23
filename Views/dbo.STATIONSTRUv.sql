SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  view [dbo].[STATIONSTRUv]
as

--siedziby
	select  
		STN_ROWID as STN_CHILDID,
		null as STN_PARENTID,
		null as STN_PARENT, 
		STN_CODE as STN_CHILD, 
		STN_ORG as STN_ORG, 
		'<b>'+[STN_CODE]+'</b> [<i><small>'+[STN_DESC]+'</small></i>]<font color="orange"><small></small></font>' STN_DESC,   
		cast(NULL as nvarchar(30)) as STN_USERID,
		STN_NUMBER 
	from dbo.STATION (nolock) 
	where  
		isnull(STN_NOTUSED,0) = 0
 

GO