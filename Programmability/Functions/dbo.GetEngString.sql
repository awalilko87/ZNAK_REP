SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetEngString] (@p_String nvarchar(100))
returns nvarchar(200)
as
begin

declare @v_String nvarchar(200)

	select @v_String=upper(@p_String);
	set @v_String=replace(@v_String,'ą','a');
	set @v_String=replace(@v_String,'ć','c');
	set @v_String=replace(@v_String,'ę','e');
	set @v_String=replace(@v_String,'ł','l');
	set @v_String=replace(@v_String,'ń','n');
	set @v_String=replace(@v_String,'ó','o');
	set @v_String=replace(@v_String,'ś','s');
	set @v_String=replace(@v_String,'ź','z');
	set @v_String=replace(@v_String,'ż','z');
	set @v_String=replace(ltrim(rtrim(@v_String)),' ','_');
	set @v_String=upper(@v_String)

  return (@v_String)
end


GO