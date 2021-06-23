SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_GetButtonRights](
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = null,
	@LangID nvarchar(50) =''
)
WITH ENCRYPTION
AS
DECLARE @t TABLE(x nvarchar(4000))
DECLARE @tb TABLE(btn nvarchar(100),BK NVARCHAR(20))
Insert into @tb  (btn) Values ('NEW')
Insert into @tb (btn) Values ('SAVE')
Insert into @tb (btn) Values ('DELETE')

select @UserID = UserGroupID from SYUsers WHERE UserID = @UserID

Declare @s varchar(8000), @f varchar(100), @r varchar(8000), @v varchar(8000)
SET @s='' SET @r ='' SET @v=''

declare c cursor for 
select f.btn FieldID, 
	case when ru.rReadOnly IS NULL or ru.rReadOnly = '' then ro.rReadOnly else ru.rReadOnly end RO,
    case when ru.rVisible is null or ru.rVisible = '' then ro.rVisible else ru.rVisible end VI
--,*
from @tb f 
	left outer join dbo.VS_Rights ru on f.btn=ru.FieldID AND ru.UserID=@UserID AND ru.FormID = @FormID AND ru.Cond = 'BTN_MAIN'
		left outer join dbo.VS_Rights ro on f.btn=ro.FieldID AND ro.UserID='*' AND ro.FormID = @FormID AND ro.Cond = 'BTN_MAIN'
--WHERE  


INSERT INTO @t(x) VALUES ('SELECT ')
open c
fetch next from c into @f, @r, @v
While @@fetch_status<>-1
BEGIN
	if @f is null set @f=''
	if @r is null set @r=''
	if @v is null set @v=''


	if @s=''
		set @s = '[READONLY_' + @f + '] = ('
	else
		set @s = @s + ', [READONLY_'+ @f + '] = ('
	if @r=''or @r is null
		set @s = @s + '-1)'
	else
		set @s = @s + @r +')'

	set @s = @s + ', [VISIBLE_'+ @f + '] = ('
	if @v=''or @v is null
		set @s = @s + '-1)'
	else
		set @s = @s + @v +')'


	if len(@s)>2000
	begin
		INSERT INTO @t(x) VALUES (@s)
		SET @s = ''
	end
fetch next from c into @f, @r, @v
END
	if len(@s)>0
		INSERT INTO @t(x) VALUES (@s)
--exec (@s)
close c
deallocate c
--print @s

SELECT x FROM @t
GO