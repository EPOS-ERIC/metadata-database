BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* COMMON */
CREATE TYPE statustype AS ENUM ('ARCHIVED', 'DISCARDED', 'DRAFT', 'SUBMITTED', 'PUBLISHED');

CREATE TYPE roletype AS ENUM ('ADMIN', 'REVIEWER', 'VIEWER', 'EDITOR');

CREATE TYPE requeststatustype AS ENUM ('ACCEPTED', 'PENDING', 'NONE');

CREATE TYPE ontologytype AS ENUM ('BASE', 'MAPPING');

CREATE TABLE IF NOT EXISTS metadata_catalogue.ontologies
(
    id character varying(100) NOT NULL,
    name character varying(1024),
    type character varying(1024),
    content text,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.versioningstatus
(
    version_id character varying(100) NOT NULL,
    instance_id character varying(100),
    meta_id character varying(100),
    uid character varying(1024),
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

CREATE TABLE IF NOT EXISTS metadata_catalogue.edm_entity_id
(
    meta_id character varying(100),
    table_name character varying(1024),
    PRIMARY KEY (meta_id)
);


/* IDENTIFIER */

CREATE TABLE IF NOT EXISTS metadata_catalogue.identifier
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    type character varying(1024),
    value character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);


/* QUANTITATIVEVALUE */

CREATE TABLE IF NOT EXISTS metadata_catalogue.quantitativevalue
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    unitcode character varying(1024),
    value character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

/* ATTRIBUTION */

CREATE TABLE IF NOT EXISTS metadata_catalogue.attribution
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    agent_id character varying(1024),
    agent_type character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.attribution_role
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    attribution_instance_id character varying(1024),
    roletype character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (attribution_instance_id) REFERENCES metadata_catalogue.attribution (instance_id)
);

CREATE TYPE elementtype AS ENUM ('TELEPHONE', 'EMAIL', 'LANGUAGE', 'DOWNLOADURL', 'ACCESSURL','DOCUMENTATION', 'RETURNS', 'PARAMVALUE', 'PROGRAMMINGLANGUAGE', 'PAGEURL', 'CITATION', 'OPERATINGSYSTEM', 'REFERENCEDBY', 'LANDINGPAGE', 'VARIABLEMEASURED');

CREATE TABLE IF NOT EXISTS metadata_catalogue.element
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    type character varying(100),
    value text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.spatial
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    location text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.temporal
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    startDate timestamp,
    endDate timestamp,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);


/* ADDRESS */

CREATE TABLE IF NOT EXISTS metadata_catalogue.address
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    country character varying(255),
    countrycode character varying(10),
    street character varying(255),
    postal_code character varying(50),
    locality character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);


/* CATEGORIES AND CATEGORIES SCHEMES */


CREATE TABLE IF NOT EXISTS metadata_catalogue.category_scheme
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    name character varying(255),
    code character varying(255),
    description text,
    logo character varying(255),
    homepage character varying(255),
    color character varying(255),
    orderitemnumber character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.category
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    in_scheme character varying(100) REFERENCES metadata_catalogue.category_scheme (instance_id),
    description text,
    name character varying(255),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.category_ispartof
