SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[MSGSv]
as        
SELECT top 99.999999 percent  
  ObjectID  
, LangID  
, ControlID  
, ObjectType  
, Caption  
FROM dbo.VS_LangMsgs (nolock)  
WHERE ObjectType = 'MSG'  
ORDER BY ObjectID, LangID 

GO