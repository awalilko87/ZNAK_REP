SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_UpdateField](
    @FormID nvarchar(50),
	@FieldID nvarchar(50)
)
WITH ENCRYPTION
AS

DECLARE @TableName nvarchar(100)
SELECT @TableName = TableName FROM VS_Forms WHERE FormID = @FormID

DECLARE @TableID int
SELECT @TableID=id FROM dbo.sysobjects WHERE name=@TableName

DECLARE @ci varchar
SET @ci=char(39)
 
DECLARE @colType varchar(100)
DECLARE @colLen int
DECLARE @isKey bit
DECLARE @colOrder int  
DECLARE @colScale int, @colPrec int, @colDef nvarchar(100), @length int


DECLARE @ctrlType varchar(30)
DECLARE @ctrlType2 varchar(30)
DECLARE @dataTable varchar(30)
DECLARE @dataType varchar(30)
DECLARE @RequireQuery varchar(30)
SET @RequireQuery=''
DECLARE @VisibleQuery varchar(30)
SET @VisibleQuery=''
DECLARE @ReadOnlyQuery varchar(30)
SET @ReadOnlyQuery=''
DECLARE @ValidateQuery varchar(255)
SET @ValidateQuery=''
DECLARE @Tooltip varchar(30)
SET @Tooltip=''
DECLARE @GridPk bit
SET @GridPk=0
DECLARE @Visible bit
SET @Visible=1
DECLARE @GridColIndex bit
SET @GridColIndex=1 
DECLARE @GridColWidth int
SET @GridColWidth=0
DECLARE @NotUse bit
SET @NotUse=1
DECLARE @Require bit
DECLARE @AllowSort bit, @AllowFilter bit
SET @AllowSort = 1
SET @AllowFilter = 1
DECLARE @DisplayGridFormat nvarchar(50)
SET @DisplayGridFormat=''
DECLARE @dataTypeSQL nvarchar(50)

DECLARE @StartNoRow int
SELECT TOP 1 @StartNoRow = NoRow FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoRow DESC
DECLARE @StartNoColumn int
SELECT TOP 1 @StartNoColumn = NoColumn FROM VS_FormFields WHERE FormID = @FormID AND NoRow = @StartNoRow ORDER BY NoColumn DESC
DECLARE @ColumnCount int
SELECT TOP 1 @ColumnCount = NoColumn FROM VS_FormFields WHERE FormID = @FormID ORDER BY NoColumn DESC
DECLARE @NoColumn int
SET @NoColumn = 1
DECLARE @NoRow int
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

DECLARE @IsPK int
SET @IsPK = 0
DECLARE @NoCustomize bit
DECLARE @AllowReportParam bit

SELECT @colType=[DATA_TYPE], @colLen=[CHARACTER_MAXIMUM_LENGTH], @colScale=[NUMERIC_SCALE],
	   @colPrec=[NUMERIC_PRECISION], @colDef=[COLUMN_DEFAULT], @colOrder=[ORDINAL_POSITION]
		FROM [INFORMATION_SCHEMA].[COLUMNS]
		WHERE [TABLE_NAME] = @TableName AND [COLUMN_NAME] = @FieldID

	IF EXISTS (SELECT c.name as ColumnName, p.xtype as IsPk
	FROM sysindexkeys k
	INNER JOIN syscolumns c ON c.id=k.id AND c.colid=k.colid
	INNER JOIN sysindexes i ON i.id=k.id AND i.indid=k.indid
	INNER JOIN sysobjects p ON i.name=p.name
	INNER JOIN sysobjects t ON i.id=t.id AND t.xtype='U'
	where t.id = @TableID and c.name = @FieldID) 
		set @IsPK = 1 else set @IsPK = 0
  
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
			when @colType='nvarchar' then @colType + '(' + convert(nvarchar(10), case when @colLen = -1 then 'max' else @colLen end) + ')'
			when @colType='varchar' then @colType + '(' + convert(nvarchar(10), case when @colLen = -1 then 'max' else @colLen end) + ')'
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
			when @colType='nvarchar' then case when @colLen = -1 then '4000' else @colLen end
			when @colType='varchar' then case when @colLen = -1 then '4000' else @colLen end
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
									VisibleQuery, ReadOnlyQuery, ValidateQuery, TextRows, TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth, NotUse,
									AllowSort, AllowFilter, DisplayGridFormat, AllowReportParam, NoCustomize)                           
            VALUES(
                @FieldID, --FieldID
                @FieldID, --FieldName
                @FormID, -- FormID
                @FieldID, -- Caption
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
	
GO