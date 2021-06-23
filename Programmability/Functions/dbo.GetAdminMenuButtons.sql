SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[GetAdminMenuButtons]
(
@p_UserID nvarchar(30)
,@p_MenuKey nvarchar(50)
,@p_GroupID nvarchar(50)
,@p_AppCode nvarchar(50)
)
returns nvarchar(max)
as
begin
	declare @return nvarchar(max)
         
	declare @v_LangID nvarchar(10)
	select @v_LangID = [dbo].[fn_GetLangID] (@p_UserID)

	declare @t table (MenuKey nvarchar(80), MenuCaption nvarchar(4000), GroupKey nvarchar(80), HTTPLink nvarchar(4000), Orders int)

	insert into @t (MenuKey, MenuCaption, GroupKey, HTTPLink, Orders)
	select MenuKey, isnull(Caption, MenuCaption), GroupKey, HTTPLink, Orders
	from SYMenus
	left join VS_LangMSGS on ControlID = MenuKey and [LangID] = @v_LangID
	where GroupKey = @p_MenuKey
	and isnull(IsVisible,0) = 1 and ModuleName = @p_AppCode
	order by Orders,MenuCaption

	SET @return =
	'<head>
	<style type="text/css">
		#tabela {
		border: 0px solid black;
		}
		.td {}
	</style>
	</head>
	<body>'+
	'<table id="tabela" style="width:900px; ">'

	if @p_GroupID='SA'
	begin
		select top 1000 @return = @return +
			'<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="e2-button e2-button-260"  name="k" value="'+isnull(MenuCaption,0)+'" onclick="location.href='''+
			dbo.VS_EncryptLink(HTTPLink)
			+''';return false;" /> </td>'
			+'</tr>'
		from @t
		order by Orders
	end

	if @p_GroupID<>'SA'
	begin
		select top 1000 @return = @return +
			'<tr  style="height: 30px; "><td style="width:260px; "><input type="submit" class="e2-button e2-button-260"  name="k" value="'+isnull(MenuCaption,0)+'" onclick="location.href='''+
			dbo.VS_EncryptLink(HTTPLink)
			+''';return false;" /> </td>'
			+'</tr>'        
		from @t
		where MenuKey in (select MenuKey from VS_SyUsersMenu (nolock) where userID=@p_GroupID and Visible=1)
		order by Orders
	end
	set @return = @return  + '</table></body>'

	return @return   
end
GO