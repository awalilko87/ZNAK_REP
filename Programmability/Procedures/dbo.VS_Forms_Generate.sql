SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_Generate](
    @TableName varchar(100),
    @FormID varchar(50),
    @Type varchar(50)='',
    @ColumnCount int,
    @TablePrefix varchar(50),
	@GroupID nvarchar(20)='')  
WITH ENCRYPTION
AS
 
IF EXISTS(SELECT * FROM VS_Forms WHERE FormID = @FormID)
       BEGIN
             RAISERROR ('1', 16, 1)
             RETURN
       END

DECLARE @tableId int
 
SELECT @tableId = id FROM dbo.sysobjects WHERE name = @TableName

--select * from dbo.sysobjects
 
DECLARE @ci varchar
 
SET @ci=char(39)
 
DECLARE @QueryStringGridFieldID varchar(250)
SET @QueryStringGridFieldID=''
DECLARE @QueryStringFieldID varchar(250)
SET @QueryStringFieldID=''
DECLARE @QueryStringFieldUserID varchar(250)
SET @QueryStringFieldUserID=''
DECLARE @SQLSelect varchar(250)
SET @SQLSelect=''
DECLARE @SQLUpdate varchar(250)
SET @SQLUpdate=''
DECLARE @IsVirtualTable bit
SET @IsVirtualTable=0
DECLARE @InDebug bit
SET @InDebug = 1
DECLARE @GridWidth int
SET @GridWidth = -1
DECLARE @GridHeight int
IF (@Type = 'LST')
	SET @GridHeight = -1
ELSE
	SET @GridHeight = NULL
DECLARE @ShowSaveButton bit
SELECT @ShowSaveButton = CASE
	WHEN @Type = 'LST' THEN 0 
	WHEN @Type = 'MST' THEN 1
	WHEN @Type = 'DTL' THEN 1
	WHEN @Type = 'TRE' THEN 0
	WHEN @Type = 'DTE' THEN 1
	WHEN @Type = 'MIX' THEN 1
	WHEN @Type = 'PUP' THEN 0
	WHEN @Type = 'PUC' THEN 0
	WHEN @Type = '' THEN 1
	ELSE 1 END

DECLARE @ShowDeleteButton bit
SELECT @ShowDeleteButton = CASE
	WHEN @Type = 'LST' THEN 0 
	WHEN @Type = 'MST' THEN 1
	WHEN @Type = 'DTL' THEN 1
	WHEN @Type = 'TRE' THEN 0
	WHEN @Type = 'DTE' THEN 1
	WHEN @Type = 'MIX' THEN 1
	WHEN @Type = 'PUP' THEN 0
	WHEN @Type = 'PUC' THEN 0
	WHEN @Type = '' THEN 1
	ELSE 1 END

DECLARE @ShowNewButton bit
SELECT @ShowNewButton = CASE
	WHEN @Type = 'LST' THEN 0 
	WHEN @Type = 'MST' THEN 1
	WHEN @Type = 'DTL' THEN 1
	WHEN @Type = 'TRE' THEN 0
	WHEN @Type = 'DTE' THEN 1
	WHEN @Type = 'MIX' THEN 1
	WHEN @Type = 'PUP' THEN 0
	WHEN @Type = 'PUC' THEN 0
	WHEN @Type = '' THEN 1
	ELSE 1 END

declare @ShowGrid bit
select @ShowGrid = case 
	WHEN @Type = 'LST' THEN 1 
	WHEN @Type = 'MST' THEN 0
	WHEN @Type = 'DTL' THEN 1
	WHEN @Type = 'TRE' THEN 0
	WHEN @Type = 'DTE' THEN 0
	WHEN @Type = 'MIX' THEN 1
	WHEN @Type = 'PUP' THEN 1
	WHEN @Type = 'PUC' THEN 0
	WHEN @Type = '' THEN 1
	ELSE 1 END
 
 declare @ShowTree bit
