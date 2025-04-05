\connect metadata_catalogue;
\connect metadata_catalogue;
-- PostgreSQL Performance Optimization: Index Creation Script
-- This script adds carefully selected indexes to improve query performance

-- ==========================================
-- Foreign Key Indexes
-- ==========================================
-- These indexes speed up join operations and foreign key constraint checks

-- Versioning Status related indexes
CREATE INDEX IF NOT EXISTS idx_versioningstatus_instance_id ON public.versioningstatus(instance_id);
CREATE INDEX IF NOT EXISTS idx_versioningstatus_meta_id ON public.versioningstatus(meta_id);

-- Identifier table indexes
CREATE INDEX IF NOT EXISTS idx_identifier_version_id ON public.identifier(version_id);
CREATE INDEX IF NOT EXISTS idx_identifier_meta_id ON public.identifier(meta_id);
CREATE INDEX IF NOT EXISTS idx_identifier_uid ON public.identifier(uid);

-- QuantitativeValue indexes
CREATE INDEX IF NOT EXISTS idx_quantitativevalue_version_id ON public.quantitativevalue(version_id);
CREATE INDEX IF NOT EXISTS idx_quantitativevalue_meta_id ON public.quantitativevalue(meta_id);

-- Element indexes
CREATE INDEX IF NOT EXISTS idx_element_version_id ON public.element(version_id);
CREATE INDEX IF NOT EXISTS idx_element_meta_id ON public.element(meta_id);
CREATE INDEX IF NOT EXISTS idx_element_type ON public.element(type);

-- Spatial and Temporal indexes
CREATE INDEX IF NOT EXISTS idx_spatial_version_id ON public.spatial(version_id);
CREATE INDEX IF NOT EXISTS idx_temporal_version_id ON public.temporal(version_id);
CREATE INDEX IF NOT EXISTS idx_temporal_startdate ON public.temporal(startDate);
CREATE INDEX IF NOT EXISTS idx_temporal_enddate ON public.temporal(endDate);

-- Address indexes
CREATE INDEX IF NOT EXISTS idx_address_version_id ON public.address(version_id);
CREATE INDEX IF NOT EXISTS idx_address_country ON public.address(country);

-- Categories and Category Schemes indexes
CREATE INDEX IF NOT EXISTS idx_category_scheme_version_id ON public.category_scheme(version_id);
CREATE INDEX IF NOT EXISTS idx_category_version_id ON public.category(version_id);
CREATE INDEX IF NOT EXISTS idx_category_in_scheme ON public.category(in_scheme);

-- Person related indexes
CREATE INDEX IF NOT EXISTS idx_person_version_id ON public.person(version_id);
CREATE INDEX IF NOT EXISTS idx_person_address_id ON public.person(address_id);
CREATE INDEX IF NOT EXISTS idx_person_name ON public.person(familyname, givenname);

-- ContactPoint indexes
CREATE INDEX IF NOT EXISTS idx_contactpoint_version_id ON public.contactpoint(version_id);

-- Organization related indexes
CREATE INDEX IF NOT EXISTS idx_organization_version_id ON public.organization(version_id);
CREATE INDEX IF NOT EXISTS idx_organization_address_id ON public.organization(address_id);
CREATE INDEX IF NOT EXISTS idx_organization_legalname ON public.organization(legalname);
CREATE INDEX IF NOT EXISTS idx_organization_acronym ON public.organization(acronym);
CREATE INDEX IF NOT EXISTS idx_organization_type ON public.organization(type);

