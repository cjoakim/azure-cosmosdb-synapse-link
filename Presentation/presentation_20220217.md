# Cosmos DB Live TV, 2022/02/17

> Chris Joakim, Microsoft, Global Black Belt NoSQL/CosmosDB
> Mark Brown, Microsoft, Principal Program Manager, CosmosDB

## Outline of Presentation

- **Dataset Generation with Python and Faker**
  - https://faker.readthedocs.io/en/master/index.html
  - sales, line items
  - ./retail_data_gen.sh
  - ./display_sale.sh

- **Load a CosmosDB/Mongo API database with Java**
  - document and container design - pk, doctype
  - partition key joins

- **Query that CosmosDB/Mongo data with Studio 3T** 
  - use the MongoDB tools you already use - 3T, mongoimport, mongoexport, etc

- **Configure and utilize **Azure Synapse Link (SL)**
  - HTAP - Hybrid Transaction Analytical Processing

- **Spark Notebook**
  - Read the Azure Synapse sales data
  - Aggregate the sales by customer
  - Write the aggregated totals to Azure Blob Storage
  - Write the aggregated totals to Azure PostgreSQL with JDBC
  
- **Azure Data Studio**
  - Query the Azure Azure PostgreSQL database
  - Reporting, PowerBI

## Themes

- MongoDB
- Synapse Link
- HTAP
- Open-Source and Standard tooling - Python, Java, 3T, Spark
- Free Microsoft Tooling - Azure Data Studio, Azure Storage Explorer
- bash shell

---

## Architecture

<p align="center">
    <img src="img/synapse-analytics-cosmos-db-architecture.png" width="100%">
</p>

## GitHub Repository Map

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
