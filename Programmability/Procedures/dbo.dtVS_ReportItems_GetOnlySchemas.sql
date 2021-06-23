SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[dtVS_ReportItems_GetOnlySchemas]
WITH ENCRYPTION
AS
  declare @t table(schemat nvarchar(30), rowid int)

  insert into @t(schemat, rowid)
  select distinct s.[schema],
  rowid = (select top 1 r.rowid from VS_ReportItems r where r.[schema] = s.[schema])
  from VS_ReportItems s (nolock)
  
  select r.* from VS_ReportItems r (nolock)
  where exists (select t.rowid from @t t where t.rowid = r.rowid)
GO