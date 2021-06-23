SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_RdlUserLayout_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
  SELECT Rowid, FormID, SchemaID, SchemaData, UserID
  FROM VS_RdlUserLayout (nolock)
  ORDER BY SchemaID
GO