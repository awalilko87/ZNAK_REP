SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[POP_EMPv]
as
select     
  EMP_ROWID
, EMP_CODE
, EMP_ORG
, EMP_DESC
, EMP_UR
, EMP_MRCCODE = (select MRC_DESC from dbo.MRC (nolock) where MRC_ROWID = EMP_MRCID) 
, EMP_TRADECODE = (SELECT TRD_DESC FROM dbo.TRADE (NOLOCK) WHERE TRD_ROWID = EMP_TRADEID)
, EMP_GROUP_CODE = (SELECT EMG_DESC FROM dbo.EMPGROUP (NOLOCK) WHERE EMG_ROWID = EMP_GROUPID)

from dbo.EMP (nolock)
where isnull(EMP_NOTUSED,0) = 0
 
GO