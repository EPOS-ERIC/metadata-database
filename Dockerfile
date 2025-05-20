FROM kartoza/postgis:16-3.4--v2024.03.17

LABEL description="Initializing EPOS metadata Database"
COPY --chown=postgres:postgres ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d