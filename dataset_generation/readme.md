# dataset_generation/ readme 

This directory is used to generate the correlated retail dataset -
the products, stores, customers, orders, and line items.

The generated files are intended to be loaded into CosmosDB,
and the CSV files are intended to be read in Azure Synapse.

## Generating the Datasets

To create the simulated eCommerce Retail data (orders, line items, deliveries)
execute the following script.

The generated files are copied to the **DotnetConsoleApp/data/** directory, 
but are "git ignored" because they are large.

```
$ ./retail_data_gen.sh
```
