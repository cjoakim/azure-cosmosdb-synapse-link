
# Provision an Azure Cosmos/Mongo DB account with the az CLI.
# Chris Joakim, Microsoft
#
# See https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
# See https://docs.microsoft.com/en-us/azure/cosmos-db/scripts/cli/mongodb/create

.\config.ps1


echo 'creating cosmos rg: '$Env:cosmos_mongo_rg
az group create `
    --location $Env:cosmos_mongo_region `
    --name $Env:cosmos_mongo_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    > tmp/cosmos_mongo_rg_create.json

echo 'creating cosmos acct: '$Env:cosmos_mongo_acct_name
az cosmosdb create `
    --name $Env:cosmos_mongo_acct_name `
    --resource-group $Env:cosmos_mongo_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --kind MongoDB `
    --server-version 4.2 `
    --default-consistency-level Eventual `
    --locations regionName=$Env:cosmos_mongo_region `
    --enable-analytical-storage true `
    --enable-multiple-write-locations false `
    > tmp/cosmos_mongo_acct_create.json

echo 'creating cosmos db: '$Env:cosmos_mongo_dbname
az cosmosdb mongodb database create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --name $Env:cosmos_mongo_dbname `
    --throughput $Env:cosmos_mongo_db_throughput `
    > tmp/cosmos_mongo_db_create.json

# containers: products, stores, customers, sales, sales_aggregates

echo 'creating cosmos collection: products'
az cosmosdb mongodb collection create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --database-name $Env:cosmos_mongo_dbname `
    --name products `
    --shard pk `
    --analytical-storage-ttl 7776000
    # --idx @cosmos_mongo_index_products.json

echo 'creating cosmos collection: stores'
az cosmosdb mongodb collection create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --database-name $Env:cosmos_mongo_dbname `
    --name stores `
    --shard pk `
    --analytical-storage-ttl 7776000
    # --idx @cosmos_mongo_index_stores.json

echo 'creating cosmos collection: customers'
az cosmosdb mongodb collection create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --database-name $Env:cosmos_mongo_dbname `
    --name customers `
    --shard pk `
    --analytical-storage-ttl 7776000
    # --idx @cosmos_mongo_index_customers.json

echo 'creating cosmos collection: sales'
az cosmosdb mongodb collection create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --database-name $Env:cosmos_mongo_dbname `
    --name sales `
    --shard pk `
    --analytical-storage-ttl 7776000
    # --idx @cosmos_mongo_index_sales.json

echo 'creating cosmos collection: sales_aggregates'
az cosmosdb mongodb collection create `
    --resource-group $Env:cosmos_mongo_rg `
    --account-name $Env:cosmos_mongo_acct_name `
    --database-name $Env:cosmos_mongo_dbname `
    --name sales_aggregates `
    --shard pk
    # --idx @cosmos_mongo_index_sales_aggregates.json


echo 'done'
