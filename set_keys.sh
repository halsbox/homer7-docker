#!/bin/sh
export $(grep -v '^#' .env | xargs -d '\n')
docker exec homer-webapp /homer-app -update-ui-user=${HOMER_APP_ADMIN_USER} -update-ui-password=${HOMER_APP_ADMIN_PASS}
docker exec homer-webapp /homer-app -update-ui-user=${HOMER_APP_SUPPORT_USER} -update-ui-password=${HOMER_APP_SUPPORT_PASS}
docker-compose up -d
