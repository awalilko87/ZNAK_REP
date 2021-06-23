SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[DOCNAMESv]
as   
	select 1 as code, N'Protokół odbioru' as [desc]
	union all
 	select 2 as code, N'Akt notarialny' as [desc]
	union all
	select 3 as code, N'Zakup poza magazynem (faktura)' as [desc]
	union all
	select 4 as code, N'Zakup przez magazyn (WZ)' as [desc]
	union all
	select 5 as code, N'Inny dokument' as [desc]
	union all
	select 6 as code, N'n.d.' as [desc]
 
GO