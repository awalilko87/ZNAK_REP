CREATE TABLE [dbo].[OBJ] (
  [OBJ_ROWID] [int] IDENTITY,
  [OBJ_CODE] [nvarchar](30) NOT NULL,
  [OBJ_ORG] [nvarchar](30) NOT NULL,
  [OBJ_DESC] [nvarchar](80) NULL,
  [OBJ_ANOID] [int] NULL,
  [OBJ_INOID] [int] NULL,
  [OBJ_OTID] [int] NULL,
  [OBJ_OTLID] [int] NULL,
  [OBJ_PSPID] [int] NULL,
  [OBJ_STSID] [int] NULL,
  [OBJ_PARENTID] [int] NULL,
  [OBJ_SIGNED] [smallint] NULL,
  [OBJ_SIGNLOC] [nvarchar](80) NULL,
  [OBJ_LEFT] [int] NULL,
  [OBJ_PM_TOSEND] [int] NULL,
  [OBJ_DATE] [datetime] NULL,
  [OBJ_STATUS] [nvarchar](30) NULL,
  [OBJ_TYPE] [nvarchar](30) NULL,
  [OBJ_TYPE2] [nvarchar](30) NULL,
  [OBJ_TYPE3] [nvarchar](30) NULL,
  [OBJ_RSTATUS] [int] NULL,
  [OBJ_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_OBJ_OBJ_CREUSER] DEFAULT (N'SA'),
  [OBJ_CREDATE] [datetime] NULL CONSTRAINT [DF_OBJ__CREDATE] DEFAULT (getdate()),
  [OBJ_UPDUSER] [nvarchar](30) NULL,
  [OBJ_UPDDATE] [datetime] NULL,
  [OBJ_NOTUSED] [int] NULL CONSTRAINT [DF_OBJ_OBJ_NOTUSED] DEFAULT (0),
  [OBJ_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_OBJ_OBJ_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [OBJ_ACCOUNTID] [int] NULL,
  [OBJ_ATTACH] [nvarchar](255) NULL,
  [OBJ_CAPACITY] [nvarchar](30) NULL,
  [OBJ_CATALOGNO] [nvarchar](30) NULL,
  [OBJ_COSTCENTERID] [int] NULL,
  [OBJ_TXT01] [nvarchar](30) NULL,
  [OBJ_TXT02] [nvarchar](30) NULL,
  [OBJ_TXT03] [nvarchar](30) NULL,
  [OBJ_TXT04] [nvarchar](30) NULL,
  [OBJ_TXT05] [nvarchar](30) NULL,
  [OBJ_TXT06] [nvarchar](80) NULL,
  [OBJ_TXT07] [nvarchar](80) NULL,
  [OBJ_TXT08] [nvarchar](255) NULL,
  [OBJ_TXT09] [nvarchar](255) NULL,
  [OBJ_TXT10] [nvarchar](80) NULL,
  [OBJ_TXT11] [nvarchar](80) NULL,
  [OBJ_TXT12] [nvarchar](80) NULL,
  [OBJ_NTX01] [numeric](24, 6) NULL,
  [OBJ_NTX02] [numeric](24, 6) NULL,
  [OBJ_NTX03] [numeric](24, 6) NULL,
  [OBJ_NTX04] [numeric](24, 6) NULL,
  [OBJ_NTX05] [numeric](24, 6) NULL,
  [OBJ_COM01] [nvarchar](max) NULL,
  [OBJ_COM02] [nvarchar](max) NULL,
  [OBJ_DTX01] [datetime] NULL,
  [OBJ_DTX02] [datetime] NULL,
  [OBJ_DTX03] [datetime] NULL,
  [OBJ_DTX04] [datetime] NULL,
  [OBJ_DTX05] [datetime] NULL,
  [OBJ_GROUPID] [int] NULL,
  [OBJ_LOCID] [int] NULL,
  [OBJ_LOCATION] [nvarchar](50) NULL,
  [OBJ_MANUFACID] [int] NULL,
  [OBJ_PARTSLISTID] [int] NULL,
  [OBJ_PERSON] [nvarchar](30) NULL,
  [OBJ_SERIAL] [nvarchar](30) NULL,
  [OBJ_VALUE] [numeric](18, 2) NULL,
  [OBJ_VENDORID] [int] NULL,
  [OBJ_YEAR] [nvarchar](30) NULL,
  [OBJ_MRCID] [int] NULL,
  [OBJ_PREFERED] [int] NULL,
  [OBJ_COMPLEX] [int] NULL,
  [OBJ_NOTE] [nvarchar](max) NULL,
  [OBJ_PM] [nvarchar](30) NULL,
  [OBJ_OT33ID] [int] NULL,
  [OBJ_SIGNEDEXISTS] [int] NULL,
  [OBJ_PM_SERVICE] [nvarchar](30) NULL,
  [OBJ_ROWGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_OBJ_OBJ_ROWGUID] DEFAULT (newid()),
  [OBJ_PM_NAME] [nvarchar](255) NULL,
  [OBJ_PRINTDATE] [datetime] NULL,
  [OBJ_PM_REQUEST] [nvarchar](30) NULL,
  [OBJ_IE2ROWID] [int] NULL,
  [OBJ_CANCELLED_OT_DOC] [nvarchar](max) NULL,
  [OBJ_CANCELLED_OT_DOC_PERSON] [nvarchar](80) NULL,
  CONSTRAINT [PK_OBJ_1] PRIMARY KEY NONCLUSTERED ([OBJ_CODE]),
  CONSTRAINT [UQ_OBJ] UNIQUE CLUSTERED ([OBJ_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OBJ01]
  ON [dbo].[OBJ] ([OBJ_ANOID], [OBJ_STSID])
  INCLUDE ([OBJ_ROWID])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OBJ02]
  ON [dbo].[OBJ] ([OBJ_STSID])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OBJ03]
  ON [dbo].[OBJ] ([OBJ_GROUPID])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OBJ05]
  ON [dbo].[OBJ] ([OBJ_OT33ID])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_OBJ06]
  ON [dbo].[OBJ] ([OBJ_INOID])
  ON [PRIMARY]
