SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[VS_RdlUserLayout_LastPreset](
@FormID nvarchar(50) = '%',
@UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS
  SELECT *
  FROM dbo.VS_RdlUserLayout (nolock)
  WHERE IsLastPreset = 1 
  AND FormID LIKE @FormID 
  AND UserID like @UserID 
  ORDER BY SchemaID
GO