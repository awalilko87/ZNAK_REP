SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[Zalogowano] as
select top 100 userid, created as ZALOGOWANO, WYLOGOWANO, a.sessionid as Ilosc from sylog A
outer apply
(select top 1 WYLOGOWANO = created, sessionid from sylog b
    where 1=1
    and (operation like 'Logoff%' or operation = 'SessionTimeout%')
    and a.sessionid = b.sessionid
    and b.id > a.id
    order by id asc) oapply
where A.operation like'Login%' and A.operation not like'%failed%'
order by id asc
GO