SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [LogEvents]
ON DATABASE
with encryption
AFTER DDL_DATABASE_LEVEL_EVENTS
AS
set nocount on
DECLARE @data XML
SET @data = EVENTDATA()
INSERT INTO dbo.DDLAuditLog (ActionTime, UserID, EventType, ObjectName, AppName, HostName, [EventData])
select getdate(), suser_sname(), @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)'), app_name(), host_name(),@data
where @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)') not in ('ALTER_INDEX', 'UPDATE_STATISTICS')
and @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') not like 'REPORT##%'
and @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') not like '[__]%'
GO