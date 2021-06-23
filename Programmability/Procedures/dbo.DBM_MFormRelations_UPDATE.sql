SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MFormRelations_UPDATE](
    @msformguid uniqueidentifier, 
    @slformguid uniqueidentifier, 
    @mskey nvarchar(30), 
    @slkey nvarchar(30), 
    @caption nvarchar(30), 
    @rowid int, 
    @tabname nvarchar(30), 
    @sltabname nvarchar(30), 
    @wizardguid uniqueidentifier, 
    @parentheader nvarchar(1024), 
    @lp tinyint, 
    @beforeaction nvarchar(512), 
    @afteraction nvarchar(512), 
    @orgguid uniqueidentifier
) AS
IF NOT EXISTS (SELECT * FROM [MFormRelations] WHERE [msformguid] = @msformguid AND [slformguid] = @slformguid AND [wizardguid] = @wizardguid)
    INSERT INTO [MFormRelations] ([msformguid], [slformguid], [mskey], [slkey], [caption], [rowid], [tabname], [sltabname], [wizardguid], [parentheader], [lp], [beforeaction], [afteraction], [orgguid])
    VALUES (@msformguid, @slformguid, @mskey, @slkey, @caption, @rowid, @tabname, @sltabname, @wizardguid, @parentheader, @lp, @beforeaction, @afteraction, @orgguid)
ELSE
    UPDATE [MFormRelations] SET [msformguid] = @msformguid, [slformguid] = @slformguid, [mskey] = @mskey, [slkey] = @slkey, [caption] = @caption, [rowid] = @rowid, [tabname] = @tabname, [sltabname] = @sltabname, [wizardguid] = @wizardguid, [parentheader] = @parentheader, [lp] = @lp, [beforeaction] = @beforeaction, [afteraction] = @afteraction, [orgguid] = @orgguid WHERE [msformguid] = @msformguid AND [slformguid] = @slformguid AND [wizardguid] = @wizardguid
GO