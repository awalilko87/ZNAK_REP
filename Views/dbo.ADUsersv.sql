SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create   view [dbo].[ADUsersv]
as
select
 UserLogin
,DisplayName
,EmailAddress
,FirstName
,LastName
,MiddleName
,TelephoneNumber
,Company
,Department
,SAPLogin
from dbo.ADUsers
where Active = 1
GO