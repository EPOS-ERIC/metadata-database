\connect metadata_catalogue;
BEGIN;

CREATE TYPE version_type_enum AS ENUM ('branch', 'tag');

CREATE TABLE converter_catalogue.plugin (
	id character varying(1024) NOT NULL PRIMARY KEY,	-- the id of the plugin (generated when the plugin is created)
	name VARCHAR(1024) NOT NULL,						-- the name of the plugin
	description VARCHAR(1024) NOT NULL,					-- a description of the plugin
	version VARCHAR(1024) NOT NULL,						-- the name of the branch if version_type is branch or the tag number if it is tag
	version_type version_type_enum NOT NULL,				-- either 'branch' or 'tag' 
	repository VARCHAR(1024) NOT NULL,					-- the url from which to clone the repository 
	runtime VARCHAR(1024) NOT NULL,						-- the runtime (binary, java, python, ...)
	executable VARCHAR(1024) NOT NULL,					-- the path for the executable
	arguments VARCHAR(1024) NOT NULL,					-- arguments for the execution (if needed (like the main java class name))
	installed BOOLEAN NOT NULL DEFAULT FALSE,			-- if the plugin is currently installed
	enabled BOOLEAN NOT NULL DEFAULT FALSE,				-- if the plugin is enabled aka if it can be used
	UNIQUE(version, version_type, repository, runtime, executable, arguments)
);

CREATE TABLE converter_catalogue.plugin_relations (
	id character varying(1024) NOT NULL PRIMARY KEY,									-- the id of the relation (generated when the relation is created)
	plugin_id character varying(1024) NOT NULL REFERENCES converter_catalogue.plugin(id) ON DELETE CASCADE,	-- the id of the plugin (from the plugin table)
	relation_id VARCHAR(1024) NOT NULL,													-- the instanceId of the distribution
	input_format VARCHAR(1024) NOT NULL,												-- the file format expected by the plugin for the input
	output_format VARCHAR(1024) NOT NULL,												-- the file format expected as the output from the plugin execution
	UNIQUE(plugin_id, relation_id, input_format, output_format)
);

END;
