#!/bin/bash
docker run --rm \
    -v "$(pwd):/lb" \
    liquibase/liquibase \
    sh /lb/scripts/update.sh /lb/db liquibase-docker-local.properties