SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[GetUserFromAD]
as
begin
	declare @v_errortext nvarchar(1000)
	declare @v_SQL nvarchar(max)
	
	declare @c_letter nvarchar(4)
	
	declare @t_letters table (l nvarchar(4), ile int)
	declare @t_users table(
		 sAMAccountName nvarchar(30)
		,displayName nvarchar(100)
		,mail nvarchar(255)
		,givenName nvarchar(50)
		,sn nvarchar(50)
		,middleName nvarchar(50)
		,telephoneNumber nvarchar(30)
		,company nvarchar(80)
		,department nvarchar(80)
		,extensionAttribute5 nvarchar(30)
		,lastLogonTimestamp bigint
		,accountExpires bigint
	)
	
	;with cteAlphaNo as (
         SELECT 1 as Id
         UNION ALL
         SELECT Id + 1 FROM cteAlphaNo ca WHERE ca.Id < 256
	), cteAlphaWithPolishChars AS (
         SELECT DISTINCT LOWER(CHAR(Id)) as AlphaSign1
         FROM cteAlphaNo
         WHERE (Id >= ASCII('a') AND Id<= ASCII('z'))
         --OR CHAR(Id) IN ('ą','ć','ę','ł','ń','ó','ś','ź','ż')
	), cteAlphaWithPolishChars2 AS (
         SELECT DISTINCT LOWER(CHAR(Id)) as AlphaSign2
         FROM cteAlphaNo
         WHERE (Id >= ASCII('a') AND Id<= ASCII('z'))
         --OR CHAR(Id) IN ('ą','ć','ę','ł','ń','ó','ś','ź','ż')
	)
	insert into @t_letters
	select AlphaSign1+AlphaSign2, null
	from cteAlphaWithPolishChars 
	cross join cteAlphaWithPolishChars2
	option (maxrecursion 0)

	declare c_ad cursor for select l from @t_letters
	open c_ad
	fetch next from c_ad into @c_letter
	while @@fetch_status = 0
	begin
		set @v_SQL = 'SELECT top 901 * FROM OpenQuery (ADSI,''SELECT accountExpires, lastLogonTimestamp, extensionAttribute5, department, company, telephoneNumber, middleName, sn, givenName, mail, displayName, sAMAccountName FROM  ''''LDAP://orlen.pl/OU=Branch_Office,OU=Regions,DC=orlen,DC=pl'''' WHERE objectClass =  ''''User'''' and sAMAccountName = '''''+@c_letter+'*'''' '') 
union all
SELECT top 901 * FROM OpenQuery (ADSI,''SELECT accountExpires, lastLogonTimestamp, extensionAttribute5, department, company, telephoneNumber, middleName, sn, givenName, mail, displayName, sAMAccountName FROM  ''''LDAP://orlen.pl/OU=PLOCK,OU=Regions,DC=orlen,DC=pl'''' WHERE objectClass =  ''''User'''' and sAMAccountName = '''''+@c_letter+'*'''' '')  
union all
SELECT top 901 * FROM OpenQuery (ADSI,''SELECT accountExpires, lastLogonTimestamp, extensionAttribute5, department, company, telephoneNumber, middleName, sn, givenName, mail, displayName, sAMAccountName FROM  ''''LDAP://orlen.pl/OU=OrlenKsiegowosc,OU=FIRMS,DC=orlen,DC=pl'''' WHERE objectClass =  ''''User'''' and sAMAccountName = '''''+@c_letter+'*'''' '')  
'
		begin try
			insert into @t_users
			exec(@v_SQL)
			
			update @t_letters set
				ile = @@rowcount
			where l = @c_letter
			
			if @@rowcount = 901
				print 'wiecej niz 901'
		end try
		begin catch
			print @c_letter
			print 'err: '+error_message()
		end catch
		
		fetch next from c_ad into @c_letter
	end
	deallocate c_ad
	
	delete from @t_users where sAMAccountName like '%$'
	update @t_users set accountExpires = 2650466016000000000 where accountExpires > 2650466016000000000 or isnull(accountExpires,0) = 0
	--select * from @t_users
	
	merge dbo.ADUsers as us
	using (select * from @t_users where convert(datetime,(convert(numeric(38,0),convert(bigint,accountExpires))-828000000001)/(8.64*100000000000) - 109205) > getdate()) as adus
	on UserLogin = sAMAccountName
	when not matched by source then update set Active = 0
	when matched then update set 
		 DisplayName = adus.displayName
		,EmailAddress = mail
		,FirstName = givenName
		,LastName = sn
		,MiddleName = adus.middleName
		,TelephoneNumber = nullif(adus.telephoneNumber,'')
		,Company = adus.company
		,Department = adus.department
		,SAPLogin = nullif(extensionAttribute5, '')
		,Active = 1
	when not matched then
	insert(UserLogin, DisplayName, EmailAddress, FirstName, LastName, MiddleName, TelephoneNumber, Company, Department, SAPLogin)
	values(sAMAccountName, displayName, mail, givenName, sn, middleName, nullif(adus.telephoneNumber,''), company, department, nullif(extensionAttribute5, ''));
end
GO