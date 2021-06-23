SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[BRANZAv]
as
select 'MECH' as CODE, 'Mechaniczna, drogi, place, budynki, zbiorniki' as [DESC]
union all
select 'AUTO' as CODE, 'Automatyka przemysłowa' as [DESC]
union all
select 'ELEKTR' as CODE, 'Elektryczna i elektromagnetyczna' as [DESC]
union all
select 'SIECI' as CODE, 'Energetyka, sieci wodne, kanal., turbiny, wentylacja i klima' as [DESC]
union all
select 'BIURO' as CODE, 'Sprzęt biurowy, gastronomia, laboratoria, środki transportu' as [DESC]
union all
select 'KOMP' as CODE, 'Sprzęt komputerowy, drukarki, sieci komputerowe' as [DESC]
union all
select 'MEDIA' as CODE, 'Środki łączności, rzutniki, projektory, audio-video' as [DESC]
union all
select 'KOLEJ' as CODE, 'Lokomotywy, wagony, torowiska, infrastruktura kolejowa' as [DESC]
union all
select 'STRAZ' as CODE, 'Pojazdy gaśnicze, sprzęt ratownictwa i ppoż.' as [DESC]
union all
select 'DETAL' as CODE, 'Stacje paliw (Detal)' as [DESC]
GO