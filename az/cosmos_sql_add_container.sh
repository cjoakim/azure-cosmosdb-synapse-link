#!/bin/bash

# Ad-hoc script to add a container to the CosmosDB database.
# Chris Joakim, Microsoft, October 2021

source ./config.sh

echo 'creating cosmos container: customer_sales'
az cosmosdb sql container create \
    --resource-group $cosmos_sql_rg \
    --account-name $cosmos_sql_acct_name \
    --database-name $cosmos_sql_dbname \
    --name customer_sales \
    --subscription $AZURE_SUBSCRIPTION_ID \
    --partition-key-path /customer_id
