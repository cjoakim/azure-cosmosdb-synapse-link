# Setup Synapse, Spark Pools, Libraries, PostgreSQL

Setup notes for Azure Synapse, the Spark Pool, and Azure PostgreSQL.

---

## Azure Synapse 

### Spark Workspace Packages 

<p align="center">
    <img src="img/spark-workspace-packages.png" width="90%">
</p>

### Spark Pool Packages 

<p align="center">
    <img src="img/spark-pool-packages.png" width="90%">
</p>

### Spark Pool Configuration

<p align="center">
    <img src="img/spark-pool-conf.png" width="90%">
</p>

#### Example spark_conf.txt

```
spark.azurepg.jdbc.connstring jdbc:postgresql://myserver.postgres.database.azure.com:5432/demo?user=user@myserver&password=xxxYYYzzz&sslmode=require
spark.azurepg.jdbc.driver     org.postgresql.Driver
spark.azurepg.jdbc.server     myserver
spark.azurepg.jdbc.database   demo
spark.azurepg.jdbc.user       user@myserver
spark.azurepg.jdbc.pass       xxxYYYzzz
```

---

## Azure PostgreSQL

Create a database called **demo** with the following tables:

### SQL DDL Scripts in this repo

You can execute these scripts in [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?) in this repo to create 
the necessary tables for this demo in your Azure PostgreSQL database.

```
Relational/PostgreSQL/sql/ecomm_customer_sales.sql
Relational/PostgreSQL/sql/ecomm_customers.sql
Relational/PostgreSQL/sql/ecomm_orders.sql
Relational/PostgreSQL/sql/packages.sql
```

### Example - ecomm_customer_sales.sql

```
drop table customer_sales;

CREATE TABLE "customer_sales" (
	"customer_id"         integer not null,
	"_id"                 character varying(80) not null,
	"pk"                  integer not null,
	"order_count"         integer not null,
	"total_dollar_amount" money,
	"total_item_count"    integer not null
);
```

#### Screen Shot - executing the above SQL in Azure Data Studio

<p align="center">
    <img src="img/azure-data-studio-create-table.png" width="90%">
</p>
