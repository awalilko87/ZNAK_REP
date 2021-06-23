SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[e2sched_update]
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
	@rowid varchar(30),
	@dm int,
	@lastupdate datetime,
	@updateuser varchar(100),
	@rowguid varchar(36),
	@enddate datetime
AS
BEGIN

	UPDATE e2sched SET 
	eqdate=@eqdate,
	userid=@userid,
	dd=@dd,
	dh=@dh,
	lp=@lp,
	typcz=@typcz,
	typpow=@typpow,
	status=@status,
	opedesc=@opedesc,
	ud1=@ud1,
	ud2=@ud2,
	ud3=@ud3,
	dm=@dm,
	lastupdate=@lastupdate,
	updateuser=@updateuser,
	enddate=@enddate
	WHERE rowid=@rowid

END
GO