(
    category1_instance_id character varying(100) NOT NULL,
    category2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (category1_instance_id, category2_instance_id),
    FOREIGN KEY (category1_instance_id) REFERENCES metadata_catalogue.category (instance_id),
    FOREIGN KEY (category2_instance_id) REFERENCES metadata_catalogue.category (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.category_hastopconcept
(
    category_scheme_instance_id character varying(100) NOT NULL,
    category_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (category_scheme_instance_id, category_instance_id),
    FOREIGN KEY (category_scheme_instance_id) REFERENCES metadata_catalogue.category_scheme (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id)
);

/* PERSON */


CREATE TABLE IF NOT EXISTS metadata_catalogue.person
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    familyname character varying(1024),
    givenname character varying(1024),
    qualifications character varying(1024),
    cvurl character varying(1024),
    address_id character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (address_id) REFERENCES metadata_catalogue.address (instance_id)
);


/* CONTACTPOINT */

CREATE TABLE IF NOT EXISTS metadata_catalogue.contactpoint
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    role character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.contactpoint_element /* email, telephone, language */
(
    contactpoint_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (contactpoint_instance_id, element_instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.person_identifier
(
    person_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id,identifier_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES metadata_catalogue.person (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.person_contactpoint
(
    person_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id, contactpoint_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES metadata_catalogue.person (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.person_element /* email, telephone */
(
    person_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id, element_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES metadata_catalogue.person (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);


/* ORGANIZATION */

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    acronym character varying(1024),
    legalname character varying(1024),
    leicode character varying(1024),
    address_id character varying(100),
    logo character varying(1024),
    URL character varying(1024),
    type character varying(1024),
    maturity character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (address_id) REFERENCES metadata_catalogue.address (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_memberof
(
    organization1_instance_id character varying(100) NOT NULL,
    organization2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization1_instance_id, organization2_instance_id),
    FOREIGN KEY (organization1_instance_id) REFERENCES metadata_catalogue.organization (instance_id),
    FOREIGN KEY (organization2_instance_id) REFERENCES metadata_catalogue.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_affiliation
(
    person_instance_id character varying(100) NOT NULL,
    organization_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (person_instance_id, organization_instance_id),
    FOREIGN KEY (person_instance_id) REFERENCES metadata_catalogue.person (instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_identifier
(
    organization_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id,identifier_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_element /* email, telephone */
(
    organization_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id, element_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_contactpoint
(
    organization_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (organization_instance_id, contactpoint_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.organization_owns
(
    organization_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (organization_instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id)
);

/* DATAPRODUCT */


CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
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
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_attribution
(
    dataproduct_instance_id character varying(100) NOT NULL,
    attribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, attribution_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (attribution_instance_id) REFERENCES metadata_catalogue.attribution (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_source
(
    dataproduct1_instance_id character varying(100) NOT NULL,
    dataproduct2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct1_instance_id, dataproduct2_instance_id),
    FOREIGN KEY (dataproduct1_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (dataproduct2_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_haspart
(
    dataproduct1_instance_id character varying(100) NOT NULL,
    dataproduct2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct1_instance_id, dataproduct2_instance_id),
    FOREIGN KEY (dataproduct1_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (dataproduct2_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_ispartof
(
    dataproduct1_instance_id character varying(100) NOT NULL,
    dataproduct2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct1_instance_id, dataproduct2_instance_id),
    FOREIGN KEY (dataproduct1_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (dataproduct2_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_publisher
(
    dataproduct_instance_id character varying(100) NOT NULL,
    organization_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, organization_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (organization_instance_id) REFERENCES metadata_catalogue.organization (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_contactpoint
(
    dataproduct_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, contactpoint_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_title
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    title character varying(1024),
    lang character varying(50),
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_description
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    description text,
    lang character varying(50),
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_category
(
    dataproduct_instance_id character varying(100) NOT NULL,
    category_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, category_instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_provenance
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    provenance text,
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_identifier
(
    dataproduct_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,identifier_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_spatial
(
    dataproduct_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,spatial_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES metadata_catalogue.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_temporal
(
    dataproduct_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id,temporal_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES metadata_catalogue.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_relation
(
    dataproduct_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (dataproduct_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.dataproduct_element /* referencedby, landingpage, variablemeasured */
(
    dataproduct_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, element_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);


/* DISTRIBUTION */


CREATE TABLE IF NOT EXISTS metadata_catalogue.distribution
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    issued timestamp,
    modified timestamp,
    type character varying(1024),
    format character varying(1024),
    license character varying(1024),
    datapolicy character varying(1024),
    mediatype character varying(1024),
    maturity character varying(1024),
    bytesize character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.distribution_dataproduct
(
    distribution_instance_id character varying(100) NOT NULL,
    dataproduct_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (dataproduct_instance_id, distribution_instance_id),
    FOREIGN KEY (dataproduct_instance_id) REFERENCES metadata_catalogue.dataproduct (instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.distribution_title
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    title character varying(1024),
    lang character varying(50),
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.distribution_description
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    description text,
    lang character varying(50),
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.distribution_element /* downloadurl, accessurl */
(
    distribution_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (distribution_instance_id, element_instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);


/* WEBSERVICE */


CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
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
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

/* conforms to or dataservice */
CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_distribution
(
    distribution_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, distribution_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_identifier
(
    webservice_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,identifier_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_contactpoint
(
    webservice_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, contactpoint_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_category
(
    category_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, category_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_element /* documentation */
(
    webservice_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, element_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_spatial
(
    webservice_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,spatial_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (spatial_instance_id) REFERENCES metadata_catalogue.spatial (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_temporal
(
    webservice_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id,temporal_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (temporal_instance_id) REFERENCES metadata_catalogue.temporal (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.webservice_relation
(
    webservice_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (webservice_instance_id, entity_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id)
);

/* OPERATION */
CREATE TABLE IF NOT EXISTS metadata_catalogue.operation
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    method character varying(1024),
    template text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.operation_webservice
(
    operation_instance_id character varying(100) NOT NULL,
    webservice_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (webservice_instance_id, operation_instance_id),
    FOREIGN KEY (webservice_instance_id) REFERENCES metadata_catalogue.webservice (instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.operation_distribution
(
    operation_instance_id character varying(100) NOT NULL,
    distribution_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (distribution_instance_id, operation_instance_id),
    FOREIGN KEY (distribution_instance_id) REFERENCES metadata_catalogue.distribution (instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id)
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.operation_element /* returns */
(
    operation_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (operation_instance_id, element_instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id),
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id)
);

/* INPUT MAPPING */

CREATE TABLE IF NOT EXISTS metadata_catalogue.mapping
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    label character varying(1024),
    variable character varying(1024),
    required boolean,
    range character varying(1024),
    defaultvalue character varying(1024),
    minvalue character varying(1024),
    maxvalue character varying(1024),
    property character varying(1024),
    valuepattern character varying(1024),
    read_only_value character varying(1024),
    multiple_values character varying(1024),
    healthcheckvalue character varying(1024),
    ismappingof character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id)  ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.operation_mapping
(
    operation_instance_id character varying(100) NOT NULL,
    mapping_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (operation_instance_id,mapping_instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id)  ON DELETE CASCADE,
    FOREIGN KEY (mapping_instance_id) REFERENCES metadata_catalogue.mapping (instance_id)  ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.mapping_element /* paramvalue */
(
    mapping_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (mapping_instance_id, element_instance_id),
    FOREIGN KEY (mapping_instance_id) REFERENCES metadata_catalogue.mapping (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id) ON DELETE CASCADE
);

/* OUTPUT MAPPING */

CREATE TABLE IF NOT EXISTS metadata_catalogue.output_mapping
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    label character varying(1024),
    variable character varying(1024),
    required boolean,
    range character varying(1024),
    property character varying(1024),
    valuepattern character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

/* PAYLOAD */
CREATE TABLE IF NOT EXISTS metadata_catalogue.payload
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    name character varying(1024),
    description text,
    content_type character varying(255),
    schema_definition text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.operation_payload
(
    operation_instance_id character varying(100) NOT NULL,
    payload_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (operation_instance_id, payload_instance_id),
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (payload_instance_id) REFERENCES metadata_catalogue.payload (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.payload_output_mapping
(
    payload_instance_id character varying(100) NOT NULL,
    output_mapping_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (payload_instance_id, output_mapping_instance_id),
    FOREIGN KEY (payload_instance_id) REFERENCES metadata_catalogue.payload (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (output_mapping_instance_id) REFERENCES metadata_catalogue.output_mapping (instance_id) ON DELETE CASCADE
);

/* SOFTWAREAPPLICATION */

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
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
    softwarestatus character varying(1024),
    spatial text,
    temporal text,
    filesize character varying(1024),
    timerequired character varying(1024),
    processorrequirements character varying(1024),
    memoryrequirements character varying(1024),
    storagerequirements character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.parameter
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    encodingformat character varying(1024),
    conformsto character varying(1024),
    action character varying(1024),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_contactpoint
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, contactpoint_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_identifier
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id,identifier_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_parameters
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    parameter_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id,parameter_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (parameter_instance_id) REFERENCES metadata_catalogue.parameter (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_operation
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    operation_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, operation_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (operation_instance_id) REFERENCES metadata_catalogue.operation (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_category
(
    category_instance_id character varying(100) NOT NULL,
    softwareapplication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, category_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_element
(
    element_instance_id character varying(100) NOT NULL,
    softwareapplication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwareapplication_instance_id, element_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_author
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_contributor
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_funder
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_maintainer
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_provider
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_publisher
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwareapplication_creator
(
    softwareapplication_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwareapplication_instance_id),
    FOREIGN KEY (softwareapplication_instance_id) REFERENCES metadata_catalogue.softwareapplication (instance_id)
);


/* SOFTWARESOURCECODE */

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
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
    softwarestatus character varying(1024),
    spatial text,
    temporal text,
    filesize character varying(1024),
    timerequired character varying(1024),
    softwarerequirements text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_contactpoint
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, contactpoint_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_identifier
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id,identifier_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_element /* programminglanguage */
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, element_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_category
(
    category_instance_id character varying(100) NOT NULL,
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (softwaresourcecode_instance_id, category_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_author
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_contributor
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_funder
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_maintainer
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_provider
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_publisher
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.softwaresourcecode_creator
(
    softwaresourcecode_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (softwaresourcecode_instance_id),
    FOREIGN KEY (softwaresourcecode_instance_id) REFERENCES metadata_catalogue.softwaresourcecode (instance_id)
);


/* SERVICE */

CREATE TABLE IF NOT EXISTS metadata_catalogue.service
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    name character varying(1024),
    description text,
    type character varying(1024),
    pageURL character varying(1024),
    keywords text,
    servicecontract character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_identifier
(
    service_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,identifier_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_contactpoint
(
    service_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id, contactpoint_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_spatial
(
    service_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,spatial_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (spatial_instance_id) REFERENCES metadata_catalogue.spatial (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_temporal
(
    service_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id,temporal_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (temporal_instance_id) REFERENCES metadata_catalogue.temporal (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_category
(
    category_instance_id character varying(100) NOT NULL,
    service_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (service_instance_id, category_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.service_provider /*person or organization*/
(
    service_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (service_instance_id),
    FOREIGN KEY (service_instance_id) REFERENCES metadata_catalogue.service (instance_id) ON DELETE CASCADE
);



/* PUBLICATION */

CREATE TABLE IF NOT EXISTS metadata_catalogue.publication
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    name character varying(1024),
    published timestamp,
    abstracttext text,
    licenseURL character varying(1024),
    keywords text,
    issn character varying(1024),
    pages integer,
    volumenumber character varying(1024),
    author character varying(1024),
    publisher character varying(100),
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.publication_identifier
(
    publication_instance_id character varying(100) NOT NULL,
    identifier_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id,identifier_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES metadata_catalogue.publication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (identifier_instance_id) REFERENCES metadata_catalogue.identifier (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.publication_contributor
(
    person_instance_id character varying(100) NOT NULL,
    publication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id, person_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES metadata_catalogue.publication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (person_instance_id) REFERENCES metadata_catalogue.person (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.publication_category
(
    category_instance_id character varying(100) NOT NULL,
    publication_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (publication_instance_id, category_instance_id),
    FOREIGN KEY (publication_instance_id) REFERENCES metadata_catalogue.publication (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);


/* FACILITY */

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
    version_id character varying(100),
    identifier character varying(1024),
    description text,
    title character varying(1024),
    type character(1024),
    keywords text,
    PRIMARY KEY (instance_id),
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_address
(
    facility_instance_id character varying(100) NOT NULL,
    address_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, address_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (address_instance_id) REFERENCES metadata_catalogue.address (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_contactpoint
(
    facility_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, contactpoint_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_element /* pageurl */
(
    facility_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, element_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_ispartof
(
    facility1_instance_id character varying(100) NOT NULL,
    facility2_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility1_instance_id, facility2_instance_id),
    FOREIGN KEY (facility1_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (facility2_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_category
(
    category_instance_id character varying(100) NOT NULL,
    facility_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id, category_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.facility_spatial
(
    facility_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (facility_instance_id,spatial_instance_id),
    FOREIGN KEY (facility_instance_id) REFERENCES metadata_catalogue.facility (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (spatial_instance_id) REFERENCES metadata_catalogue.spatial (instance_id) ON DELETE CASCADE
);


/* EQUIPMENT */

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment
(
    instance_id character varying(100) NOT NULL,
    meta_id character varying(100),
    uid character varying(1024),
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
    FOREIGN KEY (version_id) REFERENCES metadata_catalogue.versioningstatus (version_id) ON DELETE CASCADE,
    FOREIGN KEY (creator) REFERENCES metadata_catalogue.organization (instance_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_contactpoint
(
    equipment_instance_id character varying(100) NOT NULL,
    contactpoint_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, contactpoint_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (contactpoint_instance_id) REFERENCES metadata_catalogue.contactpoint (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_element /* pageurl */
(
    equipment_instance_id character varying(100) NOT NULL,
    element_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, element_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (element_instance_id) REFERENCES metadata_catalogue.element (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_spatial
(
    equipment_instance_id character varying(100) NOT NULL,
    spatial_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id,spatial_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (spatial_instance_id) REFERENCES metadata_catalogue.spatial (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_temporal
(
    equipment_instance_id character varying(100) NOT NULL,
    temporal_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id,temporal_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (temporal_instance_id) REFERENCES metadata_catalogue.temporal (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_category
(
    category_instance_id character varying(100) NOT NULL,
    equipment_instance_id character varying(100) NOT NULL,
    PRIMARY KEY (equipment_instance_id, category_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE,
    FOREIGN KEY (category_instance_id) REFERENCES metadata_catalogue.category (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_ispartof /*equipment or facility*/
(
    equipment_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (equipment_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS metadata_catalogue.equipment_relation
(
    equipment_instance_id character varying(100) NOT NULL,
    entity_instance_id character varying(100) NOT NULL,
    resource_entity character varying(100) NOT NULL,
    UNIQUE(entity_instance_id,resource_entity),
    PRIMARY KEY (equipment_instance_id),
    FOREIGN KEY (equipment_instance_id) REFERENCES metadata_catalogue.equipment (instance_id) ON DELETE CASCADE
);

END;