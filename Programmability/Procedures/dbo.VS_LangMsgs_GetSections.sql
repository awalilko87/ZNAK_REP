SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_GetSections](    
    @LangID nvarchar(10) = '%',
    @ObjectID nvarchar(150) = '%',
    @ObjectType nvarchar(20) = '%'
    )
WITH ENCRYPTION
AS
	WITH Sections as (
	SELECT
        @LangID as [LangID], @ObjectID as ObjectID, '0' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
	UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'A' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'A2' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'B' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'C' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'D' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'E' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
    UNION SELECT
        @LangID as [LangID], @ObjectID as ObjectID, 'F' as ControlID, @ObjectType as ObjectType, '' as Tooltip,
         '' as ValidateErrMessage,  '' as GridColCaption,  '' as CallbackMessage,  '' as ButtonTextNew,  '' as ButtonTextDelete,
         '' as ButtonTextSave,  '' as AltSavePrompt,  '' as AltRequirePrompt,  '' as AltRecCountPrompt,  '' as AltPageOfCounter,  '' as Caption
     )
     SELECT s.[LangID], s.ObjectID, s.ControlID, s.ObjectType, s.Tooltip,
	        s.ValidateErrMessage, s.GridColCaption, s.CallbackMessage, s.ButtonTextNew, s.ButtonTextDelete,
	        s.ButtonTextSave, s.AltSavePrompt, s.AltRequirePrompt, s.AltRecCountPrompt, s.AltPageOfCounter, coalesce(l.Caption, s.Caption) as Caption
	 FROM Sections s
	 LEFT JOIN VS_LangMsgs l on s.ControlID = l.ControlID and s.[LangID] = l.[LangID] and s.ObjectID = l.ObjectID and s.ObjectType = l.ObjectType
	 
GO