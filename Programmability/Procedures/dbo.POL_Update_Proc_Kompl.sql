SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- Author:		DG

CREATE PROCEDURE [dbo].[POL_Update_Proc_Kompl]
@RV_POTID int
, @UserID nvarchar(60)
AS
BEGIN

declare @_GroupID nvarchar(40) = (select top 1 UserGroupID from SyUsers where UserID = @UserID)
declare @checkInfo table
(id int identity, POL_ASSET_CODE nvarchar(20), POL_ASSET_SUBCODE nvarchar(10), OBJ_ROWID int, OBJ_CODE nvarchar(30), POL_STATUS nvarchar(30), STS_SETTYPE nvarchar(30)
, POL_LIKW_TYPE int)


insert into @checkInfo (POL_ASSET_CODE, POL_ASSET_SUBCODE, OBJ_ROWID, OBJ_CODE, POL_STATUS, STS_SETTYPE, POL_LIKW_TYPE)
select 
POL_ASSET_CODE = (select top 1 AST_CODE
			from dbo.ASSET (nolock)
			join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID
			where OBA_OBJID = O.OBJ_ROWID
			and AST_NOTUSED = 0
			order by AST_SUBCODE
			)
,
POL_ASSET_SUBCODE = (select top 1 AST_SUBCODE
			from dbo.ASSET (nolock)
			join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID
			where OBA_OBJID = O.OBJ_ROWID
			and AST_NOTUSED = 0
			order by AST_SUBCODE
			)
, OBJ_ROWID
, OBJ_CODE
, POL_STATUS
, STS_SETTYPE
, POL_LIKW_TYPE
from OBJTECHPROTLN (nolock) poln
left join OBJ (nolock) o on poln.POL_OBJID = o.OBJ_ROWID
left join STENCIL (nolock) st on o.OBJ_STSID = st.STS_ROWID
where
(
POL_POTID = @RV_POTID and ((POL_STATUS in ('POL_002', 'POL_008') and IsNull(POL_BIZ_DEC,0) in (0, 1)) or POL_STATUS = 'POL_007')
and (o.OBJ_GROUPID in (select PVO_OBGID  from PRVOBJ (nolock) where PVO_GROUPID = @_GroupID) or @_GroupID in ('INW','INWA','SA','TDO') )  
)
and st.STS_SETTYPE in ('KOM', 'EKOM')

declare @NewStatuses table (id int identity, POL_ROWID int, AST_CODE nvarchar(20), TargetStatus nvarchar(30), BizDec int, POL_LIKW_TYPE int)

insert into @NewStatuses (POL_ROWID, AST_CODE, TargetStatus, BizDec, POL_LIKW_TYPE)
select POL_ROWID, AST_CODE,
(select top 1 POL_STATUS from @checkInfo x where x.POL_ASSET_CODE = d.AST_CODE and x.POL_ASSET_SUBCODE = '0000') as TargetStatus,
(select top 1 POL_BIZ_DEC from @checkInfo x where x.POL_ASSET_CODE = d.AST_CODE and x.POL_ASSET_SUBCODE = '0000') as BizDec,
(select top 1 POL_LIKW_TYPE from @checkInfo x where x.POL_ASSET_CODE = d.AST_CODE and x.POL_ASSET_SUBCODE = '0000') as POL_LIKW_TYPE
from OBJTECHPROTLN (nolock) a
left join OBJ (nolock) b on a.POL_OBJID = b.OBJ_ROWID
left join OBJASSET (nolock) c on b.OBJ_ROWID = c.OBA_OBJID
left join ASSET (nolock) d on c.OBA_ASTID = d.AST_ROWID
where POL_POTID = @RV_POTID
and AST_CODE in (select distinct POL_ASSET_CODE from @checkInfo where POL_ASSET_SUBCODE = '0000')
and OBJ_NOTUSED <> 1
and AST_NOTUSED <> 1
and POL_OBJID not in (select OBJ_ROWID from @checkInfo)
and POL_STATUS = 'POL_004'
and AST_SUBCODE <> '0000'

declare @cnt int = 1
declare @cntMax int = (select count(*) from @NewStatuses)
declare @currROWID int = null
declare @tarStat nvarchar(30) = null
declare @currASTCODE nvarchar(20) = null
declare @currBizDec int = null
declare @currPOLCODE nvarchar(60) = (select top 1 POT_CODE from OBJTECHPROT where POT_ROWID = @RV_POTID)
declare @currPOLLIKWTYPE int = null

if exists (select 1 from @NewStatuses)
	begin
		while (@cnt <= @cntMax)
			begin
				select @currROWID = POL_ROWID, @tarStat = TargetStatus, @currASTCODE = AST_CODE, @currBizDec = BizDec, @currPOLLIKWTYPE = POL_LIKW_TYPE
				from @NewStatuses where id = @cnt

				update OBJTECHPROTLN set POL_TXT06 = 'Kompletacja: zmiana oceny zgodnie ze składnikiem głównym: ' + @currASTCODE + '-0000', POL_LIKW_TYPE = @currPOLLIKWTYPE,
				POL_STATUS = @tarStat, POL_BIZ_DEC = @currBizDec, POL_UPDDATE = GetDate(), POL_UPDUSER = @UserID, POL_CODE = @currPOLCODE where POL_ROWID = @currROWID

				set @cnt = @cnt + 1
			end --end while
	end --end if exists (select 1 from @NewStatuses)

	if exists (select 1 from OBJTECHPROTLN where POL_POTID = @RV_POTID and POL_STATUS = 'POL_004' and POL_TXT06 like 'Kompletacja: zmiana oceny%')
		begin
			update OBJTECHPROTLN set POL_TXT06 = null where POL_POTID = @RV_POTID and POL_STATUS = 'POL_004' and POL_TXT06 like 'Kompletacja: zmiana oceny%'
		end
END
GO