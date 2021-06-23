SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetRightsByTabGRP](
    @TabGroup nvarchar(50) = '%',
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = null
)
WITH ENCRYPTION
AS
DECLARE @t TABLE(id int identity(1,1) primary key , x nvarchar(4000))
DECLARE @tg nvarchar(50)

SELECT @UserID = UserGroupID FROM SYUsers WHERE UserID = @UserID

DECLARE @s nvarchar(4000), @f varchar(400), @v varchar(400), @r varchar(400)
SET @s = '' SET @r=''

DECLARE c CURSOR FOR 

SELECT DISTINCT t.TabName, case when ru.rReadOnly IS NULL or ru.rReadOnly = '' then ra.rReadOnly else ru.rReadOnly end READONLY,
 case when ru.rVisible is null or ru.rVisible = '' then ra.rVisible else ru.rVisible end VISIBLE
FROM dbo.VS_Tabs t 
	left outer join dbo.VS_Rights ra on t.TabName = ra.FieldID AND t.MenuID = ra.FormID AND ra.UserID = '*' AND ra.Cond = @FormID 
			left outer join dbo.VS_Rights ru on t.TabName = ru.FieldID AND t.MenuID = ru.FormID AND ru.UserID = @UserID AND ru.Cond = @FormID
WHERE t.MenuID = @TabGroup

INSERT INTO @t(x) VALUES ('SELECT ')
OPEN c
FETCH NEXT FROM c INTO @f, @r, @v
WHILE @@fetch_status <> -1
BEGIN
	if @f is null set @f=''
	if @r is null set @r=''
	if @v is null set @v=''
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

	if len(@s)>1000
	BEGIN
		INSERT INTO @t(x) VALUES (@s)
		SET @s = ''
	END
FETCH NEXT FROM c INTO @f, @r, @v
END
	if len(@s)>0
		INSERT INTO @t(x) VALUES (@s)
CLOSE c
DEALLOCATE c

SELECT x FROM @t

GO