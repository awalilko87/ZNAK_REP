SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create view [dbo].[MOB_MDev2Orgv]
as
select 
	md2o.rowguid,
	deviceguid,
	orgguid,
	deviceid,
	md.code,
	hres,
	vres,
	not_used
from MDev2Org md2o
	join mdevices md on md.rowguid = md2o.deviceguid
	join morg on md2o.orgguid = morg.rowguid
	 



GO