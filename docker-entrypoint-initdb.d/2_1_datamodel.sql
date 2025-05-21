\connect metadata_catalogue;
BEGIN;


CREATE TABLE IF NOT EXISTS usergroup_catalogue.metadata_user
(
    auth_identifier character varying(1024) NOT NULL,
    familyname character varying(1024),
    givenname character varying(1024),
    email character varying(1024),
    isadmin character varying(1024),
    PRIMARY KEY (auth_identifier)
);

CREATE TABLE IF NOT EXISTS usergroup_catalogue.metadata_group
(
    id character varying(100) NOT NULL,
    name character varying(1024),
    description text,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usergroup_catalogue.metadata_group_user
(
    id character varying(100) NOT NULL,
    auth_identifier character varying(100) NOT NULL,
    group_id character varying(100),
    request_status character varying(100),
    role character varying(100),
    PRIMARY KEY (id),
    FOREIGN KEY (group_id) REFERENCES usergroup_catalogue.metadata_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (auth_identifier) REFERENCES usergroup_catalogue.metadata_user (auth_identifier) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS usergroup_catalogue.authorization_group
(
    id character varying(100) NOT NULL,
    group_id character varying(100),
    meta_id character varying(100),
    PRIMARY KEY (id),
    FOREIGN KEY (group_id) REFERENCES usergroup_catalogue.metadata_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (meta_id) REFERENCES metadata_catalogue.edm_entity_id (meta_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO usergroup_catalogue.metadata_group (id, name, description)
VALUES
    (uuid_generate_v4(), 'ALL', 'Basic group');

END;