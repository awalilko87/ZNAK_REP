CREATE TABLE [dbo].[PROPERTYVALUES] (
  [PRV_PROID] [int] NOT NULL,
  [PRV_PKID] [int] NULL,
  [PRV_ENT] [nvarchar](10) NULL,
  [PRV_VALUE] [nvarchar](40) NULL,
  [PRV_NVALUE] [numeric](24, 6) NULL,
  [PRV_DVALUE] [datetime] NULL,
  [PRV_UPDATECOUNT] [numeric](38) NULL DEFAULT (0),
  [PRV_CREATED] [datetime] NULL DEFAULT (getdate()),
  [PRV_UPDATED] [datetime] NULL DEFAULT (getdate()),
  [PRV_ROWID] [int] IDENTITY,
  [PRV_NOTUSED] [nvarchar](1) NULL DEFAULT (N'-'),
  [PRV_ERROR] [nvarchar](255) NULL,
  [PRV_TOSEND] [tinyint] NULL CONSTRAINT [DF_PRV_TOSEND] DEFAULT (1),
  CONSTRAINT [UNQSQL_PRV] UNIQUE ([PRV_ROWID]),
  CONSTRAINT [UQ_OBJID_PROID] UNIQUE ([PRV_PKID], [PRV_ENT], [PRV_PROID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROPERTYVALUES] WITH NOCHECK
  ADD CONSTRAINT [NN01_PRV] CHECK ([PRV_PROID] IS NOT NULL)
GO

CREATE INDEX [E2IDX_PRV01]
  ON [dbo].[PROPERTYVALUES] ([PRV_PROID])
  INCLUDE ([PRV_VALUE], [PRV_NVALUE], [PRV_DVALUE])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[PM_Upd]
   on  [dbo].[PROPERTYVALUES]
   after update
as 
begin
	set nocount on;
	
	declare @c_OBJID int
	declare @ci varbinary(128)
	declare @UserID nvarchar(30)

	exec dbo.SY_GET_SESSION_VARIABLE 'UserID', @UserID output 
	set @UserID = isnull(@UserID, 'SA')

	set @ci = context_info()

	if convert(varchar, @ci) = 'RETURN'
	begin
		return
	end

    declare C_PRV cursor for select i.PRV_PKID from inserted i
							inner join deleted d on d.PRV_ROWID = i.PRV_ROWID
							inner join dbo.PROPERTIES on PRO_ROWID = i.PRV_PROID
							inner join dbo.OBJ on OBJ_ROWID = i.PRV_PKID and OBJ_PM is not null and OBJ_PM_TOSEND = 1
							where PRO_PM_KLASA is not null and PRO_PM_CECHA is not null
							and (isnull(d.PRV_VALUE,'') <> isnull(i.PRV_VALUE,'') or isnull(d.PRV_DVALUE,'') <> isnull(i.PRV_DVALUE,'') or isnull(d.PRV_NVALUE,-5645) <> isnull(i.PRV_NVALUE,-5645))
	open C_PRV
	fetch next from C_PRV into @c_OBJID
	while @@fetch_status = 0
	begin
		exec dbo.SAPO_PM_Insert @c_OBJID, 'U', null, @UserID
		
		fetch next from C_PRV into @c_OBJID
	end
	deallocate C_PRV

end
GO

ALTER TABLE [dbo].[PROPERTYVALUES] WITH NOCHECK
  ADD CONSTRAINT [FOK1_PRV] FOREIGN KEY ([PRV_PROID]) REFERENCES [dbo].[PROPERTIES] ([PRO_ROWID])
GO

ALTER TABLE [dbo].[PROPERTYVALUES] WITH NOCHECK
  ADD CONSTRAINT [FOK2_PRV] FOREIGN KEY ([PRV_ENT]) REFERENCES [dbo].[ENT] ([ENT_CODE])
GO