SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		Bartek 
-- Create date: 2013-05-07
-- Description:	Procedura tworzy przykładowe menu kontekstowe,
-- wpisy działają dla formatek "Zlecenia pracy" EVT_LS oraz dla "Zgłoszeń" RST_LS
-- =============================================
CREATE PROCEDURE [dbo].[SY_DemoContextMenu]
@FormID1 nvarchar(50),
@FormID2 nvarchar(50)
AS
BEGIN

	SET IDENTITY_INSERT [SYContextMenu] ON	
	--@FormID = EVT_LS
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (3, -1, @FormID1, N'grid', N'-----------', N'', N'', N'', 1, N'AC', N'seperator')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (100, -1, @FormID1, N'grid', N'PodMenu', N'', N'', N'', 7, N'AC', N'submenu')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (101, 100, @FormID1, N'grid', N'PodMenu 1', N'', N'alert(''Pod Menu 1'');', N'', 0, N'AC', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (102, 100, @FormID1, N'grid', N'PodMenu 2', N'', N'alert(''Pod Menu 2'');', N'', 0, N'DEF', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (4, -1, @FormID1, N'grid', N'Praca', N'', N'SET_CURRENT;PURL SimplePopup2.aspx?FID=EVT_EMP;', N'/Images/16x16/Symbol Clock.png', 1, N'AP', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (98, -1, @FormID1, N'grid', N'Następny', N'', N'MOVENEXT;
	', N'/Images/16x16/Arrow Right.png', 3, N'AP', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (99, -1, @FormID1, N'grid', N'Poprzedni', N'', N'MOVEPREV;
	', N'/Images/16x16/Arrow Left.png', 2, N'AP', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (103, 0, @FormID1, N'grid', N'Dodaj Nowy', NULL, N'URL Tabs3.aspx?TGR=EVT&TAB=EVT_RC&FID=EVT_RC&A=0&QSC=ADDNEW;SQL select @TLB_SAVE_RIGHT = [dbo].[GetBtnRight] (@EVT_ORG, @QS_FID, @_UserID, N''TLB_SAVE'');', N'/Images/16x16/Symbol Add 2.png', 0, N'AP', N'button')
	
	--@FormID = RST_LS
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (104, 0, @FormID2, N'grid', N'Zatwierdź', N'', N'SQL 
	declare @v_ASSIGNED nvarchar(30)
	set @v_ASSIGNED = dbo.GetEmpFromUser(@_UserID,@RST_ORG, @QS_FID)
	exec dbo.RSTACCEPT_Proc 
	@ROWID,
	''ZATWIERDZONE'',
	@RST_STATUS,
	''UTWORZONE'',
	@v_ASSIGNED,
	null,
	null,
	null,
	null,
	@TXT01,
	@TXT02,
	@DTX01,
	null,
	@DTX02,
	null,
	@NTX01,
	@NTX02,
	@_UserID;
	REFRESH;
	', N'/Images/16x16/Symbol Check 2.png', 0, N'AP', N'button')
	INSERT [SYContextMenu] ([ROWID], [PARENTID], [FID], [MENUPARENT], [ITEMCAPTION], [SECTION], [COMMAND], [IMGURL], [ORDERINDEX], [CALLMODE], [CONTROLTYPE]) VALUES (105, 0, @FormID1, N'grid', N'Odrzuć', NULL, N'SET_CURRENT;PURL SimplePopup2.aspx?WHO=RST_LS&FID=RSTREJECT_POP&FLD=TLB_REJECTFORM&A=TLB_REJECTFORM;', N'/Images/16x16/Symbol Delete 2.png', 0, N'AP', N'button')
	
	SET IDENTITY_INSERT [SYContextMenu] OFF
END
GO