SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[CSVIMPORTf] (@p_KodZrodla nvarchar(30), @p_Pole nvarchar(10))
--select * from CSVIMPORTf ('OBJ')
returns @t table
(
	kod nvarchar(30),
	opis nvarchar(100)
)
as
begin
	declare @tableName nvarchar(50)
	declare @formID nvarchar(50)
	
	select @tableName = tablename from vs_forms where formid =  @p_KodZrodla + '_RC'
	select @formID = formid from  vs_forms where formid =  @p_KodZrodla + '_RC'
	--struktura obiektów
	IF @p_KodZrodla = 'OBS' 
	BEGIN
		insert into @t
		SELECT 'OBS_PARENTID', 'Obiekt Nadrzędny: OBS_PARENTID'
		UNION
		SELECT 'OBS_CHILDID', 'Obiekt Podrzędny: OBS_CHILDID'
		UNION
		SELECT 'OBS_ORG', 'Siedziba: OBS_ORG'
		ORDER BY 2
	END
	ELSE
	IF @p_KodZrodla = 'USR' 
	BEGIN
		insert into @t
		SELECT 
			T0.column_name, 
			ISNULL(T1.Caption + ': ','') + T0.column_name + ' <' + T0.data_type + CASE WHEN isnull(T0.data_type,'') like '%char%' THEN '(' + cast(isnull(T0.character_maximum_length,'') as nvarchar) + ')' ELSE '' END + '>'
		FROM INFORMATION_SCHEMA.Columns T0
			INNER JOIN vs_formfields T1 ON T0.column_name = T1.FieldID AND T1.formid like 'SYS_USERS'  
				and T1.visible = 1 
				and T1.notuse = 0 
				and T1.readonly = 0
				and T1.GridColWidth <> -1
		WHERE 
			table_name = 'SyUsersv' 
			AND column_name <> 'ROWID'
			AND (column_name NOT IN (SELECT ISNULL(Wartosc,'') FROM CSVIMPORTv where KodZrodla = @p_KodZrodla) --[DS]nie pokazuje pól już zmapowanych dla tej encji
				or column_name in (select wartosc from csvimport where pole = @p_Pole and  kodzrodla = @p_KodZrodla) --[DS]dodatkowo pokazuje aktualnie wybrane pole
			)
		ORDER BY 2
	END
	BEGIN
		insert into @t
		SELECT 
			T0.column_name, 
			case when isnull(T1.Caption,'') <> '' then isnull(T1.Caption + ': ','') else isnull(T1.GridColCaption + ': ','') end + T0.column_name + ' <' + T0.data_type + CASE WHEN isnull(T0.data_type,'') like '%char%' THEN '(' + cast(isnull(T0.character_maximum_length,'') as nvarchar) + ')' ELSE '' END + '>'
		FROM INFORMATION_SCHEMA.Columns T0
			INNER JOIN vs_formfields T1 ON T0.column_name = T1.FieldID AND T1.formid like @formID 
				and T1.visible = 1 
				and T1.notuse = 0 
				--and T1.readonly = 0
				and T1.GridColWidth <> -1
		WHERE 
			table_name = @tableName 
			AND column_name <> 'ROWID'
			AND (column_name NOT IN (SELECT ISNULL(Wartosc,'') FROM CSVIMPORTv where KodZrodla = @p_KodZrodla) --[DS]nie pokazuje pól już zmapowanych dla tej encji
				or column_name in (select wartosc from csvimport where pole = @p_Pole and  kodzrodla = @p_KodZrodla) --[DS]dodatkowo pokazuje aktualnie wybrane pole
			)
		ORDER BY 2
	END
	
	return
end
GO