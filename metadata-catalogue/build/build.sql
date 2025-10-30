\connect cerif

 SET client_encoding = 'UTF8';
 SET standard_conforming_strings = off;
 SET escape_string_warning = off;
 -- debug
 -- view if we are or not in the primary
 SELECT pg_is_in_recovery();

 CREATE SCHEMA metadata_catalogue AUTHORIZATION postgres;

 GRANT ALL PRIVILEGES ON SCHEMA metadata_catalogue TO epos_admin WITH GRANT OPTION;
 ALTER DEFAULT PRIVILEGES IN SCHEMA metadata_catalogue 
 GRANT ALL PRIVILEGES ON TABLES TO epos_admin WITH GRANT OPTION;

