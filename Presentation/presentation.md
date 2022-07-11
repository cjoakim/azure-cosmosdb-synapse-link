# Azure CosmosDB with Synapse Link Presentation

Demonstration of **Azure CosmosDB** and **Azure Synapse Analytics**
integration via **Synapse Link**

**Chris Joakim, Microsoft, Global Black Belt NoSQL/CosmosDB**, chjoakim@microsoft.com

The intent of this GitHub repository is both for **presentation purposes** and **working code examples**

Repository URL: https://github.com/cjoakim/azure-cosmosdb-synapse-link

Presentation URL: https://github.com/cjoakim/azure-cosmosdb-synapse-link/blob/main/Presentation/presentation.md

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

<a name="part1"></a>

## What is HTAP?

- **Origins of the term HTAP per Wikipedia**
  - **HTAP** = **Hybrid Transactional Analytical Processing**
  - https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing
    - **Garner** in 2014 called it **HTAP**
      - "... architecture that "breaks the wall" between transaction processing and analytics."
    - **Forrester** called it **HOAP**
      - "Hybrid Operational and Analytical Processing"

### Why use HTAP?

  - It Enables:
    - Efficient use of the operational database (OLTP)
    - Efficient analytics and batch processing on copies of the same data
    - "Painless ETL"
    - Lower Costs

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Architecture of Azure Synapse Link

- **Hybrid Transactional and Analytical Processing (HTAP) Implementation in Azure**
  - Data flows from CosmosDB to the Analytic Store in approximately 2-minutes; **no ETL required**
  - Azure Cosmos DB guarantees **performance isolation** between the transactional and analytical workloads
  - The Analytic Store is **read-only from Azure Synapse**
  - The account can be either **CosmosDB/SQL** or **CosmosDB/Mongo**; this repo demonstrates both 
  - The solution is **very easy to configure and use**
  - Use the **Apache Spark** and/or **SQL** compute engines in Azure Synapse to read the Analytic Store
  - References:
    - [Azure CosmosDB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)
    - [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/)
    - [Azure Synapse Link](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link)
    - [A Common Use-Case](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link-use-cases)

<p align="center">
    <img src="img/synapse-analytics-cosmos-db-architecture.png" width="100%">
</p>

### Synapse Link data movement and transformation

- Synapse Link performs **both copy AND data transformation (to columnar format)** operations
- A **columnar datastore** is more suitable for analytical processing
- The **inserts, updates, and deletes** to your CosmosDB operational data are automatically synced to analytical store

<p align="center">
  <img src="img/transactional-analytical-data-stores.png" width="100%">
</p>

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Configure CosmosDB

### Enable the Synapse Link Feature on the Account

<p align="center">
    <img src="img/feature-enabled-in-portal.png" width="80%">
</p>

### Also Enable Synapse Link per Container

<p align="center">
    <img src="img/synapse-linked-sales-container.png" width="80%">
</p>

Note the optional **TTL** functionality in both OLTP and OLAP.

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Configure a Linked Service in Azure Synapse

First, create a **Linked Service** in Azure Synapse.  This is the sequence of steps in the UI:

```
In Synapse Studio
  Linked Services -->
    New Linked Service -->
      Select CosmosDB -->
        Select your Subscription -->
          Select your Database -->
            Test Connection -->
              Save
```

This is the resulting list of **Datasets** in Azure Synapse (see the CosmosSqlDemoDB linked service):

<p align="center">
    <img src="img/synapse-linked-datasets.png" width="80%">
</p>

### Spark Notebook Code to Read the Synapse Link Data

Right-mouse a dataset (i.e. - sales) to produce an initial working notebook:

```
df = spark.read\
    .format("cosmos.olap")\
    .option("spark.synapse.linkedService", "CosmosSqlDemoDb")\
    .option("spark.cosmos.container", "sales")\
    .load()
```

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## The Demonstration Application

- A **Client Console Application** reads a data file, and **Loads JSON documents to CosmosDB**
  - See example [DotnetSqlConsoleApp](../DotnetSqlConsoleApp/readme.md) for bulk-loading **CosmosDB/SQL**
  - See example [JavaMongoConsoleApp](../JavaMongoConsoleApp/readme.md) for loading **CosmosDB/Mongo**
  - See example [PythonMongoConsoleApp](../PythonMongoConsoleApp/readme.md) for loading **CosmosDB/Mongo**
  - See example [PythonSqlConsoleApp](../PythonSqlConsoleApp/readme.md) for loading **CosmosDB/SQL**
  - See the [dataset_generation](../dataset_generation/readme.md) directory
    - **Simulated Products, Stores, Customers, and Sales documents with Line Items**
    - The simulated data was generated with Python and the **faker** library