select @ShowTree = case 
	WHEN @Type = 'LST' THEN 0 
	WHEN @Type = 'MST' THEN 0
	WHEN @Type = 'DTL' THEN 0
	WHEN @Type = 'TRE' THEN 0
	WHEN @Type = 'DTE' THEN 1
	WHEN @Type = 'MIX' THEN 1
	WHEN @Type = 'PUP' THEN 0
	WHEN @Type = 'PUC' THEN 0
	WHEN @Type = '' THEN 1
	ELSE 1 END
declare @EditAreaHeight int
select @EditAreaHeight = case
	WHEN @Type = 'LST' THEN 0 
	WHEN @Type = 'MST' THEN -1
	WHEN @Type = 'DTL' THEN -1
	WHEN @Type = 'TRE' THEN -1
	WHEN @Type = 'DTE' THEN -1
	WHEN @Type = 'MIX' THEN -1
	WHEN @Type = 'PUP' THEN 0 
	WHEN @Type = 'PUC' THEN -1
	WHEN @Type = '' THEN -1
	ELSE -1 END

DECLARE @AllowPagging bit
SET @AllowPagging = 1

DECLARE @CaptionAlign nvarchar(10)
SELECT @CaptionAlign = 'right'

delete from VS_FormFields where FormID=@FormID
delete from VS_Forms where FormID=@FormID
INSERT INTO dbo.VS_Forms(FormID, QueryStringGridFieldID, QueryStringFieldID, QueryStringFieldUserID, Title, SQLSelect, SQLUpdate,
 IsVirtualTable, InDebug, ShowSaveButton, ShowDeleteButton, ShowNewButton, ShowGrid, ShowTree, TableName, TablePrefix, EditAreaHeight,
 ObjType, GridWidth, GridHeight, AllowPagging, GroupID,
 ShowCal,CalHeight,CalWidth,CalShowEventStartTime,CalShowEventEndTime,CalShowWeekend,
 CalCheck,CalMove,CalPrint)
 VALUES(
 @FormID,
 @QueryStringGridFieldID,
 @QueryStringFieldID,
 @QueryStringFieldUserID,
 @FormID,
 @SQLSelect,
 @SQLUpdate,
 @IsVirtualTable, -- str(
 @InDebug,
 @ShowSaveButton,
 @ShowDeleteButton,
 @ShowNewButton,
 @ShowGrid,
 @ShowTree,
 @TableName,
 @TablePrefix,
 @EditAreaHeight,
 @Type,
 @GridWidth,
 @GridHeight,
 @AllowPagging,
 @GroupID,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0)
 
DECLARE test_cursor CURSOR KEYSET FOR
	SELECT [COLUMN_NAME], [DATA_TYPE], [CHARACTER_MAXIMUM_LENGTH], [NUMERIC_SCALE],
	[NUMERIC_PRECISION], CASE WHEN LEN([IS_NULLABLE])>2 THEN 1 ELSE 0 END, [COLUMN_DEFAULT], [ORDINAL_POSITION]
	[DOMAIN_NAME] FROM [INFORMATION_SCHEMA].[COLUMNS]
	WHERE [TABLE_NAME] = @TableName
	ORDER BY [ORDINAL_POSITION]
	  
DECLARE @FieldID varchar(100), @colType varchar(100), @colLen int, @colScale int,@colPrec int, @isNullable int, @colDef nvarchar(100)
DECLARE @isKey bit, @colOrder int, @ColName varchar(100)

DECLARE @ctrlType varchar(30), @ctrlType2 varchar(30), @dataTable varchar(30), @dataType varchar(30), @dataTypeSQL nvarchar(30)
DECLARE @RequireQuery varchar(30), @VisibleQuery varchar(30), @ReadOnlyQuery varchar(30), @ValidateQuery varchar(255)
DECLARE @Tooltip varchar(30), @GridPk bit, @GridColIndex bit, @GridColWidth int, @NotUse bit, @Require bit
DECLARE @Visible bit, @AllowSort bit, @AllowFilter bit, @DisplayGridFormat nvarchar(50), @NoRow int, @length int
DECLARE @DisplayFieldFormat nvarchar(50), @NoColumn int, @AllowReportParam bit, @PanelGroup nvarchar(2), @IsPK int
DECLARE @NoCustomize bit
 
SET @RequireQuery=''
SET @VisibleQuery=''
SET @ReadOnlyQuery=''
SET @ValidateQuery=''
SET @Tooltip=''
SET @GridPk=0
SET @Visible=0
SET @GridColIndex=1 
SET @GridColWidth=0
SET @NotUse=0
SET @AllowSort = 1
SET @AllowFilter = 1
SET @DisplayGridFormat = ''
SET @DisplayFieldFormat = ''
SET @NoColumn = 1
SET @NoRow = 1
SET @IsPK = 0
SET @AllowReportParam = 0
SET @PanelGroup = 'C'

OPEN test_cursor
FETCH NEXT FROM test_cursor INTO @FieldID, @colType, @colLen, @colScale, @colPrec, @isNullable, @colDef, @colOrder
WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
	BEGIN

-- @ColName
	if exists (select * from sysobjects where name = 'sysproperties')
		SELECT	@ColName = cast(isnull(p.value,c.name) as sysname)
		FROM	sysobjects o(NOLOCK),
				syscolumns c(NOLOCK) 
				left join sysproperties  p on c.id = p.id ,systypes t(NOLOCK)  
		WHERE o.id=c.id AND c.xusertype=t.xusertype AND o.id =  @tableId AND c.name = @FieldID
	else 
		SELECT	@ColName = cast(isnull(p.value,c.name) as sysname)
		FROM	sysobjects o(NOLOCK),
				syscolumns c(NOLOCK) 
				left join sys.extended_properties  p on c.id = p.major_id and c.colid = p.minor_id,systypes t(NOLOCK)  
		WHERE o.id=c.id AND c.xusertype=t.xusertype AND o.id =  @tableId AND c.name = @FieldID

	if exists (SELECT c.name as ColumnName, p.xtype as IsPk
				FROM sysindexkeys k
				INNER JOIN syscolumns c ON c.id=k.id AND c.colid=k.colid
				INNER JOIN sysindexes i ON i.id=k.id AND i.indid=k.indid
				INNER JOIN sysobjects p ON i.name=p.name
				INNER JOIN sysobjects t ON i.id=t.id AND t.xtype='U'
				where t.id = @tableId and c.name=@ColName) set @IsPK=1 else set @IsPK=0

	-- typ kontrolki
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
			
    SET @ctrlType2 = case
		when @colType='datetime' then 'DTX'
		when @colType='date' then 'DTX'
		when @colType='nvarchar' then 'TXT'
		when @colType='varchar' then 'TXT'
		when @colType='ntext' then 'TXT'
		when @colType='text' then 'TXT'
		when @colType='numeric' then 'NTX'
		when @colType='decimal' then 'NTX'
		when @colType='int' then 'NTX'
		when @colType='smallint' then 'NTX'
		when @colType='tinyint' then 'NTX'
		when @colType='bit' then 'CHK'
		else 'TXT' end
		
    IF (@ctrlType2 = 'NTX')
		SET @ValidateQuery = '([\s\xA0]*)([\-]?)([0-9]+)((([\s\xA0]?|[\.]?|[\,]?)([0-9]))*)([\,]?|[\.]?)([0-9]{0,2})'
    ELSE
		SET @ValidateQuery = ''
		
	IF ((@colType = 'numeric' or @colType = 'decimal') and @colScale > 0)
		SET @DisplayFieldFormat = 'F' + CAST(@colScale AS nvarchar)
	ELSE
		SET @DisplayFieldFormat = ''
		
    IF (@ctrlType2 = 'DTX')
		SET @DisplayGridFormat = 'yyyy-MM-dd'
    ELSE
		SET @DisplayGridFormat = ''
		
    SET @dataType = case
		when @colType='datetime' then 'System.DateTime'
		when @colType='date' then 'System.DateTime'
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
		when @colType='uniqueidentifier' then 'System.String'
		else 'String' end
		
	SET @dataTypeSQL = case
		when @colType='datetime' then @colType
		when @colType='nvarchar' then @colType + '(' + case when @colLen = -1 then 'max' else convert(nvarchar(10), @colLen) end + ')'
		when @colType='varchar' then @colType + '(' + case when @colLen = -1 then 'max' else convert(nvarchar(10), @colLen) end + ')'
		when @colType='ntext' then @colType
		when @colType='text' then @colType
		when @colType='numeric' then @colType+ '(' + convert(nvarchar(10), @colPrec) + ',' + convert(nvarchar(10), @colScale) + ')'
		when @colType='decimal' then @colType+ '(' + convert(nvarchar(10), @colPrec) + ',' + convert(nvarchar(10), @colScale) + ')'
		when @colType='int' then @colType
		when @colType='smallint' then @colType
		when @colType='tinyint' then @colType
		when @colType='bit' then @colType
		when @colType='uniqueidentifier' then @colType
		else '' end
	
	SET @length = case
		when @colType='datetime' then 0
		when @colType='nvarchar' then case when @colLen = -1 then 4000 else @colLen end
		when @colType='varchar' then case when @colLen = -1 then 4000 else @colLen end
		when @colType='ntext' then 0
		when @colType='text' then 0
		when @colType='numeric' then @colPrec + @colScale + 1
		when @colType='decimal' then @colPrec + @colScale + 1
		when @colType='int' then 0
		when @colType='smallint' then 0
		when @colType='tinyint' then 0
		when @colType='bit' then 1
		when @colType='uniqueidentifier' then 36
		else '' end
      -- jesli PK to Require=1 else Require=0
 
      --set @Require=@IsPK--@isKey -- !dk 02.06.2008
    set @Require = case
		when @isNullable=0 then 1
		when @isNullable=1 then 0
		else 0 end
	--typy
	select @Visible = case 
		WHEN @Type = 'LST' THEN 0 
		WHEN @Type = 'MST' THEN 1
		WHEN @Type = 'DTL' THEN 1
		WHEN @Type = 'TRE' THEN 0
		WHEN @Type = 'DTE' THEN 1
		WHEN @Type = 'MIX' THEN 1
		WHEN @Type = 'PUP' THEN 0
		WHEN @Type = 'PUC' THEN 0 
		WHEN @Type = '' THEN 1
		ELSE 1 END

    INSERT INTO dbo.VS_FormFields(
		FieldID, FieldName, FormID, 
		Caption, TableName, IsPK, 
		Visible, ControlType, DataType, 
		CaptionWidth, ControlWidth,
        NoColumn, NoRow, NoColspan, 
		Length, ControlSource, DataTypeSQL, 
		DefaultValue, ReadOnly, Require, 
		RequireQuery, VisibleQuery, ReadOnlyQuery, 
		ValidateQuery, TextRows, TextColumns, 
		Tooltip, GridPk, GridColIndex, 
		GridColWidth, NotUse, AllowSort, 
		AllowFilter, DisplayGridFormat, AllowReportParam, 
		DisplayFieldFormat, PanelGroup, NoCustomize, CaptionAlign)                           
    values(
    @FieldID, --FieldID
		@FieldID, --FieldName
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
		ISNULL(@colDef,''), --defaultValue
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
		@DisplayFieldFormat,
		@PanelGroup,
		@NoCustomize,
		@CaptionAlign)
	
	IF (@NoColumn = @ColumnCount)
    BEGIN
        SET @NoColumn = 1
        SET @NoRow = @NoRow + 1
	END
    ELSE
        SET @NoColumn = @NoColumn + 1
	
    END

    FETCH NEXT FROM test_cursor INTO @FieldID, @colType, @colLen, @colScale, @colPrec, @isNullable, @colDef, @colOrder
END
CLOSE test_cursor
DEALLOCATE test_cursor
GO