-- ============================================================================
-- COMPREHENSIVE DYNAMIC INDEX CREATION SCRIPT
-- ============================================================================
-- This script automatically creates indexes on:
-- 1. Foreign key columns (for JOIN performance)
-- 2. Status/enum columns (for filtering)
-- 3. Timestamp columns (for date range queries)
-- 4. Commonly queried text fields
-- ============================================================================

DO $$
DECLARE
    rec RECORD;
    sql_stmt TEXT;
    index_count INTEGER := 0;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Starting comprehensive index creation...';
    RAISE NOTICE '========================================';
    
    -- ========================================================================
    -- SECTION 1: INDEX FOREIGN KEY COLUMNS
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '1. Creating indexes on foreign key columns...';
    RAISE NOTICE '----------------------------------------';
    
    FOR rec IN 
        SELECT DISTINCT
            tc.table_schema,
            tc.table_name,
            kcu.column_name,
            tc.constraint_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
            ON tc.constraint_name = kcu.constraint_name
            AND tc.table_schema = kcu.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
            AND tc.table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
        ORDER BY tc.table_schema, tc.table_name, kcu.column_name
    LOOP
        -- Check if index already exists
        IF NOT EXISTS (
            SELECT 1
            FROM pg_indexes
            WHERE schemaname = rec.table_schema
                AND tablename = rec.table_name
                AND indexdef LIKE '%' || rec.column_name || '%'
        ) THEN
            sql_stmt := format(
                'CREATE INDEX IF NOT EXISTS idx_%s_%s_%s ON %I.%I (%I)',
                rec.table_schema,
                rec.table_name,
                rec.column_name,
                rec.table_schema,
                rec.table_name,
                rec.column_name
            );
            
            RAISE NOTICE 'Creating FK index: %', sql_stmt;
            EXECUTE sql_stmt;
            index_count := index_count + 1;
        ELSE
            RAISE NOTICE 'Index already exists for FK: %.%.%', rec.table_schema, rec.table_name, rec.column_name;
        END IF;
    END LOOP;
    
    -- ========================================================================
    -- SECTION 2: INDEX STATUS/ENUM COLUMNS
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '2. Creating indexes on status/enum columns...';
    RAISE NOTICE '----------------------------------------';
    
    FOR rec IN
        SELECT DISTINCT
            n.nspname AS table_schema,
            c.relname AS table_name,
            a.attname AS column_name,
            t.typname AS type_name
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = c.oid
        JOIN pg_type t ON t.oid = a.atttypid
        WHERE c.relkind = 'r'
            AND n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
            AND a.attnum > 0
            AND NOT a.attisdropped
            AND (
                a.attname ILIKE '%status%' 
                OR a.attname ILIKE '%state%'
                OR a.attname = 'enabled'
                OR a.attname = 'installed'
                OR t.typtype = 'e'  -- enum types
            )
        ORDER BY n.nspname, c.relname, a.attname
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM pg_indexes
            WHERE schemaname = rec.table_schema
                AND tablename = rec.table_name
                AND indexdef LIKE '%' || rec.column_name || '%'
        ) THEN
            sql_stmt := format(
                'CREATE INDEX IF NOT EXISTS idx_%s_%s_%s ON %I.%I (%I)',
                rec.table_schema,
                rec.table_name,
                rec.column_name,
                rec.table_schema,
                rec.table_name,
                rec.column_name
            );
            
            RAISE NOTICE 'Creating status/enum index: %', sql_stmt;
            EXECUTE sql_stmt;
            index_count := index_count + 1;
        ELSE
            RAISE NOTICE 'Index already exists for status: %.%.%', rec.table_schema, rec.table_name, rec.column_name;
        END IF;
    END LOOP;
    
    -- ========================================================================
    -- SECTION 3: INDEX TIMESTAMP COLUMNS
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '3. Creating indexes on timestamp columns...';
    RAISE NOTICE '----------------------------------------';
    
    FOR rec IN
        SELECT DISTINCT
            n.nspname AS table_schema,
            c.relname AS table_name,
            a.attname AS column_name
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = c.oid
        JOIN pg_type t ON t.oid = a.atttypid
        WHERE c.relkind = 'r'
            AND n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
            AND a.attnum > 0
            AND NOT a.attisdropped
            AND (
                t.typname IN ('timestamp', 'timestamptz', 'date')
                OR a.attname ILIKE '%time%'
                OR a.attname ILIKE '%date%'
            )
        ORDER BY n.nspname, c.relname, a.attname
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM pg_indexes
            WHERE schemaname = rec.table_schema
                AND tablename = rec.table_name
                AND indexdef LIKE '%' || rec.column_name || '%'
        ) THEN
            sql_stmt := format(
                'CREATE INDEX IF NOT EXISTS idx_%s_%s_%s ON %I.%I (%I)',
                rec.table_schema,
                rec.table_name,
                rec.column_name,
                rec.table_schema,
                rec.table_name,
                rec.column_name
            );
            
            RAISE NOTICE 'Creating timestamp index: %', sql_stmt;
            EXECUTE sql_stmt;
            index_count := index_count + 1;
        ELSE
            RAISE NOTICE 'Index already exists for timestamp: %.%.%', rec.table_schema, rec.table_name, rec.column_name;
        END IF;
    END LOOP;
    
    -- ========================================================================
    -- SECTION 4: INDEX COMMONLY SEARCHED TEXT COLUMNS
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '4. Creating indexes on commonly searched text columns...';
    RAISE NOTICE '----------------------------------------';
    
    FOR rec IN
        SELECT DISTINCT
            n.nspname AS table_schema,
            c.relname AS table_name,
            a.attname AS column_name
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = c.oid
        JOIN pg_type t ON t.oid = a.atttypid
        WHERE c.relkind = 'r'
            AND n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
            AND a.attnum > 0
            AND NOT a.attisdropped
            AND (
                a.attname IN ('name', 'email', 'username', 'code', 'identifier')
                OR a.attname ILIKE '%_id'
                OR a.attname ILIKE '%_uid'
            )
            AND t.typname IN ('varchar', 'text', 'bpchar')
        ORDER BY n.nspname, c.relname, a.attname
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM pg_indexes
            WHERE schemaname = rec.table_schema
                AND tablename = rec.table_name
                AND indexdef LIKE '%' || rec.column_name || '%'
        ) THEN
            sql_stmt := format(
                'CREATE INDEX IF NOT EXISTS idx_%s_%s_%s ON %I.%I (%I)',
                rec.table_schema,
                rec.table_name,
                rec.column_name,
                rec.table_schema,
                rec.table_name,
                rec.column_name
            );
            
            RAISE NOTICE 'Creating text column index: %', sql_stmt;
            EXECUTE sql_stmt;
            index_count := index_count + 1;
        ELSE
            RAISE NOTICE 'Index already exists for text column: %.%.%', rec.table_schema, rec.table_name, rec.column_name;
        END IF;
    END LOOP;
    
    -- ========================================================================
    -- SECTION 5: COMPOSITE INDEXES FOR COMMON QUERY PATTERNS
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '5. Creating composite indexes for common patterns...';
    RAISE NOTICE '----------------------------------------';
    
    -- Example: Status + timestamp combinations (very common for filtering recent active records)
    FOR rec IN
        SELECT DISTINCT
            n.nspname AS table_schema,
            c.relname AS table_name,
            s.attname AS status_column,
            t.attname AS time_column
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute s ON s.attrelid = c.oid
        JOIN pg_attribute t ON t.attrelid = c.oid
        JOIN pg_type st ON st.oid = s.atttypid
        JOIN pg_type tt ON tt.oid = t.atttypid
        WHERE c.relkind = 'r'
            AND n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
            AND s.attnum > 0 AND NOT s.attisdropped
            AND t.attnum > 0 AND NOT t.attisdropped
            AND s.attname ILIKE '%status%'
            AND (tt.typname IN ('timestamp', 'timestamptz') OR t.attname ILIKE '%time%')
        ORDER BY n.nspname, c.relname
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM pg_indexes
            WHERE schemaname = rec.table_schema
                AND tablename = rec.table_name
                AND indexdef LIKE '%' || rec.status_column || '%' || rec.time_column || '%'
        ) THEN
            sql_stmt := format(
                'CREATE INDEX IF NOT EXISTS idx_%s_%s_%s_%s ON %I.%I (%I, %I)',
                rec.table_schema,
                rec.table_name,
                rec.status_column,
                rec.time_column,
                rec.table_schema,
                rec.table_name,
                rec.status_column,
                rec.time_column
            );
            
            RAISE NOTICE 'Creating composite index: %', sql_stmt;
            EXECUTE sql_stmt;
            index_count := index_count + 1;
        ELSE
            RAISE NOTICE 'Composite index already exists: %.%.% + %', rec.table_schema, rec.table_name, rec.status_column, rec.time_column;
        END IF;
    END LOOP;
    
    -- ========================================================================
    -- SUMMARY
    -- ========================================================================
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Index creation completed!';
    RAISE NOTICE 'Total new indexes created: %', index_count;
    RAISE NOTICE '========================================';
    
