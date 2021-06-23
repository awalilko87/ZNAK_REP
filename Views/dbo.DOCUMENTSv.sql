SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[DOCUMENTSv] as  
select   
  [FileID]  
, [FileID2]  
, [FileName] = '<a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'  
  
, [FileSize]  
, [FileContentType]  
, [Description]  
, [img]  
, [TableName]  
, [ID]  
, [FilePath]  
, [CreateDate]  
, DAE_CODE  
, null [DOT_PARENT]  
, null [DOT_CHILD]  
, null [DOT_DESC]   
from dbo.SYFiles (nolock)  
inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT  


GO