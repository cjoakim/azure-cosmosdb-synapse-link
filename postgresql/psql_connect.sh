#!/bin/bash

# Bash script to connect to my Azure PostgreSQL account with the psql
# client program.
# See the ~/github/cj-datascience/az-postgresql/ directory.
# Chris Joakim, 2020/07/27

source ../app-config.sh

pw=`printenv AZURE_PG_PASS`
echo $pw | pbcopy

psql --host=$postgresql_host \
    --port=$postgresql_port \
    --username=$postgresql_admin_user"@"$postgresql_server \
    --dbname=$postgresql_dbname
