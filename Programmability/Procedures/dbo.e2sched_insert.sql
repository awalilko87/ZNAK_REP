SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[e2sched_insert]
	@eqdate datetime,
	@userid nvarchar(30),
	@dd int,
	@dh int,
	@lp int,
	@typcz varchar(30),
	@typpow varchar(30),
	@status varchar(30),
	@opedesc varchar(255),
	@ud1 varchar(30),
	@ud2 varchar(30),
	@ud3 varchar(30),
	@dm int,
	@lastupdate datetime,
	@updateuser varchar(100),
	@enddate datetime
AS
BEGIN

	INSERT e2sched(eqdate,userid,dd,dh,lp,typcz,typpow,status,opedesc,ud1,ud2,ud3,dm, lastupdate, updateuser, enddate, rowguid) 
	VALUES( 
	@eqdate,
	@userid,
	@dd,
	@dh,
	@lp,
	@typcz,
	@typpow,
	@status,
	@opedesc,
	@ud1,
	@ud2,
	@ud3,
	@dm,
	@lastupdate,
	@updateuser,
	@enddate,
	cast(newid() as varchar(36)))

SELECT @@identity

END
GO