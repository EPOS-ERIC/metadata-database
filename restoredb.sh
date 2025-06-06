#!/bin/bash

#psql -Atx $POSTGRESQL_JOB_CONNECTION_STRING -c 'DROP DATABASE IF EXISTS "cerif";'

for x in /docker-entrypoint-initdb.d/*; do
psql -Atx $POSTGRESQL_JOB_CONNECTION_STRING_PG -f $x
done

