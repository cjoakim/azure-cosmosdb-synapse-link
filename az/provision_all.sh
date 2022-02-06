#!/bin/bash

# Provision Azure Synapse Workspace, and related services, with the az CLI.
# Chris Joakim, Microsoft, February 2022

echo '========================================'
echo 'sourcing config.sh for provisioning environment variables ...'
source ./config.sh

echo '========================================'
echo 'display the sourced environment variables ...'
env | grep primary_
env | grep subscription
env | grep akv_
env | grep la_wsp_
env | grep cosmos_
env | grep postgresql_
env | grep synapse_

echo '========================================'
echo 'creating/pruning tmp/ directory ...'
mkdir -p tmp/
rm tmp/*.*

echo '========================================'
echo 'deleting resource group '$primary_rg
./delete_rg.sh

echo '========================================'
echo 'provisioning Azure Key Vault ...'
./akv.sh create 
./akv.sh info 
sleep 30

echo '========================================'
echo 'provisioning Azure Log Analytics / Monitor ...'
# Azure Log Analytics / Monitor
./la_wsp.sh create
./la_wsp.sh info
sleep 30

echo '========================================'
echo 'provisioning Azure CosmosDB/SQL account ...'
./cosmos_sql.sh create
./cosmos_sql.sh info

echo '========================================'
echo 'provisioning Azure CosmosDB/Mongo account ...'
./cosmos_mongo.sh create
./cosmos_mongo.sh info

echo '========================================'
echo 'provisioning Azure PostgreSQL account ...'
./postgresql.sh create
./postgresql.sh info

echo '========================================'
echo 'provisioning Azure Synapse account with Spark Pool ...'
./synapse.sh create pause create_spark_pool pause info

echo ''
echo 'provision_all script completed'
