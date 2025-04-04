\connect sharing_catalogue;
BEGIN;

CREATE TABLE IF NOT EXISTS public.configurations
(
    id character varying(1024) NOT NULL,
    configuration text NOT NULL,
    PRIMARY KEY (id)
);

END;
