\connect metadata_catalogue;
-- PostgreSQL Performance Optimization: Index Creation Script
-- This script adds carefully selected indexes to improve query performance

-- ==========================================
-- Foreign Key Indexes
-- ==========================================
-- These indexes speed up join operations and foreign key constraint checks

-- Versioning Status related indexes
CREATE INDEX IF NOT EXISTS idx_versioningstatus_instance_id ON metadata_catalogue.versioningstatus(instance_id);
CREATE INDEX IF NOT EXISTS idx_versioningstatus_meta_id ON metadata_catalogue.versioningstatus(meta_id);

-- Identifier table indexes
CREATE INDEX IF NOT EXISTS idx_identifier_version_id ON metadata_catalogue.identifier(version_id);
CREATE INDEX IF NOT EXISTS idx_identifier_meta_id ON metadata_catalogue.identifier(meta_id);
CREATE INDEX IF NOT EXISTS idx_identifier_uid ON metadata_catalogue.identifier(uid);

-- QuantitativeValue indexes
CREATE INDEX IF NOT EXISTS idx_quantitativevalue_version_id ON metadata_catalogue.quantitativevalue(version_id);
CREATE INDEX IF NOT EXISTS idx_quantitativevalue_meta_id ON metadata_catalogue.quantitativevalue(meta_id);

-- Element indexes
CREATE INDEX IF NOT EXISTS idx_element_version_id ON metadata_catalogue.element(version_id);
CREATE INDEX IF NOT EXISTS idx_element_meta_id ON metadata_catalogue.element(meta_id);
CREATE INDEX IF NOT EXISTS idx_element_type ON metadata_catalogue.element(type);

-- Spatial and Temporal indexes
CREATE INDEX IF NOT EXISTS idx_spatial_version_id ON metadata_catalogue.spatial(version_id);
CREATE INDEX IF NOT EXISTS idx_temporal_version_id ON metadata_catalogue.temporal(version_id);
CREATE INDEX IF NOT EXISTS idx_temporal_startdate ON metadata_catalogue.temporal(startDate);
CREATE INDEX IF NOT EXISTS idx_temporal_enddate ON metadata_catalogue.temporal(endDate);

-- Address indexes
CREATE INDEX IF NOT EXISTS idx_address_version_id ON metadata_catalogue.address(version_id);
CREATE INDEX IF NOT EXISTS idx_address_country ON metadata_catalogue.address(country);

-- Categories and Category Schemes indexes
CREATE INDEX IF NOT EXISTS idx_category_scheme_version_id ON metadata_catalogue.category_scheme(version_id);
CREATE INDEX IF NOT EXISTS idx_category_version_id ON metadata_catalogue.category(version_id);
CREATE INDEX IF NOT EXISTS idx_category_in_scheme ON metadata_catalogue.category(in_scheme);

-- Person related indexes
CREATE INDEX IF NOT EXISTS idx_person_version_id ON metadata_catalogue.person(version_id);
CREATE INDEX IF NOT EXISTS idx_person_address_id ON metadata_catalogue.person(address_id);
CREATE INDEX IF NOT EXISTS idx_person_name ON metadata_catalogue.person(familyname, givenname);

-- ContactPoint indexes
CREATE INDEX IF NOT EXISTS idx_contactpoint_version_id ON metadata_catalogue.contactpoint(version_id);

-- Organization related indexes
CREATE INDEX IF NOT EXISTS idx_organization_version_id ON metadata_catalogue.organization(version_id);
CREATE INDEX IF NOT EXISTS idx_organization_address_id ON metadata_catalogue.organization(address_id);
CREATE INDEX IF NOT EXISTS idx_organization_legalname ON metadata_catalogue.organization(legalname);
CREATE INDEX IF NOT EXISTS idx_organization_acronym ON metadata_catalogue.organization(acronym);
CREATE INDEX IF NOT EXISTS idx_organization_type ON metadata_catalogue.organization(type);

