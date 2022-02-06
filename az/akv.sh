#!/bin/bash

# Bash script with AZ CLI to automate the creation/deletion of an
# Azure Key Vault account.
# 
# The Synapse workspace managed service identity will need to be granted GET Secrets permission to the Azure Key Vault. 
# See https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-secure-credentials-with-tokenlibrary?pivots=programming-language-python
#
# Chris Joakim, Microsoft, February 2022

source ./config.sh

mkdir -p tmp/

arg_count=$#
processed=0

create() {
    processed=1
    echo 'creating AKV rg: '$akv_rg
    az group create \
        --location $akv_region \
        --name $akv_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        > tmp/akv_rg_create.json

    sleep 20
    
    echo 'creating AKV acct: '$akv_name
    az keyvault create \
        --name $akv_name \
        --resource-group $akv_rg \
        --location $akv_region \
        --sku $akv_sku \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --enabled-for-deployment true \
        --enabled-for-template-deployment true \
        > tmp/akv_create.json

    pause
    set_secrets
}

set_secrets() {
    processed=1
    # Example - set credential secrets for an additional storage account
    echo 'setting secrets in: '$akv_name
    az keyvault secret set \
        --vault-name $akv_name \
        --name  AZURE-STORAGE-ACCOUNT \
        --value $AZURE_STORAGE_ACCOUNT

    az keyvault secret set \
        --vault-name $akv_name \
        --name  AZURE-STORAGE-KEY \
        --value $AZURE_STORAGE_KEY

    az keyvault secret set \
        --vault-name $akv_name \
        --name  AZURE-STORAGE-CONNECTION-STRING \
        --value $AZURE_STORAGE_CONNECTION_STRING
}

info() {
    processed=1
    echo 'AKV show: '$akv_name
    az keyvault show \
        --name $akv_name \
        --resource-group $akv_rg \
        --subscription $AZURE_SUBSCRIPTION_ID \
        > tmp/akv_show.json

    echo 'AKV key list: '$akv_name
    az keyvault key list \
        --vault-name $akv_name \
        --subscription $AZURE_SUBSCRIPTION_ID \
        > tmp/akv_key_list.json

    echo 'AKV secret list: '$akv_name
    az keyvault secret list \
        --vault-name $akv_name \
        --subscription $AZURE_SUBSCRIPTION_ID \
        --maxresults 25 \
        > tmp/akv_secret_list.json

    echo 'AKV secret show: '$akv_name
    az keyvault secret show \
        --name  AZURE-STORAGE-ACCOUNT \
        --vault-name $akv_name \
        --subscription $AZURE_SUBSCRIPTION_ID
        > tmp/akv_secret_show_AZURE-STORAGE-ACCOUNT.json
}

pause() {
    echo 'pause/sleep 20...'
    sleep 20
}

display_usage() {
    echo 'Usage:'
    echo './akv.sh create'
    echo './akv.sh set_secrets'
    echo './akv.sh info'
}

# ========== "main" logic below ==========

if [ $arg_count -gt 0 ]
then
    for arg in $@
    do
        if [ $arg == "create" ];      then create; fi 
        if [ $arg == "set_secrets" ]; then set_secrets; fi  
        if [ $arg == "info" ];        then info; fi 
    done
fi

if [ $processed -eq 0 ]; then display_usage; fi

echo 'done'
