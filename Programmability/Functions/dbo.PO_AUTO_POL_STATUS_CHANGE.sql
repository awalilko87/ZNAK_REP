SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- Author:		DG
CREATE FUNCTION [dbo].[PO_AUTO_POL_STATUS_CHANGE]
(
@POT_ROWID int
)
RETURNS nvarchar(max)
AS
BEGIN

declare @result nvarchar(max) =
(
select 'Automatyczna zmiana oceny elementów kompletacji, których składnik główny został oceniony: ' + stuff ((select OBJ_CODE + ', ' from OBJTECHPROTLN a
left join OBJ b on a.POL_OBJID = b.OBJ_ROWID
where POL_TXT06 is not null and POL_STATUS in ('POL_002', 'POL_008') and POL_POTID = @POT_ROWID order by POL_CODE
for xml path ('')),1,0,N'')
)

	RETURN @result

END
GO