-- DataProduct related indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_version_id ON metadata_catalogue.dataproduct(version_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_type ON metadata_catalogue.dataproduct(type);
CREATE INDEX IF NOT EXISTS idx_dataproduct_issued ON metadata_catalogue.dataproduct(issued);
CREATE INDEX IF NOT EXISTS idx_dataproduct_modified ON metadata_catalogue.dataproduct(modified);
CREATE INDEX IF NOT EXISTS idx_dataproduct_title_dataproduct_id ON metadata_catalogue.dataproduct_title(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_description_dataproduct_id ON metadata_catalogue.dataproduct_description(dataproduct_instance_id);

-- Distribution related indexes
CREATE INDEX IF NOT EXISTS idx_distribution_version_id ON metadata_catalogue.distribution(version_id);
CREATE INDEX IF NOT EXISTS idx_distribution_type ON metadata_catalogue.distribution(type);
CREATE INDEX IF NOT EXISTS idx_distribution_format ON metadata_catalogue.distribution(format);

-- WebService related indexes
CREATE INDEX IF NOT EXISTS idx_webservice_version_id ON metadata_catalogue.webservice(version_id);
CREATE INDEX IF NOT EXISTS idx_webservice_name ON metadata_catalogue.webservice(name);
CREATE INDEX IF NOT EXISTS idx_webservice_provider ON metadata_catalogue.webservice(provider);

-- Operation related indexes
CREATE INDEX IF NOT EXISTS idx_operation_version_id ON metadata_catalogue.operation(version_id);
CREATE INDEX IF NOT EXISTS idx_operation_method ON metadata_catalogue.operation(method);

-- Mapping related indexes
CREATE INDEX IF NOT EXISTS idx_mapping_version_id ON metadata_catalogue.mapping(version_id);
CREATE INDEX IF NOT EXISTS idx_mapping_variable ON metadata_catalogue.mapping(variable);

-- Output Mapping related indexes
CREATE INDEX IF NOT EXISTS idx_output_mapping_version_id ON metadata_catalogue.output_mapping(version_id);

-- Payload related indexes
CREATE INDEX IF NOT EXISTS idx_payload_version_id ON metadata_catalogue.payload(version_id);

-- SoftwareApplication related indexes
CREATE INDEX IF NOT EXISTS idx_softwareapplication_version_id ON metadata_catalogue.softwareapplication(version_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_name ON metadata_catalogue.softwareapplication(name);

-- SoftwareSourceCode related indexes
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_version_id ON metadata_catalogue.softwaresourcecode(version_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_name ON metadata_catalogue.softwaresourcecode(name);

-- Service related indexes
CREATE INDEX IF NOT EXISTS idx_service_version_id ON metadata_catalogue.service(version_id);
CREATE INDEX IF NOT EXISTS idx_service_name ON metadata_catalogue.service(name);
CREATE INDEX IF NOT EXISTS idx_service_type ON metadata_catalogue.service(type);

-- Publication related indexes
CREATE INDEX IF NOT EXISTS idx_publication_version_id ON metadata_catalogue.publication(version_id);
CREATE INDEX IF NOT EXISTS idx_publication_name ON metadata_catalogue.publication(name);
CREATE INDEX IF NOT EXISTS idx_publication_published ON metadata_catalogue.publication(published);

-- Facility related indexes
CREATE INDEX IF NOT EXISTS idx_facility_version_id ON metadata_catalogue.facility(version_id);
CREATE INDEX IF NOT EXISTS idx_facility_title ON metadata_catalogue.facility(title);

-- Equipment related indexes
CREATE INDEX IF NOT EXISTS idx_equipment_version_id ON metadata_catalogue.equipment(version_id);
CREATE INDEX IF NOT EXISTS idx_equipment_name ON metadata_catalogue.equipment(name);
CREATE INDEX IF NOT EXISTS idx_equipment_creator ON metadata_catalogue.equipment(creator);

-- ==========================================
-- Many-to-Many Relation Indexes
-- ==========================================
-- These indexes improve performance of many-to-many relationship queries

-- Person relationship indexes
CREATE INDEX IF NOT EXISTS idx_person_identifier_person_id ON metadata_catalogue.person_identifier(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_identifier_identifier_id ON metadata_catalogue.person_identifier(identifier_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_contactpoint_person_id ON metadata_catalogue.person_contactpoint(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_element_person_id ON metadata_catalogue.person_element(person_instance_id);

-- Organization relationship indexes
CREATE INDEX IF NOT EXISTS idx_organization_memberof_org1 ON metadata_catalogue.organization_memberof(organization1_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_memberof_org2 ON metadata_catalogue.organization_memberof(organization2_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_affiliation_person ON metadata_catalogue.organization_affiliation(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_affiliation_org ON metadata_catalogue.organization_affiliation(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_identifier_org ON metadata_catalogue.organization_identifier(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_element_org ON metadata_catalogue.organization_element(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_contactpoint_org ON metadata_catalogue.organization_contactpoint(organization_instance_id);

-- DataProduct relationship indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_haspart_parent ON metadata_catalogue.dataproduct_haspart(dataproduct1_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_haspart_child ON metadata_catalogue.dataproduct_haspart(dataproduct2_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_ispartof_child ON metadata_catalogue.dataproduct_ispartof(dataproduct1_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_ispartof_parent ON metadata_catalogue.dataproduct_ispartof(dataproduct2_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_publisher_dataproduct ON metadata_catalogue.dataproduct_publisher(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_contactpoint_dataproduct ON metadata_catalogue.dataproduct_contactpoint(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_category_dataproduct ON metadata_catalogue.dataproduct_category(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_category_category ON metadata_catalogue.dataproduct_category(category_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_identifier_dataproduct ON metadata_catalogue.dataproduct_identifier(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_spatial_dataproduct ON metadata_catalogue.dataproduct_spatial(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_temporal_dataproduct ON metadata_catalogue.dataproduct_temporal(dataproduct_instance_id);

-- Distribution relationship indexes
CREATE INDEX IF NOT EXISTS idx_distribution_dataproduct_distribution ON metadata_catalogue.distribution_dataproduct(distribution_instance_id);
CREATE INDEX IF NOT EXISTS idx_distribution_dataproduct_dataproduct ON metadata_catalogue.distribution_dataproduct(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_distribution_element_distribution ON metadata_catalogue.distribution_element(distribution_instance_id);

-- WebService relationship indexes
CREATE INDEX IF NOT EXISTS idx_webservice_distribution_webservice ON metadata_catalogue.webservice_distribution(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_identifier_webservice ON metadata_catalogue.webservice_identifier(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_contactpoint_webservice ON metadata_catalogue.webservice_contactpoint(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_category_webservice ON metadata_catalogue.webservice_category(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_element_webservice ON metadata_catalogue.webservice_element(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_spatial_webservice ON metadata_catalogue.webservice_spatial(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_temporal_webservice ON metadata_catalogue.webservice_temporal(webservice_instance_id);

-- Operation relationship indexes
CREATE INDEX IF NOT EXISTS idx_operation_webservice_operation ON metadata_catalogue.operation_webservice(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_webservice_webservice ON metadata_catalogue.operation_webservice(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_distribution_operation ON metadata_catalogue.operation_distribution(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_element_operation ON metadata_catalogue.operation_element(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_mapping_operation ON metadata_catalogue.operation_mapping(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_payload_operation ON metadata_catalogue.operation_payload(operation_instance_id);

-- Other relationship indexes
CREATE INDEX IF NOT EXISTS idx_mapping_element_mapping ON metadata_catalogue.mapping_element(mapping_instance_id);
CREATE INDEX IF NOT EXISTS idx_payload_output_mapping_payload ON metadata_catalogue.payload_output_mapping(payload_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_contactpoint_app ON metadata_catalogue.softwareapplication_contactpoint(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_identifier_app ON metadata_catalogue.softwareapplication_identifier(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_parameters_app ON metadata_catalogue.softwareapplication_parameters(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_operation_app ON metadata_catalogue.softwareapplication_operation(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_category_app ON metadata_catalogue.softwareapplication_category(softwareapplication_instance_id);

-- SoftwareSourceCode relationship indexes
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_contactpoint_code ON metadata_catalogue.softwaresourcecode_contactpoint(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_identifier_code ON metadata_catalogue.softwaresourcecode_identifier(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_element_code ON metadata_catalogue.softwaresourcecode_element(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_category_code ON metadata_catalogue.softwaresourcecode_category(softwaresourcecode_instance_id);

-- Service relationship indexes
CREATE INDEX IF NOT EXISTS idx_service_identifier_service ON metadata_catalogue.service_identifier(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_contactpoint_service ON metadata_catalogue.service_contactpoint(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_spatial_service ON metadata_catalogue.service_spatial(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_temporal_service ON metadata_catalogue.service_temporal(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_category_service ON metadata_catalogue.service_category(service_instance_id);

-- Publication relationship indexes
CREATE INDEX IF NOT EXISTS idx_publication_identifier_publication ON metadata_catalogue.publication_identifier(publication_instance_id);
CREATE INDEX IF NOT EXISTS idx_publication_contributor_publication ON metadata_catalogue.publication_contributor(publication_instance_id);
CREATE INDEX IF NOT EXISTS idx_publication_category_publication ON metadata_catalogue.publication_category(publication_instance_id);

-- Facility relationship indexes
CREATE INDEX IF NOT EXISTS idx_facility_address_facility ON metadata_catalogue.facility_address(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_contactpoint_facility ON metadata_catalogue.facility_contactpoint(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_element_facility ON metadata_catalogue.facility_element(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_ispartof_child ON metadata_catalogue.facility_ispartof(facility1_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_ispartof_parent ON metadata_catalogue.facility_ispartof(facility2_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_category_facility ON metadata_catalogue.facility_category(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_spatial_facility ON metadata_catalogue.facility_spatial(facility_instance_id);

-- Equipment relationship indexes
CREATE INDEX IF NOT EXISTS idx_equipment_contactpoint_equipment ON metadata_catalogue.equipment_contactpoint(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_element_equipment ON metadata_catalogue.equipment_element(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_spatial_equipment ON metadata_catalogue.equipment_spatial(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_temporal_equipment ON metadata_catalogue.equipment_temporal(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_category_equipment ON metadata_catalogue.equipment_category(equipment_instance_id);

-- ==========================================
-- Partial Indexes for Status-Based Queries
-- ==========================================
-- These indexes speed up common queries that filter by status

CREATE INDEX IF NOT EXISTS idx_versioning_published ON metadata_catalogue.versioningstatus(version_id) 
WHERE status = 'PUBLISHED';

CREATE INDEX IF NOT EXISTS idx_versioning_draft ON metadata_catalogue.versioningstatus(version_id) 
WHERE status = 'DRAFT';

CREATE INDEX IF NOT EXISTS idx_versioning_submitted ON metadata_catalogue.versioningstatus(version_id) 
WHERE status = 'SUBMITTED';

-- ==========================================
-- Text Search Indexes
-- ==========================================
-- These indexes improve performance for full-text search queries

CREATE INDEX IF NOT EXISTS idx_dataproduct_keywords_gin ON metadata_catalogue.dataproduct USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_webservice_keywords_gin ON metadata_catalogue.webservice USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_softwareapplication_keywords_gin ON metadata_catalogue.softwareapplication USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_keywords_gin ON metadata_catalogue.softwaresourcecode USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_service_keywords_gin ON metadata_catalogue.service USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_publication_keywords_gin ON metadata_catalogue.publication USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_facility_keywords_gin ON metadata_catalogue.facility USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_equipment_keywords_gin ON metadata_catalogue.equipment USING gin(to_tsvector('english', keywords));

-- Text description indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_description_gin ON metadata_catalogue.dataproduct_description USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_distribution_description_gin ON metadata_catalogue.distribution_description USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_publication_abstract_gin ON metadata_catalogue.publication USING gin(to_tsvector('english', abstracttext));

-- ==========================================
-- BRIN Indexes for Temporal Data
-- ==========================================
-- Better for large tables with naturally ordered data

CREATE INDEX IF NOT EXISTS idx_temporal_startdate_brin ON metadata_catalogue.temporal USING BRIN (startDate);
CREATE INDEX IF NOT EXISTS idx_temporal_enddate_brin ON metadata_catalogue.temporal USING BRIN (endDate);
CREATE INDEX IF NOT EXISTS idx_dataproduct_issued_brin ON metadata_catalogue.dataproduct USING BRIN (issued);
CREATE INDEX IF NOT EXISTS idx_dataproduct_modified_brin ON metadata_catalogue.dataproduct USING BRIN (modified);
CREATE INDEX IF NOT EXISTS idx_distribution_issued_brin ON metadata_catalogue.distribution USING BRIN (issued);
CREATE INDEX IF NOT EXISTS idx_distribution_modified_brin ON metadata_catalogue.distribution USING BRIN (modified);
CREATE INDEX IF NOT EXISTS idx_publication_published_brin ON metadata_catalogue.publication USING BRIN (published);

-- ==========================================
-- Additional Composite Indexes for Common Query Patterns
-- ==========================================
-- These indexes support specific query patterns that are likely to be common

CREATE INDEX IF NOT EXISTS idx_entity_id_table ON usergroup_catalogue.edm_entity_id(meta_id, table_name);
CREATE INDEX IF NOT EXISTS idx_metadata_user_name ON usergroup_catalogue.metadata_user(familyname, givenname);
CREATE INDEX IF NOT EXISTS idx_metadata_group_name ON usergroup_catalogue.metadata_group(name);

-- UID lookup is likely common across many tables
CREATE INDEX IF NOT EXISTS idx_person_uid ON metadata_catalogue.person(uid);
CREATE INDEX IF NOT EXISTS idx_organization_uid ON metadata_catalogue.organization(uid);
CREATE INDEX IF NOT EXISTS idx_dataproduct_uid ON metadata_catalogue.dataproduct(uid);
CREATE INDEX IF NOT EXISTS idx_webservice_uid ON metadata_catalogue.webservice(uid);