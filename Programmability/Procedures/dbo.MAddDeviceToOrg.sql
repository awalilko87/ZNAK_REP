SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[MAddDeviceToOrg](@DevID nvarchar(255), @OrgCode nvarchar(30))
as
	insert into dbo.MDev2Org(rowguid, deviceguid, orgguid)
	select newid(), d.rowguid, o.rowguid
	from dbo.MDevices d
	join dbo.MOrg o on o.code = @OrgCode and d.deviceid = @DevID
GO