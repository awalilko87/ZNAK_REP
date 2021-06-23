SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DBM_MMainMenu_UPDATE](
    @rowguid uniqueidentifier, 
    @name nvarchar(30), 
    @desc nvarchar(255), 
    @tabname nvarchar(30), 
    @refguid uniqueidentifier, 
    @resname nvarchar(30), 
    @order int, 
    @foradmin nvarchar(30), 
    @orgguid uniqueidentifier, 
    @parentguid uniqueidentifier, 
    @action nvarchar(255)
) AS
IF NOT EXISTS (SELECT * FROM [MMainMenu] WHERE [rowguid] = @rowguid)
    INSERT INTO [MMainMenu] ([rowguid], [name], [desc], [tabname], [refguid], [resname], [order], [foradmin], [orgguid], [parentguid], [action])
    VALUES (@rowguid, @name, @desc, @tabname, @refguid, @resname, @order, @foradmin, @orgguid, @parentguid, @action)
ELSE
    UPDATE [MMainMenu] SET [rowguid] = @rowguid, [name] = @name, [desc] = @desc, [tabname] = @tabname, [refguid] = @refguid, [resname] = @resname, [order] = @order, [foradmin] = @foradmin, [orgguid] = @orgguid, [parentguid] = @parentguid, [action] = @action WHERE [rowguid] = @rowguid
GO