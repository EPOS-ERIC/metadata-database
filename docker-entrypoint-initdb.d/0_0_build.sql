\connect postgres

-- Set client encoding and string behavior
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

-- Create database with proper encoding and collation
CREATE DATABASE metadata_catalogue 
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;

-- Connect to the newly created database
\connect metadata_catalogue

-- Install necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- For text similarity search
CREATE EXTENSION IF NOT EXISTS "btree_gin";  -- For GIN indexing on B-tree columns

-- Set optimal parameters for this database
ALTER DATABASE metadata_catalogue SET work_mem = '64MB';           -- Helps with complex joins
ALTER DATABASE metadata_catalogue SET maintenance_work_mem = '256MB'; -- Helps with index creation
ALTER DATABASE metadata_catalogue SET random_page_cost = 1.1;      -- Optimized for SSD storage
ALTER DATABASE metadata_catalogue SET effective_cache_size = '4GB'; -- Depends on your server memory
ALTER DATABASE metadata_catalogue SET default_statistics_target = 500; -- More detailed statistics