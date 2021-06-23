SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- Author:		GRZELAK DOMINIK
-- Create date: 2020-12-09
-- Description:	update tabeli GUS (waloryzacja)
-- =============================================
CREATE PROCEDURE [dbo].[GUS_Values_Upd_Proc]
@GUS_rok int,
@GUS_id int,
@GUS_procent numeric(8,3),
@UserID nvarchar(90)
AS
BEGIN

	if exists (select 1 from GUS_Valuesv where GUS_rowid = @GUS_id)
		begin
			update GUS_Values set GUS_percent = @GUS_procent, GUS_UPDUSER = @UserID, GUS_UPDDATE = GetDate()
			where GUS_rowid = @GUS_id and GUS_year = @GUS_rok
		end
	else
		begin
			insert into GUS_Values
			(GUS_year
			, GUS_percent,
			GUS_CREUSER,
			GUS_CREDATE)
			values
			(
			@GUS_rok
			, @GUS_procent
			, @UserID
			, GetDate()
			)
		end


END

GO