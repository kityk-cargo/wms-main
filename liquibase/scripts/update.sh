#!/bin/bash

usage() {
    echo "Usage: $0 [TARGET_DIR] LIQUIBASE_PROPERTIES_FILE"
    echo "  TARGET_DIR: Directory for the changelog (default: ../db)"
    echo "  LIQUIBASE_PROPERTIES_FILE: Path to the Liquibase properties file"
    exit 1
}

# Show usage if requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "usage" ]; then
    usage
fi

TARGET_DIR=${1:-../db}
cd "$(dirname "$TARGET_DIR")/scripts" || { echo "Failed to change directory to scripts folder"; exit 1; }
export $(grep -v '^#' .env | xargs)

echo "Debug: Current directory is $(pwd)"
echo "Debug: Using schema: $DB_SCHEMA"
echo "Debug: Target directory: $TARGET_DIR"

export PGPASSWORD="$DB_PASSWORD"
if command -v psql >/dev/null 2>&1; then
    echo "Creating schema if not exists..."
    psql -h host.docker.internal -p 5433 -U "$DB_USER" -d postgres -c "CREATE SCHEMA IF NOT EXISTS \"$DB_SCHEMA\";"
fi

LIQUIBASE_PROP=$2
if [ -z "$LIQUIBASE_PROP" ]; then
    usage
fi

cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR"; exit 1; }
echo "Debug: About to run Liquibase update from $(pwd)"
echo "Debug: Using properties file: $LIQUIBASE_PROP"

liquibase --username="$DB_USER" \
         --password="$DB_PASSWORD" \
         --defaultSchemaName="$DB_SCHEMA" \
         --defaultsFile="$LIQUIBASE_PROP" \
         update