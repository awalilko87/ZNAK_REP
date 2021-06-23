SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



create view [dbo].[GUS_Valuesv]
as select
GUS_rowid
, GUS_year
, GUS_percent
, (select UserName from SyUsers where UserID = GUS_CREUSER) as GUS_CREUSER
, GUS_CREDATE
, (select UserName from SyUsers where UserID = GUS_UPDUSER) as GUS_UPDUSER
, GUS_UPDDATE
, GUS_TXT01
, GUS_TXT02
, GUS_TXT03
, GUS_TXT04
, GUS_TXT05
, GUS_TXT06
, GUS_NTX01
, GUS_NTX02
, GUS_NTX03
, GUS_DTX01
, GUS_DTX02
 from GUS_Values

GO