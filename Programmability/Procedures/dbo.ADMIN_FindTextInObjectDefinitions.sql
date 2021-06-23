SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE  [dbo].[ADMIN_FindTextInObjectDefinitions]
    @Text varchar(500)
AS
BEGIN

    DECLARE @obj_id BIGINT
    DECLARE @obj_name VARCHAR(254)
    DECLARE @obj_type VARCHAR(254)


    CREATE TABLE #obj (obj_id BIGINT, obj_name VARCHAR(254),obj_type VARCHAR(254))

    DECLARE  cr CURSOR
    FOR 
    SELECT  OBJECT_ID, NAME, TYPE_DESC FROM sys.objects 
    WHERE TYPE in (
                    'P',    --SQL stored procedure
                    'TF',    --SQL table-valued function
                    'IF',    --SQL inline table-valued function
                    'FN',    --SQL scalar function
                    'V',    --View
                    'TR'    --SQL trigger (schema-scoped DML trigger, or DDL trigger at either the database or server scope)
                  )


    OPEN cr
    FETCH NEXT FROM cr INTO @obj_id, @obj_name, @obj_type 

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        IF PATINDEX('%'+@Text+'%',OBJECT_DEFINITION (@obj_id)) > 0
            INSERT INTO #obj (obj_id,obj_name,obj_type)
            VALUES (@obj_id,@obj_name,@obj_type)


        FETCH NEXT FROM cr INTO @obj_id, @obj_name, @obj_type 
    END

    CLOSE cr
    DEALLOCATE cr    


    SELECT * FROM #obj
        order by obj_type,obj_name,obj_id

    DROP TABLE #obj

END
GO