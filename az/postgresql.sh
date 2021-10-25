#!/bin/bash

# Bash script with AZ CLI to automate the creation/deletion of an
# Azure PostgreSQL account.
# Chris Joakim, Microsoft, October 2021
#

# az login

source ./config.sh

mkdir -p tmp/

arg_count=$#
processed=0

create() {
    processed=1
    echo 'creating PostgreSQL rg: '$postgresql_rg
    az group create \
        --location $postgresql_region \
        --name $postgresql_rg \
        --subscription $subscription \
        > tmp/postgresql_rg_create.json

    echo 'creating PostgreSQL server: '$postgresql_server
    az postgres server create \
        --resource-group $postgresql_rg \
        --name $postgresql_server \
        --location $postgresql_region \
        --admin-user $postgresql_admin_user \
        --admin-password $postgresql_admin_pass \
        --sku-name $postgresql_sku \
        --ssl-enforcement Disabled \
        --public-network-access Enabled \
        --version $postgresql_version \
        > tmp/postgresql_server_create.json

    create_firewall_rule

    echo 'az postgres server show: '$postgresql_server
    az postgres server show \
        --resource-group $postgresql_rg \
        --name $postgresql_server \
        > tmp/postgresql_show.json

    echo 'az postgres db create: '$postgresql_dbname
    az postgres db create \
        --name $postgresql_dbname \
        --resource-group $postgresql_rg \
        --server-name $postgresql_server \
        > tmp/postgresql_db_create.json
}

create_firewall_rule() {
    processed=1
    echo 'creating firewall-rule for: '$postgresql_server
    az postgres server firewall-rule create \
        --resource-group $postgresql_rg \
        --server $postgresql_server \
        --name AllowAll \
        --start-ip-address 0.0.0.0 \
        --end-ip-address 255.255.255.255 \
        > tmp/postgresql_server_firewall_rule.json
}

info() {
    processed=1
    echo 'az postgres server show: '$postgresql_name
    az postgres server show \
        --resource-group $postgresql_rg \
        --name $postgresql_server \
        > tmp/postgresql_show.json
}

display_usage() {
    echo 'Usage:'
    echo './postgresql.sh create'
    echo './postgresql.sh info'
}

# ========== "main" logic below ==========

if [ $arg_count -gt 0 ]
then
    for arg in $@
    doelete; fi 
        if [ $arg == "create" ];   then create; fi 
        if [ $arg == "info" ];     then info; fi 
    done
fi

if [ $processed -eq 0 ]; then display_usage; fi

echo 'done'
