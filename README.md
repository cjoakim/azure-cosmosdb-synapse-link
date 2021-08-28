# azure-cosmosdb-synapse-link

Demonstration of Azure CosmosDB with Synapse Integration via Synapse Link

<p align="center"><img src="presentation/img/csl-demo.png" width="100%"></p>

<p align="center"><img src="presentation/img/horizonal-line-1.jpeg" width="95%"></p>

<p align="center"><img src="presentation/img/transactional-analytical-data-stores.png" width="100%"></p>


- [Presentation](presentation/presentation.md)

---

## This GitHub Repository

- https://github.com/cjoakim/azure-cosmosdb-synapse-link

### Directory Structure

```
├── DotnetConsoleApp      <-- net5.0 console application
│   ├── data              <-- json and csv files, zipped
│   └── sql               <-- CosmosDB query sql file(s)
├── az                    <-- provisioning scripts using the az CLI
├── presentation
│   └── presentation.md   <-- primary presentation file
└── synapse
    └── pyspark           <-- pyspark notebooks for Azure Synapse
```