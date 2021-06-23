SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- [DOCUMENTS_TREE_proc] 'OBJ','PANEL-STERUJACY ','CRANE',null,'KP'    
CREATE procedure [dbo].[DOCUMENTS_TREE_proc]    
 @p_Entity nvarchar(4),    
 @p_PK1 nvarchar(30),    
 @p_PK2 nvarchar(30),    
 @p_PK3 nvarchar(30)=null,    
 @p_UserID nvarchar(30)    
    
as    
    
declare @v_LangID nvarchar(10)    
declare @v_Code nvarchar(50)    
declare @v_ParentCode nvarchar(50)    
declare @v_OBJID int    
declare @v_Entity nvarchar(4)    
    
select @v_LangID = LangID from SYUsers(nolock) where UserID = @p_UserID    
     
    
IF @p_Entity = ('AOBJ')    
BEGIN    
 select @v_Entity = 'OBJ'    
    
 set @v_Code = @p_PK1+'#'+@p_PK2    
 select @v_ParentCode = OBJ_CODE+'#'+OBJ_ORG from dbo.ASTOBJv (nolock) where OBJ_CODE = @p_PK1 and OBJ_ORG = @p_PK2    
 select top 1 @v_OBJID = OBJ_ROWID from OBJ where OBJ_CODE = @p_PK1 and OBJ_ORG = @p_PK2    
    
 select 'Składnik' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'ASTOBJ'    
 union    
 --select 'Składnik nadrzędny' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 --from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt nadrzędny'    
 --union    
 select 'Składniki podrzędne' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'ASTOBJ_CHILD'    
    
 union    
    
 --Obiekt    
 select    
 [FileID2] as DOT_CHILD,     
 'Składnik' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY in ('ASTOBJ','OT11','OT21', 'OBJ') and isnull(DAE_MN,0) <> -1 and DAE_CODE = @v_Code    
    
 union    
    
 ----Obiekt nadrzędny    
 --select    
 --[FileID2] as DOT_CHILD,     
 --'Obiekt nadrzędny' as DOT_PARENT,     
 --FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 --2 DOT_LEVEL,    
 --FileID2,    
 --DAE_CODE    
 --from dbo.SYFiles (nolock)    
 --inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 --where DAE_ENTITY = @p_Entity and DAE_CODE = @v_ParentCode     
 -- and isnull(DAE_MN,0) <> -1    
    
 --union     
    
 --Obiekty podrzędne    
 select distinct    
 [FileID2] as DOT_CHILD,     
 'Składniki podrzędne' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + +'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 ''    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @v_Entity and DAE_CODE in (select OBJ_CODE+'#'+OBJ_ORG from OBJ where OBJ_ROWID in (select ID from dbo.GetAstObjSubObjects(@v_OBJID)))     
  and isnull(DAE_MN,0) <> -1 and DAE_TYPE is null and DAE_TYPE2 is null and DAE_TYPE3 is null    
union    
 select top 1    
 [FileID2]  as DOT_CHILD,     
 'Składniki podrzędne' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 ''    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @v_Entity and DAE_CODE in (select OBJ_CODE+'#'+OBJ_ORG from OBJ where OBJ_ROWID in (select ID from dbo.GetAstObjSubObjects(@v_OBJID)))     
  and isnull(DAE_MN,0) <> -1 and DAE_TYPE2 is null and DAE_TYPE3 is null    
union    
 select distinct    
 [FileID2] as DOT_CHILD,     
 'Składniki podrzędne' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 ''    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @v_Entity and DAE_CODE in (select OBJ_CODE+'#'+OBJ_ORG from OBJ where OBJ_ROWID in (select ID from dbo.GetAstObjSubObjects(@v_OBJID)))     
  and isnull(DAE_MN,0) <> -1 and DAE_TYPE2 is null and DAE_TYPE3 is null    
    
    
