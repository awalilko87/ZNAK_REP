SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[E2_SAP2ZMT_DicResponse]
(
 @DIC	nvarchar(max)
,@COLS	nvarchar(max)
,@VALS	nvarchar(max)
)
AS
BEGIN
	Declare @Date datetime, @Statement nvarchar(max)
	declare @v_DICRID int
	select @Date=GETDATE()

	insert into dbo.IE2_DicResponse(i_DateTime,Dic,Cols,Vals)
	select @Date, @DIC, @COLS, @VALS

	if right(@COLS,1)=','
		set @COLS=@COLS+'i_DateTime'
	if right(@VALS,1)=','
		set @VALS=@VALS+'#'+convert(nvarchar,@Date,121)+'#'

	set @VALS=REPLACE(@VALS,'#00000000#','null')
	set @VALS=REPLACE(@VALS,'''','''''')
	set @VALS=REPLACE(@VALS,'#','''')

	set @v_DICRID = scope_identity()

	if @DIC in ('KST','MPK','INW','PSP','KONTRAHENCI','ST','EQUI','KLASYFIKATOR5')
	begin
		set @Statement = N' insert into dbo.IE2_'+@DIC+N'('+@COLS+N') VALUES('+@VALS+N');'
	end
	else
	begin
		set @DIC = replace(replace(@DIC, '-', '__'), '/', '__')
		set @Statement = N' insert into dbo.IE2_'+@DIC+N'('+@COLS+N') VALUES('+@VALS+N');'
	end

	--print @Statement
	begin try
		exec sp_executesql @Statement;
	end try
	begin catch
		update dbo.IE2_DicResponse set
			 STMT = @Statement
			,ERRORMESSAGE = error_message()
		where ROWID = @v_DICRID

		insert into dbo.MAILBOX(MAIB_RECEIVER, MAIB_ORG, MAIB_SUBJECT, MAIB_BODY, MAIB_ISSEND, MAIB_CREATED, MAIB_NROFRETRY, MAIB_MAISID)
		select 'kponiatowski@eurotronic.net.pl;Tomasz.Chrapkowski@orlen.pl', '', 'Błąd przetwarzania słowników - słownik ' + @DIC, 'Komunikat błędu: '+error_message()+'<br>Statement: '+@Statement, 0, getdate(), 0, 1
	end catch

END
GO