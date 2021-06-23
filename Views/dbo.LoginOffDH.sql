SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[LoginOffDH] as
select CAST(ZALOGOWANO as date) as Dzien, CAST(ZALOGOWANO as time) as Godzina, '' as 'Ilosc zalogowanych' from Loginoff 
GO