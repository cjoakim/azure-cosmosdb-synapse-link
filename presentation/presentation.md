# azure-cosmosdb-synapse-link: presentation

Demonstration of **Azure CosmosDB** with **Azure Synapse Analytics**
integration via **Synapse Link**

**Chris Joakim, Microsoft, Global Black Belt NoSQL/CosmosDB**, chjoakim@microsoft.com

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

<a name="part1"></a>

## Architecture of Synapse Link, and this Demonstration App

- The **CosmosDB account** has the **Azure Synapse Link Feature** enabled
  - The account can be either **CosmosDB/SQL** or **CosmosDB/Mongo** 

- A **client program** reads a data file, and **Loads JSON documents to CosmosDB**
  - See example [DotnetConsoleApp](../DotnetConsoleApp/readme.md) for bulk-loading CosmosDB/SQL
    - NuGet library: Microsoft.Azure.Cosmos 3.20.1
  - See example [JavaConsoleApp](../JavaConsoleApp/readme.md) for loading CosmosDB/SQL
    - MavenCentral library: org.mongodb:mongodb-driver-sync:4.1.1
  - See example [PythonConsoleApp](../PythonConsoleApp/readme.md) for loading CosmosDB/SQL
    - PyPi library: pymongo 4.0.1
  - See the dataset_generation/ directory where "fake" data is generated with Python
    - products, stores, customers, sales

- The CosmosDB data flows into **Synapse Link** in near realtime
- Synapse Link performs **both copy AND data transformation (to columnar format)** operations
- No other ETL solution is needed (i.e. - Databricks)
- Query the Synapse Link data with **PySpark Notebooks in Azure Synapse Analytics**
- The Synapse Link data can also be queried with **SQL pools** (not in demonstration)
- A PySpark Notebook aggregates the Synapse Link Sales data, and writes it back to CosmosDB

<p align="center">
    <img src="img/synapse-analytics-cosmos-db-architecture.png" width="100%">
</p>

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Synapse Link data movement and transformation

- Synapse Link performs **both copy AND data transformation (to columnar format)** operations
- A **columnar datastore** is more suitable for analytical processing
- The **inserts, updates, and deletes** to your CosmosDB operational data are automatically synced to analytical store
- Auto-sync latency is usually within 2 minutes, but may be up to 5 minutes
- Supported for the **Azure Cosmos DB SQL (Core)** API and **Azure Cosmos DB API for MongoDB** APIs

<p align="center"><img src="img/transactional-analytical-data-stores.png" width="100%"></p>

<p align="center"><img src="img/horizonal-line-1.jpeg" width="95%"></p>

## Synapse Link Details

- **No impact to CosmosDB performance or RU costs**
- Is Scalable and Elastic
- The Synapse Link data can be queried in Azure Synapse Analytics by:
  - **Azure Synapse Spark pools**
    - Spark Streaming not yet supported
  - **Azure Synapse Serverless SQL pools** (not provisioned pools)
- Pricing consists of **storage and IO operations**
- **Schema constraints**:
  - Only the first 1000 document properties
  - Only the first 127 document nested levels
  - No explicit versioning, the schema is inferred
  - CosmosDB stores JSON
  - Attribute names are mormalized: {"id": 1, "Name": "fred", "name": "john"}
  - Addtibute names with odd characters: colons, semicolons, parens, =, etc
- Two Schema Types:
  - **Well-defined**
    - Default option for SQL (CORE) API accounts
    - The schema, with **datatypes**, grows are documents are added
      - Non-conforming attributes are ignored
        - doc1: {"id": "1", "a":123}      <-- "a" is an integer, added to schema
        - doc2: {"id": "2", "a": "str"}   <-- "a" isn't an integer, ignored
  - **Full Fidelity**
    - Default option for Azure Cosmos DB API for MongoDB accounts
    - None of the above dataname normalization or datatype enforcement
    - Can be optionally be used by the SQL API
      - az cosmosdb create ... --analytical-storage-schema-type "FullFidelity" 

- See https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction

---

## Links / References

- [What is Azure Synapse Link for Azure Cosmos DB?](https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link)
- [Azure Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)
- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/services/synapse-analytics/)
- [Analytical Store Pricing](https://docs.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction#analytical-store-pricing)

### Synapse

- [Synapse Notebooks](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-development-using-notebooks?tabs=classical)
- [Synapse Apache Spark](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-spark)
- [Analyze data in a storage account](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-analyze-storage)
- [Azure-Samples/Synapse GitHub Repo](https://github.com/Azure-Samples/Synapse)

### Apache Spark

- [Apache Spark Docs](https://spark.apache.org/docs/latest/)
- [Apache Spark PySpark API Docs](https://spark.apache.org/docs/latest/api/python/reference/index.html)
