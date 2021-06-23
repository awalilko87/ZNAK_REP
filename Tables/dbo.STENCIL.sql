CREATE TABLE [dbo].[STENCIL] (
  [STS_ROWID] [int] IDENTITY,
  [STS_CODE] [nvarchar](30) NOT NULL,
  [STS_ORG] [nvarchar](30) NOT NULL,
  [STS_DESC] [nvarchar](80) NULL,
  [STS_DATE] [datetime] NULL,
  [STS_STATUS] [nvarchar](30) NULL,
  [STS_TYPE] [nvarchar](30) NULL,
  [STS_TYPE2] [nvarchar](30) NULL,
  [STS_TYPE3] [nvarchar](30) NULL,
  [STS_RSTATUS] [int] NULL,
  [STS_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_STS_STS_CREUSER] DEFAULT (N'SA'),
  [STS_CREDATE] [datetime] NULL CONSTRAINT [DF_STS__CREDATE] DEFAULT (getdate()),
  [STS_UPDUSER] [nvarchar](30) NULL,
  [STS_UPDDATE] [datetime] NULL,
  [STS_NOTUSED] [int] NULL CONSTRAINT [DF_STS_STS_NOTUSED] DEFAULT (0),
  [STS_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_STS_STS_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [STS_ACCOUNTID] [int] NULL,
  [STS_ATTACH] [nvarchar](255) NULL,
  [STS_CAPACITY] [nvarchar](30) NULL,
  [STS_CATALOGNO] [nvarchar](30) NULL,
  [STS_TXT01] [nvarchar](30) NULL,
  [STS_TXT02] [nvarchar](30) NULL,
  [STS_TXT03] [nvarchar](30) NULL,
  [STS_TXT04] [nvarchar](30) NULL,
  [STS_TXT05] [nvarchar](30) NULL,
  [STS_TXT06] [nvarchar](80) NULL,
  [STS_TXT07] [nvarchar](80) NULL,
  [STS_TXT08] [nvarchar](255) NULL,
  [STS_TXT09] [nvarchar](255) NULL,
  [STS_TXT10] [nvarchar](80) NULL,
  [STS_TXT11] [nvarchar](80) NULL,
  [STS_TXT12] [nvarchar](80) NULL,
  [STS_NTX01] [numeric](24, 6) NULL,
  [STS_NTX02] [numeric](24, 6) NULL,
  [STS_NTX03] [numeric](24, 6) NULL,
  [STS_NTX04] [numeric](24, 6) NULL,
  [STS_NTX05] [numeric](24, 6) NULL,
  [STS_COM01] [ntext] NULL,
  [STS_COM02] [ntext] NULL,
  [STS_DTX01] [datetime] NULL,
  [STS_DTX02] [datetime] NULL,
  [STS_DTX03] [datetime] NULL,
  [STS_DTX04] [datetime] NULL,
  [STS_DTX05] [datetime] NULL,
  [STS_GROUPID] [int] NULL,
  [STS_LOCID] [int] NULL,
  [STS_LOCATION] [nvarchar](50) NULL,
  [STS_MANUFACID] [int] NULL,
  [STS_PARTSLISTID] [int] NULL,
  [STS_PERSON] [nvarchar](30) NULL,
  [STS_SERIAL] [nvarchar](30) NULL,
  [STS_VALUE] [numeric](18, 2) NULL,
  [STS_VENDORID] [int] NULL,
  [STS_YEAR] [nvarchar](30) NULL,
  [STS_MRCID] [int] NULL,
  [STS_PREFERED] [int] NULL,
  [STS_COMPLEX] [int] NULL,
  [STS_COSTCODEID] [int] NULL,
  [STS_NOTE] [nvarchar](max) NULL,
  [STS_PSPID] [int] NULL,
  [STS_SIGNED] [smallint] NULL,
  [STS_SIGNLOC] [nvarchar](80) NULL,
  [STS_PSEID] [int] NULL,
  [STS_SETTYPE] [nvarchar](30) NULL,
  [STS_BLANK] [smallint] NULL,
  [STS_AUTO_PSP] [nvarchar](30) NULL,
  [STS_JOWIX_PRICE] [decimal](16, 2) NULL,
  [STS_SAMUELSONS_PRICE] [decimal](16, 2) NULL,
  [STS_WIKO_PRICE] [decimal](16, 2) NULL,
  [STS_DEFAULT_KST] [nvarchar](30) NULL,
  [STS_SAP_CHK] [int] NULL,
  [STS_ROTARY] [tinyint] NULL,
  [STS_PM_TOSEND] [tinyint] NULL,
  CONSTRAINT [PK_STS_1] PRIMARY KEY CLUSTERED ([STS_CODE]),
  CONSTRAINT [UQ_STS] UNIQUE ([STS_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [NonClusteredIndex-20150313-101538]
  ON [dbo].[STENCIL] ([STS_CODE])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGR_STENCIL_DELETE] 
ON [STENCIL] 
FOR DELETE 
AS 
BEGIN 
DECLARE @_UserID nvarchar(20), @_SystemID nvarchar(30), @_Oper nvarchar(10), @_VS_STATUS int 
EXEC @_VS_STATUS = dbo.SY_IS_SET_SESSION_TABLE 
IF @_VS_STATUS = 1 
  EXEC dbo.SY_GET_SESSION_VARIABLE 'UserID', @_UserID OUTPUT 
IF @_UserID is null SET @_UserID='NO_USER'
SELECT @_SystemID = 'ZMT'
SELECT @_Oper = 'USUNIECIE'
SET NOCOUNT ON
SELECT STS_DESC, STS_STATUS, STS_NOTUSED, STS_ROWID, STS_CODE INTO #DELETED_POM FROM DELETED
DECLARE @QUERY nvarchar(4000), @NAME nvarchar(30), @TABNAME nvarchar(30), @TYPE nvarchar(10)
SELECT @TABNAME = 'STENCIL'
    DECLARE getColName CURSOR FOR SELECT NAME, [user_type_id] FROM SYS.COLUMNS s INNER JOIN VS_AuditConfig a ON a.FieldName = s.name
    WHERE OBJECT_ID = OBJECT_ID(@TABNAME) AND a.TableName = @TABNAME AND a.EnableAudit = 1 FOR READ ONLY
    OPEN getColName
    FETCH NEXT FROM getColName INTO @NAME, @TYPE
    WHILE @@FETCH_STATUS = 0
    BEGIN
    IF (@TYPE = '61')
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(STS_ROWID AS nvarchar(4000)) + '';'' + CAST(STS_CODE AS nvarchar(4000)) + '';'', @UserID, 
    (SELECT CONVERT(nvarchar(19), CAST(['+@NAME+'] AS datetime), 121)), 
    getDate(), @Oper, CAST(ROWID AS nvarchar(30)), @SystemID 
    FROM #DELETED_POM '
    ELSE
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(STS_ROWID AS nvarchar(4000)) + '';'' + CAST(STS_CODE AS nvarchar(4000)) + '';'', @UserID, 
    (SELECT CAST(['+@NAME+'] AS nvarchar(4000))), 
    getDate(), @Oper, CAST(ROWID AS nvarchar(30)), @SystemID 
    FROM #DELETED_POM '
    EXEC sp_executesql @QUERY, N'@TableName nvarchar(30),@FieldName nvarchar(30),@UserID nvarchar(20),@Oper nvarchar(10),@SystemID nvarchar(30)',
    @TableName=@TABNAME,@FieldName=@NAME,@UserID=@_UserID,@Oper=@_Oper,@SystemID=@_SystemID
    FETCH NEXT FROM getColName INTO @NAME, @TYPE
    END
    DEALLOCATE getColName
DROP TABLE #DELETED_POM
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGR_STENCIL_INSERT] 
ON [STENCIL] 
FOR INSERT 
AS 
BEGIN 
DECLARE @_UserID nvarchar(20), @_SystemID nvarchar(30), @_Oper nvarchar(10), @_VS_STATUS int 
EXEC @_VS_STATUS = dbo.SY_IS_SET_SESSION_TABLE 
IF @_VS_STATUS = 1 
  EXEC dbo.SY_GET_SESSION_VARIABLE 'UserID', @_UserID OUTPUT 
IF @_UserID is null SET @_UserID='NO_USER'
SELECT @_SystemID = 'ZMT'
SELECT @_Oper = 'NOWY'
SET NOCOUNT ON
SELECT STS_DESC, STS_STATUS, STS_NOTUSED, STS_ROWID, STS_CODE INTO #INSERTED_POM FROM INSERTED
DECLARE @QUERY nvarchar(4000), @NAME nvarchar(30), @TABNAME nvarchar(30)
SELECT @TABNAME = 'STENCIL'
DECLARE getColName CURSOR FOR SELECT NAME FROM SYS.COLUMNS s INNER JOIN VS_AuditConfig a ON a.FieldName = s.name
WHERE OBJECT_ID = OBJECT_ID(@TABNAME) AND a.TableName = @TABNAME AND s.name = 'ROWID' FOR READ ONLY
OPEN getColName
FETCH NEXT FROM getColName INTO @NAME
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(STS_ROWID AS nvarchar(4000)) + '';'' + CAST(STS_CODE AS nvarchar(4000)) + '';'', @UserID, 
    getDate(), @Oper, CAST(ROWID AS nvarchar(30)), @SystemID 
    FROM #INSERTED_POM '
    EXEC sp_executesql @QUERY, N'@TableName nvarchar(30),@FieldName nvarchar(30),@UserID nvarchar(20),@Oper nvarchar(10),@SystemID nvarchar(30)',
    @TableName=@TABNAME,@FieldName=@NAME,@UserID=@_UserID,@Oper=@_Oper,@SystemID=@_SystemID
FETCH NEXT FROM getColName INTO @NAME
END
DEALLOCATE getColName
DROP TABLE #INSERTED_POM
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGR_STENCIL_UPDATE] 
ON [dbo].[STENCIL] 
FOR UPDATE 
AS 
BEGIN 
DECLARE @_UserID nvarchar(20), @_SystemID nvarchar(30), @_Oper nvarchar(10), @_VS_STATUS int 
EXEC @_VS_STATUS = dbo.SY_IS_SET_SESSION_TABLE 
IF @_VS_STATUS = 1 
  EXEC dbo.SY_GET_SESSION_VARIABLE 'UserID', @_UserID OUTPUT 
IF @_UserID is null SET @_UserID='NO_USER'
SELECT @_SystemID = 'ZMT'
SELECT @_Oper = 'ZMIANA'
SET NOCOUNT ON
SELECT STS_DESC, STS_STATUS, STS_NOTUSED, STS_ROWID, STS_CODE INTO #INSERTED_POM FROM INSERTED
SELECT STS_DESC, STS_STATUS, STS_NOTUSED, STS_ROWID, STS_CODE INTO #DELETED_POM FROM DELETED
DECLARE @QUERY nvarchar(4000), @NAME nvarchar(30), @TABNAME nvarchar(30), @TYPE nvarchar(10)
SELECT @TABNAME = 'STENCIL'
    DECLARE getColName CURSOR FOR SELECT NAME, [user_type_id] FROM SYS.COLUMNS s INNER JOIN VS_AuditConfig a ON a.FieldName = s.name
    WHERE OBJECT_ID = OBJECT_ID(@TABNAME) AND a.TableName = @TABNAME AND a.EnableAudit = 1 FOR READ ONLY
    OPEN getColName
    FETCH NEXT FROM getColName INTO @NAME, @TYPE
    WHILE @@FETCH_STATUS = 0
    BEGIN
    IF (@TYPE = '61')
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, NewValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(I.STS_ROWID AS nvarchar(4000)) + '';'' + CAST(I.STS_CODE AS nvarchar(4000)) + '';'', @UserID, 
    (SELECT CONVERT(nvarchar(19), CAST(D.['+@NAME+'] AS datetime), 121)), 
    (SELECT CONVERT(nvarchar(19), CAST(I.['+@NAME+'] AS datetime), 121)), 
    getDate(), @Oper, CAST(I.[STS_ROWID] AS nvarchar(30)), @SystemID 
    FROM #INSERTED_POM I JOIN #DELETED_POM D ON D.[STS_ROWID] = I.[STS_ROWID] AND isnull(I.['+@NAME+'],'''') <> isnull(D.['+@NAME+'],'''') '
    ELSE
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, NewValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(I.STS_ROWID AS nvarchar(4000)) + '';'' + CAST(I.STS_CODE AS nvarchar(4000)) + '';'', @UserID, 
    (SELECT CAST(D.['+@NAME+'] AS nvarchar(4000))), 
    (SELECT CAST(I.['+@NAME+'] AS nvarchar(4000))), 
    getDate(), @Oper, CAST(I.[STS_ROWID] AS nvarchar(30)), @SystemID 
    FROM #INSERTED_POM I JOIN #DELETED_POM D ON D.[STS_ROWID] = I.[STS_ROWID] AND isnull(convert(nvarchar(4000),I.['+@NAME+']),'''') <> isnull(convert(nvarchar(4000),D.['+@NAME+']),'''') '
    EXEC sp_executesql @QUERY, N'@TableName nvarchar(30),@FieldName nvarchar(30),@UserID nvarchar(20),@Oper nvarchar(10),@SystemID nvarchar(30)',
    @TableName=@TABNAME,@FieldName=@NAME,@UserID=@_UserID,@Oper=@_Oper,@SystemID=@_SystemID
    FETCH NEXT FROM getColName INTO @NAME, @TYPE
    END
    DEALLOCATE getColName
DROP TABLE #INSERTED_POM
DROP TABLE #DELETED_POM
END

GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[TRG_STS_CODE] 
on [dbo].[STENCIL]
after insert 
as 
begin

	declare @c_ROWID int
	declare @v_CODE nvarchar(50)

	declare STS_inserted cursor for
	select STS_ROWID from inserted order by STS_ROWID asc;

	open STS_inserted

	fetch next from STS_inserted
	into @c_ROWID

	while @@fetch_status = 0 
	begin

		exec GetEntCode @c_ROWID, 'STENCIL', 'STS', @v_CODE output --kolejno rołajdi, nazwa tabeli, encja do rołajdi, output
		update STENCIL set STS_CODE = @v_CODE where STS_ROWID = @c_ROWID 
			 
		
		fetch next from STS_inserted
		into @c_ROWID
	end

	close STS_inserted
	deallocate STS_inserted

end 
 
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_ACCOUNT] FOREIGN KEY ([STS_ACCOUNTID]) REFERENCES [dbo].[ACCOUNT] ([ACC_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_COSTCODE] FOREIGN KEY ([STS_COSTCODEID]) REFERENCES [dbo].[COSTCODE] ([CCD_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_MANUFAC] FOREIGN KEY ([STS_MANUFACID]) REFERENCES [dbo].[MANUFAC] ([MFC_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_MRC] FOREIGN KEY ([STS_MRCID]) REFERENCES [dbo].[MRC] ([MRC_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_ORG] FOREIGN KEY ([STS_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_PSEDIT] FOREIGN KEY ([STS_PSEID]) REFERENCES [dbo].[PSPEDIT] ([PSE_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_STSGROUP] FOREIGN KEY ([STS_GROUPID]) REFERENCES [dbo].[OBJGROUP] ([OBG_ROWID])
GO

ALTER TABLE [dbo].[STENCIL]
  ADD CONSTRAINT [FK_STS_STSPARTSLIST] FOREIGN KEY ([STS_PARTSLISTID]) REFERENCES [dbo].[OBJPARTSLIST] ([OPL_ROWID])
GO

DISABLE TRIGGER [dbo].[TGR_STENCIL_DELETE] ON [dbo].[STENCIL]
GO

DISABLE TRIGGER [dbo].[TGR_STENCIL_INSERT] ON [dbo].[STENCIL]
GO