CREATE TABLE [dbo].[IE2_DocRequest] (
  [FROM_DATE] [datetime] NULL,
  [ID_SLOWNIKA] [nvarchar](255) NOT NULL,
  [ACTIVE] [int] NULL,
  [DESCRIPTION] [nvarchar](256) NULL,
  [SCHEDID] [int] NULL,
  CONSTRAINT [PK_IE2_DocRequest] PRIMARY KEY CLUSTERED ([ID_SLOWNIKA])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[TRG_DocRequest_History] 
on [dbo].[IE2_DocRequest]
after insert, update 
as 
begin

	declare 
		@i_FROM_DATE datetime, 
		@i_ID_SLOWNIKA nvarchar(20), 
		@i_ACTIVE int,
		@d_FROM_DATE datetime, 
		@d_ID_SLOWNIKA nvarchar(20), 
		@d_ACTIVE int
		
	declare DocRequest_inserted cursor for
	select 
		inserted.FROM_DATE, inserted.ID_SLOWNIKA, inserted.ACTIVE,
		deleted.FROM_DATE, deleted.ID_SLOWNIKA, deleted.ACTIVE 
	from inserted 
		left join deleted on inserted.ID_SLOWNIKA = deleted.ID_SLOWNIKA
 
	open DocRequest_inserted

	fetch next from DocRequest_inserted
	into @i_FROM_DATE, @i_ID_SLOWNIKA, @i_ACTIVE,
		@d_FROM_DATE, @d_ID_SLOWNIKA, @d_ACTIVE

	while @@fetch_status = 0 
	begin
 
		insert into [dbo].[IE2_DocRequest_History](
			[ID_SLOWNIKA],
			[FROM_DATE_OLD],
			[FROM_DATE_NEW],
			[ACTIVE_OLD],
			[ACTIVE_NEW],
			[CHANGE_DATE])
		select top 1 @i_ID_SLOWNIKA,
			@d_FROM_DATE,
			@i_FROM_DATE,
			@d_ACTIVE,
			@i_ACTIVE,
			GETDATE()

		fetch next from DocRequest_inserted
		into @i_FROM_DATE, @i_ID_SLOWNIKA, @i_ACTIVE, 
			@d_FROM_DATE, @d_ID_SLOWNIKA, @d_ACTIVE

	end

	close DocRequest_inserted
	deallocate DocRequest_inserted

end
GO