SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[VS_AttachReport](
@FormID nvarchar(50),
@UserID nvarchar(30),
@SessionID nvarchar(50),
@FileID nvarchar(50),
@KeyName nvarchar(255),
@KeyValues nvarchar(255))

as
set nocount on
declare @Keys table(rowid int identity(1,1), keyname nvarchar(30))
declare @KVal table(rowid int identity(1,1), keyval nvarchar(255))
declare @Entity nvarchar(30)

select @Entity = TablePrefix from dbo.VS_Forms where FormID = @FormID

DECLARE @NextString NVARCHAR(40)
DECLARE @Pos INT
DECLARE @NextPos INT
DECLARE @String NVARCHAR(40)
DECLARE @Delimiter NVARCHAR(40)

SET @String = @KeyName;
SET @Delimiter = ';'
SET @String = @String + @Delimiter
SET @Pos = charindex(@Delimiter,@String)

WHILE (@pos <> 0)
BEGIN
	SET @NextString = substring(@String,1,@Pos - 1)
	INSERT INTO @Keys(keyname)
	SELECT @NextString
	SET @String = substring(@String,@pos+1,len(@String))
	SET @pos = charindex(@Delimiter,@String)
END 

SET @String = @KeyValues;
SET @Delimiter = ';'
SET @String = @String + @Delimiter
SET @Pos = charindex(@Delimiter,@String)

WHILE (@pos <> 0)
BEGIN
	SET @NextString = substring(@String,1,@Pos - 1)
	INSERT INTO @KVal(keyval)
	SELECT @NextString
	SET @String = substring(@String,@pos+1,len(@String))
	SET @pos = charindex(@Delimiter,@String)
END 

declare @param_declare nvarchar(4000)
declare @param_val nvarchar(4000)
declare @count int
declare @licznik int

set @param_declare = ''
set @param_val = ''
select @count = count(*) from @Keys
set @licznik = 1

while @licznik < @count begin
  select @param_declare = @param_declare + ', @'
  select @param_declare = @param_declare + isnull(keyname,'') from @Keys where rowid = @licznik
  select @param_declare = @param_declare + ' nvarchar(255)'
  
  select @param_val = @param_val + ', @'
  select @param_val = @param_val + isnull(keyname,'') from @Keys where rowid = @licznik
  select @param_val = @param_val + ' = '''
  select @param_val = @param_val + isnull(keyval,'') from @KVal where rowid = @licznik
  select @param_val = @param_val + ''''
  select @licznik = @licznik + 1
end

select @param_declare = substring(@param_declare, 2, len(@param_declare))
select @param_val = substring(@param_val, 2, len(@param_val))

select @param_declare = @param_declare + ', @FileID nvarchar(50)'
select @param_val = @param_val + ', @FileID = ''' + @FileID + ''''

select @param_declare = @param_declare + ', @Entity nvarchar(50)'
select @param_val = @param_val + ', @Entity = ''' + @Entity + ''''

declare @query nvarchar(4000)

begin try
	if @Entity = 'EVT' begin
	  select @query = 'sp_executesql N''insert into dbo.DOCENTITIES(DAE_DOCUMENT, DAE_ENTITY, DAE_CODE, DAE_TYPE) SELECT top 1 @FileID, @Entity, evt_code + ''''#'''' + evt_org, null from dbo.EVT where EVT_ID = @EVT_ID'', N''' + @param_declare + ''', ' + @param_val
	end
	execute sp_executesql @query
end try
begin catch
	declare @err nvarchar(max)
	select @err = ERROR_MESSAGE() + ' ' + @param_val
	raiserror('%s', 16, 1, @err)
	return 1
end catch

return 0


/* KONIEC Procedura VS_AttachReport*/
GO