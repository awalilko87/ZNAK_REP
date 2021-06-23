SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PO_BIZ_DEC_HEADv]
as
SELECT 
/*ID decyzji biznesowej:		*/ BIZ_ROWID
/*Numer decyzji biznesowej		*/,BIZ_CODE
/*Data utworzenia decyzji		*/,BIZ_CREDATE
/*Tworzący						*/,BIZ_CREUSER
/*Tworzący - nazwisko			*/,BIZ_CRELASTNAME = (select LastName from SyUsers where UserID = BIZ_CREUSER)
/*Tworzący - imię				*/,BIZ_CREFIRSTNAME = (select FirstName from SyUsers where UserID = BIZ_CREUSER)
/*Kod protokołu oceny			*/,BIZ_POTID
/*Typ likwidacji				*/,BIZ_LIKW_ODSP = 'X'
/*Wartość początkowa:			*/,BIZ_LIKW_UTYLIZ = 'X'
/*Składniki grupa 1:			*/,BIZ_OBG_I = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 1 ) then 'X' else '' end
/*Składniki grupa 2:			*/,BIZ_OBG_II = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 2 ) then 'X' else '' end
/*Składniki grupa 3:			*/,BIZ_OBG_III = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 3 ) then 'X' else '' end
/*Składniki grupa 4:			*/,BIZ_OBG_IV = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 4 ) then 'X' else '' end
/*Składniki grupa 5:			*/,BIZ_OBG_V = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 5 ) then 'X' else '' end
/*Składniki grupa 6:			*/,BIZ_OBG_VI = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 6 ) then 'X' else '' end
/*Składniki grupa 7:			*/,BIZ_OBG_VII = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 7 ) then 'X' else '' end
/*Składniki grupa 8:			*/,BIZ_OBG_VIII = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 8 ) then 'X' else '' end
/*Składniki grupa 9:			*/,BIZ_OBG_IX = case when exists (select 1 from dbo.OBJTECHPROTLNv where BIZ_POTID = POL_POTID and POL_OBGID = 9 ) then 'X' else '' end
/*Wartość netto:				*/,BIZ_NETTO = (select sum(IsNull(BII_NETTO,0)) from PO_BIZ_DEC_ITEMS where BII_BIZID = BIZ_ROWID)
/*Faktyczna wartość odsprzedaży:*/,BIZ_WART_ODSP = (select sum(IsNull(BII_WART_ODSP,0)) from PO_BIZ_DEC_ITEMS where BII_BIZID = BIZ_ROWID)
/*Składniki Obszar UR			*/,BIZ_OBSZAR_UR = case when exists (select 1  from [dbo].[OBJTECHPROTLN] (nolock) join [dbo].[OBJ] (nolock) on OBJ_ROWID = POL_OBJID 
																		  left join [dbo].[OBJGROUP_RESPONv] on OBG_ROWID = OBJ_GROUPID where POL_POTID = POT_ROWID and GroupID = 'UR') then 'X' else '' end 

/*Składniki Obszar IT			*/,BIZ_OBSZAR_IT = case when exists (select 1  from [dbo].[OBJTECHPROTLN] (nolock) join [dbo].[OBJ] (nolock) on OBJ_ROWID = POL_OBJID 
																		  left join [dbo].[OBJGROUP_RESPONv] on OBG_ROWID = OBJ_GROUPID where POL_POTID = POT_ROWID and GroupID = 'IT') then 'X' else '' end

/*Składniki Obszar GCB - bezp.	*/,BIZ_OBSZAR_GCB = case when exists (select 1  from [dbo].[OBJTECHPROTLN] (nolock) join [dbo].[OBJ] (nolock) on OBJ_ROWID = POL_OBJID 
																		  left join [dbo].[OBJGROUP_RESPONv] on OBG_ROWID = OBJ_GROUPID where POL_POTID = POT_ROWID and GroupID = 'RKB') then 'X' else '' end

/*Składniki Obszar MS			*/,BIZ_OBSZAR_MS = case when exists (select 1  from [dbo].[OBJTECHPROTLN] (nolock) join [dbo].[OBJ] (nolock) on OBJ_ROWID = POL_OBJID 
																		  left join [dbo].[OBJGROUP_RESPONv] on OBG_ROWID = OBJ_GROUPID where POL_POTID = POT_ROWID and GroupID = 'DZR') then 'X' else '' end
/*Ilość składników				*/,BIZ_ILE_POZ = (select count(1) from [dbo].[PO_BIZ_DEC_ITEMS] where BII_BIZID = BIZ_ROWID)
FROM 
dbo.PO_BIZ_DEC_HEAD
join dbo.OBJTECHPROT on POT_ROWID = BIZ_POTID
GO