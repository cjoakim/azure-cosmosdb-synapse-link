#!/bin/bash

# Bash script to connect to an Azure PostgreSQL server with the psql
# client program using your AZURE_CSL_PG_xxx environment variables.
# Chris Joakim, Microsoft, October 2021

pw=`printenv AZURE_CSL_PG_PASS`
echo $pw | pbcopy

psql --host=$AZURE_CSL_PG_SERVER_FULL_NAME \
    --port=$AZURE_CSL_PG_PORT \
    --username=$AZURE_CSL_PG_USER \
    --dbname=$AZURE_CSL_PG_DATABASE
