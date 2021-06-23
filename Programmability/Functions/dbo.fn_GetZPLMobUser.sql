SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetZPLMobUser]( @p_ROWGUID nvarchar(50))
RETURNS nvarchar(max)
AS
BEGIN
  declare @f_zebra_code nvarchar(max)
  declare @f_UserID nvarchar(20)
  declare @f_UserName nvarchar(100)
  declare @f_Password nvarchar(50)
  declare @f_ORG nvarchar (30)

  set @f_ORG = 'PKN Orlen'
  select
	 @f_UserID = isnull(UserID,'')
	 ,@f_UserName = isnull(UserName,'')
	 ,@f_Password = isnull([Password],'')
  from MobileUsersv
  where rowguid = @p_ROWGUID


	set @f_zebra_code = isnull(@f_zebra_code,'')+N'
^XA
^PR4
~SD30
^PW400
^LL240
^LH0,0

^FO8,50^FB384,3,0,C
^A@N,1,1,E:ARI001.FNT^FD
Automatyczne logowanie na użytkownika: '+ @f_UserID +N'
^FS

^FO96,120^BY2^BCN,80,N,N
^FD
'+ @f_UserID +N'$$$'+ @f_Password + N'
^FS


^PQ1
^XZ
'
+
N'^XA
^PR4
~SD30
^PW400
^LL240
^LH0,0

^FO8,80^FB384,2,0,C
^A@N,1,1,E:ARI003.FNT^FD
'+ @f_UserName +N'
^FS

^FO8,160^FB384,1,0,C
^A@N,1,1,E:ARI003.FNT^FD
Login: '+ @f_UserID +N'
^FS

^PQ1
^XZ
'
  RETURN @f_zebra_code
END

GO