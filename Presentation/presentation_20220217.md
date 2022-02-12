# Cosmos DB Live TV, 2022/02/17

> Chris Joakim, Microsoft, Global Black Belt NoSQL/CosmosDB

> Mark Brown, Microsoft, Principal Program Manager, CosmosDB

---

## Outline of Presentation

- **Architecture**
- **Dataset Generation with Python and Faker**
- **Load a CosmosDB/Mongo API database with Java**
- **Query that CosmosDB/Mongo data with both Studio 3T and Java** 
- **Configure and utilize Azure Synapse Link (SL)**
- **Azure Synapse Spark Notebook - Aggregations**  
- **Azure Data Studio with PostgreSQL**

See https://github.com/cjoakim/azure-cosmosdb-synapse-link/blob/main/Presentation/presentation_20220217.md

## Themes

- **MongoDB and Azure CosmosDB/Mongo API**
- **Azure Synapse Link**
- **HTAP** - Hybrid Transaction Analytical Processing
- **Open-Source and Standard tooling** - Python, Java, 3T, Spark
- **Free Microsoft Tooling** - Azure Data Studio, Azure Storage Explorer, VSC
- bash shell - for linux, macOS, Windows WSL (Windows Subsystem for Linux)
- **Polyglot programming** - python, java, spark, scala, etc
- **Polyglot architecture** - CosmosDB, Synapse, Spark, Blob, PostgreSQL, etc

---

## Presentation

- **Architecture**

<p align="center">
    <img src="img/synapse-analytics-cosmos-db-architecture.png" width="100%">
</p>

---

- **Dataset Generation with Python and Faker**
  - https://faker.readthedocs.io/en/master/index.html
  - DatasetGeneration/retail_data_gen.py, line 84 create_stores()
  - sales, line items
  - ./retail_data_gen.sh
  - ./display_sale.sh
  - document and container design - pk, doctype, schemaless
  - partition key joins

- **Load a CosmosDB/Mongo API database with Java**
  - gradle loadSales2
  - see JavaConsoleApp/app/build.gradle
  - org.mongodb:mongodb-driver-sync:4.4.1 on mavenCentral()
  - MongoClient, MongoDatabase, MongoCollection, Document, FindIterable
  - JavaConsoleApp/app/src/main/java/org/cjoakim/cosmos/mongo/Mongo.java

- **Query that CosmosDB/Mongo data with both Studio 3T and Java** 
  - use the MongoDB tools you already use - 3T, mongoimport, mongoexport, etc
  - db.getCollection("sales").find({})
  - db.getCollection("sales").find({pk:"1"})
  - gradle findSaleByPk

- **Configure and utilize Azure Synapse Link (SL)**
  - HTAP - Hybrid Transaction Analytical Processing
  - Beautiful integration of the Azure PaaS services
  - "Painless ETL"
  - Schema Types - Well Defined (CosmosDB/SQL), Full Fidelity (CosmosDB/Mongo)
  - [Synapse Setup](setup_synapse.md) 

- **Azure Synapse Spark Notebook - Aggregations** 
  - Read the Azure Synapse sales data
  - Aggregate the sales by customer
  - Write the aggregated totals to Azure Blob Storage as CSV
  - Download the CSV with Azure Storage Explorer
  - Write the aggregated totals to Azure PostgreSQL with JDBC
  - Synapse/notebooks/cosmos_mongo_sales_processing.ipynb

- **Azure Data Studio with PostgreSQL**
  - Query the Azure Azure PostgreSQL database
  - Reporting, PowerBI

---

## GitHub Repository Map

Note: I use this repo to present and demonstrate **both** CosmosDB/SQL
with Synapse Link as well as CosmosDB/Mongo with Synapse Link.

```
├── DatasetGeneration   <-- Python/Faker code to create sales data
├── DotnetConsoleApp    <-- C# code for CosmosDB/SQL (not in this presentation)
├── JavaConsoleApp      <-- Java/Gradle app, client of CosmosDB/Mongo API
│   ├── app
├── Presentation
├── PythonConsoleApp   <-- Java/Gradle app, client of CosmosDB/Mongo API (not in this presentation)
├── Relational
│   └── PostgreSQL     <-- DDL/SQL scripts for Azure PostgreSQL
├── Synapse            <-- Azure Synapse artifacts
│   ├── conf           <-- Spark conf examples
│   ├── graphframes
│   ├── libraries      <-- jar files for Spark
│   ├── notebooks      <-- Jupyter Notebooks with PySpark and Scala
└── az                 <-- az CLI scripts for provisioning Azure resources for this demo
                           (not shown in this presentation)
```
