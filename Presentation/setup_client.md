# Provisioning and Setup Client Apps

## Laptop/Workstation/VM Requirements

- Either the Windows, Linux, or macOS operating system
- [git source control system](https://git-scm.com/)
- DotNet 6+, Java 11+, or Python 3 - per your chosen CosmosDB API and Programming Language

## Clone this GitHub Repository

```
$ cd <some-parent-directory>

$ git clone https://github.com/cjoakim/azure-cosmosdb-synapse-link.git

$ cd azure-cosmosdb-synapse-link
```

## Provision Azure Resources

It is recommended that you provision these Azure Resources with either the 
**Azure Portal** or the **az CLI**.  This repo contains working az CLI scripts.

- **Azure CosmosDB/SQL OR CosmosDB/Mongo Account**
  - With database named **demo** with 10,000 shared Request Units (RU)
  - With containers named **customers, products, stores, sales, views** with partition key **/pk**
  - both the account and the containers should have the **Analytical Store Enabled**

- **Azure Synapse**
  - with a **Spark Pool of three small nodes**

- **Azure Monitor**
  - Configure your CosmosDB account to log to this instance

## Environment Varibles

The code in this repo assumes that the following environment variables have been
set, and populated with appropriate values for your laptop/workstation/VM as well
as your CosmosDB account.

```
AZURE_SUBSCRIPTION_ID                   <-- used in az CLI provisioning scripts
AZURE_SYNAPSE_USER                      <-- used in az/synapse* provisioning scripts
AZURE_SYNAPSE_PASS                      <-- used in az/synapse* provisioning scripts

AZURE_COSMOSDB_NOSQL_CONN_STRING1       <-- for CosmosDB/SQL & DotNet
AZURE_COSMOSDB_NOSQL_RW_KEY1            <-- for CosmosDB/SQL & DotNet
AZURE_COSMOSDB_NOSQL_URI                <-- for CosmosDB/SQL & DotNet
AZURE_COSMOSDB_NOSQL_REGIONS            <-- for CosmosDB/SQL & DotNet
AZURE_COSMOSDB_NOSQL_BULK_BATCH_SIZE    <-- for CosmosDB/SQL & DotNet Bulk Loading

AZURE_COSMOSDB_MONGODB_CONN_STRING      <-- for CosmosDB/Mongo & Java or Python
```

## Standard Generated Dataset 

A simulated set of **ecommerce retail data** consisting of customers, products, stores, and sales
JSON files is in this repo within the following file:

```
dataset_generation/retail_data_zip.sh
```

Depending on your chosen CosmosDB API and Programming Language, copy this zip file
to the **XxxConsoleApp/data** directory, where Xxx is the programming language,
and unzip it there.  Alternatively, simply execute the following script:

```
$ ./retail_data_copy_unzip.sh
```

The reason for using the zip file is that the JSON data files are too large for GitHub.

The **dataset_generation/** directory contains the Python logic to generate this
dataset.  You do not have to execute the generation process, simply use the output
from this process - the zip file mentioned above.

## CosmosDB - Use either the SQL or Mongo APIs

**This repo has working Console Application Client code for the following combinations:**

- [CosmosDB/SQL API with DotNet 6](../DotnetConsoleApp/readme.md)
- [CosmosDB/Mongo API with Java 11](../JavaConsoleApp/readme.md)
- [CosmosDB/Mongo API with Python 3](../PythonConsoleApp/readme.md)

See the appropriate readme.md files in one of these directories to proceed.
They each implement similar functionality to load CosmosDB with the generated dataset,
and then query CosmosDB.
