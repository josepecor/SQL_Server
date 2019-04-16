
--Consulta para encontrar un dato dentro de cualquier tabla o campo dentro de la Base de Datos

DECLARE
   @SearchText varchar(200),
   @Table varchar(100),
   @TableID int,
   @ColumnName varchar(100),
   @String varchar(1000);
--modify the variable, specify the text to search for 
SET @SearchText = '11180029';
DECLARE CursorSearch CURSOR
    FOR SELECT name, object_id
        FROM sys.objects
      WHERE type = 'U';
--list of tables in the current database. Type = 'U' = tables(user-defined) 
OPEN CursorSearch;
FETCH NEXT FROM CursorSearch INTO @Table, @TableID;
WHILE
       @@FETCH_STATUS
       =
       0
    BEGIN
        DECLARE CursorColumns CURSOR
            FOR SELECT name
                  FROM sys.columns
                WHERE
                       object_id
                       =
                       --@TableID AND system_type_id IN(167, 175, 231, 239);
                       @TableID AND system_type_id IN(48, 52, 56, 59, 60, 62, 106, 108, 122, 127);
        -- the columns that can contain textual data        
		--167 = varchar; 175 = char; 231 = nvarchar; 239 = nchar        
		--48 = tinyint; 52 = smallint; 56 = int; 59 = real; 60 = money; 62 = float; 106 = decimal; 108 = numeric; 122 = smallmoney; 127 = bigint;  
OPEN CursorColumns;
        FETCH NEXT FROM CursorColumns INTO @ColumnName;
        WHILE
               @@FETCH_STATUS
               =
               0
            BEGIN
                SET @String = 'IF EXISTS (SELECT * FROM '
                            + @Table
                            + ' WHERE '
                            + @ColumnName
                            + ' LIKE ''%'
                            + @SearchText
                            + '%'') PRINT '''
                            + @Table
                            + ', '
                            + @ColumnName
                            + '''';
                EXECUTE (@String);
                FETCH NEXT FROM CursorColumns INTO @ColumnName;
            END;
        CLOSE CursorColumns;
        DEALLOCATE CursorColumns;
        FETCH NEXT FROM CursorSearch INTO @Table, @TableID;
    END;
CLOSE CursorSearch;
DEALLOCATE CursorSearch;