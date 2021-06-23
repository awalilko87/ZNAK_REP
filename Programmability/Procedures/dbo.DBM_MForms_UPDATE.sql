SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MForms_UPDATE](
    @rowid int, 
    @tabname nvarchar(30), 
    @caption nvarchar(30), 
    @header nvarchar(512), 
    @sqlaftersave nvarchar(4000), 
    @listaftersave nvarchar(1), 
    @rowguid uniqueidentifier, 
    @orgguid uniqueidentifier, 
    @where nvarchar(512), 
    @startcmds ntext
) AS
IF NOT EXISTS (SELECT * FROM [MForms] WHERE [rowguid] = @rowguid)
    INSERT INTO [MForms] ([rowid], [tabname], [caption], [header], [sqlaftersave], [listaftersave], [rowguid], [orgguid], [where], [startcmds])
    VALUES (@rowid, @tabname, @caption, @header, @sqlaftersave, @listaftersave, @rowguid, @orgguid, @where, @startcmds)
ELSE
    UPDATE [MForms] SET [rowid] = @rowid, [tabname] = @tabname, [caption] = @caption, [header] = @header, [sqlaftersave] = @sqlaftersave, [listaftersave] = @listaftersave, [rowguid] = @rowguid, [orgguid] = @orgguid, [where] = @where, [startcmds] = @startcmds WHERE [rowguid] = @rowguid
GO