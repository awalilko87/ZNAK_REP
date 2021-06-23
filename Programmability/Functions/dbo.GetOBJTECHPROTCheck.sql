SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetOBJTECHPROTCheck](@p_POTID int)
returns nvarchar(max)
as
begin
	declare @v_ret nvarchar(max) = ''

	select @v_ret = @v_ret +'<span style="font-size:10.5px;">'+ GRUPA+' - '+NAZWA+' (<span style="color:'+case when STAT = 'Zatwierdzony' then 'green' else 'red' end+';">'+STAT+'</span>)<br>' from (
		select
			 POTID = POT_ROWID
			,GRUPA = 'MS'
			,NAZWA = dbo.UserName(CHK_GU_DZR_USER)
			,STAT = case when exists (select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'DZR') then 'Zatwierdzony' else 'Do zatwierdzenia' end
		from dbo.OBJTECHPROTv
		where CHK_GU_DZR = 1
		union all
		select
			 POTID = POT_ROWID
			,GRUPA = 'IT'
			,NAZWA = dbo.UserName(CHK_GU_IT_USER)
			,STAT = case when exists (select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'IT') then 'Zatwierdzony' else 'Do zatwierdzenia' end
		from dbo.OBJTECHPROTv
		where CHK_GU_IT = 1
		union all
		select
			 POTID = POT_ROWID
			,GRUPA = 'RKB'
			,NAZWA = dbo.UserName(CHK_GU_RKB_USER)
			,STAT = case when exists (select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'RKB') then 'Zatwierdzony' else 'Do zatwierdzenia' end
		from dbo.OBJTECHPROTv
		where CHK_GU_RKB = 1
		union all
		select
			 POTID = POT_ROWID
			,GRUPA = 'UR'
			,NAZWA = dbo.UserName(CHK_GU_UR_USER)
			,STAT = case when exists (select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'UR') then 'Zatwierdzony' else 'Do zatwierdzenia' end
		from dbo.OBJTECHPROTv
		where CHK_GU_UR = 1)pot
	where POTID = @p_POTID

	if len(@v_ret) > 5
		set @v_ret = left(@v_ret,len(@v_ret)-4)+'</span>'

	return @v_ret
end
GO