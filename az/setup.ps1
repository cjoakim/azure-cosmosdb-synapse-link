# Execute this script first to setup your az installation.
# See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# Chris Joakim, Microsoft, August 2021

mkdir -p tmp/

echo 'interactive az login ...'
az login 

echo 'setting subscription ...'
az account set --subscription $Env:AZURE_SUBSCRIPTION_ID

echo 'account show ...'
az account show

echo 'listing available extensions ...'
az extension list-available --output table

echo 'adding az extensions ...'
#az extension add -n storage-preview
az extension update -n storage-preview

echo 'done'
