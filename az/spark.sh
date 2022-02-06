#!/bin/bash

# Interact with a Spark cluster in Azure Synapse.
# See https://docs.microsoft.com/en-us/cli/azure/synapse/spark/session
# Chris Joakim, Microsoft, February 2022

source ./config.sh

mkdir -p tmp/

pause() {
    echo 'pause/sleep 60...'
    sleep 60
}

display_usage() {
    echo 'Usage:'
    echo './spark.sh list_sessions'
    echo './spark.sh show_session <session-id>'
}

# ========== "main" logic below ==========

if [[ $1 == "list_sessions" ]];
then
    echo 'list_sessions ...'
    az synapse spark session list \
        --workspace-name $synapse_name \
        --spark-pool-name $synapse_spark_pool_name \
        > tmp/synapse_spark_session_list.json
fi

if [[ $1 == "show_session" ]];
then
    echo 'show_session: '$2
    az synapse spark session show \
        --workspace-name $synapse_name \
        --spark-pool-name $synapse_spark_pool_name \
        --livy-id $2 \
        > tmp/synapse_spark_session_show.json
fi

echo 'done'
