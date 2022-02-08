#!/bin/bash

# Bash script to set environment variables for provisioning.
#
# NOTE: Please do a change-all edit on this script to change "cjoakim" 
# to YOUR ID!!!
#
# Chris Joakim, Microsoft

export primary_region="eastus"
export primary_rg="cjoakimsl"
export subscription=$AZURE_SUBSCRIPTION_ID
#
export akv_region=$primary_region
export akv_rg=$primary_rg
export akv_name="cjoakimslkv2"
export akv_sku="standard"
#
export la_wsp_region=$primary_region
export la_wsp_rg=$primary_rg
export la_wsp_name="cjoakimslla"
#
export cosmos_sql_region=$primary_region
export cosmos_sql_rg=$primary_rg
export cosmos_sql_acct_name="cjoakimslcosmossql"
export cosmos_sql_acct_consistency="Session"    # {BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong}
export cosmos_sql_acct_kind="GlobalDocumentDB"  # {GlobalDocumentDB, MongoDB, Parse}
export cosmos_sql_dbname="demo"
export cosmos_sql_cname="travel"
export cosmos_sql_pk_path="/pk"
export cosmos_sql_db_throughput="4000"
export cosmos_sql_sl_ttl="220903200"            # 7-years, in seconds (60 * 60 * 24 * 365.25 * 7)
#
export cosmos_mongo_region=$primary_region
export cosmos_mongo_rg=$primary_rg
export cosmos_mongo_acct_name="cjoakimslcosmosmongo"
export cosmos_mongo_acct_consistency="Session"    # {BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong}
export cosmos_mongo_acct_kind="MongoDB"  # {GlobalDocumentDB, MongoDB, Parse}
export cosmos_mongo_version="4.0"
export cosmos_mongo_dbname="demo"
export cosmos_mongo_db_throughput="4000"
#
export postgresql_region=$primary_region
export postgresql_rg=$primary_rg
export postgresql_version="11"
export postgresql_acct_name="cjoakimslpg"
export postgresql_server="cjoakimslpgsrv"
export postgresql_dbname="demo"
export postgresql_admin_user="cjoakim"
export postgresql_admin_pass=$AZURE_CSL_PG_PASS
export postgresql_sku="B_Gen5_1"  # B_Gen5_1, GP_Gen5_4, MO_Gen5_16
export postgresql_host=""$postgresql_server".postgres.database.azure.com"
export postgresql_port=5432
#
export synapse_region=$primary_region
export synapse_rg=$primary_rg
export synapse_name="cjoakimslsynapse"
export synapse_stor_kind="StorageV2"            # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
export synapse_stor_sku="Standard_LRS"          # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
export synapse_stor_access_tier="Hot"           # Cool, Hot
export synapse_fs_name="synapse_acct"
export synapse_spark_pool_name="poolspark3s"
export synapse_spark_pool_count="3"
export synapse_spark_pool_size="Small"