END $$;

-- ============================================================================
-- ANALYZE TABLES AFTER INDEX CREATION
-- ============================================================================
DO $$
DECLARE
    rec RECORD;
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE 'Running ANALYZE on all tables to update statistics...';
    
    FOR rec IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
        ORDER BY schemaname, tablename
    LOOP
        EXECUTE format('ANALYZE %I.%I', rec.schemaname, rec.tablename);
        RAISE NOTICE 'Analyzed: %.%', rec.schemaname, rec.tablename;
    END LOOP;
    
    RAISE NOTICE 'ANALYZE completed!';
END $$;



-- ============================================================================
-- TARGETED INDEXES FOR YOUR SPECIFIC SCHEMA
-- ============================================================================
-- Based on your uploaded schema files, here are specific indexes that will
-- significantly improve query performance for your use cases.
-- ============================================================================

BEGIN;

-- ============================================================================
-- PLUGIN REGISTRY SCHEMA INDEXES
-- ============================================================================

-- Plugin table indexes
CREATE INDEX IF NOT EXISTS idx_plugin_installed ON converter_catalogue.plugin(installed);
CREATE INDEX IF NOT EXISTS idx_plugin_enabled ON converter_catalogue.plugin(enabled);
CREATE INDEX IF NOT EXISTS idx_plugin_runtime ON converter_catalogue.plugin(runtime);
CREATE INDEX IF NOT EXISTS idx_plugin_version_type ON converter_catalogue.plugin(version_type);
CREATE INDEX IF NOT EXISTS idx_plugin_name ON converter_catalogue.plugin(name);

