SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[VOIVODESHIPv]
as   
	select 'DS' as code, 'woj. dolnośląskie (Wrocław)' as [desc]
	union all
	select 'KP', 'woj. kujawsko-pomorskie (Bydgoszcz - Toruń)'
	union all
	select 'LU', 'woj. lubelskie (Lublin)'
	union all
	select 'LB', 'woj. lubuskie (Gorzów Wlkp - ZG)'
	union all
	select 'LO', 'woj. łódzkie (Łódź)'
	union all
	select 'MA', 'woj. mazowieckie (Warszawa)'
	union all
	select 'MP', 'woj. małopolskie (Kraków)'
	union all
	select 'OP', 'woj. opolskie (Opole)'
	union all
	select 'PK', 'woj. podkarpackie (Rzeszów)'
	union all
	select 'PL', 'woj. podlaskie (Białystok)'
	union all
	select 'PM', 'woj. pomorskie (Gdańsk)'
	union all
	select 'SL', 'woj. śląskie (Katowice)'
	union all
	select 'SK', 'woj. świętokrzyskie (Kielce)'
	union all
	select 'WM', 'woj. warmińsko-mazurskie (Olsztyn)'
	union all
	select 'WP', 'woj. wielkopolskie (Poznań)'
	union all
	select 'ZP', 'woj. zachodniopomorskie (Szczecin)'
 
GO