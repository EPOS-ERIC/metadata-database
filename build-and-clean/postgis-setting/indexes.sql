DO $$
DECLARE
    rec RECORD;
    sql_stmt TEXT;
BEGIN
    FOR rec IN 
        SELECT 
            t.table_schema,
            t.table_name,
            string_agg(kcu.column_name, ', ') AS pk_columns,
            string_agg(kcu.column_name, '_') AS pk_columns_underscore
        FROM information_schema.tables t
        JOIN information_schema.table_constraints tc 
            ON t.table_name = tc.table_name 
            AND t.table_schema = tc.table_schema
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name 
            AND tc.table_schema = kcu.table_schema
        WHERE tc.constraint_type = 'PRIMARY KEY'
            AND t.table_schema NOT IN ('information_schema', 'pg_catalog')
        GROUP BY t.table_schema, t.table_name
    LOOP
        sql_stmt := 'CREATE INDEX IF NOT EXISTS idx_' || 
                   rec.table_schema || '_' || 
                   rec.table_name || '_' || 
                   rec.pk_columns_underscore || 
                   ' ON ' || rec.table_schema || '.' || rec.table_name || 
                   ' (' || rec.pk_columns || ')';
        
        RAISE NOTICE 'Executing: %', sql_stmt;
        EXECUTE sql_stmt;
    END LOOP;
END $$;