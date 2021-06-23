SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_UpdateDBTypes](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

DECLARE @TableName nvarchar(100)
SELECT @TableName = TableName FROM VS_Forms WHERE FormID = @FormID

DECLARE @ColName varchar(100)
DECLARE @colType varchar(100)
DECLARE @colLen int
DECLARE @colScale int, @colPrec int, @length int
DECLARE @dataType varchar(30)
DECLARE @dataTypeSQL nvarchar(50)

DECLARE updFields CURSOR KEYSET FOR
	SELECT [COLUMN_NAME], [DATA_TYPE], [CHARACTER_MAXIMUM_LENGTH], [NUMERIC_SCALE],
	[NUMERIC_PRECISION] FROM [INFORMATION_SCHEMA].[COLUMNS]
	WHERE [TABLE_NAME] = @TableName
	ORDER BY [ORDINAL_POSITION]

OPEN updFields
 
FETCH NEXT FROM updFields INTO @ColName, @colType, @colLen, @colScale, @colPrec
WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
	BEGIN
		
    SET @dataType = case
		when @colType='datetime' then 'System.DateTime'
		when @colType='nvarchar' then 'System.String'
		when @colType='varchar' then 'System.String'
		when @colType='ntext' then 'System.String'
		when @colType='text' then 'System.String'
		when @colType='numeric' then 'System.Double'
		when @colType='decimal' then 'System.Double'
		when @colType='int' then 'System.Int32'
		when @colType='smallint' then 'System.Int32'
		when @colType='tinyint' then 'System.Int32'
		when @colType='bit' then 'System.Int16'
		else 'String' end
		
	SET @dataTypeSQL = case
		when @colType='datetime' then @colType
		when @colType='nvarchar' then @colType + '(' + convert(nvarchar(10), case when cast(@colLen as nvarchar) = '-1' then 'max' else cast(@colLen as nvarchar) end) + ')'
		when @colType='varchar' then @colType + '(' + convert(nvarchar(10), case when cast(@colLen as nvarchar) = '-1' then 'max' else cast(@colLen as nvarchar) end) + ')'
		when @colType='ntext' then @colType
		when @colType='text' then @colType
		when @colType='numeric' then @colType+ '(' + convert(nvarchar(10), @colPrec) + ',' + convert(nvarchar(10), @colScale) + ')'
		when @colType='decimal' then @colType+ '(' + convert(nvarchar(10), @colPrec) + ',' + convert(nvarchar(10), @colScale) + ')'
		when @colType='int' then @colType
		when @colType='smallint' then @colType
		when @colType='tinyint' then @colType
		when @colType='bit' then @colType
		else '' end

	SET @length = case
		when @colType='datetime' then 0
		when @colType='nvarchar' then case when cast(@colLen as nvarchar) = '-1' then '4000' else cast(@colLen as nvarchar) end
		when @colType='varchar' then case when cast(@colLen as nvarchar) = '-1' then '4000' else cast(@colLen as nvarchar) end
		when @colType='ntext' then 0
		when @colType='text' then 0
		when @colType='numeric' then @colPrec + @colScale + 1
		when @colType='decimal' then @colPrec + @colScale + 1
		when @colType='int' then 0
		when @colType='smallint' then 0
		when @colType='tinyint' then 0
		when @colType='bit' then 1
		else '' end

	UPDATE VS_FormFields SET DataType = @dataType, DataTypeSQL = @dataTypeSQL, [Length] = @length WHERE FormID = @FormID AND FieldID = @ColName

	END

    FETCH NEXT FROM updFields INTO @ColName, @colType, @colLen, @colScale, @colPrec
 END
 
 CLOSE updFields
 DEALLOCATE updFields

GO