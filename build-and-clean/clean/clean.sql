\connect postgres

REVOKE CONNECT ON DATABASE cerif FROM PUBLIC, cerif_admin;
REVOKE CONNECT ON DATABASE public FROM PUBLIC, cerif_admin;

SELECT 
    pg_terminate_backend(pid) 
FROM 
    pg_stat_activity 
WHERE 
    pid <> pg_backend_pid()
    AND datname = 'cerif'
    ;

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP DATABASE cerif;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

CREATE DATABASE "cerif"  OWNER = postgres;

GRANT ALL ON SCHEMA public TO cerif_admin;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

GRANT ALL ON DATABASE cerif TO cerif_admin;

\connect cerif
