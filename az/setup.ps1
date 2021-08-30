
# Execute this script first to setup your az installation.
# See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# Chris Joakim, Microsoft, August 2021

source ./config.sh

mkdir -p tmp/

echo 'interactive az login ...'
az login 

echo 'setting subscription ...'
az account set --subscription $AZURE_SUBSCRIPTION_ID

echo 'account show ...'
az account show > tmp/account_show.json

echo 'adding az extensions ...'
az extension add -n storage-preview
az extension add --name synapse

echo 'done'
