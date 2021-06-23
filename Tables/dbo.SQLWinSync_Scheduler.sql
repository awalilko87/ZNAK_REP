CREATE TABLE [dbo].[SQLWinSync_Scheduler] (
  [TASK_NO] [int] NOT NULL,
  [INTERVAL] [smallint] NOT NULL,
  [NEXT_EXEC] [datetime] NOT NULL,
  [H_FROM] [tinyint] NOT NULL,
  [H_TO] [tinyint] NOT NULL,
  CONSTRAINT [PK_SQLWinSync_Scheduler_1] PRIMARY KEY CLUSTERED ([TASK_NO], [NEXT_EXEC])
)
ON [PRIMARY]
GO