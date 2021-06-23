SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- Author:		DG
-- Create date: 2021-02-17
-- =============================================
CREATE FUNCTION [dbo].[PO_Check_OBJ_SETTYPE]
(
@POT_CODE nvarchar(30)
)
RETURNS nvarchar(max)
AS
BEGIN

declare @Conditions table (OBJ_CODE nvarchar(30), OBJ_ROWID int, OBJ_STATUS nvarchar(30), OBJ_NOTUSED int, POT_CODE nvarchar(30), POT_STATUS nvarchar(30),
POL_STATUS nvarchar(30), AST_CODE nvarchar(20), AST_SUBCODE nvarchar(10), AST_SAP_ACTIVE int, STS_SETTYPE nvarchar(30))

insert into @Conditions (OBJ_CODE, OBJ_ROWID, OBJ_STATUS, OBJ_NOTUSED, POT_CODE, POT_STATUS, POL_STATUS, AST_CODE, AST_SUBCODE, AST_SAP_ACTIVE, STS_SETTYPE)
select c.OBJ_CODE, a.POL_OBJID, c.OBJ_STATUS, c.OBJ_NOTUSED, b.POT_CODE, b.POT_STATUS, a.POL_STATUS
, e.AST_CODE, e.AST_SUBCODE, e.AST_SAP_Active, f.STS_SETTYPE
from OBJTECHPROTLN a
left join OBJTECHPROT b on a.POL_POTID = b.POT_ROWID
left join OBJ c on a.POL_OBJID = c.OBJ_ROWID
left join OBJASSET d on c.OBJ_ROWID = d.OBA_OBJID
left join ASSET e on d.OBA_ASTID = e.AST_ROWID
left join STENCIL f on c.OBJ_STSID = f.STS_ROWID
where b.POT_CODE = @POT_CODE
and isnull(c.OBJ_CODE, '') <> ''
and f.STS_SETTYPE in ('KOM', 'EKOM')
and isnull(e.AST_CODE, '') <> '' 
order by OBJ_CODE

--select * from OBJTECHPROTLN where POL_POTID = (select POT_ROWID from OBJTECHPROT where POT_CODE = @POT_CODE)

declare @ASTCODES_TO_CHECK table (id int identity, AST_CODE nvarchar(20), Parent_PO_STA nvarchar(30))
insert into @ASTCODES_TO_CHECK
select * from (
select AST_CODE, Parent_PO_Status = (select top 1 POL_STATUS from @Conditions a where t.AST_CODE = a.AST_CODE and a.AST_SUBCODE = '0000') from
(
select AST_CODE from @Conditions
group by AST_CODE having count(*) > 1
) t
) x where x.Parent_PO_Status in ('POL_002', 'POL_008')


--select 'Składnik kompletacji ' + AST_CODE + '-' + AST_SUBCODE + ' o kodzie ' + OBJ_CODE +
--' jest w statusie "Pozostaje", a składnik główny tej kompletacji wskazano do likwidacji.' from @Conditions where AST_CODE in
--(
--select AST_CODE from @ASTCODES_TO_CHECK
--)
--and AST_SUBCODE <> '0000'
--and isnull(OBJ_NOTUSED, '') = ''
--and POL_STATUS = 'POL_004'
--and OBJ_STATUS = 'OBJ_002'

declare @returnValue nvarchar(max) = ''

if (select count(*) from @ASTCODES_TO_CHECK) > 0
begin
select @returnValue = 'Składnik główny kompletacji wskazany do likwidacji, podskładniki z oceną "Pozostaje": ' + stuff((
select OBJ_CODE + ' (' + AST_CODE + '-' + AST_SUBCODE + '), ' from @Conditions where AST_CODE in
(
select AST_CODE from @ASTCODES_TO_CHECK
)
and AST_SUBCODE <> '0000'
and isnull(OBJ_NOTUSED, '') = ''
and POL_STATUS = 'POL_004'
and OBJ_STATUS = 'OBJ_002'
for xml path ('')),1,0,N'')
end

	RETURN @returnValue

END
GO