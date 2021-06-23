SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fSTS_Rec_FROM_PSP] (@p_FRAG_PSP nvarchar(50), @p_UserID nvarchar(30))
RETURNS @tab TABLE
(
 [STS_ROWID] [int]
,[STS_PSEID] [int]
,[STS_PSE] [int]
,[STS_PSEDESC] [nvarchar](80)
,[STS_SETTYPE] [nvarchar](30)
,[STS_SETTYPEDESC] [nvarchar](80)
,[STS_SIGNED] [smallint]
,[STS_SIGNLOC] [nvarchar](80)
,[STS_VALUE] [numeric](18, 2)
,[STS_CODE] [nvarchar](30)
,[STS_ORG] [nvarchar](30)
,[STS_DESC] [nvarchar](80)
,[STS_NOTE] [nvarchar](max)
,[STS_DATE] [datetime]
,[STS_TIME] [nvarchar](20)
,[STS_STATUS] [nvarchar](30)
,[STS_STATUS_DESC] [nvarchar](80)
,[STS_ICONSTATUS] [nvarchar](80)
,[STS_TYPE] [nvarchar](30)
,[STS_TYPE_DESC] [nvarchar](80)
,[STS_TYPE2] [nvarchar](30)
,[STS_TYPE2_DESC] [nvarchar](80)
,[STS_TYPE3] [nvarchar](30)
,[STS_TYPE3_DESC] [nvarchar](80)
,[STS_RSTATUS] [int]
,[STS_CREUSER] [nvarchar](30)
,[STS_CREUSER_DESC] [nvarchar](80)
,[STS_CREDATE] [datetime]
,[STS_UPDUSER] [nvarchar](30)
,[STS_UPDUSER_DESC] [nvarchar](80)
,[STS_UPDDATE] [datetime]
,[STS_NOTUSED] [int] 
,[STS_ID] [nvarchar](50)
,[STS_GROUPID] [int]
,[STS_GROUP] [nvarchar](80)
,[STS_GROUP_DESC] [nvarchar](80)
,[STS_MANUFACID] [int]
,[STS_MANUFAC] [nvarchar](80)
,[STS_VENDORID] [int]
,[STS_PERSON] [nvarchar](80)
,[STS_PERSON_DESC] [nvarchar](80)
,[STS_PARTSLISTID] [int]
,[STS_PARTSLIST] [nvarchar](80)
,[STS_LOCID] [int]
,[STS_LOC] [nvarchar](80)
,[STS_CATALOGNO] [nvarchar](30)
,[STS_YEAR] [nvarchar](30)
,[STS_SERIAL] [nvarchar](30)
,[STS_DEFAULT_KST] [nvarchar](30)
,[STS_DEFAULT_KST_DESC] [nvarchar](80)
,[STS_ACCOUNTID] [int]
,[STS_ACCOUNT] [nvarchar](80)
,[STS_COSTCODEID] [int]
,[STS_COSTCODE] [nvarchar](30)
,[STS_MRCID] [int]
,[STS_MRC] [nvarchar](80)
,[STS_TXT01] [nvarchar](80)
,[STS_TXT02] [nvarchar](80)
,[STS_TXT03] [nvarchar](80)
,[STS_TXT04] [nvarchar](80)
,[STS_TXT05] [nvarchar](80)
,[STS_TXT06] [nvarchar](80)
,[STS_TXT07] [nvarchar](80)
,[STS_TXT08] [nvarchar](80)
,[STS_TXT09] [nvarchar](80)
,[STS_NTX01] [numeric](24, 6)
,[STS_NTX02] [numeric](24, 6)
,[STS_NTX03] [numeric](24, 6)
,[STS_NTX04] [numeric](24, 6)
,[STS_NTX05] [numeric](24, 6)
,[STS_COM01] [ntext]
,[STS_COM02] [ntext]
,[STS_DTX01] [datetime]
,[STS_DTX02] [datetime]
,[STS_DTX03] [datetime]
,[STS_DTX04] [datetime]
,[STS_DTX05] [datetime]
,[STS_AUTO_PSP] [nvarchar](30)
)
as
begin

declare @sts_rowid int = NULL
DECLARE @v_FRAG_PSP nvarchar(50)

SELECT @v_FRAG_PSP = CASE WHEN SUBSTRING(@p_FRAG_PSP,1,1) LIKE '[0-9]'
						THEN RIGHT(@p_FRAG_PSP, LEN(@p_FRAG_PSP) - (charindex('/', @p_FRAG_PSP)))
						ELSE RIGHT(@p_FRAG_PSP, LEN(@p_FRAG_PSP) - (charindex('/',@p_FRAG_PSP,charindex('/',@p_FRAG_PSP)+1))) END
			
	select top 1 @sts_rowid = p.STS_ROWID from [dbo].[STENCIL_PSP] (nolock) p where @v_FRAG_PSP like '%'+p.PSP_CODE+'%'

	if @sts_rowid is null or @sts_rowid = ''

		insert into @tab
		SELECT
	 [STS_ROWID] 
