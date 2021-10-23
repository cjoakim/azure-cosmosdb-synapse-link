# dataset_generation/ readme 

This directory is used to generate the correlated retail dataset -
the customer, orders, products, etc.

Python and the Faker library are used, as well as a Kaggle.org dataset
with sample Walmart ecommerce products.

The generated JSON files are intended to be loaded into CosmosDB.

CSV equivalents of the generated JSON files are also created for
offline analysis and optional loading into a relational database.

## Generating the Datasets

To create the simulated eCommerce Retail data (orders, line items, deliveries)
execute the following script.

The generated files are copied to the **DotnetConsoleApp/data/** directory, 
but are "git ignored" because they are large.

```
$ ./retail_data_gen.sh
```

These scripts are optional:

```
$ ./json_to_csv.sh       <-- Creates CSV equivalents of the above JSON files
$ ./zip_retail_data.sh   <-- Creates retail_data.zip file containing the JSON and CSV files
```
