SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_RdlUserLayout_GetByID](
@Rowid int
)
WITH ENCRYPTION
AS
  SELECT *
  FROM VS_RdlUserLayout (nolock)
  WHERE Rowid = @Rowid
  ORDER BY SchemaID
GO