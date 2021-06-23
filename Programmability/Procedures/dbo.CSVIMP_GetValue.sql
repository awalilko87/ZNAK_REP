SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CSVIMP_GetValue](
	@CSVID int,
	@KodZrodla nvarchar(30), 
	@Kolumna nvarchar(30), 
	@Value nvarchar  (200) output
	--@ImpSQL nvarchar(1000)
	)
as 
begin
	--select emp_mrccode, emp_group_code from empv
	--select emp_mrcid, emp_groupid from emp
	--exec CSVIMP_GetDictionaryID 3011, 'EMP', 'EMP_MRCCODE', 'MRC', 'MRC_CODE', 'EMP_MRCID'--,' INSERT INTO EMP ( EMP_CODE, EMP_DESC, EMP_ORG, EMP_EMAIL, EMP_MRCCODE, EMP_GROUP_CODE) SELECT  C1, C2, C3, C4, C5, C6 FROM CSVIMP01(nolock) WHERE rowid = 3006'
	
	declare @IdSlownika int
		,@pole nvarchar(10)
		,@SQL nvarchar(1000)
		,@Wartosc nvarchar(300)
		,@ent nvarchar(10)

	select top 1 @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = @KodZrodla and Wartosc = @Kolumna
	
	set  @SQL =  
		N'(SELECT @Wartosc = '
		+ ltrim(rtrim(@pole))
		+' from CSVIMP01 where ROWID = '
		+ cast(@CSVID as nvarchar(20))
		+')'
	exec sp_executesql 
		@query = @SQL,
		@params = N'@Wartosc nvarchar(30) OUTPUT',
		@Wartosc = @Wartosc OUTPUT 
		  
	select @Value = @Wartosc

	return 0
 
		
end 
 
 
GO