### Send a Stream of Sales data to CosmosDB with the PythonSqlConsoleApp

```
python main.py stream_sales demo sales sale_id data/sales1.json 999999 0.5
```

<p align="center">
    <img src="img/python-console-app-streaming-sales.png" width="80%">
</p>

- The CosmosDB data flows into **Synapse Link Analytical Store in near realtime**
  - Approximately 2-minutes
  - https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction
  - https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link-frequently-asked-questions

- Synapse Link performs **both copy AND data transformation (to columnar format)** operations

- No other **ETL** solution is needed (i.e. - Databricks)

- **Time To Live (TTL)** is enabled on both the transactional and analytical stores
  - https://docs.microsoft.com/en-us/azure/cosmos-db/sql/time-to-live
  - https://docs.microsoft.com/en-us/azure/cosmos-db/configure-synapse-link
  - https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction#analytical-ttl
  - https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link-frequently-asked-questions

- Query the Synapse Link data with **PySpark Notebooks in Azure Synapse Analytics**
  - https://docs.microsoft.com/en-us/azure/synapse-analytics/synapse-link/how-to-query-analytical-store-spark-3
  - See the synapse/notebooks/ directory in this repo for examples; *.ipynb files

- The Synapse Link data can also be queried with **SQL pools** (not in demonstration)
  - https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link-power-bi

- A **PySpark Notebook aggregates the Synapse Link Sales data, and writes it back to CosmosDB**
  - [The PySpark Notebook Used in the Demonstration Application](https://github.com/cjoakim/azure-cosmosdb-synapse-link/blob/main/Synapse/notebooks/cosmos_sql_sales_processing.ipynb)

<p align="center">
    <img src="img/python-console-app-streaming-sales.png" width="80%">
</p>


- **Desktop Programs** can access **CosmosDB/Mongo**
  - [Mongo shell, Studio 3T, Matlab, etc](cosmos_mongo_desktop_tools.md)

<p align="center">
    <img src="img/synapse-analytics-cosmos-db-architecture.png" width="100%">
</p>

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Synapse Link Details

- **No impact to CosmosDB performance or RU costs**
- Is Scalable and Elastic
- The Synapse Link data can be queried in Azure Synapse Analytics by:
  - **Azure Synapse Spark pools**
    - Spark Streaming not yet supported
  - **Azure Synapse Serverless SQL pools** (not provisioned pools)
- **Pricing** consists of **storage and IO operations**
  - https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction#analytical-store-pricing
  - https://azure.microsoft.com/en-us/pricing/details/cosmos-db/
  - https://azure.microsoft.com/en-us/pricing/details/synapse-analytics/

- **Schema constraints**:
  - https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction#schema-representation
  - Only the first 1000 document properties
  - Only the first 127 document nested levels
  - No explicit versioning, the schema is inferred
  - CosmosDB stores JSON
  - Attribute names are mormalized: {"id": 1, "Name": "fred", "name": "john"}
  - Addtibute names with odd characters: colons, semicolons, parens, =, etc

- **Two Schema Types**

  - **Well-defined**
    - Default option for CosmosDB/SQL API accounts
    - The schema, with **datatypes**, grows are documents are added
      - Non-conforming attributes are ignored
        - doc1: {"id": "1", "a": 123}      <-- "a" is an integer, added to schema
        - doc2: {"id": "2", "a": "str"}    <-- "a" isn't an integer, is ignored

  - **Full Fidelity**
    - Default option for CosmosDB/Mongo API accounts
    - None of the above dataname normalization or datatype enforcement
    - Can be optionally be used by the SQL API
      - az cosmosdb create ... --analytical-storage-schema-type "FullFidelity" 

- See https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction

---

## Additional Links & References

- [What is Azure Synapse Link for Azure Cosmos DB?](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link)
- [Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)
- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/services/synapse-analytics/)
- [Analytical Store Pricing](https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction#analytical-store-pricing)
- [CosmosDB Change Feed](https://docs.microsoft.com/en-us/azure/cosmos-db/change-feed)

### Synapse

- [Synapse Notebooks](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-development-using-notebooks)
- [Synapse Apache Spark](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-spark)
- [Analyze data in a Storage Account](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-storage)
- [Azure-Samples/Synapse GitHub Repo](https://github.com/Azure-Samples/Synapse)

### Apache Spark

- [Apache Spark Docs](https://spark.apache.org/docs/latest/)
- [Apache Spark PySpark API Docs](https://spark.apache.org/docs/latest/api/python/reference/index.html)
