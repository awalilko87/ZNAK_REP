SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_RdlUserLayout_GetByUserID](
@FormID nvarchar(50) = '%',
@UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS
  SELECT Rowid, FormID, SchemaID, UserID, LastUpdate, UpdateInfo, SchemaData, UpdateUser, IsDefault, IsLastPreset
  FROM dbo.VS_RdlUserLayout (nolock)
  WHERE FormID LIKE @FormID AND @UserID like UserID  
  
  UNION ALL
  
  SELECT L.Rowid, L.FormID, L.SchemaID, L.UserID, L.LastUpdate, L.UpdateInfo, L.SchemaData, L.UpdateUser, L.IsDefault, L.IsLastPreset
  FROM dbo.VS_RdlUserLayout L (nolock)
  WHERE L.FormID LIKE @FormID AND L.UserID like @UserID
  AND NOT EXISTS (SELECT null
                  FROM dbo.VS_RdlUserLayout L1 (nolock)
                  WHERE FormID LIKE @FormID AND @UserID like UserID AND L1.Rowid = L.Rowid )
  ORDER BY SchemaID
GO