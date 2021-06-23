SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE view [dbo].[MOB_FormRelationsv]
as
SELECT 
      [lp]--=row_number() over(partition by [rowid] order by [rowid])
      ,[msformguid]
	  ,[msformguid_desc] = (select top 1 caption from mforms where rowguid = [msformguid])
      ,[slformguid]
      ,[slformguid_desc] = (select top 1 caption from mforms where rowguid = [slformguid])
      ,[mskey]
      ,[slkey]
      ,[caption]
      ,[rowid]
      ,[tabname]
      ,[sltabname]
      ,[wizardguid]
      ,[wizardguid_short] = left([wizardguid] ,4)
      ,[parentheader]
      ,[beforeaction]
      ,[afteraction]
      ,[orgguid]
      ,[orgguid_desc] = (select top 1 code from morg where rowguid = [orgguid])
  FROM [dbo].[MFormRelations]
  
 -- select * from [MFormRelations]


GO