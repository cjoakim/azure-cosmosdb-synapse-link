# JavaConsoleApp

## Links

- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-java 
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/find-request-unit-charge-mongodb#use-the-mongodb-java-driver

## Quick Setup

```
$ git clone https://github.com/cjoakim/azure-cosmosdb-synapse-link.git

$ cd azure-cosmosdb-synapse-link

$ cd JavaConsoleApp/

$ java -version
openjdk version "11.0.12" 2021-07-20 LTS

$ gradle --version
Gradle 7.3.3

$ gradle build

$ gradle loadCustomers
$ gradle loadProducts
$ gradle loadStores
$ gradle loadSales1

$ ./load_retail.sh   <-- alternative to the above four loadXxx tasks

$ gradle findByPk

$ gradle findByIdPk  
```

See the **Gradle** configuration file JavaConsoleApp/app/build.gradle
