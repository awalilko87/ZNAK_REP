SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--exec VS_Forms_UpdateStructure @FormID=N'EMP_RC'

create view [dbo].[EMPv]
as
select 
 EMP.EMP_ROWID
,EMP_CODE --Kod pracownika 
,EMP_ORG
,EMP_DESC --Imię i Nazwisko
,EMP_NOTE
,EMP_DATE --Data urodzenia -- datetime
,EMP_STATUS
,EMP_STATUS_DESC = sta.DES_TEXT
,EMP_TYPE
,EMP_TYPE_DESC = typ1.DES_TEXT
,EMP_TYPE2
,EMP_TYPE2_DESC = typ2.DES_TEXT
,EMP_TYPE3
,EMP_TYPE3_DESC = typ3.DES_TEXT
,EMP_RSTATUS
,EMP_CREUSER
,EMP_CREUSER_DESC = dbo.UserName(EMP_CREUSER)
,EMP_CREDATE
,EMP_UPDUSER
,EMP_UPDUSER_DESC = dbo.UserName(EMP_UPDUSER)
,EMP_UPDDATE
,EMP_NOTUSED
,EMP_ID
,EMP_ENGAGE --Data zatrudnienia -- datetime
,EMP_MRCID  --Wydział ID -->> do tabeli z wydziałami
,EMP_MRCCODE = MRC_CODE
,EMP_MRCDESC = MRC_DESC 
,EMP_COSTCODEID
,EMP_MAGID
,EMP_PHONE   --Telefon domowy 
,EMP_EMAIL
,EMP_TRADEID --Stanowisko -->> do tabeli ze stanowiskiami
,EMP_TRADECODE = TRD_CODE
,EMP_TRADEDESC = TRD_DESC
,EMP_GROUPID --Brygada -->> do tabeli z grupami
,EMP_GROUP_CODE = EMG_CODE
,EMP_GROUP_DESC = EMG_DESC
,TXT01 --Zawód wyuczony
,TXT02 --Telefon komórkowy prywatny  
,TXT03 --Telefon komórkowy praca
,TXT04 --Telefon praca stacjonarny
,TXT05 --Telefon praca wewnętrzny
,TXT06 --Adres zamieszkania
,TXT07 --Forma zatrudnienia
,TXT08
,TXT09
,NTX01 --Stawka
,NTX02, NTX03, NTX04, NTX05
,COM01, COM02
,DTX01 --Data badań lekarskich -- datetime
,DTX02 --Ważność badań lekarskich  -- datetime
,DTX03 --Ważność szkolenia BHP  -- datetime
,DTX04 --Termin ważności uprawnień -- datetime
,DTX05
,EMP_UR
,EMP_LANGID = LangID
from dbo.EMP (nolock)
cross join VS_Langs
left join dbo.DESCRIPTIONS_EMPv sta(nolock) on sta.DES_TYPE = 'STAT' and sta.DES_CODE = EMP_STATUS and sta.DES_LANGID = LangID
left join dbo.DESCRIPTIONS_EMPv typ1(nolock) on typ1.DES_TYPE = 'TYP1' and typ1.DES_CODE = EMP_TYPE and typ1.DES_LANGID = LangID
left join dbo.DESCRIPTIONS_EMPv typ2(nolock) on typ2.DES_TYPE = 'TYP2' and typ2.DES_CODE = EMP_TYPE+'#'+EMP_TYPE2 and typ2.DES_LANGID = LangID
left join dbo.DESCRIPTIONS_EMPv typ3(nolock) on typ3.DES_TYPE = 'TYP3' and typ3.DES_CODE = EMP_TYPE+'#'+EMP_TYPE2+'#'+EMP_TYPE3 and typ3.DES_LANGID = LangID
left join dbo.EMPGROUP(nolock) on EMPGROUP.EMG_ROWID = EMP_GROUPID
left join dbo.TRADE t(nolock) on t.TRD_ROWID = EMP_TRADEID
left join dbo.MRC m(nolock) on m.MRC_ROWID = EMP_MRCID

GO