-- Composite index for finding enabled and installed plugins
CREATE INDEX IF NOT EXISTS idx_plugin_enabled_installed ON converter_catalogue.plugin(enabled, installed);

-- Plugin relations indexes
CREATE INDEX IF NOT EXISTS idx_plugin_relations_plugin_id ON converter_catalogue.plugin_relations(plugin_id);
CREATE INDEX IF NOT EXISTS idx_plugin_relations_relation_id ON converter_catalogue.plugin_relations(relation_id);
CREATE INDEX IF NOT EXISTS idx_plugin_relations_formats ON converter_catalogue.plugin_relations(input_format, output_format);

-- ============================================================================
-- PROCESSING ENVIRONMENT SCHEMA INDEXES
-- ============================================================================

-- Processing unit indexes
CREATE INDEX IF NOT EXISTS idx_processing_unit_status ON processing_catalogue.processing_unit(status);
CREATE INDEX IF NOT EXISTS idx_processing_unit_icsd_user_id ON processing_catalogue.processing_unit(icsd_user_id);
CREATE INDEX IF NOT EXISTS idx_processing_unit_type_id ON processing_catalogue.processing_unit(processing_environment_type_id);
CREATE INDEX IF NOT EXISTS idx_processing_unit_creation_time ON processing_catalogue.processing_unit(creation_time);
CREATE INDEX IF NOT EXISTS idx_processing_unit_changed_time ON processing_catalogue.processing_unit(changed_time);
CREATE INDEX IF NOT EXISTS idx_processing_unit_environment_unit_id ON processing_catalogue.processing_unit(environment_unit_id);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_processing_unit_user_status ON processing_catalogue.processing_unit(icsd_user_id, status);
CREATE INDEX IF NOT EXISTS idx_processing_unit_status_changed ON processing_catalogue.processing_unit(status, changed_time);

