SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetRightsByFormID](
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = null,
	@LangID nvarchar(50) = '%'
)
WITH ENCRYPTION
AS

DECLARE @t TABLE(id int identity(1,1) primary key , x nvarchar(4000))
--ponizsza linia do odkomentowania gdy bedziemy kozytstac?z bazy D7i
--select @UserID = usr_code from r5users WHERE usr_group = @UserID
select @UserID = UserGroupID from SYUsers WHERE UserID = @UserID

Declare @s nvarchar(4000), @f varchar(100), @v nvarchar(4000), @r nvarchar(4000), @q nvarchar(4000)
SET @s = '' SET @r='' SET @r = '' SET @q=''
declare c cursor for 
select f.FieldID, 
	case when r.rReadOnly IS NULL or r.rReadOnly = '' then rz.rReadOnly else r.rReadOnly end RO,
	case when r.rVisible is null or r.rVisible = '' then rz.rVisible else r.rVisible end VI,
	case when r.rRequire is null or r.rRequire = '' then rz.rRequire else r.rRequire end RQ
from dbo.VS_FormFields f 
	left outer join dbo.VS_Rights rz on f.FieldID =  rz.FieldID AND f.FormID= rz.FormID AND rz.UserID='*' AND rz.Cond = ''
			left outer join dbo.VS_Rights r on f.FieldID =  r.FieldID AND f.FormID= r.FormID AND r.UserID=@UserID AND r.Cond = ''
WHERE f.FormID=@FormID AND f.NotUse = 0


INSERT INTO @t(x) VALUES ('SELECT ')
open c
fetch next from c into @f, @r, @v,@q
While @@fetch_status<>-1
BEGIN
	if @f is null set @f=''
	if @r is null set @r=''
	if @v is null set @v=''
	if @q is null set @q=''
	if @s=''
		set @s = '[VISIBLE_' + @f + '] = ('
	else
		set @s = @s + ', [VISIBLE_'+ @f + '] = ('
	if @v=''or @r is null
		set @s = @s + '-1)'
	else
		set @s = @s + @v +')'

	set @s = @s + ', [READONLY_'+ @f + '] = ('
	if @r=''or @r is null
		set @s = @s + '-1)'
	else
		set @s = @s + @r +')'

	set @s = @s + ', [REQUIRE_'+ @f + '] = ('
	if @q=''or @q is null
		set @s = @s + '-1)'
	else
		set @s = @s + @q +')'

	if len(@s)>1000
	begin
		INSERT INTO @t(x) VALUES (@s)
		SET @s = ''
	end
fetch next from c into @f, @r, @v,@q
END
	if len(@s)>0
		INSERT INTO @t(x) VALUES (@s)
--exec (@s)
close c
deallocate c
--print @s

SELECT x FROM @t

GO