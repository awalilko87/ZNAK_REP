SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE view [dbo].[DOCUPLOADv] as
select 
	[FileID2] as [FileID2], 
	[FileName] as [FileName], 
	'' as [FileCode], 
	[FileID2] as [Description], 
	'' as PK1,
	'' as PK2,
	'' as PK3,
	0 as CopyToWO,
	0 as CopyToPO,
	'' as ENTITY,
	'' AS [DAE_TYPE],
	'' AS [DAE_TYPE2],
	'' AS [DAE_TYPE3],
	'' AS [DAE_RSTATUS],
	'' AS [DAE_CREUSER],
	'' AS [DAE_CREDATE],
	'' AS [DAE_UPDUSER],
	'' AS [DAE_UPDDATE],
	'' AS [DAE_NOTUSED],
	'' AS [DAE_ID],
	'' AS [DAE_COPYTOWO],
	'' AS [DAE_COPYTOPO],
	'' AS [DAE_SQLIDENTITY],
	'' AS [DAE_MN],
	'' AS [DAE_TXT01],
	'' AS [DAE_TXT02],
	'' AS [DAE_TXT03],
	'' AS [DAE_TXT04],
	'' AS [DAE_TXT05],
	'' AS [DAE_TXT06],
	'' AS [DAE_TXT07],
	'' AS [DAE_TXT08],
	'' AS [DAE_TXT09],
	'' AS [DAE_TXT10],
	'' AS [DAE_TXT11],
	'' AS [DAE_TXT12],
	'' AS [DAE_NTX01],
	'' AS [DAE_NTX02],
	'' AS [DAE_NTX03],
	'' AS [DAE_NTX04],
	'' AS [DAE_NTX05],
	'' AS [DAE_COM01],
	'' AS [DAE_COM02],
	'' AS [DAE_DTX01],
	'' AS [DAE_DTX02],
	'' AS [DAE_DTX03],
	'' AS [DAE_DTX04],
	'' AS [DAE_DTX05] 
from dbo.SYFiles (nolock)

GO