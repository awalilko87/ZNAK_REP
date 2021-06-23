SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_UpdateStructure](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

DECLARE @TableName nvarchar(100)
SELECT @TableName = TableName FROM VS_Forms WHERE FormID = @FormID
declare @TableID int
select @TableID=id from dbo.sysobjects where name=@TableName
create table #t(ColumnName nvarchar(50))

DECLARE checkFields CURSOR

KEYSET

FOR 
    SELECT NAME FROM syscolumns WHERE id=@TableID

DECLARE @field nvarchar(100)

OPEN checkFields
FETCH NEXT FROM checkFields INTO @field
WHILE (@@fetch_status <> -1)
  BEGIN
    IF (@@fetch_status <> -2)
      BEGIN
	IF NOT EXISTS (SELECT * FROM VS_FormFields WHERE FormID = @FormID AND FieldID = @field)
	  BEGIN
	    INSERT INTO #t(ColumnName) VALUES (@field)
	  END
      END  
    FETCH NEXT FROM checkFields INTO @field
  END
CLOSE checkFields
DEALLOCATE checkFields 

DECLARE @ci varchar
SET @ci=char(39)
 
DECLARE test_cursor CURSOR
 
KEYSET
 
FOR
    SELECT * FROM #t

  
 DECLARE @ColName varchar(100)
 DECLARE @colType varchar(100)
 DECLARE @colLen int
 DECLARE @isKey bit
 DECLARE @colOrder int  
 DECLARE @colScale int, @colPrec int, @colDef nvarchar(100), @length int

 declare @ctrlType varchar(30)
 declare @ctrlType2 varchar(30)
 declare @dataTable varchar(30)
 declare @dataType varchar(30)
 declare @RequireQuery varchar(30)
set @RequireQuery=''
 declare @VisibleQuery varchar(30)
set @VisibleQuery=''
 declare @ReadOnlyQuery varchar(30)
set @ReadOnlyQuery=''
 declare @ValidateQuery varchar(255)
set @ValidateQuery=''
 declare @Tooltip varchar(30)
set @Tooltip=''
 declare @GridPk bit
set @GridPk=0
 declare @Visible bit
set @Visible=1
 declare @GridColIndex bit
set @GridColIndex=1 
declare @GridColWidth int
set @GridColWidth=0
 declare @NotUse bit
set @NotUse=1
 declare @Require bit
Declare @AllowSort bit, @AllowFilter bit
set @AllowSort = 1
set @AllowFilter = 1
declare @DisplayGridFormat nvarchar(50)
 set @DisplayGridFormat=''
DECLARE @dataTypeSQL nvarchar(50)

declare @StartNoRow int
SELECT TOP 1 @StartNoRow = NoRow FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoRow DESC
declare @StartNoColumn int
SELECT TOP 1 @StartNoColumn = NoColumn FROM VS_FormFields WHERE FormID = @FormID AND NoRow = @StartNoRow ORDER BY NoColumn DESC
declare @ColumnCount int
SELECT TOP 1 @ColumnCount = NoColumn FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoColumn DESC
declare @NoColumn int
SET @NoColumn = 1
declare @NoRow int
SET @NoRow = 1

IF (@ColumnCount > @StartNoColumn)
  BEGIN
    SET @NoColumn = @StartNoColumn + 1
    SET @NoRow = @StartNoRow
  END
ELSE IF (@ColumnCount = @StartNoColumn)
    BEGIN
      SET @NoColumn = 1
      SET @NoRow = @StartNoRow + 1
    END

declare @IsPK int
SET @IsPK=0
DECLARE @NoCustomize bit
DECLARE @AllowReportParam bit

OPEN test_cursor
 
 
FETCH NEXT FROM test_cursor INTO @ColName
 WHILE (@@fetch_status <> -1)
 BEGIN
       IF (@@fetch_status <> -2)
	BEGIN
        SELECT @colType=[DATA_TYPE], @colLen=[CHARACTER_MAXIMUM_LENGTH], @colScale=[NUMERIC_SCALE],
			@colPrec=[NUMERIC_PRECISION], @colDef=[COLUMN_DEFAULT], @colOrder=[ORDINAL_POSITION]
			FROM [INFORMATION_SCHEMA].[COLUMNS]
			WHERE [TABLE_NAME] = @TableName AND [COLUMN_NAME] = @ColName


--		select @colType=typ.name, @colLen=col.prec, @isNullable=col.isnullable, @colOrder=colorder from dbo.sysobjects tbl
--            left join dbo.syscolumns col on tbl.id=col.id
--            left join dbo.systypes typ on col.xtype=typ.xtype and col.xusertype=typ.xusertype
--            --left join dbo.sysindexkeys keys on keys.id=tbl.id and keys.colid=col.colid
--            where tbl.id=@TableID and col.name=@ColName

	if exists (SELECT c.name as ColumnName, p.xtype as IsPk
	FROM sysindexkeys k
	INNER JOIN syscolumns c ON c.id=k.id AND c.colid=k.colid
	INNER JOIN sysindexes i ON i.id=k.id AND i.indid=k.indid
	INNER JOIN sysobjects p ON i.name=p.name
	INNER JOIN sysobjects t ON i.id=t.id AND t.xtype='U'
	where t.id = @TableID and c.name=@ColName) set @IsPK=1 else set @IsPK=0
       
	IF (@IsPK = 1)
		BEGIN
			SET @AllowReportParam = 1
			SET @NoCustomize = 1
		END
	ELSE
		BEGIN
			SET @AllowReportParam = 0
			SET @NoCustomize = 0
		END
-- typ kontrolki
 
		SET @ctrlType2 = case
             when @colType='datetime' then 'DTX'
             when @colType='nvarchar' then 'TXT'
             when @colType='varchar' then 'TXT'
             when @colType='ntext' then 'TXT'
             when @colType='text' then 'TXT'
             when @colType='numeric' then 'NTX'
             when @colType='int' then 'NTX'
             when @colType='smallint' then 'NTX'
             when @colType='tinyint' then 'NTX'
             when @colType='bit' then 'CHK'
             else 'TXT' end

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
			when @colType='nvarchar' then @colType + '(' + convert(nvarchar(10), @colLen) + ')'
			when @colType='varchar' then @colType + '(' + convert(nvarchar(10), @colLen) + ')'
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
			when @colType='nvarchar' then @colLen
			when @colType='varchar' then @colLen
			when @colType='ntext' then 0
			when @colType='text' then 0
			when @colType='numeric' then @colPrec + @colScale + 1
			when @colType='decimal' then @colPrec + @colScale + 1
			when @colType='int' then 0
			when @colType='smallint' then 0
			when @colType='tinyint' then 0
			when @colType='bit' then 1
			else '' end

      IF (@ctrlType2 = 'NTX')
		SET @ValidateQuery = '([\s\xA0]*)([\-]?)([0-9]+)((([\s\xA0]?|[\.]?|[\,]?)([0-9]))*)([\,]?|[\.]?)([0-9]{0,2})'
      ELSE
		SET @ValidateQuery = ''

      IF (@ctrlType2 = 'DTX')
		SET @DisplayGridFormat = 'yyyy-MM-dd'
      ELSE
		SET @DisplayGridFormat = ''
  
      -- jesli PK to Require=1 else Require=0
 
      SET @Require = @IsPK --@isKey

            INSERT INTO dbo.VS_FormFields(FieldID, FieldName, FormID, Caption, TableName, IsPK, Visible, ControlType, DataType, CaptionWidth, ControlWidth,
                                    NoColumn, NoRow, NoColspan, [Length], ControlSource, DataTypeSQL, DefaultValue, [ReadOnly], Require, RequireQuery,
									VisibleQuery, ReadOnlyQuery, ValidateQuery, TextRows, TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
									NotUse, AllowSort, AllowFilter, DisplayGridFormat, AllowReportParam, NoCustomize)                           
            VALUES(
                   @ColName, --FieldID
                   @ColName, --FieldName
                   @FormID, -- FormID
                   @ColName, -- Caption
                   '', -- TableName
                   @IsPK,--@isKey, -- IsPK
                   @Visible, -- Visible
                   @ctrlType2, --ControlType
                   @dataType, -- DataType
                   100, -- CaptionWidth
                   100, -- ControlWidth
        					 @NoColumn, --str(0), -- NoColumn
                   @NoRow, --str(0), --NoRow
                   str(0), --NoColspan
                   @length, -- length
                   '', --ControlSource
                   @dataTypeSQL, --DataTypeSQL
                   '', --defaultValue
                   0, --ReadOnly
                   @Require,
									 @RequireQuery, -- RequireQuery
									 @VisibleQuery, -- VisibleQuery 
									 @ReadOnlyQuery, -- ReadOnlyQuery
									 @ValidateQuery, -- ValidateQuery
									 str(0), -- TextRows
									 str(0), -- TextColumns
									 @Tooltip, -- Tooltip
									 @GridPk, -- GridPk
									 @colOrder, -- GridColIndex
									 @GridColWidth, --GridColWidth
									 @NotUse, -- NotUse
									 @AllowSort,
									 @AllowFilter,
									 @DisplayGridFormat,
									 @AllowReportParam, 
									 @NoCustomize
                  )
	
	IF (@NoColumn = @ColumnCount)
          BEGIN
            SET @NoColumn = 1
            SET @NoRow = @NoRow + 1
	  END
        ELSE
            SET @NoColumn = @NoColumn + 1
	
      END

      FETCH NEXT FROM test_cursor INTO @ColName
 END
 
 CLOSE test_cursor
 DEALLOCATE test_cursor

GO