\connect postgres

REVOKE CONNECT ON DATABASE metadata_catalogue FROM PUBLIC, metadata_catalogue_admin;
REVOKE CONNECT ON DATABASE public FROM PUBLIC, metadata_catalogue_admin;

SELECT 
    pg_terminate_backend(pid) 
FROM 
    pg_stat_activity 
WHERE 
    pid <> pg_backend_pid()
    AND datname = 'metadata_catalogue'
    ;

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP DATABASE metadata_catalogue;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

CREATE DATABASE "metadata_catalogue"  OWNER = postgres;

GRANT ALL ON SCHEMA public TO metadata_catalogue_admin;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

GRANT ALL ON DATABASE metadata_catalogue TO metadata_catalogue_admin;

\connect metadata_catalogue