,[STS_PSEID] 
,[STS_PSE] 
,[STS_PSEDESC] 
,[STS_SETTYPE] 
,[STS_SETTYPEDESC] 
,[STS_SIGNED] 
,[STS_SIGNLOC]
,[STS_VALUE] 
,[STS_CODE] 
,[STS_ORG] 
,[STS_DESC] 
,[STS_NOTE] 
,[STS_DATE] 
,[STS_TIME] 
,[STS_STATUS] 
,[STS_STATUS_DESC]
,[STS_ICONSTATUS] 
,[STS_TYPE] 
,[STS_TYPE_DESC] 
,[STS_TYPE2] 
,[STS_TYPE2_DESC] 
,[STS_TYPE3] 
,[STS_TYPE3_DESC] 
,[STS_RSTATUS] 
,[STS_CREUSER] 
,[STS_CREUSER_DESC] 
,[STS_CREDATE] 
,[STS_UPDUSER] 
,[STS_UPDUSER_DESC] 
,[STS_UPDDATE] 
,[STS_NOTUSED] 
,[STS_ID] 
,[STS_GROUPID] 
,[STS_GROUP]
,[STS_GROUP_DESC]
,[STS_MANUFACID] 
,[STS_MANUFAC] 
,[STS_VENDORID] 
,[STS_PERSON]
,[STS_PERSON_DESC] 
,[STS_PARTSLISTID] 
,[STS_PARTSLIST] 
,[STS_LOCID] 
,[STS_LOC] 
,[STS_CATALOGNO] 
,[STS_YEAR] 
,[STS_SERIAL] 
,[STS_DEFAULT_KST] 
,[STS_DEFAULT_KST_DESC] 
,[STS_ACCOUNTID] 
,[STS_ACCOUNT] 
,[STS_COSTCODEID] 
,[STS_COSTCODE] 
,[STS_MRCID] 
,[STS_MRC] 
,[STS_TXT01] 
,[STS_TXT02] 
,[STS_TXT03] 
,[STS_TXT04] 
,[STS_TXT05] 
,[STS_TXT06] 
,[STS_TXT07] 
,[STS_TXT08] 
,[STS_TXT09] 
,[STS_NTX01] 
,[STS_NTX02] 
,[STS_NTX03] 
,[STS_NTX04] 
,[STS_NTX05] 
,[STS_COM01] 
,[STS_COM02] 
,[STS_DTX01] 
,[STS_DTX02] 
,[STS_DTX03] 
,[STS_DTX04] 
,[STS_DTX05] 
,[STS_AUTO_PSP]
		--, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_REFRESH'))
		--, [TLB_ADDNEW_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_ADDNEW'))
		--, [TLB_DELETE_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_DELETE'))
		--, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_SAVE'))
		--, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_PRINT'))
		--, [TLB_COPYREC_RIGHT] = (select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_COPYREC'))
		--, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_PREV'))
		--, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_NEXT'))

			FROM [dbo].[STENCILv] (NOLOCK) 
			WHERE 1 = 1
			and STS_STATUS = 'STS_001'
	else

		insert into @tab
		SELECT
		   [STS_ROWID] 
,[STS_PSEID] 
,[STS_PSE] 
,[STS_PSEDESC] 
,[STS_SETTYPE] 
,[STS_SETTYPEDESC] 
,[STS_SIGNED] 
,[STS_SIGNLOC]
,[STS_VALUE] 
,[STS_CODE] 
,[STS_ORG] 
,[STS_DESC] 
,[STS_NOTE] 
,[STS_DATE] 
,[STS_TIME] 
,[STS_STATUS] 
,[STS_STATUS_DESC]
,[STS_ICONSTATUS] 
,[STS_TYPE] 
,[STS_TYPE_DESC] 
,[STS_TYPE2] 
,[STS_TYPE2_DESC] 
,[STS_TYPE3] 
,[STS_TYPE3_DESC] 
,[STS_RSTATUS] 
,[STS_CREUSER] 
,[STS_CREUSER_DESC] 
,[STS_CREDATE] 
,[STS_UPDUSER] 
,[STS_UPDUSER_DESC] 
,[STS_UPDDATE] 
,[STS_NOTUSED] 
,[STS_ID] 
,[STS_GROUPID] 
,[STS_GROUP]
,[STS_GROUP_DESC]
,[STS_MANUFACID] 
,[STS_MANUFAC] 
,[STS_VENDORID] 
,[STS_PERSON]
,[STS_PERSON_DESC] 
,[STS_PARTSLISTID] 
,[STS_PARTSLIST] 
,[STS_LOCID] 
,[STS_LOC] 
,[STS_CATALOGNO] 
,[STS_YEAR] 
,[STS_SERIAL] 
,[STS_DEFAULT_KST] 
,[STS_DEFAULT_KST_DESC] 
,[STS_ACCOUNTID] 
,[STS_ACCOUNT] 
,[STS_COSTCODEID] 
,[STS_COSTCODE] 
,[STS_MRCID] 
,[STS_MRC] 
,[STS_TXT01] 
,[STS_TXT02] 
,[STS_TXT03] 
,[STS_TXT04] 
,[STS_TXT05] 
,[STS_TXT06] 
,[STS_TXT07] 
,[STS_TXT08] 
,[STS_TXT09] 
,[STS_NTX01] 
,[STS_NTX02] 
,[STS_NTX03] 
,[STS_NTX04] 
,[STS_NTX05] 
,[STS_COM01] 
,[STS_COM02] 
,[STS_DTX01] 
,[STS_DTX02] 
,[STS_DTX03] 
,[STS_DTX04] 
,[STS_DTX05] 
,[STS_AUTO_PSP]
		--, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_REFRESH'))
		--, [TLB_ADDNEW_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_ADDNEW'))
		--, [TLB_DELETE_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_DELETE'))
		--, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_SAVE'))
		--, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_PRINT'))
		--, [TLB_COPYREC_RIGHT] = (select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_COPYREC'))
		--, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_PREV'))
		--, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] (STS_ORG, @p_FID, @p_UserID, N'TLB_NEXT'))

			FROM [dbo].[STENCILv] (NOLOCK) 
			WHERE 1 = 1
			and STS_STATUS = 'STS_001'
			and STS_ROWID IN (select p.STS_ROWID from [dbo].[STENCIL_PSP] p where @v_FRAG_PSP like '%'+p.PSP_CODE+'%')


return
end


GO