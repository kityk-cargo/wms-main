#!/bin/bash

usage() {
    echo "Usage: $0 <rollback_count> <liquibase_properties_file>"
    exit 1
}

if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi

TARGET_DIR=${2%/*}  # Extract directory path from properties file
cd "$(dirname "$TARGET_DIR")/scripts" || { echo "Failed to change directory to scripts folder"; exit 1; }
export $(grep -v '^#' .env | xargs)

echo "Debug: Current directory is $(pwd)"
echo "Debug: Using schema: $DB_SCHEMA"
echo "Debug: Target directory: $TARGET_DIR"

cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR"; exit 1; }
echo "Debug: About to run Liquibase rollback from $(pwd)"
echo "Debug: Using properties file: $2"

liquibase --username="$DB_USER" \
         --password="$DB_PASSWORD" \
         --defaultSchemaName="$DB_SCHEMA" \
         --defaultsFile="$(basename "$2")" \
         rollbackCount "$1"
