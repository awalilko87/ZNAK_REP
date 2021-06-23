SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[KRAJEv]
as
select 'PL' as [code], 'Polska' as [desc]
union all
select 'DE' as [code], 'Niemcy' as [desc]
union all
select 'CZ' as [code], 'Czechy' as [desc]
union all
select 'RU' as [code], 'Rosja' as [desc]
union all
select 'LT' as [code], 'Litwa' as [desc]
union all
select 'SK' as [code], 'Słowacja' as [desc]
union all
select 'UA' as [code], 'Ukraina' as [desc]
GO