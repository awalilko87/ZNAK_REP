CREATE TABLE [dbo].[E2_SAP2ZMT_ActResp] (
  [ZmtGetActValueRequestId] [nvarchar](60) NULL,
  [Anln1] [nvarchar](60) NULL,
  [Anln2] [nvarchar](60) NULL,
  [Wartoscpocz] [numeric](24, 6) NULL,
  [Wartoscnetto] [numeric](24, 6) NULL,
  [OkrAmort] [nvarchar](60) NULL,
  [CREDATE] [datetime] NOT NULL DEFAULT (getdate())
)
ON [PRIMARY]
GO