-- Resource item indexes
CREATE INDEX IF NOT EXISTS idx_resource_item_processing_unit_id ON processing_catalogue.resource_item(processing_unit_id);
CREATE INDEX IF NOT EXISTS idx_resource_item_status ON processing_catalogue.resource_item(status);
CREATE INDEX IF NOT EXISTS idx_resource_item_resource_uid ON processing_catalogue.resource_item(resource_uid);
CREATE INDEX IF NOT EXISTS idx_resource_item_addition_time ON processing_catalogue.resource_item(addition_time);
CREATE INDEX IF NOT EXISTS idx_resource_item_file_type ON processing_catalogue.resource_item(file_type);

-- Composite index for finding resources by status and time
CREATE INDEX IF NOT EXISTS idx_resource_item_status_time ON processing_catalogue.resource_item(status, addition_time);

-- ============================================================================
-- USER GROUP SCHEMA INDEXES
-- ============================================================================

-- User indexes
CREATE INDEX IF NOT EXISTS idx_metadata_user_email ON usergroup_catalogue.metadata_user(email);
CREATE INDEX IF NOT EXISTS idx_metadata_user_familyname ON usergroup_catalogue.metadata_user(familyname);
CREATE INDEX IF NOT EXISTS idx_metadata_user_isadmin ON usergroup_catalogue.metadata_user(isadmin);

-- Group indexes
CREATE INDEX IF NOT EXISTS idx_metadata_group_name ON usergroup_catalogue.metadata_group(name);

-- Group user indexes (already has FK indexes from comprehensive script, but adding specific ones)
CREATE INDEX IF NOT EXISTS idx_metadata_group_user_auth_id ON usergroup_catalogue.metadata_group_user(auth_identifier);
CREATE INDEX IF NOT EXISTS idx_metadata_group_user_group_id ON usergroup_catalogue.metadata_group_user(group_id);
CREATE INDEX IF NOT EXISTS idx_metadata_group_user_status ON usergroup_catalogue.metadata_group_user(request_status);
CREATE INDEX IF NOT EXISTS idx_metadata_group_user_role ON usergroup_catalogue.metadata_group_user(role);

-- Composite index for finding users in groups by status
CREATE INDEX IF NOT EXISTS idx_metadata_group_user_group_status ON usergroup_catalogue.metadata_group_user(group_id, request_status);

-- Authorization group indexes
CREATE INDEX IF NOT EXISTS idx_authorization_group_group_id ON usergroup_catalogue.authorization_group(group_id);
CREATE INDEX IF NOT EXISTS idx_authorization_group_meta_id ON usergroup_catalogue.authorization_group(meta_id);

-- ============================================================================
-- SHARING CATALOGUE SCHEMA INDEXES
-- ============================================================================

-- Configuration indexes (id is already primary key, no additional needed unless you have patterns)
-- If you frequently search configuration content, consider a GIN index:
-- CREATE INDEX IF NOT EXISTS idx_configurations_content_gin ON sharing_catalogue.configurations USING gin(to_tsvector('english', configuration));

