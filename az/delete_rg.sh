#!/bin/bash

# Delete the Azure Resource Group associated with this project.
# Chris Joakim, Microsoft, August 2021

source ./config.sh

mkdir -p tmp/

az group delete \
    --name $primary_rg \
    --subscription $subscription \
    --yes \
    > tmp/delete_rg.json

echo 'done'
