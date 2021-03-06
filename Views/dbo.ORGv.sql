SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ORGv]
AS
SELECT 
  ORG_CODE
, ORG_DESC
, ORG_STATUS
, ORG_DEFAULTVEN
, ORG_FONTCOLOR
, ORG_COLOR
, ORG_RSTATUS
, ORG_NOTUSED
, ORG_ORDER
, ORG_DEFAULT
, ORG_MODULE
, ORG_CITY
, ORG_NIP
, ORG_STREET
, ORG_REGON
, ORG_ZIP
, ORG_BANKNOM
, ORG_AXCODE
, ORG_LOGO
, ORG_LOGO_IMG = (select top 1 img from SYFiles where FileID2 = ORG_LOGO)
FROM dbo.ORG (nolock)



GO