# DotnetNoSqlConsoleApp

## Quick Setup

```
$ git clone https://github.com/cjoakim/azure-cosmosdb-synapse-link.git

$ cd azure-cosmosdb-synapse-link

$ cd DotnetConsoleApp

$ dotnet --version
6.0.100

$ dotnet restore

$ dotnet build

$ ./recreate_demo_db.sh

$ ./load_retail.sh

$ dotnet run

Command-Line Examples:
dotnet run list_databases
dotnet run create_database <dbname> <shared-ru | 0>
dotnet run delete_database <dbname>
dotnet run update_database_throughput <dbname> <shared-ru>
---
dotnet run list_containers <dbname>
dotnet run create_container <dbname> <cname> <pk> <ru>
dotnet run update_container_throughput <dbname> <cname> <ru>
dotnet run update_container_indexing <dbname> <cname> <json-doc-infile>
dotnet run truncate_container <dbname> <cname>
dotnet run delete_container <dbname> <cname>
---
dotnet run bulk_load_container <dbname> <cname> <pk-attr> <json-rows-infile> <batch-count>
dotnet run bulk_load_container demo customers customer_id data/customers.json 9999
dotnet run bulk_load_container demo products  upc         data/product_catalog.json 9999
dotnet run bulk_load_container demo stores    store_id    data/stores.json 9999
dotnet run bulk_load_container demo sales     sale_id     data/sales.json 9999
---
dotnet run count_documents <dbname> <cname>
---
dotnet run execute_queries <dbname> <cname> <queries-file>
dotnet run execute_queries demo customer_sales sql/customer_sales.txt

```
