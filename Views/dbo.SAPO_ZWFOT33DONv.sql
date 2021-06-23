﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT33DONv]
as
select 
ANLN2 = isnull(OT33DON_ANLN2,''),
TXT50 = isnull(OT33DON_TXT50,''),
WARST = convert(decimal(13,2),Replace(convert(nvarchar,OT33DON_WARST),',','.')), 
NDJARPER = isnull(OT33DON_NDJARPER,0),
MTOPER = isnull(OT33DON_MTOPER,''),
ANLN1_DO = isnull(OT33DON_ANLN1_DO,''),
ANLN2_DO = isnull(OT33DON_ANLN2_DO,''),
ANLKL_DO = isnull(OT33DON_ANLKL_DO,''),
KOSTL_DO = isnull(OT33DON_KOSTL_DO,''),
UZYTK_DO = isnull(OT33DON_UZYTK_DO,''),
PRAC_DO = isnull(OT33DON_PRAC_DO,0),
PRCNT_DO = isnull(OT33DON_PRCNT_DO,0),
WARST_DO = isnull(OT33DON_WARST_DO,0.00),
TXT50_DO = isnull(OT33DON_TXT50_DO,''),
NDPER_DO = isnull(OT33DON_NDPER_DO,0),
CHAR_DO = isnull(OT33DON_CHAR_DO,''),
BELNR = isnull(OT33DON_BELNR,''),
	
OT33DON_ROWID,
OT33DON_ZMT_ROWID,
OT33DON_OT33ID
from dbo.SAPO_ZWFOT33DON (nolock) 
inner join dbo.ZWFOTDON on OTD_ROWID = OT33DON_ZMT_ROWID and OTD_NOTUSED = 0
GO