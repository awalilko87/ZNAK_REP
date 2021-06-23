SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_GenerateUpdateProc](
    @FormID nvarchar(50)
)
WITH ENCRYPTION
AS

DECLARE @procName nvarchar(100)
SET @procName = @FormID + '_Update'

DECLARE @execProc nvarchar(3999)
SET @execProc = 'exec ' + @FormID + '_Update ' + char(13)
DECLARE @TableName nvarchar(100)
SELECT @TableName = TableName FROM VS_Forms WHERE FormID = @FormID
DECLARE @count int
SET @count = 1

DECLARE @field nvarchar(100)
DECLARE @isOut bit

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[' + @procName + ']') AND type in (N'P', N'PC'))

DECLARE genParameters CURSOR KEYSET FOR 
    SELECT FieldName, Is2Dir FROM VS_FormFields WHERE FormID = @FormID AND FieldName <> '' AND NotUse <> 1 AND ISNULL(ExFromWhere, 0) <> 1 AND ISNULL(IsFilter, 0) <> 1

OPEN genParameters
FETCH NEXT FROM genParameters INTO @field, @isOut
WHILE (@@fetch_status <> -1)
  BEGIN
    IF (@@fetch_status <> -2)
      BEGIN
		IF @isOut is null
			SET @isOut = 0
		IF EXISTS (select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE a, 
						INFORMATION_SCHEMA.TABLE_CONSTRAINTS b 
						where b.constraint_type='PRIMARY KEY' and 
						a.constraint_name = b.constraint_name 
						and a.table_name = @TableName and isnull(a.Column_Name,'NO_PRIMARY') = @field)
		  SET @isOut = 1

		IF (@count > 1)
			SET @execProc = @execProc + ', '
		SET @execProc = @execProc + '@' + @field + ' = ' + '@' + @field
		IF (@isOut = 1)
			SET @execProc = @execProc + ' OUT'
		SET @execProc = @execProc + ', @OLD_' + @field + ' = ' + '@OLD_' + @field
		IF (@isOut = 1)
			SET @execProc = @execProc + ' OUT'
		SET @count = @count + 1
      END
    FETCH NEXT FROM genParameters INTO @field, @isOut
  END
CLOSE genParameters
DEALLOCATE genParameters 
SET @execProc = @execProc + ', @_UserID = @_UserID, @_GroupID = @_GroupID, @_LangID = @_LangID '
SELECT @execProc
GO