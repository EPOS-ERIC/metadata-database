-- Connect to postgres database first
\connect postgres

-- Revoke connections and terminate existing sessions
REVOKE CONNECT ON DATABASE cerif FROM epos_admin;

SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE pid <> pg_backend_pid()
    AND datname = 'cerif';

-- Connect to cerif
\connect cerif

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

-- Truncate all tables (clears data but keeps structure)
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'metadata_catalogue') LOOP
        BEGIN
            EXECUTE 'TRUNCATE TABLE metadata_catalogue.' || quote_ident(r.tablename) || ' CASCADE';
            RAISE NOTICE 'Truncated: %', r.tablename;
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'Skipped (not found): %', r.tablename;
        END;
    END LOOP;
END $$;

DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'converter_catalogue') LOOP
        BEGIN
            EXECUTE 'TRUNCATE TABLE converter_catalogue.' || quote_ident(r.tablename) || ' CASCADE';
            RAISE NOTICE 'Truncated: %', r.tablename;
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'Skipped (not found): %', r.tablename;
        END;
    END LOOP;
END $$;

DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'processing_catalogue') LOOP
        BEGIN
            EXECUTE 'TRUNCATE TABLE processing_catalogue.' || quote_ident(r.tablename) || ' CASCADE';
            RAISE NOTICE 'Truncated: %', r.tablename;
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'Skipped (not found): %', r.tablename;
        END;
    END LOOP;
END $$;

DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'sharing_catalogue') LOOP
        BEGIN
            EXECUTE 'TRUNCATE TABLE sharing_catalogue.' || quote_ident(r.tablename) || ' CASCADE';
            RAISE NOTICE 'Truncated: %', r.tablename;
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'Skipped (not found): %', r.tablename;
        END;
    END LOOP;
END $$;

DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'usergroup_catalogue') LOOP
        BEGIN
            EXECUTE 'TRUNCATE TABLE usergroup_catalogue.' || quote_ident(r.tablename) || ' CASCADE';
            RAISE NOTICE 'Truncated: %', r.tablename;
        EXCEPTION
            WHEN undefined_table THEN
                RAISE NOTICE 'Skipped (not found): %', r.tablename;
        END;
    END LOOP;
END $$;

ALTER TABLE metadata_catalogue.softwareapplication_author DROP CONSTRAINT IF EXISTS softwareapplication_author_entity_instance_id_resource_enti_key;
ALTER TABLE metadata_catalogue.softwareapplication_contributor DROP CONSTRAINT IF EXISTS softwareapplication_contribut_entity_instance_id_resource_e_key;
ALTER TABLE metadata_catalogue.softwareapplication_creator DROP CONSTRAINT IF EXISTS softwareapplication_creator_entity_instance_id_resource_ent_key;
ALTER TABLE metadata_catalogue.softwareapplication_funder DROP CONSTRAINT IF EXISTS softwareapplication_funder_entity_instance_id_resource_enti_key;
ALTER TABLE metadata_catalogue.softwareapplication_maintainer DROP CONSTRAINT IF EXISTS softwareapplication_maintaine_entity_instance_id_resource_e_key;
ALTER TABLE metadata_catalogue.softwareapplication_provider DROP CONSTRAINT IF EXISTS softwareapplication_provider_entity_instance_id_resource_en_key;
ALTER TABLE metadata_catalogue.softwareapplication_publisher DROP CONSTRAINT IF EXISTS softwareapplication_publisher_entity_instance_id_resource_e_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_author DROP CONSTRAINT IF EXISTS softwaresourcecode_author_entity_instance_id_resource_entit_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_contributor DROP CONSTRAINT IF EXISTS softwaresourcecode_contributo_entity_instance_id_resource_e_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_creator DROP CONSTRAINT IF EXISTS softwaresourcecode_creator_entity_instance_id_resource_enti_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_funder DROP CONSTRAINT IF EXISTS softwaresourcecode_funder_entity_instance_id_resource_entit_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_maintainer DROP CONSTRAINT IF EXISTS softwaresourcecode_maintainer_entity_instance_id_resource_e_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_provider DROP CONSTRAINT IF EXISTS softwaresourcecode_provider_entity_instance_id_resource_ent_key;
ALTER TABLE metadata_catalogue.softwaresourcecode_publisher DROP CONSTRAINT IF EXISTS softwaresourcecode_publisher_entity_instance_id_resource_en_key;

-- Re-grant database connection rights
\connect postgres
GRANT CONNECT ON DATABASE cerif TO epos_admin;
GRANT ALL ON DATABASE cerif TO epos_admin;

\connect cerif
