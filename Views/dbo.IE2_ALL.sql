SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 

CREATE view [dbo].[IE2_ALL] as 
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121)i_DateTime_SHORT,i_DateTime, POSKI, 'KONTRAHENCI' SLOWNIK, DOC_NEW_INSERTED  from dbo.IE2_KONTRAHENCI
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'INW', DOC_NEW_INSERTED from dbo.IE2_INW
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'KST', DOC_NEW_INSERTED from dbo.IE2_KST
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'MPK', DOC_NEW_INSERTED from dbo.IE2_MPK
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'KLASYFIKATOR5', DOC_NEW_INSERTED from dbo.IE2_KLASYFIKATOR5
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'ST', DOC_NEW_INSERTED from dbo.IE2_ST
union all
select convert (nvarchar (16), case when datepart(minute,i_DateTime) % 2 = 1 then i_DateTime else DATEADD(minute,1,i_DateTime) end, 121),i_DateTime, POSKI, 'PSP', DOC_NEW_INSERTED from dbo.IE2_PSP

--  select * from IE2_DicResponse


GO