SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create Procedure [dbo].[CopyGroups]   
 @OldGroupID nvarchar(50),  
 @NewGroupID nvarchar(50),  
 @UserID     nvarchar(50)  
as  
begin  
  
 --if not exists(select null from VS_KPIUSERSGROUP where KPG_GROUPID = @NewGroupID)  
 delete from VS_KPIUSERSGROUP where KPG_GROUPID = @NewGroupID   
  insert into VS_KPIUSERSGROUP  
         (  
       KPG_KPIID,  
       KPG_GROUPID,  
       LastUpdate,  
       UpdateUser,  
       UpdateInfo  
         )  
  select    KPG_KPIID,  
       @NewGroupID,  
       LastUpdate,  
       UpdateUser,  
       UpdateInfo  
  from VS_KPIUSERSGROUP where KPG_GROUPID = @OldGroupID  
 --if not exists(select null from PRVSTA where PST_GROUP = @NewGroupID)  
 delete from PRVSTA where PST_GROUP = @NewGroupID   
  insert into PRVSTA (PST_GROUP,  
       PST_ENTITY,  
       PST_OLDSTATUS,  
       PST_NEWSTATUS,  
       PST_DEFAULT)  
  select    @NewGroupID,  
       PST_ENTITY,  
       PST_OLDSTATUS,  
       PST_NEWSTATUS,  
       PST_DEFAULT  
  from PRVSTA where PST_GROUP = @OldGroupID  
    
 --if not exists(select null from VS_FormFieldProfilesGroup where UserGroupID = @NewGroupID)  
 delete from VS_FormFieldProfilesGroup where UserGroupID = @NewGroupID   
  insert into VS_FormFieldProfilesGroup  
     (  
     FormID,  
     FieldID,  
     GridColIndex,  
     GridColWidth,  
     GridColVisible,  
     LastUpdate,  
     UpdateInfo,  
     GridColCaption,  
     UpdateUser,  
     UserGroupID  
     )  
  select  FormID,  
     FieldID,  
     GridColIndex,  
     GridColWidth,  
     GridColVisible,  
     LastUpdate,  
     UpdateInfo,  
     GridColCaption,  
     UpdateUser,  
     @NewGroupID  
  from VS_FormFieldProfilesGroup where UserGroupID = @OldGroupID  
    
 --if not exists(select null from VS_FormToolbarBtnProfiles where UserGroupID = @NewGroupID)  
 delete from VS_FormToolbarBtnProfiles where UserGroupID = @NewGroupID   
  insert into VS_FormToolbarBtnProfiles  
     (  
     Org,  
     FormID,  
     FieldID,  
     UserGroupID,  
     ReadOnly,  
     LastUpdate,  
     UpdateInfo,  
     UpdateUser  
     )  
  select  Org,  
     FormID,  
     FieldID,  
     @NewGroupID,  
     ReadOnly,  
     LastUpdate,  
     UpdateInfo,  
     UpdateUser  
  from VS_FormToolbarBtnProfiles where UserGroupID = @OldGroupID  
    
 --if not exists(select null from PRVTYPE where PTY_GROUP = @NewGroupID)  
 delete from PRVTYPE where PTY_GROUP = @NewGroupID   
  insert into  PRVTYPE  
     (  
     PTY_GROUP,  
     PTY_ENTITY,  
     PTY_TYPE  
     )  
  select  @NewGroupID,  
     PTY_ENTITY,  
     PTY_TYPE  
  from PRVTYPE where PTY_GROUP = @OldGroupID  
    
 --if not exists(select null from PRVMAG where OPR_GROUP = @NewGroupID)  
 delete from PRVMAG where OPR_GROUP = @NewGroupID  
  insert into PRVMAG (  
       OPR_GROUP,  
       OPR_MAGID,  
       OPR_RW,  
       OPR_ZW,  
       OPR_PR,  
       OPR_RV,  
       OPR_MM_FROM,  
       OPR_MM_TO,  
       OPR_QR,  
       OPR_IT,  
       OPR_DEFAULT  
       )  
  select    @NewGroupID,  
       OPR_MAGID,  
       OPR_RW,  
       OPR_ZW,  
       OPR_PR,  
       OPR_RV,  
       OPR_MM_FROM,  
       OPR_MM_TO,  
       OPR_QR,  
       OPR_IT,  
       OPR_DEFAULT  
  from PRVMAG where  OPR_GROUP = @OldGroupID  
    
 --if not exists(select null from VS_TabRights where TabGroup = @NewGroupID)  
 delete from VS_TabRights where TabGroup = @NewGroupID  
  insert into VS_TabRights(  
        TabGroup,  
        LastUpdate,  
        UpdateInfo,  
        UpdateUser,  
        UserID  
        )  
  select     @NewGroupID,  
        LastUpdate,  
        UpdateInfo,  
        UpdateUser,  
        UserID  
  from VS_TabRights where TabGroup = @OldGroupID  
    
-- if not exists(select null from SYUserMenu where UserID = @NewGroupID)  
 delete from SYUserMenu where UserID = @NewGroupID  
  insert into SYUserMenu(  
        MenuKey,  
        ModuleCode,  
        LastUpdate,  
        UpdateInfo,  
        UpdateUser,  
        UserID,  
        DisableInsert,  
        DisableEdit,  
        DisableDelete  
        )  
  select     old.MenuKey,  
        old.ModuleCode,  
        old.LastUpdate,  
        old.UpdateInfo,  
        old.UpdateUser,  
        @NewGroupID,  
        old.DisableInsert,  
        old.DisableEdit,  
        old.DisableDelete  
  from SYUserMenu  old  
  where old.UserID = @OldGroupID   
    
 --if not exists(select null from PRVORG where POR_GROUP = @NewGroupID)  
 delete from PRVORG where POR_GROUP = @NewGroupID  
  insert into PRVORG(  
       POR_GROUP,  
       POR_ORG,  
       POR_DEFAULT  
       )  
  select    @NewGroupID,  
       POR_ORG,  
       POR_DEFAULT  
  from PRVORG where POR_GROUP = @OldGroupID  
  
  delete from VS_RIGHTS where  UserID = @NewGroupID
  insert into VS_Rights(
					FormID,
					FieldID,
					Cond,
					Rights,
					rReadOnly,
					rVisible,
					rRequire,
					LastUpdate,
					UpdateInfo,
					UpdateUser,
					UserID)
 select 
					FormID,
					FieldID,
					Cond,
					Rights,
					rReadOnly,
					rVisible,
					rRequire,
					LastUpdate,
					UpdateInfo,
					UpdateUser,
					@NewGroupID
 from VS_Rights
 where UserID =  @OldGroupID  
   
   
  
  
end
GO