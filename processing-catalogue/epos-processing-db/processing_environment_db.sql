\connect processing_catalogue;
BEGIN;

CREATE TYPE processing_unit_status AS ENUM ('READY', 'CREATING', 'UPDATING', 'DELETING', 'NOT_READY');

CREATE TYPE processing_item_status AS ENUM ('LOADED', 'NOT_LOADED');

CREATE CAST (varchar AS processing_unit_status) WITH INOUT AS IMPLICIT;

CREATE CAST (varchar AS processing_item_status) WITH INOUT AS IMPLICIT;

CREATE TABLE IF NOT EXISTS public.processing_unit
(
    id character varying(1024) NOT NULL,
    name character varying(1024) NOT NULL,
    environment_unit_url character varying(1024),
    environment_unit_id character varying(1024),
    description text,
    icsd_user_id character varying(1024) NOT NULL,
    processing_environment_type_id character varying(1024) NOT NULL,
    creation_time timestamptz NOT NULL,
    changed_time timestamptz NOT NULL,
    status processing_unit_status NOT NULL,
    additional_information character varying(10485760),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.resource_item
(
    id character varying(1024) NOT NULL,
    processing_unit_id character varying(1024),
    addition_time timestamptz NOT NULL,
    resource_uid character varying(1024) NOT NULL,
    resource_url character varying(1024),
    resource_version character varying(1024),
    file_name character varying(1024),
    file_description text,
    file_type character varying(1024),
    status processing_item_status NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS  public.resource_item
    ADD FOREIGN KEY (processing_unit_id)
    references public.processing_unit (id);

END;
