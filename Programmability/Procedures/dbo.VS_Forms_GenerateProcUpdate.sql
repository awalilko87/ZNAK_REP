SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_GenerateProcUpdate](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

DECLARE @proc nvarchar(3999)
DECLARE @t TABLE(x nvarchar(4000))
DECLARE @si nvarchar
SET @si = char(39)

--SET @proc = '/*****************************************************************************/' + char(13)
--SET @proc = @proc + '/*** PROCEDURE ' + @FormID + '_Update ***/' + char(13)
--SET @proc = @proc + '/*****************************************************************************/' + char(13)
SET @proc = /*@proc +*/ 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N' + @si + '[' + @FormID + '_Update]' + @si + ') AND OBJECTPROPERTY(id, N' + @si + 'IsProcedure' + @si + ') = 1)' + char(13)
SET @proc = @proc + '    DROP PROCEDURE [' + @FormID + '_Update]' + char(13)
SET @proc = @proc + 'GO' + char(13)
SET @proc = @proc + ' ' + char(13)
SET @proc = @proc + 'CREATE PROCEDURE ' + @FormID + '_Update(' + char(13)

DECLARE genFields CURSOR
KEYSET
FOR 
    SELECT FieldName, Is2Dir FROM VS_FormFields WHERE FormID = @FormID AND FieldName <> '' AND NotUse <> 1 AND ISNULL(ExFromWhere, 0) <> 1 AND ISNULL(IsFilter, 0) <> 1

DECLARE @field nvarchar(100)
DECLARE @isOut bit
DECLARE @fieldList nvarchar(3999)
SET @fieldList = ''
DECLARE @fieldValues nvarchar(3999)
SET @fieldValues = ''
DECLARE @fieldUpdate nvarchar(3999)
SET @fieldUpdate = ''
DECLARE @TableName nvarchar(100)
SELECT @TableName = TableName FROM VS_Forms WHERE FormID = @FormID
DECLARE @Count int
SET @Count = 1
DECLARE @org nvarchar(200)

OPEN genFields
FETCH NEXT FROM genFields INTO @field, @isOut
WHILE (@@fetch_status <> -1)
  BEGIN
	SET @org=''+ char(13)
    IF (@@fetch_status <> -2)
    BEGIN
		IF (@Count = 1)
		  SET @proc = @proc + ''
		ELSE
		  SET @proc = @proc + ',' + char(13)
		  
		SET @org = ',' + char(13)
		
		SET @proc = @proc + '    ' + '@' + @field + ' '
		SET @org = @org + '    ' + '@OLD_' + @field + ' '
		
		DECLARE @type nvarchar(50)
			SELECT @type = case DATA_TYPE collate polish_ci_as 
					when 'int' then	DATA_TYPE 
					when 'tinyint' then	DATA_TYPE 
					when 'ntext' then DATA_TYPE 
					when 'text' then 'ntext' 
					when 'datetime' then DATA_TYPE 
					when 'bigint' then DATA_TYPE 
					when 'bit' then DATA_TYPE 
					when 'smallint' then DATA_TYPE 
					when 'image' then DATA_TYPE 
					else 
						case DATA_TYPE collate polish_ci_as when 'varchar' then 'nvarchar' else DATA_TYPE collate polish_ci_as end + '('+convert(varchar(10),isnull(CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION))+  
						case when isnull(NUMERIC_SCALE,-1)>-1 then ',' + Convert(varchar(10),isnull( NUMERIC_SCALE ,'')) else '' 
						end +')'  
								End 
					FROM INFORMATION_SCHEMA.COLUMNS 
					WHERE table_name = @TableName AND COLUMN_NAME = @field
		SET @proc = @proc + ISNULL(@type,'<>') + ' = NULL'
		SET @org = @org + ISNULL(@type,'<>') + ' = NULL'

		IF @isOut is null
			SET @isOut = 0

		IF EXISTS (select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE a, 
						INFORMATION_SCHEMA.TABLE_CONSTRAINTS b 
						where b.constraint_type='PRIMARY KEY' and 
						a.constraint_name = b.constraint_name 
						and a.table_name = @TableName and isnull(a.Column_Name,'NO_PRIMARY') = @field) OR (@isOut = 1)
		BEGIN
		  SET @proc = @proc + ' OUT'
		  SET @org = @org + ' OUT'
		END
		
		--IF (@isOut = 1)
		--BEGIN
		--	SET @proc = @proc + ' OUT'
		--	SET @org = @org + ' OUT'
		--END
		SET @proc = @proc +  @org
		if len(@proc)>100
		BEGIN
			INSERT INTO @t (x) VALUES (@proc)
			SET @proc=''
		END
		IF (@Count > 1)
		BEGIN
			SET @fieldList = @fieldList + ', '
			SET @fieldValues = @fieldValues + ', '
			SET @fieldUpdate = @fieldUpdate + ', '
		END
		SET @fieldList = @fieldList + '[' + @field + ']'  
		SET @fieldValues = @fieldValues + '@' + @field  
		SET @fieldUpdate = @fieldUpdate + '[' + @field + '] = ' + '@' + @field

        SET @Count = @Count + 1
    END 
  FETCH NEXT FROM genFields INTO @field, @isOut
END
CLOSE genFields
DEALLOCATE genFields 

SET @proc = @proc + ', ' + char(13) + '    @_UserID nvarchar(30)'
SET @proc = @proc + ', ' + char(13) + '    @_GroupID nvarchar(20)'
SET @proc = @proc + ', ' + char(13) + '    @_LangID varchar(10)'
SET @proc = @proc + char(13) + ')' + char(13)
SET @proc = @proc + 'AS' + char(13)
SET @proc = @proc + 'BEGIN TRAN ' + char(13)
if len(@proc)>100
BEGIN
	INSERT INTO @t (x) VALUES (@proc)
	SET @proc=''
