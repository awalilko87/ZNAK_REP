SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE view [dbo].[STAMAILv]
as
SELECT --isnull(STAMAIL.ROWID, (select max(ROWID) from STAMAIL) + ROW_NUMBER() over (order by STAMAIL.ROWID desc, UserID asc)) as STM_ROWID_PK
	--,
	m.ROWID as STM_ROWID
	, u.UserName as STM_USERNAME
	, u.Email as STM_EMAIL
	, u.UserID as STM_USERID
	, u.UserGroupID as STM_GROUPID
	, s.STA_CODE as STM_STATUS
	, s.STA_DESC as STM_STADESC
	, e.ENT_CODE as STM_ENTITY
	, case when e.ENT_CODE = 'POT' and left(s.STA_CODE,3) = 'PZO' then 'Protokół Zdawczo-Odbiorczy' else e.ENT_DESC end as STM_ENTDESC
	, isnull(m.STM_CHNG, 0) as STM_CHNG
	, isnull(m.STM_P3D, 0) as STM_P3D
FROM SYUsers u
cross join STA s
join ENT e on s.STA_ENTITY = e.ENT_CODE
left join STAMAIL m on u.UserID = m.STM_USERID and s.STA_CODE = m.STM_STATUS and m.STM_ENTITY = e.ENT_CODE
where e.ENT_CODE in ('POT')
and isnull(u.Email, '') <> ''
GO