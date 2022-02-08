# dataset_generation/ readme 

This directory is used to generate the correlated retail dataset -
the products, stores, customers, orders, and line items.

The generated files are intended to be loaded into CosmosDB,
and the CSV files are intended to be read in Azure Synapse.

## Generating the Datasets

To create the simulated eCommerce Retail data execute the following script.

```
$ ./venv.sh                   <-- create the python virtual environment
$ source venv/bin/activate    <-- activate the python virtual environment
$ ./retail_data_gen.sh        <-- generate the randomized retail datasets
```

The generated files are copied to the **DotnetConsoleApp/data/** and
**PythonConsoleApp/data/** directories, but are "git ignored" because they are large.
