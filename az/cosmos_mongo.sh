#!/bin/bash

# Bash script with AZ CLI to automate the creation/deletion of my
# Azure Cosmos/Mongo DB.
# Chris Joakim, Microsoft
#
# See https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
# See https://docs.microsoft.com/en-us/azure/cosmos-db/scripts/cli/mongodb/create

# az login

source ./config.sh

arg_count=$#
processed=0

create() {
    processed=1
    echo 'creating cosmos rg: '$cosmos_mongo_rg
    az group create \
        --location $cosmos_mongo_region \
        --name $cosmos_mongo_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        > tmp/cosmos_mongo_rg_create.json

    echo 'creating cosmos acct: '$cosmos_mongo_acct_name
    az cosmosdb create \
        --name $cosmos_mongo_acct_name \
        --resource-group $cosmos_mongo_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --kind MongoDB \
        --server-version $cosmos_mongo_version \
        --default-consistency-level Eventual \
        --locations regionName=$cosmos_mongo_region \
        --enable-analytical-storage true \
        --enable-multiple-write-locations false \
        > tmp/cosmos_mongo_acct_create.json

    sleep 20 
    create_db 
    sleep 20 
    create_collections
}

recreate_all() {
    processed=1
    delete
    create
    info 
}

recreate_demo_db() {
    processed=1
    delete_db
    sleep 20
    create_db 
    sleep 20 
    create_collections
    info   
}

delete_db() {
    processed=1
    echo 'deleting cosmos db: '$cosmos_mongo_dbname
    az cosmosdb mongodb database delete \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --name $cosmos_mongo_dbname \
        --yes -y \
        > tmp/cosmos_mongo_db_delete.json
}

create_db() {
    processed=1
    echo 'creating cosmos db: '$cosmos_mongo_dbname
    az cosmosdb mongodb database create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --name $cosmos_mongo_dbname \
        --throughput $cosmos_mongo_db_throughput \
        > tmp/cosmos_mongo_db_create.json
}

create_collections() {
    # products stores customers sales 
    # TTL: >>> 60 * 60 * 24 * 90 -> 7776000
    processed=1

    echo 'creating cosmos collection: products'
    az cosmosdb mongodb collection create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --database-name $cosmos_mongo_dbname \
        --name products \
        --shard pk \
        --analytical-storage-ttl 7776000 \
        --idx @cosmos_mongo_index_products.json

    echo 'creating cosmos collection: stores'
    az cosmosdb mongodb collection create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --database-name $cosmos_mongo_dbname \
        --name stores \
        --shard pk \
        --analytical-storage-ttl 7776000 \
        --idx @cosmos_mongo_index_stores.json

    echo 'creating cosmos collection: customers'
    az cosmosdb mongodb collection create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --database-name $cosmos_mongo_dbname \
        --name customers \
        --shard pk \
        --analytical-storage-ttl 7776000 \
        --idx @cosmos_mongo_index_customers.json

    echo 'creating cosmos collection: sales'
    az cosmosdb mongodb collection create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --database-name $cosmos_mongo_dbname \
        --name sales \
        --shard pk \
        --analytical-storage-ttl 7776000 \
        --idx @cosmos_mongo_index_sales.json

    echo 'creating cosmos collection: sales_aggregates'
    az cosmosdb mongodb collection create \
        --resource-group $cosmos_mongo_rg \
        --account-name $cosmos_mongo_acct_name \
        --database-name $cosmos_mongo_dbname \
        --name sales_aggregates \
        --shard pk \
        --idx @cosmos_mongo_index_sales_aggregates.json

    # https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/mongodb-indexing
    # --idx @cosmos_mongo_amtrak_index_policy.json 
}

info() {
    processed=1
    echo 'az cosmosdb show ...'
    az cosmosdb show \
        --name $cosmos_mongo_acct_name \
        --resource-group $cosmos_mongo_rg \
        > tmp/cosmos_mongo_db_show.json

    echo 'az cosmosdb keys list - keys ...'
    az cosmosdb keys list \
        --resource-group $cosmos_mongo_rg \
        --name $cosmos_mongo_acct_name \
        --type keys \
        > tmp/cosmos_mongo_db_keys.json

    echo 'az cosmosdb keys list - connection-strings ...'
    az cosmosdb keys list \
        --resource-group $cosmos_mongo_rg \
        --name $cosmos_mongo_acct_name \
        --type connection-strings \
        > tmp/cosmos_mongo_db_connection_strings.json

    # This command has been deprecated and will be removed in a future release. Use 'cosmosdb keys list' instead.
}

display_usage() {
    echo 'Usage:'
    echo './cosmos_mongo.sh create'
    echo './cosmos_mongo.sh recreate'
    echo './cosmos_mongo.sh recreate_demo_db'
    echo './cosmos_mongo.sh create_collections'
    echo './cosmos_mongo.sh info'
}

# ========== "main" logic below ==========

if [ $arg_count -gt 0 ]
then
    for arg in $@
    do
        if [ $arg == "create" ];   then create; fi 
        if [ $arg == "recreate" ]; then recreate_all; fi 
        if [ $arg == "recreate_demo_db" ]; then recreate_demo_db; fi 
        if [ $arg == "create_collections" ]; then create_collections; fi 
        if [ $arg == "info" ];     then info; fi 
    done
fi

if [ $processed -eq 0 ]; then display_usage; fi

echo 'done'
