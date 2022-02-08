# Delete the Azure Resource Group associated with this project.
# Chris Joakim, Microsoft

echo "deleting resource group: "$Env:cosmos_sql_rg

az group delete `
    --name $Env:cosmos_sql_rg `
    --subscription $Env:AZURE_SUBSCRIPTION_ID `
    --yes `
    --no-wait `
    > tmp/delete_rg.json

echo 'done'