END    
    
    
IF @p_Entity = ('OPZ')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
 select @v_ParentCode = OBJ_CODE + '#'+OBJ_ORG from dbo.ASTOBJv (nolock) where OBJ_CODE = @p_PK1 and OBJ_ORG = @p_PK2    
    
    
 select 'Obiekt' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt'    
 union    
 select 'Obiekt nadrzędny' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt nadrzędny'    
 union     
 select 'Elementy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Elementy'    
 union    
    
 --Obiekt    
 select    
 [FileID2] as DOT_CHILD,     
 'Obiekt' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 --Obiekt nadrzędny    
 select    
 [FileID2] as DOT_CHILD,     
 'Obiekt nadrzędny' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE = @v_ParentCode and isnull(DAE_MN,0) <> -1    
     
 union    
     
 -- elementy    
 select    
 [FileID2] as DOT_CHILD,     
 'Elementy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE in (select OPC_CHILD_CODE+'#'+OPC_ORG from PR_OPZCOMPv     
          where OPC_PARENT_CODE = @p_PK1) and isnull(DAE_MN,0) <> -1    
    
END    
    
    
IF @p_Entity = ('OPL')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Listy części zamiennych' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Listy części zamiennych'    
 union    
 select 'Materiały' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Materiały'    
 union    
 select ASS_CODE+'#'+ASS_ORG as DOT_CHILD, 'Materiały' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+ASS_CODE+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.ST_ASSORT(nolock)    
 inner join dbo.DOCENTITIES(nolock) on DAE_CODE = ASS_CODE+'#'+ASS_ORG where ASS_CODE+'#'+ASS_ORG in (select OBP_PARCODE+'#'+OBP_ORG from OPLPARTSv(nolock) where OBP_OPLID in (select ROWID from dbo.OBJPARTSLIST(nolock) where OPL_CODE = @p_PK1 and OPL_ORG 
  
= @p_PK2))    
     
 union    
    
 --Listy części zamiennych    
 select    
 [FileID2] as DOT_CHILD,     
 'Listy części zamiennych' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'ASS' and DAE_CODE in (select OBP_PARCODE+'#'+OBP_ORG from OPLPARTSv(nolock) where OBP_OPLID in (select ROWID from dbo.OBJPARTSLIST(nolock) where OPL_CODE = @p_PK1 and OPL_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('EMP')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Pracownicy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Pracownicy'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Pracownicy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 --szkolenia    
 select    
 [FileID2] as DOT_CHILD,     
 'Pracownicy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'ETR' and DAE_CODE in (select ETR_CODE+'#'+ETR_ORG from dbo.EMPTRAIN(nolock) inner join dbo.EMP(nolock) on EMP.EMP_ROWID = ETR_EMPID and EMP_CODE = @p_PK1 and EMP_ORG = @p_PK2) and isnull(DAE_MN,0) <> -1    
    
END    
    
    
IF @p_Entity = ('VEN')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Wykonawcy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Wykonawcy'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Wykonawcy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
    
IF @p_Entity = ('MFC')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Producenci' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Producenci'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Producenci' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('AST')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Środki trwałe' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Środki trwałe'    
     
 union    
    
 --Środki trwałe    
 select    
 [FileID2] as DOT_CHILD,     
 'Środki trwałe' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
    
IF @p_Entity = ('LOC')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Budynki' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Budynki'    
     
 union    
    
 --Budynki    
 select    
 [FileID2] as DOT_CHILD,     
 'Budynki' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('OBG')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Typy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Typy'    
     
 union    
    
 --Typy    
 select    
 [FileID2] as DOT_CHILD,     
 'Typy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('TSK')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Zadanie' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zadanie'    
 union    
 select 'Obiekt' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt'    
     
 union    
    
 --Obiekt    
 select    
 [FileID2] as DOT_CHILD,     
 'Obiekt' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE in (select OBJ_CODE+'#'+OBJ_ORG from dbo.OBJ (nolock) where OBJ.OBJ_ROWID in (select TSO_OBJID from dbo.TASKSOBJ (nolock) where TASKSOBJ.TSO_TSKID = (select TASKS.ROWID from TASKS where TSK_CODE = @p_PK1 and TSK_ORG 
  
= @p_PK2))) and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 'Zadanie' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
    
IF @p_Entity = ('TSI')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Czynność' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Czynność'    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 'Czynność' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('ASS')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Materiały' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Materiały'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Materiały' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('IVO')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Faktury' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Faktury'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Faktury' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('RST')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Zgłoszenia' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zgłoszenia'    
    
 union    
      
 select 'Obiekty' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt'    
 union    
 select    
 [FileID2] as DOT_CHILD,     
 'Obiekty' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE in (select RST_OBJCODE+'#'+RST_ORG from dbo.REQUESTv(nolock) where RST_CODE = @p_PK1) and isnull(DAE_MN,0) <> -1    
 union    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Zgłoszenia' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
 select 'Formatki wzorcowe' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Formatki wzorcowe:</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Formatki wzorcowe' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('REQ')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Zapotrzebowania' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zapotrzebowania'    
 union    
 select 'Materiały' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Materiały'    
 union    
 select ASS_CODE+'#'+ASS_ORG as DOT_CHILD, 'Materiały' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+ASS_CODE+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.ST_ASSORT(nolock)    
 inner join dbo.DOCENTITIES(nolock) on DAE_CODE = ASS_CODE+'#'+ASS_ORG where ASS_CODE+'#'+ASS_ORG in (select RQL_ASS+'#'+RQL_ORG from REQLNv where RQL_REQID in (select REQUIS.ROWID from dbo.REQUIS(nolock) where REQ_CODE = @p_PK1 and REQ_ORG = @p_PK2))    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Zapotrzebowania' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'ASS' and DAE_CODE in (select RQL_ASS+'#'+RQL_ORG from REQLNv where RQL_REQID in (select ROWID from dbo.REQUIS where REQ_CODE = @p_PK1 and REQ_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('WRC')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Plan produkcji' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Plan produkcji'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Plan produkcji' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('PRD')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Produkty' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Produkty'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Produkty' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('CFG')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Szablony konfiguracyjne' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Szablony konfiguracyjne'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Szablony konfiguracyjne' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('ORD')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Zamówienia' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zamówienia'    
 union    
 select 'Materiały' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Materiały'    
 union    
 select 'Zapotrzebowania' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 3 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zapotrzebowania'    
 union    
 select ASS_CODE+'#'+ASS_ORG as DOT_CHILD, 'Materiały' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+ASS_CODE+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.ST_ASSORT(nolock)    
 inner join dbo.DOCENTITIES(nolock) on DAE_CODE = ASS_CODE+'#'+ASS_ORG where ASS_CODE+'#'+ASS_ORG in (select RQL_ASS+'#'+RQL_ORG from ORDLNv where RQL_LANGID = @v_LangID and RQL_ORDID in (select ORDERS.ROWID from dbo.ORDERS(nolock) where ORD_CODE = @p_PK1  
 and ORD_ORG = @p_PK2))    
 union    
 select REQ_CODE+'#'+REQ_ORG as DOT_CHILD, 'Zapotrzebowania' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+REQ_CODE+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.REQUIS (nolock) r    
 inner join dbo.DOCENTITIES(nolock) d on DAE_CODE = r.REQ_CODE+'#'+r.REQ_ORG where r.ROWID in (select RQL_REQID from REQLNv where RQL_ORDID in (select ORDERS.ROWID from dbo.ORDERS(nolock) where ORD_CODE = @p_PK1 and ORD_ORG = @p_PK2))    
 union    
 select  r.REQ_CODE+'#'+convert(nvarchar,rp.RQL_CODE)+'#'+rp.RQL_ORG as DOT_CHILD, r.REQ_CODE+'#'+r.REQ_ORG as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+r.REQ_CODE+' Poz.'+convert(nvarchar,rp.RQL_CODE)+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.REQUIS (nolock) r    
 inner join REQLNv rp on r.ROWID = rp.RQL_REQID    
 inner join dbo.DOCENTITIES(nolock) d on DAE_CODE = r.REQ_CODE+'#'+convert(nvarchar,rp.RQL_CODE)+'#'+rp.RQL_ORG where rp.RQL_ORDID in (select ORDERS.ROWID from dbo.ORDERS(nolock) where ORD_CODE = @p_PK1 and ORD_ORG = @p_PK2)    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 'Zamówienia' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'ASS' and DAE_CODE in (select RQL_ASS+'#'+RQL_ORG from ORDLNv where RQL_ORDID in (select ROWID from dbo.ORDERS where ORD_CODE = @p_PK1 and ORD_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'REQ' and DAE_CODE in (select REQ_CODE+'#'+REQ_ORG from dbo.REQUIS (nolock) where ROWID in (select RQL_REQID from REQLNv where RQL_ORDID in (select ORDERS.ROWID from dbo.ORDERS(nolock) where ORD_CODE = @p_PK1 and ORD_ORG = @p_PK2))) and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'RQL' and DAE_CODE in (select r.REQ_CODE+'#'+convert(nvarchar,rp.RQL_CODE)+'#'+rp.RQL_ORG from dbo.REQUIS (nolock) r inner join REQLNv rp on r.ROWID = rp.RQL_REQID where rp.RQL_ORDID in (select ORDERS.ROWID from dbo.ORDERS(nolock) where ORD_CODE = @p_PK1 and ORD_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('EVT')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select '5Czynności' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Czynności'    
 union    
 select '1Zlecenia' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zlecenia'    
 union    
 select '4Zadanie' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zadanie'    
 union     
 select '2Obiekty' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Obiekt'    
 union     
 select '3Zgłoszenia' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zgłoszenia'    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 '1Zlecenia' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 '2Obiekty' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'OBJ' and DAE_CODE in (select ACT_OBJCODE+'#'+ACT_ORG from dbo.ACTv(nolock) where ACT_EVTID = (select ROWID from dbo.EVT(nolock) where EVT_CODE = @p_PK1 and EVT_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 '4Zadanie' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'TSK' and DAE_CODE = (select TSK_CODE+'#'+TSK_ORG from dbo.TASKS where ROWID = (select EVT_TSKID from dbo.EVT (nolock) where EVT_CODE = @p_PK1 and EVT_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 '3Zgłoszenia' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'RST' and DAE_CODE in (select RST_CODE+'#'+RST_ORG from dbo.REQUEST(nolock) where RST_ID = (select EVT_ID from dbo.EVT(nolock) where EVT_CODE = @p_PK1 and EVT_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
     
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 '5Czynności' as DOT_PARENT,     
 isnull(DAE_CODE,'')  + ' ' + FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else  
 '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'TSI' and DAE_CODE in (select TSI_CODE+'#'+TSI_ORG from dbo.TSKINSTR(nolock) where ROWID in (select EVI_TSIID from dbo.EVTI(nolock) where EVI_EVTID = (select ROWID from EVT where EVT_CODE = @p_PK1 and EVT_ORG = @p_PK2))) and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('AGR')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Umowy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Umowy'    
    
 union    
    
 --umowy    
 select    
 [FileID2] as DOT_CHILD,     
 'Umowy' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('SRW')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'RW' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'RW'    
 union    
 select 'Materiały' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Materiały'    
 union    
 select ASS_CODE+'#'+ASS_ORG as DOT_CHILD, 'Materiały' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+ASS_CODE+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.ST_ASSORT(nolock)    
 inner join dbo.DOCENTITIES(nolock) on DAE_CODE = ASS_CODE+'#'+ASS_ORG where ASS_CODE+'#'+ASS_ORG in (select SRL_ASSORT+'#'+SRL_ORG from dbo.ST_RWLNv(nolock) where SRL_SRWID in (select ROWID from dbo.ST_RW(nolock) where SRW_CODE = @p_PK1 and SRW_ORG = @p_PK2))    
    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'RW' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 union    
    
 select    
 [FileID2] as DOT_CHILD,     
 DAE_CODE as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 3 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = 'ASS' and DAE_CODE in (select SRL_ASSORT+'#'+SRL_ORG from ST_RWLNv(nolock) where SRL_SRWID in (select ROWID from dbo.ST_RW(nolock) where SRW_CODE = @p_PK1 and SRW_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1    
END    
    
    
IF @p_Entity = ('OFF')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select * from (    
  select 'Zapytania ofertowe' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
  from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Zapytania ofertowe'    
  union    
  select 'Dostawcy' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE    
  from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Dostawcy'    
  union    
  select VEN_CODE+'#'+VEN_ORG as DOT_CHILD, 'Dostawcy' as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+VEN_CODE+'</b>' as DOT_DESC, 3 DOT_LEVEL, '' FileID2, '' DAE_CODE    
  from dbo.VENDOR(nolock)    
  inner join dbo.DOCENTITIES(nolock) on DAE_CODE = VEN_CODE+'#'+VEN_ORG where VEN_CODE+'#'+VEN_ORG in (select OFV_VENDOR+'#'+OFV_ORG from OFFVENDORv(nolock) where OFV_OFFID in (select ROWID from dbo.OFFQRY(nolock) where OFF_CODE = @p_PK1 and OFF_ORG = @p_PK2))    
    
    
  union    
    
  --Pracownicy    
  select    
  [FileID2] as DOT_CHILD,     
  'Zapytania ofertowe' as DOT_PARENT,     
  FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
  2 DOT_LEVEL,    
  FileID2,    
  DAE_CODE    
  from dbo.SYFiles (nolock)    
  inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
  where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
  union    
    
  select    
  [FileID2] as DOT_CHILD,     
  DAE_CODE as DOT_PARENT,     
  FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
  3 DOT_LEVEL,    
  FileID2,    
  DAE_CODE    
  from dbo.SYFiles (nolock)    
  inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
  where DAE_ENTITY = 'VEN' and DAE_CODE in (select OFV_VENDOR+'#'+OFV_ORG from OFFVENDORv where OFV_OFFID in (select ROWID from dbo.OFFQRY where OFF_CODE = @p_PK1 and OFF_ORG = @p_PK2)) and isnull(DAE_MN,0) <> -1  )a order by DOT_LEVEL,DOT_CHILD    END    
    
    
IF @p_Entity = ('SIN')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select * from (    
  select 'Inwentaryzacja' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
  from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Inwentaryzacja'    
    
  union    
    
  select    
  [FileID2] as DOT_CHILD,     
  'Inwentaryzacja' as DOT_PARENT,     
  FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
  2 DOT_LEVEL,    
  FileID2,    
  DAE_CODE    
  from dbo.SYFiles (nolock)    
  inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
  where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
 )a order by DOT_LEVEL,DOT_CHILD    
END    
    
IF @p_Entity = ('TOO')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Narzędzia' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Narzędzia'    
    
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Narzędzia' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('PKT')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
    
 select 'Projekty' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Projekty'    
    
 union    
    
 --umowy    
 select    
 [FileID2] as DOT_CHILD,     
 'Projekty' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('STS')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select 'Szablony' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = 'Szablony'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 'Szablony' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
    
END    
    
IF @p_Entity = ('POT')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Protokoły oceny technicznej' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Protokoły oceny technicznej'    
     
	union
	select N'Dokumenty państwowe' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Dokumenty państwowe:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Ekspertyzy' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Ekspertyzy:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Karty gwarancyjne' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Karty gwarancyjne:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Ocena techniczna serwisu' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Ocena techniczna serwisu:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Raporty i analizy' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Raporty i analizy:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Zarządzanie biznesowe' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Zarządzanie biznesowe:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Inna dokumentacja techniczna' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Inna dokumentacja techniczna:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Inne' as DOT_CHILD, N'Protokoły oceny technicznej' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Inne:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE

 
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
	Case DAE_TYPE
	WHEN 'DOKUMENTY' THEN N'Dokumenty państwowe'
	WHEN 'EKSPERTYZY' THEN N'Ekspertyzy'
	WHEN 'KARTY' THEN N'Karty gwarancyjne'
	WHEN 'OCENA' THEN N'Ocena techniczna serwisu'
	WHEN 'RAPORT' THEN N'Raporty i analizy'
	WHEN 'ZARZADZANIE' THEN N'Zarządzanie biznesowe'
	WHEN 'INNA_DOK' THEN N'Inna dokumentacja techniczna'
	WHEN 'INNE' THEN N'Inne'
	ELSE N'Protokoły oceny technicznej'
	END
	as DOT_PARENT,    
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END 


IF @p_Entity = ('CPO')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Centralny Protokół Oceny' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Centralny Protokół Oceny'    
  
	union
	select N'Dokumenty państwowe' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Dokumenty państwowe:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Ekspertyzy' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Ekspertyzy:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Karty gwarancyjne' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Karty gwarancyjne:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Ocena techniczna serwisu' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Ocena techniczna serwisu:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Raporty i analizy' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Raporty i analizy:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Zarządzanie biznesowe' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Zarządzanie biznesowe:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Inna dokumentacja techniczna' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Inna dokumentacja techniczna:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE
	union
	select N'Inne' as DOT_CHILD, N'Centralny Protokół Oceny' as DOT_PARENT, N'<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>Inne:</b>' as DOT_DESC, 2 DOT_LEVEL, '' FileID2, '' DAE_CODE  
  
  
  
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,
 	Case DAE_TYPE
	WHEN 'DOKUMENTY' THEN N'Dokumenty państwowe'
	WHEN 'EKSPERTYZY' THEN N'Ekspertyzy'
	WHEN 'KARTY' THEN N'Karty gwarancyjne'
	WHEN 'OCENA' THEN N'Ocena techniczna serwisu'
	WHEN 'RAPORT' THEN N'Raporty i analizy'
	WHEN 'ZARZADZANIE' THEN N'Zarządzanie biznesowe'
	WHEN 'INNA_DOK' THEN N'Inna dokumentacja techniczna'
	WHEN 'INNE' THEN N'Inne'
	ELSE  N'Centralny Protokół Oceny'
	END     
 as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END  
   
    
IF @p_Entity = ('MOV')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Formularze ruchu' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Formularze ruchu'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Formularze ruchu' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('OT11')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty OT' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty OT'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty OT' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('OT12')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Kompletacja OT' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Kompletacja OT'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Kompletacja OT' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
IF @p_Entity = ('OT21')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty W' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty W'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty W' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
     
 IF @p_Entity in ('OT31', 'OT32', 'OT33')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty MT' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty MT'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty MT' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
     
IF @p_Entity = ('OT40')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty LTS' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty LTS'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty LTS' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
     
 IF @p_Entity = ('OT41')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty LTW' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty LTW'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty LTW' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END    
    
  IF @p_Entity = ('OT42')    
BEGIN    
 set @v_Code = @p_PK1+'#'+@p_PK2    
     
 select N'Dokumenty PL' as DOT_CHILD, null as DOT_PARENT, '<input TYPE="image" SRC="/Images/16x16/Folder.png"> <b>'+Caption+'</b>' as DOT_DESC, 1 DOT_LEVEL, '' FileID2, '' DAE_CODE    
 from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'DOC_TREE' and ObjectID = N'Dokumenty PL'    
     
 union    
    
 --Pracownicy    
 select    
 [FileID2] as DOT_CHILD,     
 N'Dokumenty PL' as DOT_PARENT,     
 FileID2+' <a href="' + '/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(FileID2) + '" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DOT_DESC,    
 2 DOT_LEVEL,    
 FileID2,    
 DAE_CODE    
 from dbo.SYFiles (nolock)    
 inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT     
 where DAE_ENTITY = @p_Entity and DAE_CODE = @v_Code and isnull(DAE_MN,0) <> -1    
END 
GO