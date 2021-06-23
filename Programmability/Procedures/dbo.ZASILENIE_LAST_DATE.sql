SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZASILENIE_LAST_DATE]
as

declare @LastPackageDiff int,
@LastPackageDT datetime,
@FROM_DATE datetime

begin
select top 1 @LastPackageDT = i_Datetime from IE2_ALL order by i_Datetime desc
select @LastPackageDiff= DATEDIFF (MINUTE, @LastPackageDT, GETDATE())
--print @LastPackageDT
--print @LastPackageDiff

--waitfor delay '00:00:30' 
select top 1 @FROM_DATE=FROM_DATE from IE2_DocRequest

if @LastPackageDiff>45 and @FROM_DATE < '2017-01-01'
	begin

	select @FROM_DATE= DATEADD (YY,1,@FROM_DATE)
	print @FROM_DATE
	--update _TEST set DT=@FROM_DATE
	insert into _TEST (DT, TDESC) values (GETDATE(), 'ST.Kolejny rok:'+CONVERT (nvarchar (20), @FROM_DATE,112))
	update IE2_DocRequest set FROM_DATE = @FROM_DATE
	end


end


-- select * from _TEST
GO