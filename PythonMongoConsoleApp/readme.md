# PythonNoSqlConsoleApp

## Links 

- https://pymongo.readthedocs.io/en/stable/
- https://pymongo.readthedocs.io/en/stable/tutorial.html
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/mongodb-introduction
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-python 
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/find-request-unit-charge-mongodb


## Quick Setup

### Azure Provisioning

This code assumes that you have a **CosmosDB SQL API** account provisioned.

The examples below assume a database named **demo** with the several containers -
**products, stores, sales, customers, and sales_aggregates**.  The partition key for
each is **/pk**.

### Environment Variables

Set the following environment variable to your CosmosDB connection string.

```
AZURE_COSMOSDB_MONGODB_CONN_STRING=<your connection string from Azure Portal>
```

### Clone and Go

Instructions for both Windows or Linux/macOS

```
$ git clone https://github.com/cjoakim/azure-cosmosdb-synapse-link.git

$ cd azure-cosmosdb-synapse-link

# Unzip the zip file containing several large json files
> .\retail_data_copy_unzip.ps1
 - or -
$ ./retail_data_copy_unzip.sh

$ cd PythonConsoleApp/

# Create and activate a python virtual environment, specifying the libraries in requirements.in
$ ./venv.sh    (linux or macOS)
$ source venv/bin/activate
 - or -
> .\venv.ps1   (Windows)
> .\venv\Scripts\Activate.ps1

$ python --version
Python 3.9.10

# See the available command-line options in main.py
(venv) PS ...\PythonConsoleApp>  python main.py
Error: no command-line args entered
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json --verbose
    python main.py stream_sales demo sales sale_id data/sales1.json 999999 0.5
    python main.py execute_query demo stores find_by_pk --pk 2
    python main.py execute_query demo stores find_by_pk_id --pk 2 --id 61e6d8407a0af4624aaf0212 --verbose

### Loading the customers, products, stores, and sales containers

See scripts load_retail.ps1 and load_retail.sh

### Streaming

```
> python main.py stream_sales demo sales sale_id data/sales1.json 999999 0.5

where:
  demo = the database name
  sales = the container name
  sale_id = the partition key attribute name in the data, will be used to populate /pk
  data/sales.json = the input file  (see above instructions on unzipping the zip file)
  999999 = max documents to be loaded count
  0.5 = pause 0.5 seconds between each write
```