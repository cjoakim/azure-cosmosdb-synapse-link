#!/bin/bash

# Load the CosmosDB/Mongo database with the generated "ecommerce retail" dataset
# consisting of customers, products, sales, and line items.
# Chris Joakim, Microsoft, February 2022

gradle loadCustomers

gradle loadProducts

gradle loadStores

gradle loadSales1

# execute during demonstration:
# gradle loadSales2

echo 'done'
