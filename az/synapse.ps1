# Provision Azure Synapse Workspace, and related services, with the az CLI.
# Chris Joakim, Microsoft, August 2021

echo 'create rg ...'
az group create `
    --location $Env:synapse_region `
    --name $Env:synapse_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    > tmp/synapse_rg_create.json

echo 'creating synapse storage (ADL V2) ...'
az storage account create `
    --name $Env:synapse_name `
    --resource-group $Env:synapse_rg `
    --location $Env:synapse_region `
    --sku $Env:synapse_stor_sku `
    --kind StorageV2 `
    --hierarchical-namespace true `
    > tmp/synapse_storage_acct_create.json

Start-Sleep -s 60

echo 'creating synapse workspace ... '
az synapse workspace create `
    --name $Env:synapse_name `
    --resource-group $Env:synapse_rg `
    --storage-account $Env:storage_name `
    --file-system $Env:synapse_fs_name `
    --sql-admin-login-user $Env:AZURE_SYNAPSE_USER `
    --sql-admin-login-password $Env:AZURE_SYNAPSE_PASS `
    --location $Env:synapse_region `
    > tmp/synapse_workspace_create.json

Start-Sleep -s 60

echo 'creating synapse workspace firewall-rule ...'
az synapse workspace firewall-rule create `
    --name allowAll `
    --workspace-name $Env:synapse_name `
    --resource-group $Env:synapse_rg `
    --start-ip-address 0.0.0.0 `
    --end-ip-address 255.255.255.255  `
    > tmp/synapse_firewall_rule_create.json

    echo 'creating synapse spark pool ...'
az synapse spark pool create `
    --name $Env:synapse_spark_pool_name `
    --workspace-name $Env:synapse_name `
    --resource-group $Env:synapse_rg `
    --spark-version 2.4 `
    --enable-auto-pause true `
    --delay 120 `
    --node-count $Env:synapse_spark_pool_count `
    --node-size $Env:synapse_spark_pool_size `
    > tmp/synapse_spark_pool_create.json

echo 'done'
