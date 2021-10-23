# dataset_generation/ readme 

This directory is used to generate the correlated retail dataset -
the customer, orders, products, etc.

Python and the Faker library are used, as well as a Kaggle.org dataset
on Walmart ecommerce products.

The generated JSON files are intended to be loaded into CosmosDB.

CSV equivalents of the generated JSON files are also created for
offline analysis and optional loading into a relational database.
