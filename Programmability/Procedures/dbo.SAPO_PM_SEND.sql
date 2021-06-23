SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SAPO_PM_SEND]
as
declare @pm_id int

/* Pierwszy do wys-ania */
select top 1 @pm_id = PM_ROWID from dbo.SAPO_PM where PM_IF_STATUS = 1 order by PM_ROWID asc

/* LINES */
select 
	[COL_NAME] = PMLN_COL_NAME,
	COL_VALUE = PMLN_COL_VALUE 
from dbo.SAPO_PMLN
where 
	PMLN_PMID = @pm_id 

/*=================================================*/
/* PM_REQ*/
--SELECT OPER_TYPE = 'INSERT' ,ZMT_EQUNR = '000001'
--FROM PM_REQ

/* HEADER */
SELECT 
	 OPER_TYPE = case PM_OPER_TYPE
					when 'I' then 'INSERT'
					when 'U' then 'UPDATE'
					when 'D' then 'DELETE'
					else PM_OPER_TYPE
				end
	,ZMT_EQUNR = PM_ZMT_EQUNR 
from dbo.SAPO_PM
where 
	PM_ROWID = @pm_id 
 
 
--0 nieaktywny (czyli pozycja czeka)
--1 do wylania (oczekuje na PI)
--2 wyslane (procesowane po stronie PI)
--3 odpowiedč bez bledu
--9 odpowiedz z bledem
GO