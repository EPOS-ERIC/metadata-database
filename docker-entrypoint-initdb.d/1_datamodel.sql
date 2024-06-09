\connect cerif;
BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* COMMON */
CREATE TYPE statustype AS ENUM ('ARCHIVED', 'DISCARDED', 'DRAFT', 'SUBMITTED', 'PUBLISHED');

CREATE TYPE roletype AS ENUM ('ADMIN', 'REVIEWER', 'VIEWER', 'EDITOR');

CREATE TYPE requeststatustype AS ENUM ('ACCEPTED', 'PENDING', 'NONE');

CREATE TYPE ontologytype AS ENUM ('BASE', 'MAPPING');

CREATE TABLE IF NOT EXISTS public.ontologies
(
    id character varying(100) NOT NULL,
    ontologyname character varying(1024),
    ontologybase64 text,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.versioningstatus
(
    version_id character varying(100) NOT NULL,
    instance_id character varying(100),
    meta_id character varying(100),
    uid character varying(100),
    instance_change_id character varying(1024),
    provenance character varying(1024),
    editor_id character varying(1024),
    reviewer_id character varying(100),
    review_comment character varying(1024),
    change_comment text,
    change_timestamp timestamptz,
    version character varying(1024),
    status character varying(100),
    PRIMARY KEY (version_id)
);

/* EPOS DATA MODEL MASTER ENTITIES TABLE */

CREATE TABLE IF NOT EXISTS public.edm_entity_id
(
    meta_id character varying(100),
    table_name character varying(1024),
    PRIMARY KEY (meta_id)
);

/* ROLES AND GROUPS */

CREATE TABLE IF NOT EXISTS public.metadata_user
(
    auth_identifier character varying(1024) NOT NULL,
    familyname character varying(1024),
    givenname character varying(1024),
    email character varying(1024),
    PRIMARY KEY (auth_identifier)
);

CREATE TABLE IF NOT EXISTS public.metadata_group
(
    id character varying(100) NOT NULL,
    name character varying(1024),
    description TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.metadata_group_user
(
    id character varying(100) NOT NULL,
    auth_identifier character varying(100) NOT NULL,
    group_id character varying(100),
    request_status requeststatustype,
    role roletype,
    PRIMARY KEY (id),
    FOREIGN KEY (group_id) REFERENCES public.metadata_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (auth_identifier) REFERENCES public.metadata_user (auth_identifier) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS public.authorization_group
(
    id character varying(100) NOT NULL,
    group_id character varying(100),
    meta_id character varying(100),
    PRIMARY KEY (id),
    FOREIGN KEY (group_id) REFERENCES public.metadata_group (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (meta_id) REFERENCES public.edm_entity_id (meta_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO public.metadata_group (id, name, description)
VALUES
    (uuid_generate_v4(), 'ALL', 'Basic group');

/* IDENTIFIER */

CREATE TABLE IF NOT EXISTS public.identifier
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    type character varying(1024),
    value character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);


/* QUANTITATIVEVALUE */

CREATE TABLE IF NOT EXISTS public.quantitativevalue
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    unitcode character varying(1024),
    value character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TYPE elementtype AS ENUM ('TELEPHONE', 'EMAIL', 'LANGUAGE', 'DOWNLOADURL', 'ACCESSURL','DOCUMENTATION', 'RETURNS', 'PARAMVALUE', 'PROGRAMMINGLANGUAGE', 'PAGEURL');

CREATE TABLE IF NOT EXISTS public.element
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    type character varying(100),
    value text NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.spatial
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    location text NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.temporal
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    startDate timestamp,
    endDate timestamp,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);


/* ADDRESS */

CREATE TABLE IF NOT EXISTS public.address
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    country character varying(255),
    countrycode character varying(10),
    street character varying(255),
    postal_code character varying(20),
    locality character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);


/* CATEGORIES AND CATEGORIES SCHEMES */


CREATE TABLE IF NOT EXISTS public.category_scheme
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    name character varying(255),
    code character varying(255),
    description TEXT,
    logo character varying(255),
    homepage character varying(255),
    color character varying(255),
    orderitemnumber character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.category
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    in_scheme character varying(100) REFERENCES public.category_scheme (instance_id),
    description TEXT,
    name character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.category_ispartof
(
    category1_instance_id character varying(100) NOT NULL,
    category2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (category1_instance_id, category2_instance_id),
    FOREIGN KEY (category1_instance_id) REFERENCES public.category (instance_id),
    FOREIGN KEY (category2_instance_id) REFERENCES public.category (instance_id)
);

CREATE TABLE IF NOT EXISTS public.category_hastopconcept
(
    category_scheme_instance_id character varying(100) NOT NULL,
    category_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (category_scheme_instance_id, category_instance_id),
    FOREIGN KEY (category_scheme_instance_id) REFERENCES public.category_scheme (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);

/* PERSON */


CREATE TABLE IF NOT EXISTS public.person
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    familyname character varying(1024),
    givenname character varying(1024),
    qualifications character varying(1024),
    cvurl character varying(1024),
    address_id character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (address_id) REFERENCES public.address (instance_id)
);

CREATE TABLE IF NOT EXISTS public.person_identifier
(
    person_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id,identifier_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES public.person (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.person_element /* email, telephone */
(
    person_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id, element_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES public.person (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


/* CONTACTPOINT */

CREATE TABLE IF NOT EXISTS public.contactpoint
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    role character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);


CREATE TABLE IF NOT EXISTS public.contactpoint_element /* email, telephone, language */
(
    contactpoint_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (contactpoint_instance_id, element_instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);

/* ORGANIZATION */

CREATE TABLE IF NOT EXISTS public.organization
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    acronym character varying(1024),
    leicode character varying(1024),
    address_id character varying(100),
    logo character varying(1024),
    URL character varying(1024),
    type character varying(1024),
    maturity character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (address_id) REFERENCES public.address (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_memberof
(
    organization1_instance_id character varying(100) NOT NULL,
    organization2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization1_instance_id, organization2_instance_id),
    FOREIGN KEY (organization1_instance_id) REFERENCES public.organization (instance_id),
    FOREIGN KEY (organization2_instance_id) REFERENCES public.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_affiliation
(
    person_instance_id character varying(100) NOT NULL,
    organization_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id, organization_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES public.person (instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_identifier
(
    organization_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id,identifier_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_element /* email, telephone */
(
    organization_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id, element_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


CREATE TABLE IF NOT EXISTS public.organization_legalname
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    legalname character varying(1024) NOT NULL,
    language character varying(1024),
    organization_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_contactpoint
(
    organization_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id, contactpoint_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.organization_owns
(
    organization_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (organization_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id)
);

/* DATAPRODUCT */


CREATE TABLE IF NOT EXISTS public.dataproduct
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    identifier character varying(1024),
    created timestamptz,
    issued timestamptz,
    modified timestamptz,
    versioninfo character varying(1024),
    type character varying(1024),
    accrualperiodicity character varying(1024),
    keywords text,
    accessright character varying(1024),
    documentation character varying(1024),
    qualityAssurance character varying(1024),
    has_quality_annotation character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_haspart
(
    dataproduct1_instance_id character varying(100) NOT NULL,
    dataproduct2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct1_instance_id, dataproduct2_instance_id),
    FOREIGN KEY (dataproduct1_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (dataproduct2_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_ispartof
(
    dataproduct1_instance_id character varying(100) NOT NULL,
    dataproduct2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct1_instance_id, dataproduct2_instance_id),
    FOREIGN KEY (dataproduct1_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (dataproduct2_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_publisher
(
    dataproduct_instance_id character varying(100) NOT NULL,
    organization_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, organization_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES public.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_contactpoint
(
    dataproduct_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, contactpoint_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_title
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    title character varying(1024) NOT NULL,
    lang character varying(20),
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_description
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    description text NOT NULL,
    lang character varying(20),
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_category
(
    dataproduct_instance_id character varying(100) NOT NULL,
    category_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, category_instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_provenance
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    provenance character varying(1024) NOT NULL,
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_identifier
(
    dataproduct_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,identifier_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_spatial
(
    dataproduct_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,spatial_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES public.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_temporal
(
    dataproduct_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,temporal_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES public.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS public.dataproduct_relation
(
    dataproduct_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (dataproduct_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id)
);


/* DISTRIBUTION */


CREATE TABLE IF NOT EXISTS public.distribution
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    issued timestamp,
    modified timestamp,
    type character varying(1024),
    format character varying(1024),
    license character varying(1024),
    datapolicy character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.distribution_dataproduct
(
    distribution_instance_id character varying(100) NOT NULL,
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, distribution_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES public.dataproduct (instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS public.distribution_title
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    title character varying(1024) NOT NULL,
    lang character varying(20),
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS public.distribution_description
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    description character varying(1024) NOT NULL,
    lang character varying(20),
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id)
);


CREATE TABLE IF NOT EXISTS public.distribution_element /* downloadurl, accessurl */
(
    distribution_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (distribution_instance_id, element_instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


/* WEBSERVICE */


CREATE TABLE IF NOT EXISTS public.webservice
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    schemaidentifier character varying(1024),
    description text,
    name character varying(1024),
    entrypoint character varying(1024),
    datapublished timestamp,
    datamodified timestamp,
    keywords text,
    license character varying(1024),
    provider character varying(100),
    aaaitypes character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

/* conforms to or dataservice */
CREATE TABLE IF NOT EXISTS public.webservice_distribution
(
    distribution_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, distribution_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS public.webservice_identifier
(
    webservice_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,identifier_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);


CREATE TABLE IF NOT EXISTS public.webservice_contactpoint
(
    webservice_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, contactpoint_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.webservice_category
(
    category_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, category_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);

CREATE TABLE IF NOT EXISTS public.webservice_element /* documentation */
(
    webservice_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, element_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


CREATE TABLE IF NOT EXISTS public.webservice_spatial
(
    webservice_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,spatial_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES public.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS public.webservice_temporal
(
    webservice_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,temporal_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES public.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS public.webservice_relation
(
    webservice_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (webservice_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id)
);

/* OPERATION */
CREATE TABLE IF NOT EXISTS public.operation
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    method character varying(1024),
    template text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.operation_webservice
(
    operation_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, operation_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES public.webservice (instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES public.operation (instance_id)
);

CREATE TABLE IF NOT EXISTS public.operation_distribution
(
    operation_instance_id character varying(100) NOT NULL,
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (distribution_instance_id, operation_instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES public.distribution (instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES public.operation (instance_id)
);


CREATE TABLE IF NOT EXISTS public.operation_element /* returns */
(
    operation_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (operation_instance_id, element_instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES public.operation (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


/* MAPPING */

CREATE TABLE IF NOT EXISTS public.mapping
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    label character varying(1024),
    variable character varying(1024) NOT NULL,
    required boolean NOT NULL,
    range character varying(1024) NOT NULL,
    defaultvalue character varying(1024),
    minvalue character varying(1024),
    maxvalue character varying(1024),
    property character varying(1024),
    valuepattern character varying(1024),
    read_only_value character varying(1024),
    multiple_values character varying(1024),
    ismappingof character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (ismappingof) REFERENCES public.operation (instance_id)
);

CREATE TABLE IF NOT EXISTS public.mapping_element /* paramvalue */
(
    mapping_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (mapping_instance_id, element_instance_id),
    FOREIGN KEY (mapping_instance_id) REFERENCES public.mapping (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


/* SOFTWAREAPPLICATION */

CREATE TABLE IF NOT EXISTS public.softwareapplication
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    name character varying(1024),
    description text,
    downloadURL character varying(1024),
    licenseURL character varying(1024),
    softwareversion character varying(1024),
    keywords text,
    requirements character varying(1024),
    installURL character varying(1024),
    mainentityofpage character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.softwareapplication_contactpoint
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, contactpoint_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES public.softwareapplication (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwareapplication_identifier
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id,identifier_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES public.softwareapplication (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwareapplication_parameters
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    encodingformat character varying(1024),
    conformsto character varying(1024),
    action character varying(1024) NOT NULL,
    softwareapplication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES public.softwareapplication (instance_id)
);


CREATE TABLE IF NOT EXISTS public.softwareapplication_operation
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    operation_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, operation_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES public.softwareapplication (instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES public.operation (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwareapplication_category
(
    category_instance_id character varying(100) NOT NULL,
    softwareapplication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, category_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES public.softwareapplication (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);


/* SOFTWARESOURCECODE */

CREATE TABLE IF NOT EXISTS public.softwaresourcecode
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    name character varying(1024),
    description text,
    licenseURL character varying(1024),
    downloadURL character varying(1024),
    runtimeplatform character varying(1024),
    softwareversion character varying(1024),
    keywords text,
    coderepository character varying(1024),
    mainentityofpage character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.softwaresourcecode_contactpoint
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, contactpoint_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES public.softwaresourcecode (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwaresourcecode_identifier
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id,identifier_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES public.softwaresourcecode (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwaresourcecode_element /* programminglanguage */
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, element_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES public.softwaresourcecode (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);

CREATE TABLE IF NOT EXISTS public.softwaresourcecode_category
(
    category_instance_id character varying(100) NOT NULL,
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, category_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES public.softwaresourcecode (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);


/* SERVICE */

CREATE TABLE IF NOT EXISTS public.service
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    name character varying(1024),
    description text,
    type character varying(1024),
    pageURL character varying(1024),
    keywords text,
    servicecontract character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.service_identifier
(
    service_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,identifier_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS public.service_contactpoint
(
    service_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id, contactpoint_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.service_spatial
(
    service_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,spatial_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES public.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS public.service_temporal
(
    service_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,temporal_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES public.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS public.service_category
(
    category_instance_id character varying(100) NOT NULL,
    service_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id, category_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);

CREATE TABLE IF NOT EXISTS public.service_provider /*person or organization*/
(
    service_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (service_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES public.service (instance_id)
);



/* PUBLICATION */

CREATE TABLE IF NOT EXISTS public.publication
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    name character varying(1024) NOT NULL,
    published timestamp,
    abstracttext text,
    licenseURL character varying(1024),
    keywords text,
    issn character varying(1024),
    pages integer,
    volumenumber character varying(1024),
    author character varying(1024) NOT NULL,
    publisher character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.publication_identifier
(
    publication_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id,identifier_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES public.publication (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES public.identifier (instance_id)
);


CREATE TABLE IF NOT EXISTS public.publication_contributor
(
    person_instance_id character varying(100) NOT NULL,
    publication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id, person_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES public.publication (instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES public.person (instance_id)
);


CREATE TABLE IF NOT EXISTS public.publication_category
(
    category_instance_id character varying(100) NOT NULL,
    publication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id, category_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES public.publication (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);


/* FACILITY */

CREATE TABLE IF NOT EXISTS public.facility
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    identifier character varying(1024),
    description text,
    title character varying(1024),
    type character(1024),
    keywords text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS public.facility_address
(
    facility_instance_id character varying(100) NOT NULL,
    address_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, address_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (address_instance_id) REFERENCES public.address (instance_id)
);

CREATE TABLE IF NOT EXISTS public.facility_contactpoint
(
    facility_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, contactpoint_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.facility_element /* pageurl */
(
    facility_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, element_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);


CREATE TABLE IF NOT EXISTS public.facility_ispartof
(
    facility1_instance_id character varying(100) NOT NULL,
    facility2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility1_instance_id, facility2_instance_id),
    FOREIGN KEY (facility1_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (facility2_instance_id) REFERENCES public.facility (instance_id)
);

CREATE TABLE IF NOT EXISTS public.facility_category
(
    category_instance_id character varying(100) NOT NULL,
    facility_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, category_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);

CREATE TABLE IF NOT EXISTS public.facility_spatial
(
    facility_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id,spatial_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES public.facility (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES public.spatial (instance_id)
);


/* EQUIPMENT */

CREATE TABLE IF NOT EXISTS public.equipment
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(100),
    version_id character varying(100),
    identifier character varying(1024),
    description text,
    name character varying(1024),
    type character(1024),
    creator character varying(100),
    keywords text,
    pageURL character varying(1024),
    filter character varying(1024),
    dynamicrange character varying(100),
    orientation character varying(1024),
    resolution character varying(1024),
    sampleperiod character varying(100),
    serialnumber character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES public.versioningstatus (version_id),
    FOREIGN KEY (creator) REFERENCES public.organization (instance_id)
);


CREATE TABLE IF NOT EXISTS public.equipment_contactpoint
(
    equipment_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, contactpoint_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES public.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_element /* pageurl */
(
    equipment_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, element_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES public.element (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_spatial
(
    equipment_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id,spatial_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES public.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_temporal
(
    equipment_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id,temporal_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES public.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_category
(
    category_instance_id character varying(100) NOT NULL,
    equipment_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, category_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES public.category (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_ispartof /*equipment or facility*/
(
    equipment_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (equipment_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id)
);

CREATE TABLE IF NOT EXISTS public.equipment_relation
(
    equipment_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (equipment_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES public.equipment (instance_id)
);

END;