-- DataProduct related indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_version_id ON public.dataproduct(version_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_type ON public.dataproduct(type);
CREATE INDEX IF NOT EXISTS idx_dataproduct_issued ON public.dataproduct(issued);
CREATE INDEX IF NOT EXISTS idx_dataproduct_modified ON public.dataproduct(modified);
CREATE INDEX IF NOT EXISTS idx_dataproduct_title_dataproduct_id ON public.dataproduct_title(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_description_dataproduct_id ON public.dataproduct_description(dataproduct_instance_id);

-- Distribution related indexes
CREATE INDEX IF NOT EXISTS idx_distribution_version_id ON public.distribution(version_id);
CREATE INDEX IF NOT EXISTS idx_distribution_type ON public.distribution(type);
CREATE INDEX IF NOT EXISTS idx_distribution_format ON public.distribution(format);

-- WebService related indexes
CREATE INDEX IF NOT EXISTS idx_webservice_version_id ON public.webservice(version_id);
CREATE INDEX IF NOT EXISTS idx_webservice_name ON public.webservice(name);
CREATE INDEX IF NOT EXISTS idx_webservice_provider ON public.webservice(provider);

-- Operation related indexes
CREATE INDEX IF NOT EXISTS idx_operation_version_id ON public.operation(version_id);
CREATE INDEX IF NOT EXISTS idx_operation_method ON public.operation(method);

-- Mapping related indexes
CREATE INDEX IF NOT EXISTS idx_mapping_version_id ON public.mapping(version_id);
CREATE INDEX IF NOT EXISTS idx_mapping_variable ON public.mapping(variable);

-- Output Mapping related indexes
CREATE INDEX IF NOT EXISTS idx_output_mapping_version_id ON public.output_mapping(version_id);

-- Payload related indexes
CREATE INDEX IF NOT EXISTS idx_payload_version_id ON public.payload(version_id);

-- SoftwareApplication related indexes
CREATE INDEX IF NOT EXISTS idx_softwareapplication_version_id ON public.softwareapplication(version_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_name ON public.softwareapplication(name);

-- SoftwareSourceCode related indexes
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_version_id ON public.softwaresourcecode(version_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_name ON public.softwaresourcecode(name);

-- Service related indexes
CREATE INDEX IF NOT EXISTS idx_service_version_id ON public.service(version_id);
CREATE INDEX IF NOT EXISTS idx_service_name ON public.service(name);
CREATE INDEX IF NOT EXISTS idx_service_type ON public.service(type);

-- Publication related indexes
CREATE INDEX IF NOT EXISTS idx_publication_version_id ON public.publication(version_id);
CREATE INDEX IF NOT EXISTS idx_publication_name ON public.publication(name);
CREATE INDEX IF NOT EXISTS idx_publication_published ON public.publication(published);

-- Facility related indexes
CREATE INDEX IF NOT EXISTS idx_facility_version_id ON public.facility(version_id);
CREATE INDEX IF NOT EXISTS idx_facility_title ON public.facility(title);

-- Equipment related indexes
CREATE INDEX IF NOT EXISTS idx_equipment_version_id ON public.equipment(version_id);
CREATE INDEX IF NOT EXISTS idx_equipment_name ON public.equipment(name);
CREATE INDEX IF NOT EXISTS idx_equipment_creator ON public.equipment(creator);

-- ==========================================
-- Many-to-Many Relation Indexes
-- ==========================================
-- These indexes improve performance of many-to-many relationship queries

-- Person relationship indexes
CREATE INDEX IF NOT EXISTS idx_person_identifier_person_id ON public.person_identifier(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_identifier_identifier_id ON public.person_identifier(identifier_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_contactpoint_person_id ON public.person_contactpoint(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_person_element_person_id ON public.person_element(person_instance_id);

-- Organization relationship indexes
CREATE INDEX IF NOT EXISTS idx_organization_memberof_org1 ON public.organization_memberof(organization1_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_memberof_org2 ON public.organization_memberof(organization2_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_affiliation_person ON public.organization_affiliation(person_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_affiliation_org ON public.organization_affiliation(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_identifier_org ON public.organization_identifier(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_element_org ON public.organization_element(organization_instance_id);
CREATE INDEX IF NOT EXISTS idx_organization_contactpoint_org ON public.organization_contactpoint(organization_instance_id);

-- DataProduct relationship indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_haspart_parent ON public.dataproduct_haspart(dataproduct1_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_haspart_child ON public.dataproduct_haspart(dataproduct2_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_ispartof_child ON public.dataproduct_ispartof(dataproduct1_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_ispartof_parent ON public.dataproduct_ispartof(dataproduct2_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_publisher_dataproduct ON public.dataproduct_publisher(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_contactpoint_dataproduct ON public.dataproduct_contactpoint(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_category_dataproduct ON public.dataproduct_category(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_category_category ON public.dataproduct_category(category_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_identifier_dataproduct ON public.dataproduct_identifier(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_spatial_dataproduct ON public.dataproduct_spatial(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_dataproduct_temporal_dataproduct ON public.dataproduct_temporal(dataproduct_instance_id);

-- Distribution relationship indexes
CREATE INDEX IF NOT EXISTS idx_distribution_dataproduct_distribution ON public.distribution_dataproduct(distribution_instance_id);
CREATE INDEX IF NOT EXISTS idx_distribution_dataproduct_dataproduct ON public.distribution_dataproduct(dataproduct_instance_id);
CREATE INDEX IF NOT EXISTS idx_distribution_element_distribution ON public.distribution_element(distribution_instance_id);

-- WebService relationship indexes
CREATE INDEX IF NOT EXISTS idx_webservice_distribution_webservice ON public.webservice_distribution(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_identifier_webservice ON public.webservice_identifier(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_contactpoint_webservice ON public.webservice_contactpoint(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_category_webservice ON public.webservice_category(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_element_webservice ON public.webservice_element(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_spatial_webservice ON public.webservice_spatial(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_webservice_temporal_webservice ON public.webservice_temporal(webservice_instance_id);

-- Operation relationship indexes
CREATE INDEX IF NOT EXISTS idx_operation_webservice_operation ON public.operation_webservice(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_webservice_webservice ON public.operation_webservice(webservice_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_distribution_operation ON public.operation_distribution(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_element_operation ON public.operation_element(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_mapping_operation ON public.operation_mapping(operation_instance_id);
CREATE INDEX IF NOT EXISTS idx_operation_payload_operation ON public.operation_payload(operation_instance_id);

-- Other relationship indexes
CREATE INDEX IF NOT EXISTS idx_mapping_element_mapping ON public.mapping_element(mapping_instance_id);
CREATE INDEX IF NOT EXISTS idx_payload_output_mapping_payload ON public.payload_output_mapping(payload_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_contactpoint_app ON public.softwareapplication_contactpoint(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_identifier_app ON public.softwareapplication_identifier(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_parameters_app ON public.softwareapplication_parameters(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_operation_app ON public.softwareapplication_operation(softwareapplication_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwareapplication_category_app ON public.softwareapplication_category(softwareapplication_instance_id);

-- SoftwareSourceCode relationship indexes
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_contactpoint_code ON public.softwaresourcecode_contactpoint(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_identifier_code ON public.softwaresourcecode_identifier(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_element_code ON public.softwaresourcecode_element(softwaresourcecode_instance_id);
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_category_code ON public.softwaresourcecode_category(softwaresourcecode_instance_id);

-- Service relationship indexes
CREATE INDEX IF NOT EXISTS idx_service_identifier_service ON public.service_identifier(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_contactpoint_service ON public.service_contactpoint(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_spatial_service ON public.service_spatial(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_temporal_service ON public.service_temporal(service_instance_id);
CREATE INDEX IF NOT EXISTS idx_service_category_service ON public.service_category(service_instance_id);

-- Publication relationship indexes
CREATE INDEX IF NOT EXISTS idx_publication_identifier_publication ON public.publication_identifier(publication_instance_id);
CREATE INDEX IF NOT EXISTS idx_publication_contributor_publication ON public.publication_contributor(publication_instance_id);
CREATE INDEX IF NOT EXISTS idx_publication_category_publication ON public.publication_category(publication_instance_id);

-- Facility relationship indexes
CREATE INDEX IF NOT EXISTS idx_facility_address_facility ON public.facility_address(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_contactpoint_facility ON public.facility_contactpoint(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_element_facility ON public.facility_element(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_ispartof_child ON public.facility_ispartof(facility1_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_ispartof_parent ON public.facility_ispartof(facility2_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_category_facility ON public.facility_category(facility_instance_id);
CREATE INDEX IF NOT EXISTS idx_facility_spatial_facility ON public.facility_spatial(facility_instance_id);

-- Equipment relationship indexes
CREATE INDEX IF NOT EXISTS idx_equipment_contactpoint_equipment ON public.equipment_contactpoint(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_element_equipment ON public.equipment_element(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_spatial_equipment ON public.equipment_spatial(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_temporal_equipment ON public.equipment_temporal(equipment_instance_id);
CREATE INDEX IF NOT EXISTS idx_equipment_category_equipment ON public.equipment_category(equipment_instance_id);

-- ==========================================
-- Partial Indexes for Status-Based Queries
-- ==========================================
-- These indexes speed up common queries that filter by status

CREATE INDEX IF NOT EXISTS idx_versioning_published ON public.versioningstatus(version_id) 
WHERE status = 'PUBLISHED';

CREATE INDEX IF NOT EXISTS idx_versioning_draft ON public.versioningstatus(version_id) 
WHERE status = 'DRAFT';

CREATE INDEX IF NOT EXISTS idx_versioning_submitted ON public.versioningstatus(version_id) 
WHERE status = 'SUBMITTED';

-- ==========================================
-- Text Search Indexes
-- ==========================================
-- These indexes improve performance for full-text search queries

CREATE INDEX IF NOT EXISTS idx_dataproduct_keywords_gin ON public.dataproduct USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_webservice_keywords_gin ON public.webservice USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_softwareapplication_keywords_gin ON public.softwareapplication USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_softwaresourcecode_keywords_gin ON public.softwaresourcecode USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_service_keywords_gin ON public.service USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_publication_keywords_gin ON public.publication USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_facility_keywords_gin ON public.facility USING gin(to_tsvector('english', keywords));
CREATE INDEX IF NOT EXISTS idx_equipment_keywords_gin ON public.equipment USING gin(to_tsvector('english', keywords));

-- Text description indexes
CREATE INDEX IF NOT EXISTS idx_dataproduct_description_gin ON public.dataproduct_description USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_distribution_description_gin ON public.distribution_description USING gin(to_tsvector('english', description));
CREATE INDEX IF NOT EXISTS idx_publication_abstract_gin ON public.publication USING gin(to_tsvector('english', abstracttext));

-- ==========================================
-- BRIN Indexes for Temporal Data
-- ==========================================
-- Better for large tables with naturally ordered data

CREATE INDEX IF NOT EXISTS idx_temporal_startdate_brin ON public.temporal USING BRIN (startDate);
CREATE INDEX IF NOT EXISTS idx_temporal_enddate_brin ON public.temporal USING BRIN (endDate);
CREATE INDEX IF NOT EXISTS idx_dataproduct_issued_brin ON public.dataproduct USING BRIN (issued);
CREATE INDEX IF NOT EXISTS idx_dataproduct_modified_brin ON public.dataproduct USING BRIN (modified);
CREATE INDEX IF NOT EXISTS idx_distribution_issued_brin ON public.distribution USING BRIN (issued);
CREATE INDEX IF NOT EXISTS idx_distribution_modified_brin ON public.distribution USING BRIN (modified);
CREATE INDEX IF NOT EXISTS idx_publication_published_brin ON public.publication USING BRIN (published);

-- ==========================================
-- Additional Composite Indexes for Common Query Patterns
-- ==========================================
-- These indexes support specific query patterns that are likely to be common

CREATE INDEX IF NOT EXISTS idx_entity_id_table ON public.edm_entity_id(meta_id, table_name);
CREATE INDEX IF NOT EXISTS idx_metadata_user_name ON public.metadata_user(familyname, givenname);
CREATE INDEX IF NOT EXISTS idx_metadata_group_name ON public.metadata_group(name);

-- UID lookup is likely common across many tables
CREATE INDEX IF NOT EXISTS idx_person_uid ON public.person(uid);
CREATE INDEX IF NOT EXISTS idx_organization_uid ON public.organization(uid);
CREATE INDEX IF NOT EXISTS idx_dataproduct_uid ON public.dataproduct(uid);
CREATE INDEX IF NOT EXISTS idx_webservice_uid ON public.webservice(uid);