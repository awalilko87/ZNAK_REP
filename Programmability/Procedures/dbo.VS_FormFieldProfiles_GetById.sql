SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[VS_FormFieldProfiles_GetById]
@FormID nvarchar(50) = null,
@FieldID nvarchar(30) = null,
@_UserID nvarchar(30) = null
as

select FormID,
       FieldID,
       GridColIndex = cast(GridColIndex as nvarchar(30)),
       GridColWidth = cast(GridColWidth as nvarchar(30)),
       GridColVisible,
       GridColCaption,
       UserID
from dbo.VS_FormFieldProfiles
where FormID like isnull(@FormID,'%')
and FieldID like isnull(@FieldID,'%')
and UserID like isnull(@_UserID,'%')
order by dbo.VS_FormFieldProfiles.GridColIndex asc
GO