END

DECLARE genPks CURSOR

KEYSET

FOR

	select isnull(a.Column_Name,'NO_PRIMARY') as [name] from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE a, 
                    INFORMATION_SCHEMA.TABLE_CONSTRAINTS b 
                    where b.constraint_type='PRIMARY KEY' and 
                    a.constraint_name = b.constraint_name 
                    and a.table_name = @TableName
                    order by a.table_name, a.column_name

DECLARE @pk nvarchar(50)
DECLARE @pkEq nvarchar(300)
SET @pkEq = ''
DECLARE @genPksCount int
SET @genPksCount = 1

OPEN genPks
FETCH NEXT FROM genPks INTO @pk
WHILE (@@fetch_status <> -1)
  BEGIN
    IF (@@fetch_status <> -2)
      BEGIN
        SET @proc = @proc + '--IF @' + @pk + ' is null' + char(13)
        SET @proc = @proc + '    --SET @' + @pk + ' = NewID()' + char(13)
        SET @proc = @proc + '--IF @' + @pk + ' =' + @si + @si + char(13)
        SET @proc = @proc + '    --SET @' + @pk + ' = NewID()' + char(13) 
		SET @proc = @proc + '-- SET @'+ @pk + ' = @@IDENTITY' + char(13)
	IF (@genPksCount > 1)
	  SET @pkEq = @pkEq + ' AND '
	SET @pkEq = @pkEq + @pk + ' = @' + @pk
	SET @genPksCount = @genPksCount + 1
      END
	if len(@proc)>100
	BEGIN
		INSERT INTO @t (x) VALUES (@proc)
		SET @proc=''
	END

    FETCH NEXT FROM genPks INTO @pk
  END
CLOSE genPks
DEALLOCATE genPks


SET @proc = @proc + ' ' + char(13)
SET @proc = @proc + 'DECLARE @Msg nvarchar(500), @IsErr bit' + char(13)
SET @proc = @proc + 'SELECT @Msg = '''', @IsErr = 0 ' + char(13)
SET @proc = @proc + ' ' + char(13)
SET @proc = @proc + '/* Error management */' + char(13)
SET @proc = @proc + 'IF @IsErr = 1' + char(13)
SET @proc = @proc + 'BEGIN' + char(13)
SET @proc = @proc + '   SET @Msg = ''<b>Komunikat bledu</b>''' + char(13)
SET @proc = @proc + '   GOTO ERR' + char(13)
SET @proc = @proc + 'END' + char(13)
SET @proc = @proc + ' ' + char(13)

SET @proc = @proc + '/* Generate number' + char(13)
SET @proc = @proc + 'IF 1=1 ' + char(13)
SET @proc = @proc + '  DECLARE @RC int, @Type nvarchar(50), @Pref nvarchar(50), @Suff nvarchar(50), @Number nvarchar(50), @No int' + char(13)
SET @proc = @proc + '  SELECT @Type = ''DOC_TYPE'', @Pref = '''', @Suff='''' /* + CONVERT(nvarchar(4),YEAR(@LOCAL_Date)) */' + char(13)
SET @proc = @proc + '  EXECUTE @RC = [dbo].[VS_GetNumber] @Type, @Pref, @Suff, @Number OUTPUT, @No OUTPUT' + char(13)
SET @proc = @proc + '  /* SET @LOCAL_Number = @Number */' + char(13)
SET @proc = @proc + '  /* SET @LOCAL_No = @No */' + char(13)
SET @proc = @proc + 'END' + char(13)
SET @proc = @proc + '*/' + char(13)

SET @proc = @proc + ' ' + char(13)
SET @proc = @proc + 'IF NOT EXISTS (SELECT * FROM ' + @TableName + ' WHERE ' + (CASE WHEN @pkEq = '' THEN '1=2' ELSE @pkEq END) + ')' + char(13)
SET @proc = @proc + 'BEGIN' + char(13)
SET @proc = @proc + 'INSERT INTO ' + @TableName + '(' + char(13)
SET @proc = @proc + '    ' + @fieldList + '/*, [_UserID], [_GroupID], [_LangID]*/)' + char(13)
SET @proc = @proc + 'VALUES (' + char(13)
SET @proc = @proc + '    ' + @fieldValues + '/*, @_UserID, @_GroupID, @_LangID*/)' + char(13)
SET @proc = @proc + 'END ' + char(13)
SET @proc = @proc + 'ELSE ' + char(13)
SET @proc = @proc + 'BEGIN ' + char(13)
SET @proc = @proc + 'UPDATE ' + @TableName + ' SET' + char(13)
SET @proc = @proc + '    ' + @fieldUpdate + '/*, [_UserID] = @_UserID, [_GroupID] = @_GroupID, [_LangID] = @_LangID*/ ' + char(13)
SET @proc = @proc + '    ' + 'WHERE ' + (CASE WHEN @pkEq = '' THEN '1=2' ELSE @pkEq END) + char(13)
SET @proc = @proc + 'END ' + char(13)
SET @proc = @proc + ' ' + char(13)
SET @proc = @proc + '/* Error managment */' + char(13)
SET @proc = @proc + 'IF @@TRANCOUNT>0 COMMIT TRAN' + char(13)
SET @proc = @proc + '   RETURN' + char(13)
SET @proc = @proc + 'ERR:' + char(13)
SET @proc = @proc + '   IF @@TRANCOUNT>0 ROLLBACK TRAN' + char(13)
SET @proc = @proc + '      RAISERROR(@Msg, 16, 1)' + char(13)
SET @proc = @proc + 'GO ' + char(13)

INSERT INTO @t (x) VALUES (@proc)

SELECT * FROM @t
GO