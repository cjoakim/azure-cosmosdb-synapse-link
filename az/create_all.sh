#!/bin/bash

# Bash shell script to create/provision the necessary Azure resources
# for this project.
# Chris Joakim, Microsoft, October 2021

source ./config.sh

mkdir -p tmp/

echo 'az logout'
az logout

echo 'for this example, az login with the UI and not with a service principal ...'
az login 

#./akv.sh create

./cosmos_sql.sh create info

./synapse.sh create pause create_spark_pool pause info

./postgresql.sh create
