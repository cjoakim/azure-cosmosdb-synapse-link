#!/bin/bash

# Bash shell that defines provisioning parameters and environment variables
# and is "sourced" by the other scripts in this directory.
#
# Some of these values from environment variables already defined on my
# system, such as USER, AZURE_SUBSCRIPTION_ID, AZURE_SYNAPSE_PASS.
# You should likewise set thesein your environment before running this script.
#
# NOTE: Please do a change-all on this script to change "cjoakim" to your ID.
#
# Chris Joakim, Microsoft, August 2021

export subscription=$AZURE_SUBSCRIPTION_ID
export user=$USER
export primary_region="eastus"
export primary_rg="cjoakimcosmosdemoSL"
#
export cosmos_sql_region=$primary_region
export cosmos_sql_rg=$primary_rg
export cosmos_sql_acct_name="cjoakimcosmossqlSL"
export cosmos_sql_acct_consistency="Session"    # {BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong}
export cosmos_sql_acct_kind="GlobalDocumentDB"  # {GlobalDocumentDB, MongoDB, Parse}
export cosmos_sql_dbname="demo"
export cosmos_sql_db_throughput="4000"
#
export la_wsp_region=$primary_region
export la_wsp_rg=$primary_rg
export la_wsp_name="cjoakimloganalyticsSL"
#
export storage_region=$primary_region
export storage_rg=$primary_rg
export storage_name="cjoakimstorageSL"
export storage_kind="BlobStorage"     # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
export storage_sku="Standard_LRS"     # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
export storage_access_tier="Hot"      # Cool, Hot
#
export synapse_region=$primary_region
export synapse_rg=$primary_rg
export synapse_name="cjoakimsynapseSL"
export synapse_stor_kind="StorageV2"       # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
export synapse_stor_sku="Standard_LRS"     # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
export synapse_stor_access_tier="Hot"      # Cool, Hot
export synapse_admin_user="cjoakim"
export synapse_admin_pass=$AZURE_SYNAPSE_PASS
export synapse_fs_name="synapse_acct"
export synapse_spark_pool_name="poolspark3s"
export synapse_spark_pool_count="3"
export synapse_spark_pool_size="Small"
