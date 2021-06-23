SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[CheckUserRole] 
(
@UserID nvarchar(50)
)
RETURNS int
AS
BEGIN

declare @Rola int = NULL
--@Rola = 1 -> Rozliczający
--@Rola = 2 -> Rozliczający + Realizator oceniający
--@Rola = 3 -> Realizator oceniający centralny
--@Rola = 4 -> Realizator oceniający terenowy
--@Rola = 5 -> Administratorzy biznesowi
--@Rola = 6 -> użytkownik spoza UR, INW, URA, INWA
--@Rola = 7 -> użytkownik z UR, INW, URA, INWA ma błędnie określony zestaw Realizator, Ocena PO, Ocena CPO

select @Rola =
	case when (select UserGroupID from SYUsersPKNv where UserID = @UserID) = 'INW'
		and (select SAPRealizator from SYUsersPKNv where UserID = @UserID) = 0
		and (select POT_rozliczenie from SYUsersPKNv where UserID = @UserID) = 1
		and (select CPO_ROZLICZANIE from SYUsersPKNv where UserID = @UserID) = 1
	then 1
		when (select UserGroupID from SYUsersPKNv where UserID = @UserID) = 'INW'
		and (select SAPRealizator from SYUsersPKNv where UserID = @UserID) = 1
		and (select POT_rozliczenie from SYUsersPKNv where UserID = @UserID) = 1
		and (select CPO_ROZLICZANIE from SYUsersPKNv where UserID = @UserID) = 1
	then 2
		when (select UserGroupID from SYUsersPKNv where UserID = @UserID) = 'INW'
		and (select SAPRealizator from SYUsersPKNv where UserID = @UserID) = 1
		and (select POT_rozliczenie from SYUsersPKNv where UserID = @UserID) = 0
		and (select CPO_ROZLICZANIE from SYUsersPKNv where UserID = @UserID) = 0
	then 3
		when (select UserGroupID from SYUsersPKNv where UserID = @UserID) = 'UR'
		and (select SAPRealizator from SYUsersPKNv where UserID = @UserID) = 1
		and (select POT_rozliczenie from SYUsersPKNv where UserID = @UserID) = 0
		and (select CPO_ROZLICZANIE from SYUsersPKNv where UserID = @UserID) = 0
	then 4
		when (select UserGroupID from SYUsersPKNv where UserID = @UserID) in ('INWA', 'URA')
		and (select SAPRealizator from SYUsersPKNv where UserID = @UserID) = 1
		and (select POT_rozliczenie from SYUsersPKNv where UserID = @UserID) = 1
		and (select CPO_ROZLICZANIE from SYUsersPKNv where UserID = @UserID) = 1
	then 5
		when (select UserGroupID from SYUsersPKNv where UserID = @UserID) not in ('INWA', 'URA', 'INW', 'UR')
	then 6
	else 7 end

	-- Return the result of the function
	RETURN @Rola

END
GO