#!/bin/bash

# Bash script to set environment variables for provisioning.
#
# NOTE: Please do a change-all edit on this script to change "cjoakim" 
# to YOUR ID!!!
#
# Chris Joakim, Microsoft, October 2021

export primary_region="eastus"
export primary_rg="cjoakimcsldemo"              # csl = Cosmos-Synapse-Link
#
export akv_region=$primary_region
export akv_rg=$primary_rg
export akv_name="cjoakimcslkv"
export akv_sku="standard"
#
export cosmos_sql_region=$primary_region
export cosmos_sql_rg=$primary_rg
export cosmos_sql_acct_name="cjoakimcslcosmos"
export cosmos_sql_acct_consistency="Session"    # {BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong}
export cosmos_sql_acct_kind="GlobalDocumentDB"  # {GlobalDocumentDB, MongoDB, Parse}
export cosmos_sql_dbname="demo"
export cosmos_sql_cname="travel"
export cosmos_sql_pk_path="/pk"
export cosmos_sql_db_throughput="5000"
export cosmos_sql_sl_ttl="220903200"            # 7-years, in seconds (60 * 60 * 24 * 365.25 * 7)
#
export postgresql_region=$primary_region
export postgresql_rg=$primary_rg
export postgresql_version="11"
export postgresql_acct_name="cjoakimcslpg"
export postgresql_server="cjoakimcslpgsrv"
export postgresql_dbname="demo"
export postgresql_admin_user="cjoakim"
export postgresql_admin_pass=$AZURE_CSL_PG_PASS
export postgresql_sku="B_Gen5_1"  # B_Gen5_1, GP_Gen5_4, MO_Gen5_16
export postgresql_host=""$postgresql_server".postgres.database.azure.com"
export postgresql_port=5432
#
export synapse_region=$primary_region
export synapse_rg=$primary_rg
export synapse_name="cjoakimcslsynapse"
export synapse_stor_kind="StorageV2"            # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
export synapse_stor_sku="Standard_LRS"          # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
export synapse_stor_access_tier="Hot"           # Cool, Hot
export synapse_fs_name="synapse_acct"
export synapse_spark_pool_name="poolspark3s"
export synapse_spark_pool_count="3"
export synapse_spark_pool_size="Small"
