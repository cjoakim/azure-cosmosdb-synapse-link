#!/bin/bash

source ./config.sh

mkdir -p tmp/

echo 'az logout'
az logout

echo 'az login with UI, not with a service principal ...'
az login 

./storage.sh create info 

./cosmos_sql.sh create info

./la_wsp.sh create info

./synapse.sh create pause create_spark_pool pause info