GO

CREATE INDEX [OBJ_CODE_ORG]
  ON [dbo].[OBJ] ([OBJ_CODE], [OBJ_ORG])
  ON [PRIMARY]
GO

CREATE INDEX [OBJ_ID]
  ON [dbo].[OBJ] ([OBJ_ID])
  ON [PRIMARY]
GO

CREATE INDEX [OBJ_PARENTID]
  ON [dbo].[OBJ] ([OBJ_PARENTID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[PM_Del_OBJ]
on [dbo].[OBJ]
for delete
as
begin
	set nocount on;
	
	declare @UserID nvarchar(30)
	declare @v_STATUS nvarchar(30)

	declare @c_OBJID int
	declare @c_STATUS nvarchar(30)
	declare @c_CODE nvarchar(30)
	declare @c_STATUS_old nvarchar(30)
	declare @p_OPER_TYPE nvarchar(1) = 'D'

	exec dbo.SY_GET_SESSION_VARIABLE 'UserID', @UserID output 
	set @UserID = isnull(@UserID, 'SA')

    declare C_PRV cursor for select d.OBJ_ROWID, d.OBJ_STATUS, d.OBJ_STATUS, d.OBJ_CODE--, i.OBJ_STATUS
							from deleted d
							--inner join inserted i on d.OBJ_ROWID = i.OBJ_ROWID
							where 1=1
							and (isnull(d.OBJ_PM,'') <> '' OR isnull(d.OBJ_PM_REQUEST,'') <> '')
							and d.OBJ_PM_TOSEND = 1
	
	open C_PRV
		fetch next from C_PRV into @c_OBJID, @c_STATUS, @c_STATUS_old, @c_CODE
	while @@fetch_status = 0
	begin

		insert into dbo.SAPO_PM(PM_OPER_TYPE, PM_ZMT_EQUNR, PM_IF_STATUS, PM_IF_SENTDATE, PM_IF_ERR, PM_IF_EQUNR, PM_ZMT_ROWID, PM_SAPUSER)
		VALUES (@p_OPER_TYPE, @c_CODE, 0, NULL, NULL, NULL, @c_OBJID, NULL)
		
		fetch next from C_PRV into @c_OBJID, @c_STATUS, @c_STATUS_old, @c_CODE
	end
	deallocate C_PRV

end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[PM_Upd_OBJ]
on [dbo].[OBJ]
after update
as
begin
	set nocount on;
	
	declare @UserID nvarchar(30)
	declare @v_STATUS nvarchar(30)

	declare @c_OBJID int
	declare @c_STATUS nvarchar(30)
	declare @c_STATUS_old nvarchar(30)

	exec dbo.SY_GET_SESSION_VARIABLE 'UserID', @UserID output 
	set @UserID = isnull(@UserID, 'SA')

    declare C_PRV cursor for select i.OBJ_ROWID, i.OBJ_STATUS, d.OBJ_STATUS
							from inserted i
							inner join deleted d on d.OBJ_ROWID = i.OBJ_ROWID
							where isnull(i.OBJ_PM,'') <> '' and i.OBJ_PM_TOSEND = 1
							and (isnull(d.OBJ_STATUS,'') <> isnull(i.OBJ_STATUS,'') or isnull(d.OBJ_SERIAL,'') <> isnull(i.OBJ_SERIAL,''))
	open C_PRV
	fetch next from C_PRV into @c_OBJID, @c_STATUS, @c_STATUS_old
	while @@fetch_status = 0
	begin
		if @c_STATUS = 'OBJ_002' and @c_STATUS_old in ('OBJ_003', 'OBJ_005')
			set @v_STATUS = 'OBJ_009'
		else
			set @v_STATUS = null

		exec dbo.SAPO_PM_Insert @c_OBJID, 'U', @v_STATUS, @UserID
		
		fetch next from C_PRV into @c_OBJID, @c_STATUS, @c_STATUS_old
	end
	deallocate C_PRV

end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGR_OBJ_UPDATE] 
ON [dbo].[OBJ] 
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
SELECT OBJ_STATUS, OBJ_CODE, OBJ_ROWID INTO #INSERTED_POM FROM INSERTED
SELECT OBJ_STATUS, OBJ_CODE, OBJ_ROWID INTO #DELETED_POM FROM DELETED
DECLARE @QUERY nvarchar(4000), @NAME nvarchar(30), @TABNAME nvarchar(30), @TYPE nvarchar(10)
SELECT @TABNAME = 'OBJ'
    DECLARE getColName CURSOR FOR SELECT NAME, [user_type_id] FROM SYS.COLUMNS s INNER JOIN VS_AuditConfig a ON a.FieldName = s.name
    WHERE OBJECT_ID = OBJECT_ID(@TABNAME) AND a.TableName = @TABNAME AND a.EnableAudit = 1 FOR READ ONLY
    OPEN getColName
    FETCH NEXT FROM getColName INTO @NAME, @TYPE
    WHILE @@FETCH_STATUS = 0
    BEGIN
    IF (@TYPE = '61')
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, NewValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(I.OBJ_ROWID AS nvarchar(4000)), @UserID, 
    (SELECT CONVERT(nvarchar(19), CAST(D.['+@NAME+'] AS datetime), 121)), 
    (SELECT CONVERT(nvarchar(19), CAST(I.['+@NAME+'] AS datetime), 121)), 
    getDate(), @Oper, CAST(I.[OBJ_ROWID] AS nvarchar(30)), @SystemID 
    FROM #INSERTED_POM I JOIN #DELETED_POM D ON D.[OBJ_ROWID] = I.[OBJ_ROWID] AND isnull(I.['+@NAME+'],'''') <> isnull(D.['+@NAME+'],'''') '
    ELSE
    SELECT @QUERY = 'INSERT INTO VS_Audit(AuditID, TableName, FieldName, RowID, UserID, OldValue, NewValue, DateWhen, Oper, TableRowID, SystemID) 
    SELECT newID(), @TableName, @FieldName, 
    CAST(I.OBJ_ROWID AS nvarchar(4000)), @UserID, 
    (SELECT CAST(D.['+@NAME+'] AS nvarchar(4000))), 
    (SELECT CAST(I.['+@NAME+'] AS nvarchar(4000))), 
    getDate(), @Oper, CAST(I.[OBJ_ROWID] AS nvarchar(30)), @SystemID 
    FROM #INSERTED_POM I JOIN #DELETED_POM D ON D.[OBJ_ROWID] = I.[OBJ_ROWID] AND isnull(convert(nvarchar(4000),I.['+@NAME+']),'''') <> isnull(convert(nvarchar(4000),D.['+@NAME+']),'''') '
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
CREATE trigger [dbo].[TRG_OBJ_PARENTID] 
on [dbo].[OBJ]
after insert 
as 
begin

	declare @c_ROWID int
	, @c_PARENTID int

	declare OBJ_inserted cursor for
	select OBJ_ROWID, OBJ_PARENTID from inserted order by OBJ_ROWID asc;

	open OBJ_inserted

	fetch next from OBJ_inserted
	into  @c_ROWID, @c_PARENTID

	while @@fetch_status = 0 
	begin
	 
		--domyślnie ustala każdy obiekt na siebie samego (nadrzędny)
		if @c_PARENTID is null
			update [dbo].[OBJ] set [OBJ_PARENTID] = @c_ROWID where [OBJ_ROWID] = @c_ROWID

		fetch next from OBJ_inserted
		into @c_ROWID, @c_PARENTID
	end

	close OBJ_inserted
	deallocate OBJ_inserted

end
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_ACCOUNT] FOREIGN KEY ([OBJ_ACCOUNTID]) REFERENCES [dbo].[ACCOUNT] ([ACC_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_COSTCENTER] FOREIGN KEY ([OBJ_COSTCENTERID]) REFERENCES [dbo].[COSTCENTER] ([CCT_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_INVTSK_NEW_OBJ] FOREIGN KEY ([OBJ_INOID]) REFERENCES [dbo].[INVTSK_NEW_OBJ] ([INO_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_MANUFAC] FOREIGN KEY ([OBJ_MANUFACID]) REFERENCES [dbo].[MANUFAC] ([MFC_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_MRC] FOREIGN KEY ([OBJ_MRCID]) REFERENCES [dbo].[MRC] ([MRC_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_OBJGROUP] FOREIGN KEY ([OBJ_GROUPID]) REFERENCES [dbo].[OBJGROUP] ([OBG_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_OBJPARTSLIST] FOREIGN KEY ([OBJ_PARTSLISTID]) REFERENCES [dbo].[OBJPARTSLIST] ([OPL_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_ORG] FOREIGN KEY ([OBJ_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_PSP] FOREIGN KEY ([OBJ_PSPID]) REFERENCES [dbo].[PSP] ([PSP_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_STENCIL] FOREIGN KEY ([OBJ_STSID]) REFERENCES [dbo].[STENCIL] ([STS_ROWID])
GO

ALTER TABLE [dbo].[OBJ]
  ADD CONSTRAINT [FK_OBJ_ZWFOT] FOREIGN KEY ([OBJ_OTID]) REFERENCES [dbo].[ZWFOT] ([OT_ROWID])
GO

DISABLE TRIGGER [dbo].[PM_Del_OBJ] ON [dbo].[OBJ]
GO

DISABLE TRIGGER [dbo].[PM_Upd_OBJ] ON [dbo].[OBJ]
GO

DISABLE TRIGGER [dbo].[TGR_OBJ_UPDATE] ON [dbo].[OBJ]
GO

DISABLE TRIGGER [dbo].[TRG_OBJ_PARENTID] ON [dbo].[OBJ]
GO