-- ============================================================================
-- PARTIAL INDEXES FOR COMMON FILTERED QUERIES
-- ============================================================================

-- Partial index for only READY processing units (much smaller, faster)
CREATE INDEX IF NOT EXISTS idx_processing_unit_ready ON processing_catalogue.processing_unit(icsd_user_id, changed_time) 
WHERE status = 'READY';

-- Partial index for only LOADED resource items
CREATE INDEX IF NOT EXISTS idx_resource_item_loaded ON processing_catalogue.resource_item(processing_unit_id, addition_time) 
WHERE status = 'LOADED';

-- Partial index for enabled plugins
CREATE INDEX IF NOT EXISTS idx_plugin_enabled_only ON converter_catalogue.plugin(name, version) 
WHERE enabled = true;

-- ============================================================================
-- TEXT SEARCH INDEXES (Optional - uncomment if you need full-text search)
-- ============================================================================

-- Full-text search on plugin descriptions
-- CREATE INDEX IF NOT EXISTS idx_plugin_description_fts ON converter_catalogue.plugin 
-- USING gin(to_tsvector('english', description));

-- Full-text search on processing unit descriptions
-- CREATE INDEX IF NOT EXISTS idx_processing_unit_description_fts ON processing_catalogue.processing_unit 
-- USING gin(to_tsvector('english', description));

-- Full-text search on resource item file descriptions
-- CREATE INDEX IF NOT EXISTS idx_resource_item_description_fts ON processing_catalogue.resource_item 
-- USING gin(to_tsvector('english', file_description));

COMMIT;

-- ============================================================================
-- ANALYZE TABLES
-- ============================================================================
ANALYZE converter_catalogue.plugin;
ANALYZE converter_catalogue.plugin_relations;
ANALYZE processing_catalogue.processing_unit;
ANALYZE processing_catalogue.resource_item;
ANALYZE usergroup_catalogue.metadata_user;
ANALYZE usergroup_catalogue.metadata_group;
ANALYZE usergroup_catalogue.metadata_group_user;
ANALYZE usergroup_catalogue.authorization_group;
ANALYZE sharing_catalogue.configurations;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================
DO $$
BEGIN
    RAISE NOTICE 'Targeted indexes created successfully!';
    RAISE NOTICE 'All tables analyzed and statistics updated.';
END $$;


-- ============================================================================
-- INDEX ANALYSIS AND MONITORING UTILITIES
-- ============================================================================
-- This script helps you:
-- 1. View all existing indexes
-- 2. Find missing indexes based on query patterns
-- 3. Identify unused indexes
-- 4. Check index sizes
-- ============================================================================

-- ============================================================================
-- VIEW 1: All Indexes Summary
-- ============================================================================
SELECT 
    schemaname AS schema,
    tablename AS table,
    indexname AS index,
    indexdef AS definition,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_indexes
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
ORDER BY schemaname, tablename, indexname;

-- ============================================================================
-- VIEW 2: Indexes by Size (Largest First)
-- ============================================================================
SELECT 
    schemaname AS schema,
    tablename AS table,
    indexname AS index,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size,
    pg_relation_size(indexrelid) AS size_bytes
FROM pg_indexes
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- VIEW 3: Unused Indexes (Consider Dropping)
-- ============================================================================
-- Note: Requires pg_stat_statements extension or pg_stat_user_indexes
SELECT
    schemaname AS schema,
    tablename AS table,
    indexname AS index,
    idx_scan AS scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size
