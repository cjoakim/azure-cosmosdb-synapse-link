
# PowerShell script to "az login" and set environment variables for provisioning.
# Chris Joakim, Microsoft

.\config.ps1

echo 'logging in...'
az login

echo 'setting subscription ...'
az account set --subscription $Env:AZURE_SUBSCRIPTION_ID

echo 'current account ...'
az account show

echo 'done'
