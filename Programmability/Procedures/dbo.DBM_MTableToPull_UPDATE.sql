SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MTableToPull_UPDATE](
    @tabname nvarchar(30), 
    @key nvarchar(4000), 
    @rowid int, 
    @commitsql nvarchar(4000), 
    @trackchanges nvarchar(1), 
    @orgguid uniqueidentifier, 
    @commitImportSql nvarchar(512), 
    @todrop bit
) AS
IF NOT EXISTS (SELECT * FROM [MTableToPull] WHERE [tabname] = @tabname)
    INSERT INTO [MTableToPull] ([tabname], [key], [rowid], [commitsql], [trackchanges], [orgguid], [commitImportSql], [todrop])
    VALUES (@tabname, @key, @rowid, @commitsql, @trackchanges, @orgguid, @commitImportSql, @todrop)
ELSE
    UPDATE [MTableToPull] SET [tabname] = @tabname, [key] = @key, [rowid] = @rowid, [commitsql] = @commitsql, [trackchanges] = @trackchanges, [orgguid] = @orgguid, [commitImportSql] = @commitImportSql, [todrop] = @todrop WHERE [tabname] = @tabname
GO