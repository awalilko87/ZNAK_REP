SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
CREATE view [dbo].[LIQUIDATION_METHODv]
as
select 1 as [code], N'We własnym zakresie' as [desc]
union
select 2 as [code], N'Firma zewnętrzna' as [desc]
union
select 3 as [code], N'Brak demontażu' as [desc]
union
select 4 as [code], N'W ramach zadania inwestycyjnego' as [desc]
union
select 5 as [code], N'Sprzedaż' as [desc] 
 
GO