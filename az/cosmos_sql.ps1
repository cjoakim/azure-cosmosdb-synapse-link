
# Provision an Azure Cosmos/SQL DB account with the az CLI.
# Chris Joakim, Microsoft

# /cosmos_sql.ps1

echo 'creating rg: '$Env:cosmos_sql_rg
az group create `
    --location $Env:cosmos_sql_region `
    --name $Env:cosmos_sql_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    > tmp/cosmos_sql_rg_create.json

echo 'creating cosmos acct: '$Env:cosmos_sql_acct_name
az cosmosdb create `
    --name $Env:cosmos_sql_acct_name `
    --resource-group $Env:cosmos_sql_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --locations regionName=$Env:cosmos_sql_region failoverPriority=0 isZoneRedundant=False `
    --default-consistency-level $Env:cosmos_sql_acct_consistency `
    --enable-multiple-write-locations true `
    --enable-analytical-storage true `
    --kind $Env:cosmos_sql_acct_kind `
    > tmp/cosmos_sql_acct_create.json

echo 'creating cosmos db: '$Env:cosmos_sql_dbname
az cosmosdb sql database create `
    --resource-group $Env:cosmos_sql_rg `
    --account-name $Env:cosmos_sql_acct_name `
    --name $Env:cosmos_sql_dbname `
    --max-throughput $Env:cosmos_sql_db_throughput `
    > tmp/cosmos_sql_db_create.json

echo 'creating cosmos container: '$Env:cosmos_sql_cname
az cosmosdb sql container create `
    --resource-group $Env:cosmos_sql_rg `
    --account-name $Env:cosmos_sql_acct_name `
    --database-name $Env:cosmos_sql_dbname `
    --name $Env:cosmos_sql_cname `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --partition-key-path $Env:cosmos_sql_pk_path `
    --analytical-storage-ttl $Env:cosmos_sql_sl_ttl

echo 'creating cosmos container: customers'
az cosmosdb sql container create `
    --resource-group $Env:cosmos_sql_rg `
    --account-name $Env:cosmos_sql_acct_name `
    --database-name $Env:cosmos_sql_dbname `
    --name customers `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --partition-key-path $Env:cosmos_sql_pk_path `
    --analytical-storage-ttl $Env:cosmos_sql_sl_ttl

echo 'creating cosmos container: products'
az cosmosdb sql container create `
    --resource-group $Env:cosmos_sql_rg `
    --account-name $Env:cosmos_sql_acct_name `
    --database-name $Env:cosmos_sql_dbname `
    --name products `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --partition-key-path $Env:cosmos_sql_pk_path `
    --analytical-storage-ttl $Env:cosmos_sql_sl_ttl

echo 'creating cosmos container: orders'
az cosmosdb sql container create `
    --resource-group $Env:cosmos_sql_rg `
    --account-name $Env:cosmos_sql_acct_name `
    --database-name $Env:cosmos_sql_dbname `
    --name orders `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --partition-key-path $Env:cosmos_sql_pk_path `
    --analytical-storage-ttl $Env:cosmos_sql_sl_ttl
        
echo 'done'
