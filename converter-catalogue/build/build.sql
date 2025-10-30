\connect cerif

 SET client_encoding = 'UTF8';
 SET standard_conforming_strings = off;
 SET escape_string_warning = off;

 CREATE SCHEMA converter_catalogue  AUTHORIZATION postgres;
 
 GRANT ALL PRIVILEGES ON SCHEMA converter_catalogue TO epos_admin WITH GRANT OPTION;
 ALTER DEFAULT PRIVILEGES IN SCHEMA converter_catalogue 
 GRANT ALL PRIVILEGES ON TABLES TO epos_admin WITH GRANT OPTION;