FROM pg_stat_user_indexes
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
    AND idx_scan = 0  -- Never been used
    AND indexrelname NOT LIKE 'pg_toast%'
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- VIEW 4: Foreign Keys Without Indexes
-- ============================================================================
WITH foreign_keys AS (
    SELECT
        tc.table_schema,
        tc.table_name,
        kcu.column_name,
        tc.constraint_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
    WHERE tc.constraint_type = 'FOREIGN KEY'
        AND tc.table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
),
indexed_columns AS (
    SELECT DISTINCT
        schemaname AS table_schema,
        tablename AS table_name,
        regexp_split_to_table(
            regexp_replace(
                substring(indexdef from '\(([^)]+)\)'),
                '\s+',
                '',
                'g'
            ),
            ','
        ) AS column_name
    FROM pg_indexes
    WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
)
SELECT 
    fk.table_schema AS schema,
    fk.table_name AS table,
    fk.column_name AS foreign_key_column,
    fk.constraint_name,
    'Missing index on foreign key!' AS status
FROM foreign_keys fk
LEFT JOIN indexed_columns ic
    ON fk.table_schema = ic.table_schema
    AND fk.table_name = ic.table_name
    AND fk.column_name = ic.column_name
WHERE ic.column_name IS NULL
ORDER BY fk.table_schema, fk.table_name, fk.column_name;

-- ============================================================================
-- VIEW 5: Duplicate Indexes
-- ============================================================================
WITH index_columns AS (
    SELECT
        schemaname,
        tablename,
        indexname,
        array_agg(attname ORDER BY attnum) AS columns
    FROM (
        SELECT
            n.nspname AS schemaname,
            t.relname AS tablename,
            i.relname AS indexname,
            a.attname,
            a.attnum
        FROM pg_index ix
        JOIN pg_class t ON t.oid = ix.indrelid
        JOIN pg_class i ON i.oid = ix.indexrelid
        JOIN pg_namespace n ON n.oid = t.relnamespace
        JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(ix.indkey)
        WHERE t.relkind = 'r'
            AND n.nspname NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
    ) sub
    GROUP BY schemaname, tablename, indexname
)
SELECT
    ic1.schemaname AS schema,
    ic1.tablename AS table,
    ic1.indexname AS index1,
    ic2.indexname AS index2,
    ic1.columns AS indexed_columns
FROM index_columns ic1
JOIN index_columns ic2
    ON ic1.schemaname = ic2.schemaname
    AND ic1.tablename = ic2.tablename
    AND ic1.columns = ic2.columns
    AND ic1.indexname < ic2.indexname
ORDER BY ic1.schemaname, ic1.tablename;

-- ============================================================================
-- VIEW 6: Table Statistics
-- ============================================================================
SELECT
    schemaname AS schema,
    tablename AS table,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) AS indexes_size,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows
FROM pg_stat_user_tables
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- ============================================================================
-- VIEW 7: Index Usage Statistics
-- ============================================================================
SELECT
    schemaname AS schema,
    tablename AS table,
    indexname AS index,
    idx_scan AS scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched,
    pg_size_pretty(pg_relation_size(indexrelid)) AS size,
    CASE
        WHEN idx_scan = 0 THEN 'Never used'
        WHEN idx_scan < 10 THEN 'Rarely used'
        WHEN idx_scan < 100 THEN 'Sometimes used'
        ELSE 'Frequently used'
    END AS usage_level
FROM pg_stat_user_indexes
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- UTILITY: Generate DROP statements for unused indexes
-- ============================================================================
SELECT
    'DROP INDEX IF EXISTS ' || schemaname || '.' || indexname || '; -- ' || 
    'Size: ' || pg_size_pretty(pg_relation_size(indexrelid)) || 
    ', Scans: ' || idx_scan AS drop_statement
FROM pg_stat_user_indexes
WHERE schemaname NOT IN ('information_schema', 'pg_catalog', 'pg_toast', 'tiger', 'topology')
    AND idx_scan = 0
    AND indexrelname NOT LIKE '%_pkey'  -- Don't drop primary keys
    AND indexrelname NOT LIKE 'pg_toast%'
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- UTILITY: Reset Index Statistics (for monitoring)
-- ============================================================================
-- Uncomment to reset statistics
-- SELECT pg_stat_reset();