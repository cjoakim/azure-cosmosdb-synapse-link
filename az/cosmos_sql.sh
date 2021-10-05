#!/bin/bash

# Provision an Azure Cosmos/SQL DB account with the az CLI.
# Chris Joakim, Microsoft, October 2021

source ./config.sh

mkdir -p tmp/

arg_count=$#
processed=0

create() {
    processed=1
    create_rg
    create_acct
    create_db
    create_containers
}

create_rg() {
    echo 'creating rg: '$cosmos_sql_rg
    az group create \
        --location $cosmos_sql_region \
        --name $cosmos_sql_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        > tmp/cosmos_sql_rg_create.json
}

create_acct() {
    echo 'creating cosmos acct: '$cosmos_sql_acct_name
    az cosmosdb create \
        --name $cosmos_sql_acct_name \
        --resource-group $cosmos_sql_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --locations regionName=$cosmos_sql_region failoverPriority=0 isZoneRedundant=False \
        --default-consistency-level $cosmos_sql_acct_consistency \
        --enable-multiple-write-locations true \
        --enable-analytical-storage true \
        --kind $cosmos_sql_acct_kind \
        > tmp/cosmos_sql_acct_create.json
}

create_db() {
    echo 'creating cosmos db: '$cosmos_sql_dbname
    az cosmosdb sql database create \
        --resource-group $cosmos_sql_rg \
        --account-name $cosmos_sql_acct_name \
        --name $cosmos_sql_dbname \
        --max-throughput $cosmos_sql_db_throughput \
        > tmp/cosmos_sql_db_create.json
}

create_containers() {
    echo 'creating cosmos container: '$cosmos_sql_cname
    az cosmosdb sql container create \
        --resource-group $cosmos_sql_rg \
        --account-name $cosmos_sql_acct_name \
        --database-name $cosmos_sql_dbname \
        --name $cosmos_sql_cname \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --partition-key-path $cosmos_sql_pk_path \
        --analytical-storage-ttl $cosmos_sql_sl_ttl

    echo 'creating cosmos container: customers'
    az cosmosdb sql container create \
        --resource-group $cosmos_sql_rg \
        --account-name $cosmos_sql_acct_name \
        --database-name $cosmos_sql_dbname \
        --name customers \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --partition-key-path $cosmos_sql_pk_path \
        --analytical-storage-ttl $cosmos_sql_sl_ttl

    echo 'creating cosmos container: products'
    az cosmosdb sql container create \
        --resource-group $cosmos_sql_rg \
        --account-name $cosmos_sql_acct_name \
        --database-name $cosmos_sql_dbname \
        --name products \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --partition-key-path $cosmos_sql_pk_path \
        --analytical-storage-ttl $cosmos_sql_sl_ttl

    echo 'creating cosmos container: orders'
    az cosmosdb sql container create \
        --resource-group $cosmos_sql_rg \
        --account-name $cosmos_sql_acct_name \
        --database-name $cosmos_sql_dbname \
        --name orders \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --partition-key-path $cosmos_sql_pk_path \
        --analytical-storage-ttl $cosmos_sql_sl_ttl
}

info() {
    processed=1
    echo 'az cosmosdb show ...'
    az cosmosdb show \
        --name $cosmos_sql_acct_name \
        --resource-group $cosmos_sql_rg \
        > tmp/cosmos_sql_acct_show.json

    echo 'az cosmosdb keys list - keys ...'
    az cosmosdb keys list \
        --resource-group $cosmos_sql_rg \
        --name $cosmos_sql_acct_name \
        --type keys \
        > tmp/cosmos_sql_keys.json

    echo 'az cosmosdb keys list - read-only-keys ...'
    az cosmosdb keys list \
        --resource-group $cosmos_sql_rg \
        --name $cosmos_sql_acct_name \
        --type read-only-keys \
        > tmp/cosmos_sql_read_only_keys.json

    echo 'az cosmosdb keys list - connection-strings ...'
    az cosmosdb keys list \
        --resource-group $cosmos_sql_rg \
        --name $cosmos_sql_acct_name \
        --type connection-strings \
        > tmp/cosmos_sql_connection_strings.json
}

display_usage() {
    echo 'Usage:'
    echo './cosmos_sql.sh create'
    echo './cosmos_sql.sh info'
}

# ========== "main" logic below ==========

if [[ $arg_count -gt 0 ]];
then
    for arg in $@
    do
        if [[ $arg == "create" ]]; then create; fi 
        if [[ $arg == "info" ]];   then info; fi 
    done
fi

if [[ $processed -eq 0 ]]; then display_usage; fi

echo 'done'
