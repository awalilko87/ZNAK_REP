SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create function [dbo].[fn_MInterfaces](
@d nvarchar(255),
@a nvarchar(255),
@v nvarchar(30))
RETURNS @ret TABLE 
(
    -- Columns returned by the function
    rowguid	uniqueidentifier,
	orgguid	uniqueidentifier,
	deviceguid uniqueidentifier,
	assemblyname nvarchar(255),
	assemblyver	nvarchar(30),
	assemblydata varbinary(max),
	createdon datetime
)
as
begin
with fordev as (
	select i.* from [MDevices] d 
	join [MDev2Org] o on d.rowguid = o.deviceguid
	join [MInterfaces] i on i.deviceguid = d.rowguid
	where d.deviceid = @d
	),
fororg as (
	select i.*
	from [MInterfaces] i
	  join [MDev2Org] o on o.orgguid = i.orgguid
	  join [MDevices] d on d.rowguid = o.deviceguid and i.deviceguid = '00000000-0000-0000-0000-000000000000'
	where d.deviceid = @d
	and not exists(select * from fordev)
),
both as (
select top 99.9999 percent * from fordev order by assemblyver desc
union
select top 99.9999 percent * from fororg order by assemblyver desc
)
insert into @ret
select top 1 rowguid,orgguid,deviceguid,assemblyname,assemblyver,assemblydata,createdon from both where both.assemblyver > @v and both.assemblyname = @a

return
end

GO