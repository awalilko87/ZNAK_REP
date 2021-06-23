SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[IE2_ALL_PACZKI] as
select top 99.9999 percent i_DateTime_SHORT, SLOWNIK, COUNT (*) REC_COUNT from  IE2_ALL 
group by i_DateTime_SHORT,SLOWNIK
order by 1 desc
GO