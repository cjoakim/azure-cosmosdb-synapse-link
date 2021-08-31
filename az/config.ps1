# PowerShell script to set environment variables for provisioning.
# NOTE: Please do a change-all on this script to change "cjoakim" to YOUR ID!
#
# Chris Joakim, Microsoft, August 2021

$Env:cosmos_sql_region="eastus"
$Env:cosmos_sql_rg="cjoakimcsl2"              # csl = Cosmos-Synapse-Link
$Env:cosmos_sql_acct_name="cjoakimcslcosmos2"
$Env:cosmos_sql_acct_consistency="Session"    # {BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong}
$Env:cosmos_sql_acct_kind="GlobalDocumentDB"  # {GlobalDocumentDB, MongoDB, Parse}
$Env:cosmos_sql_dbname="demo"
$Env:cosmos_sql_cname="travel"
$Env:cosmos_sql_pk_path="/pk"
$Env:cosmos_sql_db_throughput="4000"
$Env:cosmos_sql_sl_ttl="220903200"            # 7-years, in seconds (60 * 60 * 24 * 365.25 * 7)
#
$Env:synapse_region="eastus"
$Env:synapse_rg="cjoakimcsl2"                 # csl = Cosmos-Synapse-Link
$Env:synapse_name="cjoakimcslsynapse2"
$Env:synapse_stor_kind="StorageV2"            # {BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2}]
$Env:synapse_stor_sku="Standard_LRS"          # {Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, , Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]
$Env:synapse_stor_access_tier="Hot"           # Cool, Hot
$Env:synapse_fs_name="synapse_acct"
$Env:synapse_spark_pool_name="poolspark3s2"
$Env:synapse_spark_pool_count="3"
$Env:synapse_spark_pool_size="Small"

mkdir -p tmp/

echo "cosmos_sql_region: "$Env:cosmos_sql_region
