SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CSVIMPORTv]  
AS  
	SELECT TOP (100) PERCENT   
	CASE  
	WHEN T0.POLE = 'C1' THEN 'A'  
	WHEN T0.POLE = 'C10' THEN 'J'  
	WHEN T0.POLE = 'C11' THEN 'K'  
	WHEN T0.POLE = 'C12' THEN 'L'  
	WHEN T0.POLE = 'C13' THEN 'M'  
	WHEN T0.POLE = 'C14' THEN 'N'  
	WHEN T0.POLE = 'C15' THEN 'O'  
	WHEN T0.POLE = 'C16' THEN 'P'  
	WHEN T0.POLE = 'C17' THEN 'Q'  
	WHEN T0.POLE = 'C18' THEN 'R'  
	WHEN T0.POLE = 'C19' THEN 'S'  
	WHEN T0.POLE = 'C2' THEN 'B'  
	WHEN T0.POLE = 'C20' THEN 'T'  
	WHEN T0.POLE = 'C21' THEN 'U'  
	WHEN T0.POLE = 'C22' THEN 'V'  
	WHEN T0.POLE = 'C23' THEN 'W'  
	WHEN T0.POLE = 'C24' THEN 'X'  
	WHEN T0.POLE = 'C25' THEN 'Y'  
	WHEN T0.POLE = 'C26' THEN 'Z'  
	WHEN T0.POLE = 'C27' THEN 'AA'  
	WHEN T0.POLE = 'C28' THEN 'AB'  
	WHEN T0.POLE = 'C29' THEN 'AC'  
	WHEN T0.POLE = 'C3' THEN 'C'  
	WHEN T0.POLE = 'C30' THEN 'AD'  
	WHEN T0.POLE = 'C31' THEN 'AE'  
	WHEN T0.POLE = 'C32' THEN 'AF'  
	WHEN T0.POLE = 'C33' THEN 'AG'  
	WHEN T0.POLE = 'C34' THEN 'AH'  
	WHEN T0.POLE = 'C35' THEN 'AI'  
	WHEN T0.POLE = 'C36' THEN 'AJ'  
	WHEN T0.POLE = 'C37' THEN 'AK'  
	WHEN T0.POLE = 'C38' THEN 'AL'  
	WHEN T0.POLE = 'C39' THEN 'AM'  
	WHEN T0.POLE = 'C4' THEN 'D'  
	WHEN T0.POLE = 'C40' THEN 'AN'  
	WHEN T0.POLE = 'C41' THEN 'AO'  
	WHEN T0.POLE = 'C42' THEN 'AP'  
	WHEN T0.POLE = 'C43' THEN 'AQ'  
	WHEN T0.POLE = 'C44' THEN 'AR'  
	WHEN T0.POLE = 'C45' THEN 'AS'  
	WHEN T0.POLE = 'C46' THEN 'AT'  
	WHEN T0.POLE = 'C47' THEN 'AU'  
	WHEN T0.POLE = 'C48' THEN 'AV'  
	WHEN T0.POLE = 'C49' THEN 'AW'  
	WHEN T0.POLE = 'C5' THEN 'E'  
	WHEN T0.POLE = 'C50' THEN 'AX'  
	WHEN T0.POLE = 'C6' THEN 'F'  
	WHEN T0.POLE = 'C7' THEN 'G'  
	WHEN T0.POLE = 'C8' THEN 'H'  
	WHEN T0.POLE = 'C9' THEN 'I'  
	END as Pole_excel,  
	 T0.Pole,   
	 T0.Wartosc,   
	 case when isnull(T1.Caption,'') <> '' then isnull(T1.Caption + ': ','') else isnull(T1.GridColCaption + ': ','') end as Caption,   
	 T1.GridColCaption ,
	 T1.DataTypeSQL,   
	 T1.FormID,   
	 T0.KodZrodla  
FROM  dbo.CSVIMPORT AS T0   
	LEFT OUTER JOIN(select T1.*,T2.TABLEPREFIX from dbo.VS_FormFields T1
	JOIN dbo.VS_Forms as T2 ON T2.FORMID = T1.FORMID)  AS T1 ON T0.Wartosc = T1.FieldID 
	AND T1.FormID IN ('EMP_RC', 'OBJ_RC','VEN_RC','ASS_RC', 'SYS_USERS', 'ASTOBJ_RC')   
	and (T1.TABLEPREFIX =T0.KodZrodla or T1.FormID = 'SYS_USERS' or T1.FormID = 'ASTOBJ_RC') --[DS] SyUsers jako tabela Vision nie podlega regułom STD (nie ma prefixu)
	AND isnull(T1.Visible,0)= 1   
	AND isnull(T1.NOTUSE,0) = 0  
ORDER BY CAST(REPLACE(T0.Pole, 'C', '') AS int)  
    


--select caption, gridcolcaption, T1.*,T2.TABLEPREFIX from dbo.VS_FormFields T1
--	JOIN dbo.VS_Forms as T2 ON T2.FORMID = T1.FORMID and 'OBJ_DESC' = T1.FieldID 
--	AND T1.FormID IN ('EMP_RC', 'OBJ_RC','VEN_RC','ASS_RC', 'SYS_USERS', 'ASTOBJ_RC')   
--	and (TABLEPREFIX = 'ASTOBJ' or T1.FormID = 'SYS_USERS') --[DS] SyUsers jako tabela Vision nie podlega regułom STD (nie ma prefixu)
--	AND isnull(T1.Visible,0)= 1   
--	AND isnull(T1.NOTUSE,0) = 0  
GO

EXEC sys.sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T0"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 134
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T1"
            Begin Extent = 
               Top = 6
               Left = 237
               Bottom = 114
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'CSVIMPORTv'
GO

EXEC sys.sp_addextendedproperty N'MS_DiagramPaneCount', 1, 'SCHEMA', N'dbo', 'VIEW', N'CSVIMPORTv'
GO